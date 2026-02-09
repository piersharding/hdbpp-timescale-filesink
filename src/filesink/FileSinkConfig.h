#ifndef FILESINK_CONFIG_H
#define FILESINK_CONFIG_H

#include <string>
#include <cstdlib>

namespace filesink {

/**
 * Configuration for the file sink, primarily from environment variables.
 */
struct FileSinkConfig {
    // Output directory for CSV files
    std::string outputDirectory;
    
    // Rotation interval in seconds (aligned to wall-clock boundaries)
    int rotateIntervalSeconds;
    
    // Maximum bytes before triggering rotation (per file or total)
    size_t rotateMaxBytes;
    
    // Maximum records in the queue before blocking
    size_t queueMaxRecords;
    
    /**
     * Load configuration from environment variables with defaults.
     */
    static FileSinkConfig fromEnvironment() {
        FileSinkConfig config;
        
        // HDBPP_COPY_OUT_DIR default: /var/lib/hdbpp-copy
        const char* outDir = std::getenv("HDBPP_COPY_OUT_DIR");
        config.outputDirectory = outDir ? outDir : "/var/lib/hdbpp-copy";
        
        // HDBPP_ROTATE_INTERVAL_SECONDS default: 300
        const char* rotateInterval = std::getenv("HDBPP_ROTATE_INTERVAL_SECONDS");
        config.rotateIntervalSeconds = rotateInterval ? std::atoi(rotateInterval) : 300;
        
        // HDBPP_ROTATE_MAX_BYTES default: 1073741824 (1GB)
        const char* rotateMaxBytes = std::getenv("HDBPP_ROTATE_MAX_BYTES");
        config.rotateMaxBytes = rotateMaxBytes ? std::strtoull(rotateMaxBytes, nullptr, 10) : 1073741824ULL;
        
        // HDBPP_QUEUE_MAX_RECORDS default: 100000
        const char* queueMaxRecords = std::getenv("HDBPP_QUEUE_MAX_RECORDS");
        config.queueMaxRecords = queueMaxRecords ? std::strtoull(queueMaxRecords, nullptr, 10) : 100000ULL;
        
        return config;
    }
};

} // namespace filesink

#endif // FILESINK_CONFIG_H
