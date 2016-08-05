@ECHO OFF
SET CurrentDir=%~dp0
PUSHD %CurrentDir%

SET DATABASE_NAME=sau_geo
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Process command line parameter(s)
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
SET DbHost=%1
SET DbPort=%2

IF /i "%DbHost%"=="" SET DbHost=localhost
IF /i "%DbPort%"=="" SET DbPort=5432

:::::::::::::::::::::::::
:: Deleting any previous log files
:::::::::::::::::::::::::
IF EXIST log GOTO LogDirExists
mkdir log

:LogDirExists
IF EXIST log\*.log del /Q .\log\*.log
       
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Check if there's already a "sau_geo" database present. 
::   If not, create the "sau_geo" database and the requisite db users, then proceed to invoke the initialize.sql script.
::   If yes, proceed to invoke initialize.sql script only.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::FOR /F "tokens=1 delims=| " %%A IN ('"psql -h %DbHost% -p %DbPort% -U postgres -A -t -c "select datname from pg_database""') DO (
::  IF /i "%%A"=="%DATABASE_NAME%" GOTO CreateIntSchema
::)

:: Only get to this point if we didn't find a database with the name 'sau_geo' in the code immediately above
SET SQLINPUTFILE=create_user_and_db
psql -h %DbHost% -p %DbPort% -U postgres -f %SQLINPUTFILE%.sql -L .\log\%SQLINPUTFILE%.log
IF ERRORLEVEL 1 GOTO ErrorLabel

:CreateIntSchema
SET SQLINPUTFILE=initialize
psql -h %DbHost% -p %DbPort% -d %DATABASE_NAME% -U postgres -f %SQLINPUTFILE%.sql -L .\log\%SQLINPUTFILE%.log
IF ERRORLEVEL 1 GOTO ErrorLabel

:: Check if we are creating a database in an RDS environment, then reconfigure the postgis package appropriately for user access
FOR /F "tokens=1 delims=| " %%A IN ('"psql -h %DbHost% -p %DbPort% -U postgres -A -t -c "select usename from pg_user""') DO (
  IF /i "%%A"=="rdsadmin" GOTO ConfigureForRDS
)
GOTO InitializeGeoSchema

:ConfigureForRDS
ECHO Amazon RDS environment detected. Re-configuring postgis environment appropriately...
SET SQLINPUTFILE=rds_postgis_setup
psql -h %DbHost% -p %DbPort% -d %DATABASE_NAME% -U postgres -f %SQLINPUTFILE%.sql -L .\log\%SQLINPUTFILE%.log
IF ERRORLEVEL 1 GOTO ErrorLabel

:InitializeGeoSchema
IF NOT EXIST data_dump/geo.schema GOTO WrapUp
ECHO Password for user sau_geo
pg_restore -h %DbHost% -p %DbPort% -d %DATABASE_NAME% -Fc -a -j 4 -U sau_geo data_dump/geo.schema
IF ERRORLEVEL 1 GOTO ErrorLabel

:WrapUp
:: Clear previous content or create anew

:: Refreshing materialized views 
psql -h %DbHost% -p %DbPort% -d %DATABASE_NAME% -U sau_geo -t -f refresh_mv.sql -o rmv.sql 
IF ERRORLEVEL 1 GOTO ErrorLabel

ECHO vacuum analyze; >> rmv.sql

:: Adding foreign keys
type index_geo.sql >> rmv.sql

psql -h %DbHost% -p %DbPort% -d %DATABASE_NAME% -U sau_geo -f rmv.sql
IF ERRORLEVEL 1 GOTO ErrorLabel

GOTO Success

:Success
ECHO.
CD %CurrentDir%
ECHO #####
ECHO Successfully created %DATABASE_NAME% database
ECHO #####
GOTO End

:ErrorLabel
CD %CurrentDir%
ECHO "######"
ECHO Error encountered trying to create %DATABASE_NAME% db.
ECHO See .\log\%SQLINPUTFILE%.log for more details...
ECHO #####
GOTO End

:End
SET DbHost=
SET DbPort=
POPD
GOTO:EOF

