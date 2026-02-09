# HDB++ File Sink

A file-based sink for HDB++ TimescaleDB archiving that writes CSV files suitable for server-side PostgreSQL COPY operations.

## Overview

The File Sink provides an alternative to direct database insertion, writing archival data to CSV files that can be bulk-loaded into TimescaleDB using PostgreSQL's COPY command. This approach offers:

- **Higher throughput** for bulk data ingestion
- **Decoupled archiving** - data collection separate from database loading
- **Resilience** - files can be retried if database is unavailable
- **At-least-once delivery** semantics

## Features

### CSV Output
- Plain CSV format (UTF-8, no header lines)
- Proper escaping and quoting per RFC 4180
- NULL values represented as empty fields
- PostgreSQL array syntax for array columns

### File Rotation
The sink rotates files based on two triggers:
1. **Time-based**: Aligned to wall-clock boundaries (e.g., every 5 minutes)
2. **Size-based**: When any file or total size exceeds threshold

During rotation:
- All active `.csv.current` files are flushed and synced (`fdatasync`)
- Files are atomically renamed to `.csv` (ready for COPY)
- New `.csv.current` files are opened for the next epoch

### Naming Convention
- Active files: `<table>__<epoch>.csv.current`
- Published files: `<table>__<epoch>.csv`
- Epoch format: `YYYYMMDDTHHMMSSZ` (UTC)

Example:
```
att_scalar_devdouble__20260209T200000Z.csv
att_scalar_devdouble__20260209T200500Z.csv.current
```

### Backpressure
- Bounded in-memory queue between producers and writer
- Blocks producers when queue is full (configurable limit)
- Prevents memory exhaustion under load

## Configuration

All configuration via environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `HDBPP_COPY_OUT_DIR` | `/var/lib/hdbpp-copy` | Output directory for CSV files |
| `HDBPP_ROTATE_INTERVAL_SECONDS` | `300` | Rotation interval (wall-clock aligned) |
| `HDBPP_ROTATE_MAX_BYTES` | `1073741824` (1GB) | Max bytes before rotation |
| `HDBPP_QUEUE_MAX_RECORDS` | `100000` | Queue size limit |

## Usage

### Building

```bash
cd src/filesink
mkdir build && cd build
cmake ..
make
```

This builds:
- `filesink_test` - Unit tests
- `filesink_example` - Example program

### Running Tests

```bash
./filesink_test
```

### Running Example

```bash
# Use defaults
./filesink_example

# Test mode (short rotation intervals)
HDBPP_COPY_OUT_DIR=/tmp/hdbpp-test ./filesink_example --test
```

### Integration

The FileSink is designed to be integrated into the HDB++ Event Subscriber (hdbpp-es) or used as a standalone library.

#### Header-only Library

```cpp
#include "FileSink.h"

using namespace filesink;

// Load config from environment
FileSinkConfig config = FileSinkConfig::fromEnvironment();

// Create and start sink
FileSink sink(config);
sink.start();

// Enqueue records
DataRecord record;
record.tableName = "att_scalar_devdouble";
record.fields = {"1001", "2026-02-09 20:00:00+00", "42.5", "", "0", "", "{}"};
sink.enqueue(record);

// Stop and flush
sink.stop();
```

## Table Schema Mapping

The file sink writes to the same tables as the TimescaleDB backend:

### Data Tables (32 tables)
- **Scalar**: `att_scalar_dev{boolean,uchar,short,ushort,long,ulong,long64,ulong64,float,double,string,state,encoded,enum}` (16 types)
- **Array**: `att_array_dev{boolean,uchar,short,ushort,long,ulong,long64,ulong64,float,double,string,state,encoded,enum}` (16 types)

### Configuration Tables
- `att_conf` - Attribute configuration
- `att_parameter` - Attribute parameters
- `att_error_desc` - Error descriptions
- `att_history` - Configuration history

### Column Structure (Data Tables)
All data tables share this structure:
1. `att_conf_id` (integer)
2. `data_time` (timestamp with timezone)
3. `value_r` (type-specific or array)
4. `value_w` (type-specific or array)
5. `quality` (smallint)
6. `att_error_desc_id` (integer, nullable)
7. `details` (json)

## Loading into PostgreSQL

Use the `COPY` command to load published `.csv` files:

```sql
-- Set NULL representation
\pset null ''

-- Load scalar double data
COPY att_scalar_devdouble 
FROM '/var/lib/hdbpp-copy/att_scalar_devdouble__20260209T200000Z.csv'
WITH (FORMAT csv, NULL '');

-- Load all files for a table (requires superuser or pg_read_server_files role)
COPY att_scalar_devdouble 
FROM PROGRAM 'cat /var/lib/hdbpp-copy/att_scalar_devdouble__*.csv'
WITH (FORMAT csv, NULL '');
```

## Safety Guarantees

1. **Loader safety**: Only consume `.csv` files (never `.csv.current`)
2. **Atomic publish**: `rename()` is atomic on POSIX systems
3. **Durability**: `fdatasync` before publish ensures data on disk
4. **At-least-once**: Records may be duplicated on crash/restart

## Testing

The included tests verify:
- CSV escaping (quotes, commas, newlines)
- NULL formatting
- Array formatting (PostgreSQL syntax)
- Configuration loading
- Rotation alignment
- Filename generation

## Performance Considerations

- **Throughput**: Designed for high-volume event streams
- **Memory**: Bounded queue prevents runaway memory usage
- **Disk I/O**: Buffered writes, sync only on rotation
- **Scalability**: One file per table, parallel COPY possible

## Limitations

- At-least-once semantics (not exactly-once)
- Requires external loader process
- Single output directory (no partitioning by epoch)
