/**
 * Simple unit tests for FileSink components.
 */
#include "CSVWriter.h"
#include "FileSinkConfig.h"
#include <iostream>
#include <cassert>
#include <cstdlib>

using namespace filesink;

void testCSVEscaping() {
    std::cout << "Testing CSV escaping..." << std::endl;
    
    // Simple string - no escaping needed
    assert(CSVWriter::escapeCSV("simple") == "simple");
    
    // String with comma - needs quoting
    assert(CSVWriter::escapeCSV("hello,world") == "\"hello,world\"");
    
    // String with quotes - needs escaping and quoting
    assert(CSVWriter::escapeCSV("say \"hello\"") == "\"say \"\"hello\"\"\"");
    
    // String with newline - needs quoting
    assert(CSVWriter::escapeCSV("line1\nline2") == "\"line1\nline2\"");
    
    std::cout << "  CSV escaping tests passed!" << std::endl;
}

void testArrayFormatting() {
    std::cout << "Testing array formatting..." << std::endl;
    
    // Integer array
    std::vector<int> intArr = {1, 2, 3};
    assert(CSVWriter::arrayToPostgresArray(intArr) == "{1,2,3}");
    
    // Empty array
    std::vector<int> emptyArr;
    assert(CSVWriter::arrayToPostgresArray(emptyArr) == "{}");
    
    // String array
    std::vector<std::string> strArr = {"hello", "world"};
    assert(CSVWriter::stringArrayToPostgresArray(strArr) == "{\"hello\",\"world\"}");
    
    std::cout << "  Array formatting tests passed!" << std::endl;
}

void testNullFormatting() {
    std::cout << "Testing NULL formatting..." << std::endl;
    
    // NULL should be empty string
    assert(CSVWriter::formatNull() == "");
    
    std::cout << "  NULL formatting tests passed!" << std::endl;
}

void testRowBuilding() {
    std::cout << "Testing row building..." << std::endl;
    
    std::vector<std::string> fields = {"1", "test", "42.5"};
    std::string row = CSVWriter::buildRow(fields);
    assert(row == "1,test,42.5\n");
    
    std::cout << "  Row building tests passed!" << std::endl;
}

void testConfig() {
    std::cout << "Testing configuration..." << std::endl;
    
    // Set environment variables for testing
    setenv("HDBPP_COPY_OUT_DIR", "/tmp/test-hdbpp", 1);
    setenv("HDBPP_ROTATE_INTERVAL_SECONDS", "600", 1);
    setenv("HDBPP_ROTATE_MAX_BYTES", "2147483648", 1);
    setenv("HDBPP_QUEUE_MAX_RECORDS", "200000", 1);
    
    FileSinkConfig config = FileSinkConfig::fromEnvironment();
    
    assert(config.outputDirectory == "/tmp/test-hdbpp");
    assert(config.rotateIntervalSeconds == 600);
    assert(config.rotateMaxBytes == 2147483648ULL);
    assert(config.queueMaxRecords == 200000ULL);
    
    // Test defaults
    unsetenv("HDBPP_COPY_OUT_DIR");
    unsetenv("HDBPP_ROTATE_INTERVAL_SECONDS");
    unsetenv("HDBPP_ROTATE_MAX_BYTES");
    unsetenv("HDBPP_QUEUE_MAX_RECORDS");
    
    FileSinkConfig defaultConfig = FileSinkConfig::fromEnvironment();
    assert(defaultConfig.outputDirectory == "/var/lib/hdbpp-copy");
    assert(defaultConfig.rotateIntervalSeconds == 300);
    assert(defaultConfig.rotateMaxBytes == 1073741824ULL);
    assert(defaultConfig.queueMaxRecords == 100000ULL);
    
    std::cout << "  Configuration tests passed!" << std::endl;
}

int main() {
    std::cout << "Running FileSink Unit Tests" << std::endl;
    std::cout << "===========================" << std::endl;
    
    try {
        testCSVEscaping();
        testArrayFormatting();
        testNullFormatting();
        testRowBuilding();
        testConfig();
        
        std::cout << "\nAll tests passed!" << std::endl;
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Test failed with exception: " << e.what() << std::endl;
        return 1;
    }
}
