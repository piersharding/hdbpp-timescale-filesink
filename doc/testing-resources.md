# Testing Resources

- [Testing Resources](#Testing-Resources)
  - [Test Scripts](#Test-Scripts)
  - [hdbpp-timescale-docker](#hdbpp-timescale-docker)
  - [Test Deployment Guidelines](#Test-Deployment-Guidelines)
    - [Base System](#Base-System)
    - [Insertion Testing](#Insertion-Testing)
    - [Aggregate Views](#Aggregate-Views)
    - [Services](#Services)

## Test Scripts

Test scripts are located [here](../resources/test-scripts). Description of scripts:

- test-database.py - This script has two functions:
  - Build a simple test database by inserting data for all data types over a span of time.
  - It can also insert simple data at regular intervals to simulate the HDB backend. It should be noted the 

See the script help for more details on parameters:

```bash
test-database.py --help
```

Database creation command:

```bash
test-database.py db --help
```

Data insertion command:

```bash
test-database.py data --help
```

## hdbpp-timescale-docker

The Docker image has its own [README](../resources/test-scripts/hdbpp-timescale-docker) that details how to build and deploy the image. 

The image is supplied as a method to quickly setup a test database for development or general system testing. It can be used as a first step for general deployment, but it is not currently recommended for a full production system.

## Test Deployment Guidelines

Some outline guidelines of deploying parts of the system for test and development.

### Base System

To setup a simple system to test again, follow these steps:

- Prepare a server or VM ready for deployment.
- Run the [hdbpp-timescale-docker](../resources/test-scripts/hdbpp-timescale-docker) Docker image (with/without persistent storage)

### Insertion Testing

With the base system deployed, it is possible to deploy the hdbpp-es/hdbpp-cm and the libhdbpp/libhdbpp-timescale shared libraries and insert data from a running Device Server. The setup of the HDB++ hdbpp-es/hdbpp-cm is outside the scope of this project, see the Tango documentation [here](https://tango-controls.readthedocs.io/en/latest) for mofre detailed information on HDB++. Configuration settings for the hdbpp-es/hdbpp-cm properties to interact with the TimescaleDb database is detailed in the libhdbpp-timescale [README](https://gitlab.com/tango-controls/hdbpp/libhdbpp-timescale), and should be reviewed.

### Aggregate Views

The aggregate views are not part of the hdbpp-timescale-docker image and must be added manually. psql can be used from the host system to insert the SQL into the hdb database. For example:

```bash
psql -U postgres -d hdb -a -f hdb_ext_aggregates.sql
```

### Services

All services can be deployed against the hdbpp-timescale-docker Docker image. If deploying test test system all on a single server, the default configuration for each service should be enough to bring up the service. Review each services README for more details on how to deploy:

- [hdbpp-cluster-reporting](../services/hdbpp-cluster-reporting)
- [hdbpp-reorder-chunks](../services/hdbpp-reorder-chunks)
- [hdbpp-ttl](../services/hdbpp-ttl)

Docker deployment recommended.
