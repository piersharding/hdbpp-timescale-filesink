/**
 * Example program demonstrating the FileSink usage.
 */
#include "FileSink.h"
#include <iostream>
#include <thread>
#include <chrono>

using namespace filesink;

int main(int argc, char** argv) {
    std::cout << "FileSink Example Program" << std::endl;
    std::cout << "=========================" << std::endl;
    
    // Load configuration from environment
    FileSinkConfig config = FileSinkConfig::fromEnvironment();
    
    // Override for testing (short rotation interval)
    if (argc > 1 && std::string(argv[1]) == "--test") {
        config.rotateIntervalSeconds = 10; // 10 seconds for testing
        config.rotateMaxBytes = 1024; // 1KB for testing
    }
    
    // Create and start file sink
    FileSink sink(config);
    if (!sink.start()) {
        std::cerr << "Failed to start FileSink" << std::endl;
        return 1;
    }
    
    std::cout << "\nWriting sample data to simulate HDB++ tables..." << std::endl;
    
    // Simulate writing to different HDB++ tables
    const char* tables[] = {
        "att_scalar_devdouble",
        "att_scalar_devlong",
        "att_scalar_devstring",
        "att_array_devdouble",
        "att_conf"
    };
    
    // Write some sample records
    for (int i = 0; i < 100; ++i) {
        // Scalar double record
        {
            DataRecord record;
            record.tableName = "att_scalar_devdouble";
            record.fields = {
                std::to_string(1001),  // att_conf_id
                "2026-02-09 20:00:00+00",  // data_time
                std::to_string(42.5 + i),  // value_r
                CSVWriter::formatNull(),  // value_w (NULL)
                "0",  // quality
                CSVWriter::formatNull(),  // att_error_desc_id (NULL)
                "{}"  // details (empty JSON)
            };
            sink.enqueue(record);
        }
        
        // Scalar long record
        {
            DataRecord record;
            record.tableName = "att_scalar_devlong";
            record.fields = {
                std::to_string(1002),  // att_conf_id
                "2026-02-09 20:00:00+00",  // data_time
                std::to_string(1000 + i),  // value_r
                CSVWriter::formatNull(),  // value_w (NULL)
                "0",  // quality
                CSVWriter::formatNull(),  // att_error_desc_id (NULL)
                "{}"  // details
            };
            sink.enqueue(record);
        }
        
        // Scalar string record with CSV escaping
        {
            DataRecord record;
            record.tableName = "att_scalar_devstring";
            record.fields = {
                std::to_string(1003),  // att_conf_id
                "2026-02-09 20:00:00+00",  // data_time
                CSVWriter::escapeCSV("Test value " + std::to_string(i)),  // value_r
                CSVWriter::formatNull(),  // value_w
                "0",  // quality
                CSVWriter::formatNull(),  // att_error_desc_id
                "{}"  // details
            };
            sink.enqueue(record);
        }
        
        // Array double record
        {
            std::vector<double> arrayValues = {1.1 + i, 2.2 + i, 3.3 + i};
            DataRecord record;
            record.tableName = "att_array_devdouble";
            record.fields = {
                std::to_string(1004),  // att_conf_id
                "2026-02-09 20:00:00+00",  // data_time
                CSVWriter::arrayToPostgresArray(arrayValues),  // value_r
                CSVWriter::formatNull(),  // value_w
                "0",  // quality
                CSVWriter::formatNull(),  // att_error_desc_id
                "{}"  // details
            };
            sink.enqueue(record);
        }
        
        // Configuration record
        {
            DataRecord record;
            record.tableName = "att_conf";
            record.fields = {
                std::to_string(1000 + i),  // att_conf_id
                CSVWriter::escapeCSV("domain/family/member/attr" + std::to_string(i)),  // att_name
                "8",  // att_conf_type_id (DEVDOUBLE)
                "0",  // att_conf_format_id (SCALAR)
                "0",  // att_conf_write_id (READ)
                CSVWriter::escapeCSV("att_scalar_devdouble"),  // table_name
                CSVWriter::escapeCSV("tango://host:10000"),  // cs_name
                CSVWriter::escapeCSV("domain"),  // domain
                CSVWriter::escapeCSV("family"),  // family
                CSVWriter::escapeCSV("member"),  // member
                CSVWriter::escapeCSV("attr" + std::to_string(i)),  // name
                "0"  // ttl
            };
            sink.enqueue(record);
        }
        
        // Small delay to simulate event rate
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
        
        if ((i + 1) % 20 == 0) {
            std::cout << "Written " << (i + 1) << " records..." << std::endl;
        }
    }
    
    std::cout << "\nAll records enqueued. Queue size: " << sink.getQueueSize() << std::endl;
    std::cout << "Waiting for processing (press Ctrl+C to stop or wait 30s)..." << std::endl;
    
    // Wait a bit to let records process
    std::this_thread::sleep_for(std::chrono::seconds(30));
    
    std::cout << "\nStopping FileSink..." << std::endl;
    sink.stop();
    
    std::cout << "\nExample completed. Check " << config.outputDirectory << " for CSV files." << std::endl;
    std::cout << "Files with .csv extension are ready for COPY." << std::endl;
    std::cout << "Files with .csv.current extension are still being written." << std::endl;
    
    return 0;
}
