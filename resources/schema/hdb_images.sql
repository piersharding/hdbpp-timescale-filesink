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
\c hdb

CREATE TABLE IF NOT EXISTS att_image_devboolean (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r boolean[][],
    value_w boolean[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devboolean IS 'Array Boolean Values Table';
CREATE INDEX IF NOT EXISTS att_image_devboolean_att_conf_id_idx ON att_image_devboolean (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devboolean_att_conf_id_data_time_idx ON att_image_devboolean (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devboolean', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devuchar (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r uchar[][],
    value_w uchar[][],
    quality smallint,
    details json,
    att_error_desc_id integer,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devuchar IS 'Array UChar Values Table';
CREATE INDEX IF NOT EXISTS att_image_devuchar_att_conf_id_idx ON att_image_devuchar (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devuchar_att_conf_id_data_time_idx ON att_image_devuchar (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devuchar', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devshort (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r smallint[][],
    value_w smallint[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devshort IS 'Array Short Values Table';
CREATE INDEX IF NOT EXISTS att_image_devshort_att_conf_id_idx ON att_image_devshort (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devshort_att_conf_id_data_time_idx ON att_image_devshort (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devshort', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devushort (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r ushort[][],
    value_w ushort[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devushort IS 'Array UShort Values Table';
CREATE INDEX IF NOT EXISTS att_image_devushort_att_conf_id_idx ON att_image_devushort (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devushort_att_conf_id_data_time_idx ON att_image_devushort (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devushort', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devlong (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r integer[][],
    value_w integer[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devlong IS 'Array Long Values Table';
CREATE INDEX IF NOT EXISTS att_image_devlong_att_conf_id_idx ON att_image_devlong (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devlong_att_conf_id_data_time_idx ON att_image_devlong (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devlong', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devulong (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r ulong[][],
    value_w ulong[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devulong IS 'Array ULong Values Table';
CREATE INDEX IF NOT EXISTS att_image_devulong_att_conf_id_idx ON att_image_devulong (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devulong_att_conf_id_data_time_idx ON att_image_devulong (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devulong', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devlong64 (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r bigint[][],
    value_w bigint[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devlong64 IS 'Array Long64 Values Table';
CREATE INDEX IF NOT EXISTS att_image_devlong64_att_conf_id_idx ON att_image_devlong64 (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devlong64_att_conf_id_data_time_idx ON att_image_devlong64 (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devlong64', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devulong64 (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r ulong64[][],
    value_w ulong64[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devulong64 IS 'Array ULong64 Values Table';
CREATE INDEX IF NOT EXISTS att_image_devulong64_att_conf_id_idx ON att_image_devulong64 (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devulong64_att_conf_id_data_time_idx ON att_image_devulong64 (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devulong64', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devfloat (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r real[][],
    value_w real[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devfloat IS 'Array Float Values Table';
CREATE INDEX IF NOT EXISTS att_image_devfloat_att_conf_id_idx ON att_image_devfloat (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devfloat_att_conf_id_data_time_idx ON att_image_devfloat (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devfloat', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devdouble (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r double precision[][],
    value_w double precision[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devdouble IS 'Array Double Values Table';
CREATE INDEX IF NOT EXISTS att_image_devdouble_att_conf_id_idx ON att_image_devdouble (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devdouble_att_conf_id_data_time_idx ON att_image_devdouble (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devdouble', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devstring (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r text[][],
    value_w text[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devstring IS 'Array String Values Table';
CREATE INDEX IF NOT EXISTS att_image_devstring_att_conf_id_idx ON att_image_devstring (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devstring_att_conf_id_data_time_idx ON att_image_devstring (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devstring', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devstate (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r integer[][],
    value_w integer[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devstate IS 'Array State Values Table';
CREATE INDEX IF NOT EXISTS att_image_devstate_att_conf_id_idx ON att_image_devstate (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devstate_att_conf_id_data_time_idx ON att_image_devstate (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devstate', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devencoded (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r bytea[][],
    value_w bytea[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);
COMMENT ON TABLE att_image_devencoded IS 'Array DevEncoded Values Table';
CREATE INDEX IF NOT EXISTS att_image_devencoded_att_conf_id_idx ON att_image_devencoded (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devencoded_att_conf_id_data_time_idx ON att_image_devencoded (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devencoded', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

CREATE TABLE IF NOT EXISTS att_image_devenum (
    att_conf_id integer NOT NULL,
    data_time timestamp WITH TIME ZONE NOT NULL,
    value_r_label text[][],
    value_r smallint[][],
    value_w_label text[][],
    value_w smallint[][],
    quality smallint,
    att_error_desc_id integer,
    details json,
    PRIMARY KEY (att_conf_id, data_time),
    FOREIGN KEY (att_conf_id) REFERENCES att_conf (att_conf_id),
    FOREIGN KEY (att_error_desc_id) REFERENCES att_error_desc (att_error_desc_id)
);

COMMENT ON TABLE att_image_devenum IS 'Array Enum Values Table';
CREATE INDEX IF NOT EXISTS att_image_devenum_att_conf_id_idx ON att_image_devenum (att_conf_id);
CREATE INDEX IF NOT EXISTS att_image_devenum_att_conf_id_data_time_idx ON att_image_devenum (att_conf_id,data_time DESC);
SELECT create_hypertable('att_image_devenum', 'data_time', chunk_time_interval => interval '28 day', create_default_indexes => FALSE);

-- Trigger to set the enum_labels
CREATE OR REPLACE FUNCTION set_enum_label_array() RETURNS TRIGGER AS $$
DECLARE
BEGIN
    IF NEW.value_r IS NOT NULL THEN
	WITH enum_labels AS (
		SELECT enum_labels FROM att_parameter WHERE att_conf_id=NEW.att_conf_id ORDER BY recv_time DESC limit 1
	)
        SELECT array_agg(res) FROM (SELECT enum_labels[UNNEST(NEW.value_r)+ 1] FROM enum_labels) as res INTO NEW.value_r_label;
    END IF;
    IF NEW.value_w IS NOT NULL THEN
	WITH enum_labels AS (
		SELECT enum_labels FROM att_parameter WHERE att_conf_id=NEW.att_conf_id ORDER BY recv_time DESC limit 1
	)
        SELECT array_agg(res) FROM (SELECT enum_labels[UNNEST(NEW.value_w)+ 1] FROM enum_labels) as res INTO NEW.value_w_label;
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER enum_label_trigger BEFORE INSERT ON att_image_devenum FOR EACH ROW EXECUTE PROCEDURE set_enum_label_array();

