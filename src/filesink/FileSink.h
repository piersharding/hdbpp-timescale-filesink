#ifndef FILESINK_FILE_SINK_H
#define FILESINK_FILE_SINK_H

#include "FileSinkConfig.h"
#include "TableWriter.h"
#include "CSVWriter.h"
#include <map>
#include <memory>
#include <chrono>
#include <ctime>
#include <iomanip>
#include <sstream>
#include <queue>
#include <mutex>
#include <condition_variable>
#include <thread>
#include <atomic>
#include <sys/stat.h>
#include <iostream>

namespace filesink {

/**
 * Represents a record to be written to a table.
 */
struct DataRecord {
    std::string tableName;
    std::vector<std::string> fields;
};

/**
 * Main FileSink class that manages CSV file writing with rotation.
 */
class FileSink {
private:
    FileSinkConfig config_;
    std::map<std::string, std::unique_ptr<TableWriter>> tableWriters_;
    
    // Queue for records
    std::queue<DataRecord> recordQueue_;
    std::mutex queueMutex_;
    std::condition_variable queueCV_;
    size_t queueSize_;
    
    // Worker thread
    std::thread workerThread_;
    std::atomic<bool> running_;
    
    // Rotation tracking
    std::chrono::time_point<std::chrono::system_clock> nextRotationTime_;
    std::string currentEpoch_;
    std::mutex rotationMutex_;
    
    /**
     * Calculate the next wall-clock aligned rotation time.
     */
    std::chrono::time_point<std::chrono::system_clock> calculateNextRotationTime() {
        auto now = std::chrono::system_clock::now();
        auto nowTime = std::chrono::system_clock::to_time_t(now);
        
        // Calculate next aligned boundary
        int interval = config_.rotateIntervalSeconds;
        time_t nextTime = (nowTime / interval + 1) * interval;
        
        return std::chrono::system_clock::from_time_t(nextTime);
    }
    
    /**
     * Generate epoch marker in UTC format: YYYYMMDDTHHMMSSZ
     */
    std::string generateEpochMarker() {
        auto now = std::chrono::system_clock::now();
        auto nowTime = std::chrono::system_clock::to_time_t(now);
        
        std::tm utcTime;
        gmtime_r(&nowTime, &utcTime);
        
        std::ostringstream oss;
        oss << std::put_time(&utcTime, "%Y%m%dT%H%M%SZ");
        return oss.str();
    }
    
    /**
     * Check if rotation is needed due to time or size constraints.
     */
    bool shouldRotate() {
        // Check time-based rotation
        auto now = std::chrono::system_clock::now();
        if (now >= nextRotationTime_) {
            return true;
        }
        
        // Check size-based rotation
        size_t totalBytes = 0;
        for (const auto& pair : tableWriters_) {
            size_t bytes = pair.second->getBytesWritten();
            
            // Individual file exceeded limit
            if (bytes >= config_.rotateMaxBytes) {
                return true;
            }
            
            totalBytes += bytes;
        }
        
        // Total size exceeded limit
        if (totalBytes >= config_.rotateMaxBytes) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Perform rotation: sync, close, rename, and open new files.
     */
    void rotate() {
        std::lock_guard<std::mutex> lock(rotationMutex_);
        
        std::cout << "Starting rotation for epoch: " << currentEpoch_ << std::endl;
        
        // 1. Flush and sync all files
        for (auto& pair : tableWriters_) {
            pair.second->flush();
            pair.second->sync();
        }
        
        // 2. Close all files
        for (auto& pair : tableWriters_) {
            pair.second->close();
        }
        
        // 3. Publish (rename) all files
        for (auto& pair : tableWriters_) {
            pair.second->publish();
        }
        
        // 4. Generate new epoch and open new files
        currentEpoch_ = generateEpochMarker();
        for (auto& pair : tableWriters_) {
            pair.second->open(currentEpoch_);
        }
        
        // 5. Update next rotation time
        nextRotationTime_ = calculateNextRotationTime();
        
        std::cout << "Rotation complete. New epoch: " << currentEpoch_ << std::endl;
        std::cout << "Next rotation at: " << std::chrono::system_clock::to_time_t(nextRotationTime_) << std::endl;
    }
    
    /**
     * Get or create a table writer for the given table.
     */
    TableWriter* getTableWriter(const std::string& tableName) {
        auto it = tableWriters_.find(tableName);
        if (it != tableWriters_.end()) {
            return it->second.get();
        }
        
        // Create new table writer
        auto writer = std::make_unique<TableWriter>(tableName, config_.outputDirectory);
        writer->open(currentEpoch_);
        
        TableWriter* writerPtr = writer.get();
        tableWriters_[tableName] = std::move(writer);
        
        return writerPtr;
    }
    
    /**
     * Worker thread function that processes records from the queue.
     */
    void workerThreadFunc() {
        while (running_) {
            DataRecord record;
            
            // Dequeue record
            {
                std::unique_lock<std::mutex> lock(queueMutex_);
                
                // Wait for records or shutdown
                queueCV_.wait(lock, [this]() {
                    return !recordQueue_.empty() || !running_;
                });
                
                if (!running_ && recordQueue_.empty()) {
                    break;
                }
                
                if (!recordQueue_.empty()) {
                    record = std::move(recordQueue_.front());
                    recordQueue_.pop();
                    queueSize_--;
                    
                    // Notify producers that space is available
                    queueCV_.notify_all();
                } else {
                    continue;
                }
            }
            
            // Write record
            TableWriter* writer = getTableWriter(record.tableName);
            if (writer) {
                std::string row = CSVWriter::buildRow(record.fields);
                writer->write(row);
            }
            
            // Check if rotation is needed
            if (shouldRotate()) {
                rotate();
            }
        }
    }
    
public:
    FileSink(const FileSinkConfig& config) 
        : config_(config), queueSize_(0), running_(false) {
    }
    
    ~FileSink() {
        stop();
    }
    
    /**
     * Start the file sink.
     */
    bool start() {
        // Create output directory if it doesn't exist
        struct stat st;
        if (stat(config_.outputDirectory.c_str(), &st) != 0) {
            if (mkdir(config_.outputDirectory.c_str(), 0755) != 0) {
                std::cerr << "Failed to create output directory: " << config_.outputDirectory << std::endl;
                return false;
            }
        }
        
        // Initialize epoch and rotation time
        currentEpoch_ = generateEpochMarker();
        nextRotationTime_ = calculateNextRotationTime();
        
        std::cout << "FileSink started" << std::endl;
        std::cout << "  Output directory: " << config_.outputDirectory << std::endl;
        std::cout << "  Rotation interval: " << config_.rotateIntervalSeconds << " seconds" << std::endl;
        std::cout << "  Max bytes: " << config_.rotateMaxBytes << std::endl;
        std::cout << "  Queue max records: " << config_.queueMaxRecords << std::endl;
        std::cout << "  Current epoch: " << currentEpoch_ << std::endl;
        
        // Start worker thread
        running_ = true;
        workerThread_ = std::thread(&FileSink::workerThreadFunc, this);
        
        return true;
    }
    
    /**
     * Stop the file sink and flush all pending data.
     */
    void stop() {
        if (running_) {
            running_ = false;
            queueCV_.notify_all();
            
            if (workerThread_.joinable()) {
                workerThread_.join();
            }
            
            // Final rotation to publish all data
            rotate();
            
            std::cout << "FileSink stopped" << std::endl;
        }
    }
    
    /**
     * Enqueue a record for writing.
     * Blocks if the queue is full (backpressure).
     */
    void enqueue(const DataRecord& record) {
        std::unique_lock<std::mutex> lock(queueMutex_);
        
        // Wait if queue is full (backpressure)
        queueCV_.wait(lock, [this]() {
            return queueSize_ < config_.queueMaxRecords || !running_;
        });
        
        if (!running_) {
            return;
        }
        
        recordQueue_.push(record);
        queueSize_++;
        
        // Notify worker
        queueCV_.notify_one();
    }
    
    /**
     * Get current queue size.
     */
    size_t getQueueSize() const {
        return queueSize_;
    }
};

} // namespace filesink

#endif // FILESINK_FILE_SINK_H
