#ifndef FILESINK_TABLE_WRITER_H
#define FILESINK_TABLE_WRITER_H

#include <string>
#include <fstream>
#include <sys/stat.h>
#include <unistd.h>
#include <iostream>

namespace filesink {

/**
 * Manages writing to a single table's CSV file with rotation support.
 */
class TableWriter {
private:
    std::string tableName_;
    std::string outputDir_;
    std::string currentEpoch_;
    std::ofstream fileStream_;
    size_t bytesWritten_;
    bool isOpen_;
    
    std::string getCurrentFilePath() const {
        return outputDir_ + "/" + tableName_ + "__" + currentEpoch_ + ".csv.current";
    }
    
    std::string getPublishedFilePath() const {
        return outputDir_ + "/" + tableName_ + "__" + currentEpoch_ + ".csv";
    }
    
public:
    TableWriter(const std::string& tableName, const std::string& outputDir)
        : tableName_(tableName), outputDir_(outputDir), bytesWritten_(0), isOpen_(false) {
    }
    
    ~TableWriter() {
        close();
    }
    
    /**
     * Open a new file for the given epoch.
     */
    bool open(const std::string& epoch) {
        if (isOpen_) {
            close();
        }
        
        currentEpoch_ = epoch;
        std::string filePath = getCurrentFilePath();
        
        fileStream_.open(filePath, std::ios::out | std::ios::app);
        if (!fileStream_.is_open()) {
            std::cerr << "Failed to open file: " << filePath << std::endl;
            return false;
        }
        
        isOpen_ = true;
        bytesWritten_ = 0;
        return true;
    }
    
    /**
     * Write a CSV row to the file.
     */
    bool write(const std::string& row) {
        if (!isOpen_) {
            std::cerr << "Attempting to write to closed file for table: " << tableName_ << std::endl;
            return false;
        }
        
        fileStream_ << row;
        bytesWritten_ += row.size();
        
        return fileStream_.good();
    }
    
    /**
     * Flush the file buffer.
     */
    void flush() {
        if (isOpen_) {
            fileStream_.flush();
        }
    }
    
    /**
     * Sync to disk (fdatasync).
     */
    bool sync() {
        if (!isOpen_) {
            return false;
        }
        
        flush();
        
        // Get file descriptor and sync
        int fd = fileno(fopen(getCurrentFilePath().c_str(), "r"));
        if (fd != -1) {
            #ifdef __linux__
            fdatasync(fd);
            #else
            fsync(fd);
            #endif
            ::close(fd);
        }
        
        return true;
    }
    
    /**
     * Close the current file.
     */
    void close() {
        if (isOpen_) {
            fileStream_.close();
            isOpen_ = false;
        }
    }
    
    /**
     * Publish the current file by renaming .current to final .csv.
     * This should be called after sync() during rotation.
     */
    bool publish() {
        if (isOpen_) {
            close();
        }
        
        std::string currentPath = getCurrentFilePath();
        std::string publishedPath = getPublishedFilePath();
        
        // Check if current file exists
        struct stat buffer;
        if (stat(currentPath.c_str(), &buffer) != 0) {
            // File doesn't exist, nothing to publish
            return true;
        }
        
        // Atomic rename
        if (rename(currentPath.c_str(), publishedPath.c_str()) != 0) {
            std::cerr << "Failed to rename " << currentPath << " to " << publishedPath << std::endl;
            return false;
        }
        
        std::cout << "Published: " << publishedPath << std::endl;
        return true;
    }
    
    /**
     * Get the number of bytes written to the current file.
     */
    size_t getBytesWritten() const {
        return bytesWritten_;
    }
    
    /**
     * Get the table name.
     */
    const std::string& getTableName() const {
        return tableName_;
    }
};

} // namespace filesink

#endif // FILESINK_TABLE_WRITER_H
