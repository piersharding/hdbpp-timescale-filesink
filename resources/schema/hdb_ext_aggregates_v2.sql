-- -----------------------------------------------------------------------------
-- This file is part of the hdbpp-timescale-project
--
-- Copyright (C) : 2014-2019
--   European Synchrotron Radiation Facility
--   BP 220, Grenoble 38043, FRANCE
--
-- libhdb++timescale is free software: you can redistribute it and/or modify
-- it under the terms of the Lesser GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- libhdb++timescale is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the Lesser
-- GNU General Public License for more details.
--
-- You should have received a copy of the Lesser GNU General Public License
-- along with libhdb++timescale.  If not, see <http://www.gnu.org/licenses/>.
-- -----------------------------------------------------------------------------

-- Continuous aggregates views for the attributes.
\c hdb
-- Double attributes
CREATE MATERIALIZED VIEW cagg_scalar_devdouble_1min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, count_nan_r, mean_r, min_r, max_r, stddev_r
		, count_w, count_nan_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 min', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devdouble
        GROUP BY time_bucket('1 min', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devdouble_1min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 min'
);

CREATE MATERIALIZED VIEW cagg_scalar_devdouble_10min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, count_nan_r, mean_r, min_r, max_r, stddev_r
		, count_w, count_nan_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('10 mins', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devdouble
        GROUP BY time_bucket('10 mins', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devdouble_10min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '10 mins'
);

CREATE MATERIALIZED VIEW cagg_scalar_devdouble_1hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, count_nan_r, mean_r, min_r, max_r, stddev_r
		, count_w, count_nan_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 hour', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devdouble
        GROUP BY time_bucket('1 hour', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devdouble_1hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 hour'
);

CREATE MATERIALIZED VIEW cagg_scalar_devdouble_8hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, count_nan_r, mean_r, min_r, max_r, stddev_r
		, count_w, count_nan_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('8 hours', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devdouble
        GROUP BY time_bucket('8 hours', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devdouble_8hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '8 hours'
);

CREATE MATERIALIZED VIEW cagg_scalar_devdouble_1day(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, count_nan_r, mean_r, min_r, max_r, stddev_r
		, count_w, count_nan_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 day', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devdouble
        GROUP BY time_bucket('1 day', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devdouble_1day',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 day'
);

-- Float attributes
CREATE MATERIALIZED VIEW cagg_scalar_devfloat_1min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 min', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devfloat
        GROUP BY time_bucket('1 min', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devfloat_1min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 min'
);

CREATE MATERIALIZED VIEW cagg_scalar_devfloat_10min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('10 mins', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devfloat
        GROUP BY time_bucket('10 mins', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devfloat_10min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '10 mins'
);

CREATE MATERIALIZED VIEW cagg_scalar_devfloat_1hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 hour', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devfloat
        GROUP BY time_bucket('1 hour', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devfloat_1hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 hour'
);

CREATE MATERIALIZED VIEW cagg_scalar_devfloat_8hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('8 hours', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devfloat
        GROUP BY time_bucket('8 hours', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devfloat_8hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '8 hours'
);

CREATE MATERIALIZED VIEW cagg_scalar_devfloat_1day(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 day', data_time), count(*), count(att_error_desc_id)
		, count(value_r), sum(
                    CASE
                        WHEN value_r='NaN' THEN 1
                        WHEN value_r='infinity' THEN 1
                        WHEN value_r='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , max(
                    CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)
                , stddev(
                    (CASE
                        WHEN value_r='NaN' THEN null
                        WHEN value_r='infinity' THEN null
                        WHEN value_r='-infinity' THEN null
                        ELSE value_r
                    END)::numeric)::float8
		, count(value_w), sum(
                    CASE
                        WHEN value_w='NaN' THEN 1
                        WHEN value_w='infinity' THEN 1
                        WHEN value_w='-infinity' THEN 1
                        ELSE 0
                    END)
                , avg(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
                , min(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , max(
                    CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)
                , stddev(
                    (CASE
                        WHEN value_w='NaN' THEN null
                        WHEN value_w='infinity' THEN null
                        WHEN value_w='-infinity' THEN null
                        ELSE value_w
                    END)::numeric)::float8
       	FROM att_scalar_devfloat
        GROUP BY time_bucket('1 day', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devfloat_1day',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 day'
);

-- Long Attributes
CREATE MATERIALIZED VIEW cagg_scalar_devlong_1min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 min', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong
        GROUP BY time_bucket('1 min', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong_1min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 min'
);

CREATE MATERIALIZED VIEW cagg_scalar_devlong_10min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('10 mins', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong
        GROUP BY time_bucket('10 mins', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong_10min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '10 mins'
);

CREATE MATERIALIZED VIEW cagg_scalar_devlong_1hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 hour', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong
        GROUP BY time_bucket('1 hour', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong_1hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 hour'
);

CREATE MATERIALIZED VIEW cagg_scalar_devlong_8hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('8 hours', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong
        GROUP BY time_bucket('8 hours', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong_8hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '8 hours'
);

CREATE MATERIALIZED VIEW cagg_scalar_devlong_1day(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 day', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong
        GROUP BY time_bucket('1 day', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong_1day',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 day'
);

-- Long 64 attributes
CREATE MATERIALIZED VIEW cagg_scalar_devlong64_1min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 min', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong64
        GROUP BY time_bucket('1 min', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong64_1min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 min'
);

CREATE MATERIALIZED VIEW cagg_scalar_devlong64_10min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('10 mins', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong64
        GROUP BY time_bucket('10 mins', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong64_10min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '10 mins'
);

CREATE MATERIALIZED VIEW cagg_scalar_devlong64_1hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 hour', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong64
        GROUP BY time_bucket('1 hour', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong64_1hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 hour'
);

CREATE MATERIALIZED VIEW cagg_scalar_devlong64_8hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('8 hours', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong64
        GROUP BY time_bucket('8 hours', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong64_8hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '8 hours'
);

CREATE MATERIALIZED VIEW cagg_scalar_devlong64_1day(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 day', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devlong64
        GROUP BY time_bucket('1 day', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devlong64_1day',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 day'
);

-- Short attributes
CREATE MATERIALIZED VIEW cagg_scalar_devshort_1min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 min', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devshort
        GROUP BY time_bucket('1 min', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devshort_1min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 min'
);

CREATE MATERIALIZED VIEW cagg_scalar_devshort_10min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('10 mins', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devshort
        GROUP BY time_bucket('10 mins', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devshort_10min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '10 mins'
);

CREATE MATERIALIZED VIEW cagg_scalar_devshort_1hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 hour', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devshort
        GROUP BY time_bucket('1 hour', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devshort_1hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 hour'
);

CREATE MATERIALIZED VIEW cagg_scalar_devshort_8hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('8 hours', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devshort
        GROUP BY time_bucket('8 hours', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devshort_8hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '8 hours'
);

CREATE MATERIALIZED VIEW cagg_scalar_devshort_1day(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 day', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devshort
        GROUP BY time_bucket('1 day', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devshort_1day',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 day'
);

-- Unsigned long attributes
CREATE MATERIALIZED VIEW cagg_scalar_devulong_1min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 min', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong
        GROUP BY time_bucket('1 min', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong_1min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 min'
);

CREATE MATERIALIZED VIEW cagg_scalar_devulong_10min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('10 mins', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong
        GROUP BY time_bucket('10 mins', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong_10min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '10 mins'
);

CREATE MATERIALIZED VIEW cagg_scalar_devulong_1hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 hour', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong
        GROUP BY time_bucket('1 hour', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong_1hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 hour'
);

CREATE MATERIALIZED VIEW cagg_scalar_devulong_8hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('8 hours', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong
        GROUP BY time_bucket('8 hours', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong_8hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '8 hours'
);

CREATE MATERIALIZED VIEW cagg_scalar_devulong_1day(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 day', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong
        GROUP BY time_bucket('1 day', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong_1day',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 day'
);

-- Unsigned long 64 attributes
CREATE MATERIALIZED VIEW cagg_scalar_devulong64_1min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 min', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong64
        GROUP BY time_bucket('1 min', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong64_1min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 min'
);

CREATE MATERIALIZED VIEW cagg_scalar_devulong64_10min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('10 mins', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong64
        GROUP BY time_bucket('10 mins', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong64_10min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '10 mins'
);

CREATE MATERIALIZED VIEW cagg_scalar_devulong64_1hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 hour', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong64
        GROUP BY time_bucket('1 hour', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong64_1hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 hour'
);

CREATE MATERIALIZED VIEW cagg_scalar_devulong64_8hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('8 hours', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong64
        GROUP BY time_bucket('8 hours', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong64_8hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '8 hours'
);

CREATE MATERIALIZED VIEW cagg_scalar_devulong64_1day(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 day', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devulong64
        GROUP BY time_bucket('1 day', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devulong64_1day',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 day'
);

-- Unsigned short attributes
CREATE MATERIALIZED VIEW cagg_scalar_devushort_1min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 min', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devushort
        GROUP BY time_bucket('1 min', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devushort_1min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 min'
);

CREATE MATERIALIZED VIEW cagg_scalar_devushort_10min(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('10 mins', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devushort
        GROUP BY time_bucket('10 mins', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devushort_10min',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '10 mins'
);

CREATE MATERIALIZED VIEW cagg_scalar_devushort_1hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 hour', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devushort
        GROUP BY time_bucket('1 hour', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devushort_1hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 hour'
);

CREATE MATERIALIZED VIEW cagg_scalar_devushort_8hour(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('8 hours', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devushort
        GROUP BY time_bucket('8 hours', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devushort_8hour',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '8 hours'
);

CREATE MATERIALIZED VIEW cagg_scalar_devushort_1day(
		att_conf_id, data_time, count_rows, count_errors
		, count_r, mean_r, min_r, max_r, stddev_r
		, count_w, mean_w, min_w, max_w, stddev_w
	) WITH (timescaledb.continuous)
       	AS SELECT att_conf_id, time_bucket('1 day', data_time), count(*), count(att_error_desc_id)
		, count(value_r), avg(value_r), min(value_r), max(value_r), stddev(value_r)
		, count(value_w), avg(value_w), min(value_w), max(value_w), stddev(value_w)
       	FROM att_scalar_devushort
        GROUP BY time_bucket('1 day', data_time), att_conf_id;
SELECT add_continuous_aggregate_policy(
    'cagg_scalar_devushort_1day',
    start_offset => NULL,
    end_offset => INTERVAL '0 days',
    schedule_interval => INTERVAL '1 day'
);


--Set access

GRANT ALL ON cagg_scalar_devdouble_1min TO readwrite;
GRANT SELECT ON cagg_scalar_devdouble_1min TO readonly;
GRANT ALL ON cagg_scalar_devdouble_10min TO readwrite;
GRANT SELECT ON cagg_scalar_devdouble_10min TO readonly;
GRANT ALL ON cagg_scalar_devdouble_1hour TO readwrite;
GRANT SELECT ON cagg_scalar_devdouble_1hour TO readonly;
GRANT ALL ON cagg_scalar_devdouble_8hour TO readwrite;
GRANT SELECT ON cagg_scalar_devdouble_8hour TO readonly;
GRANT ALL ON cagg_scalar_devdouble_1day TO readwrite;
GRANT SELECT ON cagg_scalar_devdouble_1day TO readonly;

GRANT ALL ON cagg_scalar_devfloat_1min TO readwrite;
GRANT SELECT ON cagg_scalar_devfloat_1min TO readonly;
GRANT ALL ON cagg_scalar_devfloat_10min TO readwrite;
GRANT SELECT ON cagg_scalar_devfloat_10min TO readonly;
GRANT ALL ON cagg_scalar_devfloat_1hour TO readwrite;
GRANT SELECT ON cagg_scalar_devfloat_1hour TO readonly;
GRANT ALL ON cagg_scalar_devfloat_8hour TO readwrite;
GRANT SELECT ON cagg_scalar_devfloat_8hour TO readonly;
GRANT ALL ON cagg_scalar_devfloat_1day TO readwrite;
GRANT SELECT ON cagg_scalar_devfloat_1day TO readonly;

GRANT ALL ON cagg_scalar_devlong_1min TO readwrite;
GRANT SELECT ON cagg_scalar_devlong_1min TO readonly;
GRANT ALL ON cagg_scalar_devlong_10min TO readwrite;
GRANT SELECT ON cagg_scalar_devlong_10min TO readonly;
GRANT ALL ON cagg_scalar_devlong_1hour TO readwrite;
GRANT SELECT ON cagg_scalar_devlong_1hour TO readonly;
GRANT ALL ON cagg_scalar_devlong_8hour TO readwrite;
GRANT SELECT ON cagg_scalar_devlong_8hour TO readonly;
GRANT ALL ON cagg_scalar_devlong_1day TO readwrite;
GRANT SELECT ON cagg_scalar_devlong_1day TO readonly;

GRANT ALL ON cagg_scalar_devulong_1min TO readwrite;
GRANT SELECT ON cagg_scalar_devulong_1min TO readonly;
GRANT ALL ON cagg_scalar_devulong_10min TO readwrite;
GRANT SELECT ON cagg_scalar_devulong_10min TO readonly;
GRANT ALL ON cagg_scalar_devulong_1hour TO readwrite;
GRANT SELECT ON cagg_scalar_devulong_1hour TO readonly;
GRANT ALL ON cagg_scalar_devulong_8hour TO readwrite;
GRANT SELECT ON cagg_scalar_devulong_8hour TO readonly;
GRANT ALL ON cagg_scalar_devulong_1day TO readwrite;
GRANT SELECT ON cagg_scalar_devulong_1day TO readonly;

GRANT ALL ON cagg_scalar_devulong64_1min TO readwrite;
GRANT SELECT ON cagg_scalar_devulong64_1min TO readonly;
GRANT ALL ON cagg_scalar_devulong64_10min TO readwrite;
GRANT SELECT ON cagg_scalar_devulong64_10min TO readonly;
GRANT ALL ON cagg_scalar_devulong64_1hour TO readwrite;
GRANT SELECT ON cagg_scalar_devulong64_1hour TO readonly;
GRANT ALL ON cagg_scalar_devulong64_8hour TO readwrite;
GRANT SELECT ON cagg_scalar_devulong64_8hour TO readonly;
GRANT ALL ON cagg_scalar_devulong64_1day TO readwrite;
GRANT SELECT ON cagg_scalar_devulong64_1day TO readonly;

GRANT ALL ON cagg_scalar_devlong64_1min TO readwrite;
GRANT SELECT ON cagg_scalar_devlong64_1min TO readonly;
GRANT ALL ON cagg_scalar_devlong64_10min TO readwrite;
GRANT SELECT ON cagg_scalar_devlong64_10min TO readonly;
GRANT ALL ON cagg_scalar_devlong64_1hour TO readwrite;
GRANT SELECT ON cagg_scalar_devlong64_1hour TO readonly;
GRANT ALL ON cagg_scalar_devlong64_8hour TO readwrite;
GRANT SELECT ON cagg_scalar_devlong64_8hour TO readonly;
GRANT ALL ON cagg_scalar_devlong64_1day TO readwrite;
GRANT SELECT ON cagg_scalar_devlong64_1day TO readonly;

GRANT ALL ON cagg_scalar_devshort_1min TO readwrite;
GRANT SELECT ON cagg_scalar_devshort_1min TO readonly;
GRANT ALL ON cagg_scalar_devshort_10min TO readwrite;
GRANT SELECT ON cagg_scalar_devshort_10min TO readonly;
GRANT ALL ON cagg_scalar_devshort_1hour TO readwrite;
GRANT SELECT ON cagg_scalar_devshort_1hour TO readonly;
GRANT ALL ON cagg_scalar_devshort_8hour TO readwrite;
GRANT SELECT ON cagg_scalar_devshort_8hour TO readonly;
GRANT ALL ON cagg_scalar_devshort_1day TO readwrite;
GRANT SELECT ON cagg_scalar_devshort_1day TO readonly;

GRANT ALL ON cagg_scalar_devushort_1min TO readwrite;
GRANT SELECT ON cagg_scalar_devushort_1min TO readonly;
GRANT ALL ON cagg_scalar_devushort_10min TO readwrite;
GRANT SELECT ON cagg_scalar_devushort_10min TO readonly;
GRANT ALL ON cagg_scalar_devushort_1hour TO readwrite;
GRANT SELECT ON cagg_scalar_devushort_1hour TO readonly;
GRANT ALL ON cagg_scalar_devushort_8hour TO readwrite;
GRANT SELECT ON cagg_scalar_devushort_8hour TO readonly;
GRANT ALL ON cagg_scalar_devushort_1day TO readwrite;
GRANT SELECT ON cagg_scalar_devushort_1day TO readonly;



-- Drop all the views
-- DROP VIEW cagg_scalar_devdouble_1min CASCADE;
-- DROP VIEW cagg_scalar_devdouble_10min CASCADE;
-- DROP VIEW cagg_scalar_devdouble_1hour CASCADE;
-- DROP VIEW cagg_scalar_devdouble_8hour CASCADE;
-- DROP VIEW cagg_scalar_devdouble_1day CASCADE;

-- DROP VIEW cagg_scalar_devfloat_1min CASCADE;
-- DROP VIEW cagg_scalar_devfloat_10min CASCADE;
-- DROP VIEW cagg_scalar_devfloat_1hour CASCADE;
-- DROP VIEW cagg_scalar_devfloat_8hour CASCADE;
-- DROP VIEW cagg_scalar_devfloat_1day CASCADE;

-- DROP VIEW cagg_scalar_devlong_1min CASCADE;
-- DROP VIEW cagg_scalar_devlong_10min CASCADE;
-- DROP VIEW cagg_scalar_devlong_1hour CASCADE;
-- DROP VIEW cagg_scalar_devlong_8hour CASCADE;
-- DROP VIEW cagg_scalar_devlong_1day CASCADE;

-- DROP VIEW cagg_scalar_devlong64_1min CASCADE;
-- DROP VIEW cagg_scalar_devlong64_10min CASCADE;
-- DROP VIEW cagg_scalar_devlong64_1hour CASCADE;
-- DROP VIEW cagg_scalar_devlong64_8hour CASCADE;
-- DROP VIEW cagg_scalar_devlong64_1day CASCADE;

-- DROP VIEW cagg_scalar_devshort_1min CASCADE;
-- DROP VIEW cagg_scalar_devshort_10min CASCADE;
-- DROP VIEW cagg_scalar_devshort_1hour CASCADE;
-- DROP VIEW cagg_scalar_devshort_8hour CASCADE;
-- DROP VIEW cagg_scalar_devshort_1day CASCADE;

-- DROP VIEW cagg_scalar_devulong_1min CASCADE;
-- DROP VIEW cagg_scalar_devulong_10min CASCADE;
-- DROP VIEW cagg_scalar_devulong_1hour CASCADE;
-- DROP VIEW cagg_scalar_devulong_8hour CASCADE;
-- DROP VIEW cagg_scalar_devulong_1day CASCADE;

-- DROP VIEW cagg_scalar_devulong64_1min CASCADE;
-- DROP VIEW cagg_scalar_devulong64_10min CASCADE;
-- DROP VIEW cagg_scalar_devulong64_1hour CASCADE;
-- DROP VIEW cagg_scalar_devulong64_8hour CASCADE;
-- DROP VIEW cagg_scalar_devulong64_1day CASCADE;

-- DROP VIEW cagg_scalar_devushort_1min CASCADE;
-- DROP VIEW cagg_scalar_devushort_10min CASCADE;
-- DROP VIEW cagg_scalar_devushort_1hour CASCADE;
-- DROP VIEW cagg_scalar_devushort_8hour CASCADE;
-- DROP VIEW cagg_scalar_devushort_1day CASCADE;
