ARG PG_VERSION=pg13
ARG TDB_VERSION=latest
FROM timescale/timescaledb:${TDB_VERSION}-${PG_VERSION} AS hdbpp-timescale

COPY build-files/schema/hdb_schema.sql  /docker-entrypoint-initdb.d/901_hdb_schema.sql
COPY build-files/schema/hdb_roles.sql  /docker-entrypoint-initdb.d/902_hdb_roles.sql
COPY build-files/schema/hdb_images.sql  /docker-entrypoint-initdb.d/903_hdb_images.sql

USER root
RUN chown postgres:postgres /docker-entrypoint-initdb.d/901_hdb_schema.sql
RUN chown postgres:postgres /docker-entrypoint-initdb.d/902_hdb_roles.sql
RUN chown postgres:postgres /docker-entrypoint-initdb.d/903_hdb_images.sql

FROM hdbpp-timescale:latest AS hdbpp-timescale-full

COPY build-files/schema/hdb_ext_users.sql  /docker-entrypoint-initdb.d/910_hdb_ext_users.sql
COPY build-files/schema/hdb_ext_import.sql  /docker-entrypoint-initdb.d/911_hdb_ext_import.sql
#COPY build-files/schema/hdb_ext_aggregates.sql  /docker-entrypoint-initdb.d/912_hdb_ext_aggregates.sql
COPY build-files/schema/hdb_ext_arrays_aggregates_helper.sql  /docker-entrypoint-initdb.d/913_hdb_ext_arrays_aggregates_helper.sql
#COPY build-files/schema/hdb_ext_arrays_aggregates.sql  /docker-entrypoint-initdb.d/914_hdb_ext_arrays_aggregates.sql
COPY build-files/schema/hdb_ext_compress_policy.sql  /docker-entrypoint-initdb.d/915_hdb_ext_compress_policy.sql
COPY build-files/schema/hdb_ext_reorder_policy.sql  /docker-entrypoint-initdb.d/916_hdb_ext_reorder_policy.sql

USER root
RUN chown postgres:postgres /docker-entrypoint-initdb.d/910_hdb_ext_users.sql
RUN chown postgres:postgres /docker-entrypoint-initdb.d/911_hdb_ext_import.sql
#RUN chown postgres:postgres /docker-entrypoint-initdb.d/912_hdb_ext_aggregates.sql
RUN chown postgres:postgres /docker-entrypoint-initdb.d/913_hdb_ext_arrays_aggregates_helper.sql
#RUN chown postgres:postgres /docker-entrypoint-initdb.d/914_hdb_ext_arrays_aggregates.sql
RUN chown postgres:postgres /docker-entrypoint-initdb.d/915_hdb_ext_compress_policy.sql
RUN chown postgres:postgres /docker-entrypoint-initdb.d/916_hdb_ext_reorder_policy.sql

