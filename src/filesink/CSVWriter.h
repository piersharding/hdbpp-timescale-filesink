#ifndef FILESINK_CSV_WRITER_H
#define FILESINK_CSV_WRITER_H

#include <string>
#include <sstream>
#include <vector>

namespace filesink {

/**
 * Utility class for proper CSV escaping and formatting.
 */
class CSVWriter {
public:
    /**
     * Escape a string value for CSV output.
     * Handles quotes, commas, newlines according to RFC 4180.
     */
    static std::string escapeCSV(const std::string& value) {
        bool needsQuoting = false;
        
        // Check if we need quoting (contains comma, quote, newline, or CR)
        if (value.find(',') != std::string::npos ||
            value.find('"') != std::string::npos ||
            value.find('\n') != std::string::npos ||
            value.find('\r') != std::string::npos) {
            needsQuoting = true;
        }
        
        if (!needsQuoting) {
            return value;
        }
        
        // Escape quotes by doubling them
        std::string escaped;
        escaped.reserve(value.size() + 10);
        for (char c : value) {
            if (c == '"') {
                escaped += "\"\"";
            } else {
                escaped += c;
            }
        }
        
        // Wrap in quotes
        return "\"" + escaped + "\"";
    }
    
    /**
     * Convert a vector/array to PostgreSQL array format for CSV.
     * Example: {1,2,3} for integer arrays
     */
    template<typename T>
    static std::string arrayToPostgresArray(const std::vector<T>& values) {
        if (values.empty()) {
            return "{}";
        }
        
        std::ostringstream oss;
        oss << "{";
        for (size_t i = 0; i < values.size(); ++i) {
            if (i > 0) oss << ",";
            oss << values[i];
        }
        oss << "}";
        return oss.str();
    }
    
    /**
     * Specialized version for string arrays (needs quoting within the array)
     */
    static std::string stringArrayToPostgresArray(const std::vector<std::string>& values) {
        if (values.empty()) {
            return "{}";
        }
        
        std::ostringstream oss;
        oss << "{";
        for (size_t i = 0; i < values.size(); ++i) {
            if (i > 0) oss << ",";
            // Within PostgreSQL array syntax, quotes are escaped differently
            oss << "\"";
            for (char c : values[i]) {
                if (c == '"' || c == '\\') {
                    oss << '\\';
                }
                oss << c;
            }
            oss << "\"";
        }
        oss << "}";
        return oss.str();
    }
    
    /**
     * Format NULL value for CSV (empty field).
     */
    static std::string formatNull() {
        return "";
    }
    
    /**
     * Build a CSV row from values.
     */
    static std::string buildRow(const std::vector<std::string>& fields) {
        std::ostringstream oss;
        for (size_t i = 0; i < fields.size(); ++i) {
            if (i > 0) oss << ",";
            oss << fields[i];
        }
        oss << "\n";
        return oss.str();
    }
};

} // namespace filesink

#endif // FILESINK_CSV_WRITER_H
