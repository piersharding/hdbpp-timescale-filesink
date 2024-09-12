-- -----------------------------------------------------------------------------
-- This file is part of the hdbpp-timescale-project
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

\c hdb

-------------------------------------------------------------------------------
ALTER TABLE att_conf ALTER COLUMN ttl TYPE INTERVAL using (make_interval(hours => ttl));

-- The reverse command to go back if needed.
-- ALTER TABLE att_conf ALTER COLUMN ttl TYPE int using (extract(hours from ttl));

CREATE OR REPLACE PROCEDURE delete_expired_ttl(job_id int, job_config jsonb) LANGUAGE PLPGSQL AS
$$
DECLARE
    compress_interval INTERVAL;
    ttls record;
BEGIN
    SELECT (config->>'compress_after')::interval INTO compress_interval FROM timescaledb_information.jobs WHERE application_name LIKE 'Compression%' LIMIT 1;
    IF FOUND THEN
        for ttls in SELECT att_conf_id, ttl, table_name, att_name FROM att_conf WHERE ttl IS NOT NULL AND ttl > INTERVAL '0 days' loop
            EXECUTE format('DELETE FROM %I WHERE data_time BETWEEN CURRENT_DATE - $1 AND CURRENT_DATE - $2 AND att_conf_id = $3', ttls.table_name) USING compress_interval, ttls.ttl, ttls.att_conf_id;
        end loop;
    ELSE
        for ttls in SELECT att_conf_id, ttl, table_name, att_name FROM att_conf WHERE ttl IS NOT NULL AND ttl > INTERVAL '0 days' loop
            EXECUTE format('DELETE FROM %I WHERE data_time < CURRENT_DATE - $1 AND att_conf_id = $2', ttls.table_name) USING ttls.ttl, ttls.att_conf_id;
        end loop;
    END IF;
END
$$; 

SELECT add_job('delete_expired_ttl', initial_start => '2024-08-03 00:00:00+00'::timestamptz);
