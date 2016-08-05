\echo
\echo Creating SAU_GEO Database...
\echo

DROP DATABASE IF EXISTS sau_geo;
CREATE DATABASE sau_geo;

DROP USER IF EXISTS sau_geo;
CREATE USER sau_geo WITH PASSWORD 'sau_geo';

ALTER DATABASE sau_geo OWNER TO sau_geo;
GRANT postgres TO sau_geo;

ALTER USER sau_geo SET search_path TO geo, tiger, topology, tiger_data, public;
