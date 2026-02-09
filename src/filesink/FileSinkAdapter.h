#ifndef HDBPP_FILE_SINK_ADAPTER_H
#define HDBPP_FILE_SINK_ADAPTER_H

#include "SinkInterface.h"
#include "FileSink.h"
#include "CSVWriter.h"
#include <sstream>

namespace hdbpp {

/**
 * Adapter that implements ISink interface using the FileSink backend.
 */
class FileSinkAdapter : public ISink {
private:
    std::unique_ptr<filesink::FileSink> sink_;
    filesink::FileSinkConfig config_;
    
    /**
     * Determine table name based on attribute configuration.
     * This should match the logic in libhdbpp-timescale.
     */
    std::string getTableName(int attConfTypeId, int attConfFormatId) {
        // Map type ID to type name
        const char* typeNames[] = {
            "devboolean",   // 0
            "devshort",     // 1
            "devlong",      // 2
            "devfloat",     // 3
            "devdouble",    // 4
            "devstring",    // 5
            "devuchar",     // 6
            "devushort",    // 7
            "devulong",     // 8
            "devlong64",    // 9
            "devulong64",   // 10
            "devstate",     // 11
            "devencoded",   // 12
            "devenum"       // 13
        };
        
        std::string prefix;
        if (attConfFormatId == 0) {
            prefix = "att_scalar_";
        } else if (attConfFormatId == 1) {
            prefix = "att_array_";
        } else {
            prefix = "att_image_";
        }
        
        if (attConfTypeId >= 0 && attConfTypeId < 14) {
            return prefix + typeNames[attConfTypeId];
        }
        
        return prefix + "devdouble"; // Default
    }
    
public:
    FileSinkAdapter() : config_(filesink::FileSinkConfig::fromEnvironment()) {
        sink_ = std::make_unique<filesink::FileSink>(config_);
    }
    
    bool start() override {
        return sink_->start();
    }
    
    void stop() override {
        sink_->stop();
    }
    
    void writeScalar(
        int attConfId,
        const std::string& dataTime,
        const std::string& valueR,
        const std::string& valueW,
        int quality,
        int errorDescId,
        const std::string& details) override 
    {
        // Note: We'd need to know the table name. For now, use a generic approach.
        // In real integration, this would be determined from att_conf lookup.
        filesink::DataRecord record;
        record.tableName = "att_scalar_devdouble"; // Placeholder
        
        record.fields.push_back(std::to_string(attConfId));
        record.fields.push_back(dataTime);
        record.fields.push_back(valueR);
        record.fields.push_back(valueW.empty() ? filesink::CSVWriter::formatNull() : valueW);
        record.fields.push_back(std::to_string(quality));
        record.fields.push_back(errorDescId < 0 ? filesink::CSVWriter::formatNull() : std::to_string(errorDescId));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(details));
        
        sink_->enqueue(record);
    }
    
    void writeArray(
        int attConfId,
        const std::string& dataTime,
        const std::vector<std::string>& valueR,
        const std::vector<std::string>& valueW,
        int quality,
        int errorDescId,
        const std::string& details) override
    {
        filesink::DataRecord record;
        record.tableName = "att_array_devdouble"; // Placeholder
        
        record.fields.push_back(std::to_string(attConfId));
        record.fields.push_back(dataTime);
        record.fields.push_back(filesink::CSVWriter::stringArrayToPostgresArray(valueR));
        record.fields.push_back(valueW.empty() ? filesink::CSVWriter::formatNull() : 
                                filesink::CSVWriter::stringArrayToPostgresArray(valueW));
        record.fields.push_back(std::to_string(quality));
        record.fields.push_back(errorDescId < 0 ? filesink::CSVWriter::formatNull() : std::to_string(errorDescId));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(details));
        
        sink_->enqueue(record);
    }
    
    void writeAttConf(
        int attConfId,
        const std::string& attName,
        int attConfTypeId,
        int attConfFormatId,
        int attConfWriteId,
        const std::string& tableName,
        const std::string& csName,
        const std::string& domain,
        const std::string& family,
        const std::string& member,
        const std::string& name,
        int ttl) override
    {
        filesink::DataRecord record;
        record.tableName = "att_conf";
        
        record.fields.push_back(std::to_string(attConfId));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(attName));
        record.fields.push_back(std::to_string(attConfTypeId));
        record.fields.push_back(std::to_string(attConfFormatId));
        record.fields.push_back(std::to_string(attConfWriteId));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(tableName));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(csName));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(domain));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(family));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(member));
        record.fields.push_back(filesink::CSVWriter::escapeCSV(name));
        record.fields.push_back(std::to_string(ttl));
        
        sink_->enqueue(record);
    }
};

} // namespace hdbpp

#endif // HDBPP_FILE_SINK_ADAPTER_H
