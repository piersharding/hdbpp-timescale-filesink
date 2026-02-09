#ifndef HDBPP_SINK_INTERFACE_H
#define HDBPP_SINK_INTERFACE_H

#include <string>
#include <vector>
#include <memory>

namespace hdbpp {

/**
 * Abstract interface for HDB++ data sinks.
 * Implementations include TimescaleDB (direct insert) and FileSink (CSV export).
 */
class ISink {
public:
    virtual ~ISink() = default;
    
    /**
     * Initialize and start the sink.
     */
    virtual bool start() = 0;
    
    /**
     * Stop the sink and flush pending data.
     */
    virtual void stop() = 0;
    
    /**
     * Write a scalar value to the appropriate table.
     */
    virtual void writeScalar(
        int attConfId,
        const std::string& dataTime,
        const std::string& valueR,
        const std::string& valueW,
        int quality,
        int errorDescId,
        const std::string& details) = 0;
    
    /**
     * Write an array value to the appropriate table.
     */
    virtual void writeArray(
        int attConfId,
        const std::string& dataTime,
        const std::vector<std::string>& valueR,
        const std::vector<std::string>& valueW,
        int quality,
        int errorDescId,
        const std::string& details) = 0;
    
    /**
     * Write attribute configuration.
     */
    virtual void writeAttConf(
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
        int ttl) = 0;
};

/**
 * Sink factory - creates appropriate sink based on configuration.
 */
class SinkFactory {
public:
    enum class SinkType {
        TIMESCALE,  // Direct TimescaleDB insert
        FILE        // CSV file output
    };
    
    /**
     * Create a sink of the specified type.
     */
    static std::unique_ptr<ISink> create(SinkType type);
    
    /**
     * Get sink type from environment variable HDBPP_SINK_TYPE.
     * Default is TIMESCALE.
     */
    static SinkType getSinkTypeFromEnv();
};

} // namespace hdbpp

#endif // HDBPP_SINK_INTERFACE_H
