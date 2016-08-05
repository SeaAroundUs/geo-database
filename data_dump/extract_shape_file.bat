@ECHO OFF
IF [%1]==[] (
  SET /p ShapeFile=Enter output shape file name:
) ELSE (
  SET ShapeFile=%1
)

IF [%2]==[] (
  SET /p TableOrQuery=Enter db table or query in quotes:
) ELSE (
  SET TableOrQuery=%2
)

IF [%3]==[] (
  SET /p DbServer=Enter host name or IP:
) ELSE (
  SET DbServer=%3
)

pgsql2shp -f %ShapeFile% -u sau_geo -h %DbServer% -P j9CRqMbfEUYG sau_geo %TableOrQuery%
@ECHO ON

