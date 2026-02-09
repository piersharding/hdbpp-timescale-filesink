/**
 * Integration example showing how to use the ISink interface
 * to switch between TimescaleDB and FileSink backends.
 */
#include "SinkInterface.h"
#include "FileSinkAdapter.h"
#include <iostream>
#include <cstdlib>

using namespace hdbpp;

/**
 * Example function that uses the ISink interface.
 * This code is agnostic to the actual sink implementation.
 */
void processData(ISink* sink) {
    std::cout << "Processing data using sink..." << std::endl;
    
    // Write attribute configuration
    sink->writeAttConf(
        1001,                           // attConfId
        "domain/family/member/temp",    // attName
        4,                              // attConfTypeId (DEVDOUBLE)
        0,                              // attConfFormatId (SCALAR)
        0,                              // attConfWriteId (READ)
        "att_scalar_devdouble",         // tableName
        "tango://host:10000",           // csName
        "domain",                       // domain
        "family",                       // family
        "member",                       // member
        "temp",                         // name
        0                               // ttl
    );
    
    // Write some scalar data
    for (int i = 0; i < 10; ++i) {
        sink->writeScalar(
            1001,                       // attConfId
            "2026-02-09 20:30:00+00",   // dataTime
            std::to_string(25.5 + i),   // valueR
            "",                         // valueW (NULL)
            0,                          // quality
            -1,                         // errorDescId (NULL)
            "{}"                        // details
        );
    }
    
    // Write array data
    std::vector<std::string> arrayValues = {"10.1", "20.2", "30.3"};
    sink->writeArray(
        1002,                       // attConfId
        "2026-02-09 20:30:00+00",   // dataTime
        arrayValues,                // valueR
        {},                         // valueW (NULL)
        0,                          // quality
        -1,                         // errorDescId (NULL)
        "{}"                        // details
    );
    
    std::cout << "Data processing complete" << std::endl;
}

int main(int argc, char** argv) {
    std::cout << "HDB++ Sink Integration Example" << std::endl;
    std::cout << "===============================" << std::endl;
    
    // Determine which sink to use based on environment or command line
    std::string sinkType = "file"; // Default to file for this example
    
    if (argc > 1) {
        sinkType = argv[1];
    } else {
        const char* envSink = std::getenv("HDBPP_SINK_TYPE");
        if (envSink) {
            sinkType = envSink;
        }
    }
    
    std::cout << "Using sink type: " << sinkType << std::endl;
    std::cout << std::endl;
    
    // Create the appropriate sink
    std::unique_ptr<ISink> sink;
    
    if (sinkType == "file") {
        std::cout << "Creating FileSink backend..." << std::endl;
        sink = std::make_unique<FileSinkAdapter>();
    } else if (sinkType == "timescale") {
        std::cerr << "TimescaleDB sink not implemented in this example" << std::endl;
        std::cerr << "In production, this would create a TimescaleDB adapter" << std::endl;
        return 1;
    } else {
        std::cerr << "Unknown sink type: " << sinkType << std::endl;
        std::cerr << "Valid types: file, timescale" << std::endl;
        return 1;
    }
    
    // Start the sink
    if (!sink->start()) {
        std::cerr << "Failed to start sink" << std::endl;
        return 1;
    }
    
    // Process data
    processData(sink.get());
    
    // Stop the sink
    std::cout << "\nStopping sink..." << std::endl;
    sink->stop();
    
    std::cout << "\nExample completed successfully" << std::endl;
    std::cout << "For FileSink: Check $HDBPP_COPY_OUT_DIR for CSV files" << std::endl;
    
    return 0;
}
