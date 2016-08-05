\echo
\echo Adding usefull extensions...
-- sau public (global) schema objects
\i aggregate.sql
\i view.sql
\cd util
\i initialize.sql
\cd ..

--These extensions are not supported by RDS
--CREATE EXTENSION adminpack;
--CREATE EXTENSION xml2;

DROP EXTENSION IF EXISTS dblink CASCADE;
DROP EXTENSION IF EXISTS hstore CASCADE;
DROP EXTENSION IF EXISTS intarray CASCADE;
DROP EXTENSION IF EXISTS tablefunc CASCADE;
DROP EXTENSION IF EXISTS "uuid-ossp" CASCADE;
DROP EXTENSION IF EXISTS fuzzystrmatch CASCADE;
DROP EXTENSION IF EXISTS postgis CASCADE;

CREATE EXTENSION dblink;
CREATE EXTENSION hstore;
CREATE EXTENSION intarray;
CREATE EXTENSION tablefunc;
CREATE EXTENSION "uuid-ossp";
CREATE EXTENSION fuzzystrmatch;
CREATE EXTENSION postgis;
CREATE EXTENSION postgis_topology;
CREATE EXTENSION postgis_tiger_geocoder;

\echo
\echo Creating Admin DB Objects...
\echo
\c sau_geo sau_geo

--- Create a project schema (namespace) for ease of maintenance (backup)
DROP SCHEMA IF EXISTS geo CASCADE;
CREATE SCHEMA geo;

\echo
\echo Creating DB Objects for the Geo schema...
\echo
\i table_geo.sql
\i function_geo.sql
