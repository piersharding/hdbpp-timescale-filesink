# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.3.2] - 2026-02-05

### Added [general]

- CI builds docker image for various versions of postgresql

## [2.3.1] - 2025-12-04

### Fixed [general]

- Fix DEV_ENUM type_num in att_conf_type table

### Added [general]

- Support of arrays continuous aggregates through custom aggregation functions

### Change [hdbpp-ttl]

* Docker image now includes all dependencies
* Main script processes new config section in .conf file for rest access

### Added [hdbpp-health-check]

- Check on more than 1 health endpoints.
- Configure the endpoints through a device server property.

## [0.2.0] - 2020-03-06

### Added [general]

- Added a CMake project build system that can build all required elements for deployment. External elements are downloaded to external/
- Added hdbpp-health-check device server to the components.
- Improved the documents

### Added [hdbpp-cluster-reporting]

- endpoints for a basic health check on ttl, backup, tables chunk sizes
- Replica database lag
- Aggregate size
- Aggregate row count per type and interval
- PUT method for barman reporting
- information from barman
- barman hook script to report to reporting tool
- PUT method for ttl reporting
- information from ttl

### Added [hdbpp-ttl]

- Report script result to rest reporting server

### Changed [resources]

- Renamed create-test-database -> test-database
- Updated test-database help display.

### Changed [schema]

- Removed some duplicate indexes
- Schema for the aggregates view for scalar data. Aggregates avg, min, max, stddev over a year. For floating point data, nan and infinity values are counted and not taken into account

### Changed [hdbpp-timescale-docker]

- Updated to TimescaleDB version 1.6

### Changed [hdbpp-cluster-reporting]

- Use /cluster endpoint from patroni, if available, to retrieve some of the data. Check for patroni version if the endpoint exists.

### Fixed [hdbpp-cluster-reporting]

- Block the version for the dependency Werkzeug as new version breaks flaskrestplus

### Fixed [resources]

- test-database script was not clustering tables after data insert.

## [0.1.0] - 2020-01-05

### Added [hdbpp-cluster-reporting]

- Database size
- Attributes count, per type and format
- Tables size
- Last chunk size
- Chunk interval size
- Tables row count

### Changed [hdbpp-reorder-chunks]

- Do not reorder last chunk
- Nor the already ordered chunks 

### Removed [hdbpp-reorder-chunks]

- Schedule window, we keep track of ordered chunks

