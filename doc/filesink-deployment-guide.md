# FileSink Deployment Guide

This guide covers deploying the HDB++ FileSink in production environments.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────┐
│  Tango Control System                                   │
│  ┌────────┐  ┌────────┐  ┌────────┐                   │
│  │Device 1│  │Device 2│  │Device N│                   │
│  └───┬────┘  └───┬────┘  └───┬────┘                   │
│      │           │            │                         │
│      └───────────┴────────────┘                         │
│                  │ Events                               │
└──────────────────┼──────────────────────────────────────┘
                   │
                   ▼
         ┌──────────────────┐
         │   hdbpp-es       │  Event Subscriber
         │   (with FileSink)│  (Modified to use FileSink)
         └────────┬─────────┘
                  │ DataRecords
                  ▼
         ┌──────────────────┐
         │   FileSink       │  CSV Writer
         │   (Queue)        │  - Bounded queue
         │                  │  - Rotation logic
         └────────┬─────────┘  - Atomic publish
                  │ .csv files
                  ▼
         ┌──────────────────┐
         │   Output Dir     │  /var/lib/hdbpp-copy/
         │   *.csv.current  │  Active files
         │   *.csv          │  Published files
         └────────┬─────────┘
                  │
                  ▼
         ┌──────────────────┐
         │  Loader Service  │  Watches for .csv files
         │  (Python/Cron)   │  Loads into TimescaleDB
         └────────┬─────────┘
                  │ SQL COPY
                  ▼
         ┌──────────────────┐
         │  TimescaleDB     │  HDB++ Schema
         │  (PostgreSQL)    │  - Hypertables
         └──────────────────┘  - Continuous aggregates
```

## Deployment Scenarios

### Scenario 1: Single Server (Development/Testing)

All components on one server:
- hdbpp-es with FileSink
- TimescaleDB
- Loader service

**Pros**: Simple setup, easy debugging
**Cons**: Not scalable, single point of failure

### Scenario 2: Separate Storage Server (Production)

- hdbpp-es with FileSink on application server
- Shared NFS/network storage for CSV files
- Loader service on database server

**Pros**: Better resource isolation, scalability
**Cons**: Network dependency, more complex

### Scenario 3: Multiple Event Subscribers (High Availability)

- Multiple hdbpp-es instances with FileSink
- Shared storage with file locking
- Multiple loader instances with coordination

**Pros**: High availability, load distribution
**Cons**: Complex coordination, potential conflicts

## Installation

### Step 1: Build FileSink Library

```bash
cd /path/to/hdbpp-timescale-filesink
mkdir build && cd build
cmake -DBUILD_FILESINK=ON ..
make
sudo make install
```

This installs headers to `/usr/local/include/filesink/`.

### Step 2: Integrate with hdbpp-es

The FileSink can be integrated into hdbpp-es by:

1. **Option A**: Modify libhdbpp-timescale to use FileSink
2. **Option B**: Create a new backend library (libhdbpp-filesink)
3. **Option C**: Use environment variable to switch backends

Example integration code (in hdbpp-es):
```cpp
#include <filesink/FileSinkAdapter.h>

// During initialization
std::unique_ptr<hdbpp::ISink> sink;
const char* sinkType = std::getenv("HDBPP_SINK_TYPE");

if (sinkType && std::string(sinkType) == "file") {
    sink = std::make_unique<hdbpp::FileSinkAdapter>();
} else {
    // Use TimescaleDB sink
    sink = createTimescaleSink();
}

sink->start();
```

### Step 3: Configure Output Directory

```bash
# Create output directory
sudo mkdir -p /var/lib/hdbpp-copy
sudo chown hdbpp:hdbpp /var/lib/hdbpp-copy
sudo chmod 755 /var/lib/hdbpp-copy

# Create processed archive directory
sudo mkdir -p /var/lib/hdbpp-copy/processed
sudo chown hdbpp:hdbpp /var/lib/hdbpp-copy/processed
```

### Step 4: Configure hdbpp-es

Set environment variables in hdbpp-es startup script or systemd service:

```bash
# /etc/default/hdbpp-es or environment file
HDBPP_SINK_TYPE=file
HDBPP_COPY_OUT_DIR=/var/lib/hdbpp-copy
HDBPP_ROTATE_INTERVAL_SECONDS=300
HDBPP_ROTATE_MAX_BYTES=1073741824
HDBPP_QUEUE_MAX_RECORDS=100000
```

### Step 5: Install Loader Service

```bash
# Copy loader script
sudo cp doc/hdbpp-loader.py /usr/local/bin/
sudo chmod +x /usr/local/bin/hdbpp-loader.py

# Install systemd service
sudo cp doc/hdbpp-loader.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable hdbpp-loader
```

### Step 6: Configure Loader

Edit `/etc/default/hdbpp-loader`:
```bash
HDBPP_COPY_OUT_DIR=/var/lib/hdbpp-copy
HDBPP_DB_NAME=hdbpp
HDBPP_DB_HOST=localhost
HDBPP_DB_USER=hdbpp
HDBPP_DB_PASSWORD=secret
```

### Step 7: Start Services

```bash
# Start hdbpp-es with FileSink
sudo systemctl restart hdbpp-es

# Start loader service
sudo systemctl start hdbpp-loader

# Check status
sudo systemctl status hdbpp-es
sudo systemctl status hdbpp-loader
```

## Configuration Tuning

### Rotation Settings

#### Time-Based Rotation

```bash
# Rotate every 5 minutes (default)
HDBPP_ROTATE_INTERVAL_SECONDS=300

# Rotate every hour
HDBPP_ROTATE_INTERVAL_SECONDS=3600

# Rotate every 15 minutes
HDBPP_ROTATE_INTERVAL_SECONDS=900
```

**Guidelines**:
- **Short intervals** (5 min): Lower latency, more files, more loader overhead
- **Long intervals** (60 min): Higher latency, fewer files, better batch efficiency
- **Recommendation**: 5-15 minutes for most deployments

#### Size-Based Rotation

```bash
# Rotate at 1GB (default)
HDBPP_ROTATE_MAX_BYTES=1073741824

# Rotate at 100MB (smaller files)
HDBPP_ROTATE_MAX_BYTES=104857600

# Rotate at 5GB (larger batches)
HDBPP_ROTATE_MAX_BYTES=5368709120
```

**Guidelines**:
- **Small files** (100MB): Better for slow networks, more frequent rotation
- **Large files** (5GB): Better database batch performance, needs more disk space
- **Recommendation**: 512MB - 2GB for most deployments

### Queue Settings

```bash
# Queue size (default 100k records)
HDBPP_QUEUE_MAX_RECORDS=100000

# Larger queue for high event rate
HDBPP_QUEUE_MAX_RECORDS=500000

# Smaller queue for memory-constrained systems
HDBPP_QUEUE_MAX_RECORDS=50000
```

**Memory usage**: Approximately 500 bytes per record
- 100k records ≈ 50 MB
- 500k records ≈ 250 MB

## Monitoring

### Metrics to Monitor

1. **Queue size** - Indicates backpressure
2. **Rotation frequency** - Should match configuration
3. **File sizes** - Check for size-based rotation triggers
4. **Loader lag** - Time between file creation and loading
5. **Disk space** - Ensure sufficient space for CSV files

### Log Locations

```bash
# hdbpp-es logs (FileSink output)
journalctl -u hdbpp-es -f

# Loader service logs
journalctl -u hdbpp-loader -f

# Application logs
tail -f /var/log/hdbpp/filesink.log
```

### Monitoring Script Example

```bash
#!/bin/bash
# monitor-filesink.sh

DATA_DIR=${HDBPP_COPY_OUT_DIR:-/var/lib/hdbpp-copy}

echo "=== FileSink Status ==="
echo "Current files:"
ls -lh $DATA_DIR/*.csv.current 2>/dev/null | wc -l

echo "Ready files:"
ls -lh $DATA_DIR/*.csv 2>/dev/null | wc -l

echo "Disk usage:"
du -sh $DATA_DIR

echo "Oldest unprocessed file:"
ls -lt $DATA_DIR/*.csv 2>/dev/null | tail -1

echo "Newest rotation:"
ls -lt $DATA_DIR/*.csv.current 2>/dev/null | head -1
```

### Prometheus Metrics (Optional)

Export metrics for monitoring:
```python
# In loader service
from prometheus_client import start_http_server, Counter, Gauge

files_loaded = Counter('hdbpp_files_loaded_total', 'Total CSV files loaded')
rows_loaded = Counter('hdbpp_rows_loaded_total', 'Total rows loaded')
queue_size = Gauge('hdbpp_filesink_queue_size', 'Current queue size')
pending_files = Gauge('hdbpp_pending_files', 'Number of .csv files waiting')

# Start metrics server
start_http_server(9090)
```

## Backup and Disaster Recovery

### Backup Strategy

1. **CSV files are the backup** - Keep processed files archived
2. **Database backups** - Regular TimescaleDB backups
3. **Configuration backups** - Save environment configs

### Archive Processed Files

```bash
# Compress and archive daily
0 2 * * * find /var/lib/hdbpp-copy/processed -name "*.csv" -mtime +1 \
    -exec gzip {} \; -exec mv {}.gz /backup/hdbpp-archive/ \;
```

### Disaster Recovery

To restore from CSV backups:
```bash
# Restore database from backup
pg_restore -d hdbpp /backup/hdbpp_backup.dump

# Reload recent CSV files
for file in /backup/hdbpp-archive/*.csv.gz; do
    gunzip -c $file | psql -d hdbpp -c "COPY <table> FROM STDIN WITH (FORMAT csv, NULL '');"
done
```

## Troubleshooting

### High Queue Size

**Symptom**: Queue size consistently at or near maximum

**Causes**:
- Loader too slow
- Database performance issues
- Insufficient rotation (files too large)

**Solutions**:
- Increase loader parallelism
- Optimize database indexes
- Reduce rotation interval/size
- Increase queue size temporarily

### Files Not Being Loaded

**Symptom**: `.csv` files accumulating in output directory

**Causes**:
- Loader service stopped
- Permission issues
- Database connection failure

**Solutions**:
```bash
# Check loader status
systemctl status hdbpp-loader

# Check logs
journalctl -u hdbpp-loader -n 100

# Verify permissions
ls -l /var/lib/hdbpp-copy/

# Test database connection
psql -h localhost -U hdbpp -d hdbpp -c "SELECT 1;"
```

### Disk Space Issues

**Symptom**: Disk full or near capacity

**Causes**:
- Loader too slow, files accumulating
- Archive not configured
- High event rate

**Solutions**:
```bash
# Check disk usage
df -h /var/lib/hdbpp-copy

# Find large files
find /var/lib/hdbpp-copy -type f -size +100M

# Clean old processed files
find /var/lib/hdbpp-copy/processed -mtime +7 -delete
```

## Performance Benchmarks

Typical performance (single hdbpp-es instance):
- **Event rate**: 10,000 - 50,000 events/second
- **Write throughput**: 50-200 MB/s CSV output
- **Queue latency**: < 1 second (normal load)
- **Rotation overhead**: < 500ms
- **Loader throughput**: 100,000 - 500,000 rows/second (COPY)

## Security Considerations

1. **File permissions**: Only hdbpp user should access CSV files
2. **Database credentials**: Use .pgpass or environment variables
3. **Network security**: Firewall rules for PostgreSQL
4. **Audit logging**: Enable PostgreSQL audit logs for COPY operations
5. **Encryption**: Consider encrypting CSV files at rest

## Upgrade Path

To upgrade from TimescaleDB direct insert to FileSink:

1. **Test in development** with production-like data
2. **Parallel run** both sinks temporarily
3. **Monitor metrics** during migration
4. **Validate data** after cutover
5. **Rollback plan** if issues arise

## Production Checklist

- [ ] FileSink built and tested
- [ ] Output directory created with correct permissions
- [ ] Environment variables configured
- [ ] Loader service installed and tested
- [ ] Monitoring configured
- [ ] Backups configured
- [ ] Alerts configured for failures
- [ ] Documentation updated
- [ ] Team trained on new system
- [ ] Rollback plan documented
