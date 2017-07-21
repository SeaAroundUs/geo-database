@ECHO OFF
IF [%2]==[] (
  SET DbHost=localhost
) ELSE (
  SET DbHost=%2
)

IF [%3]==[] (
  SET DbPort=5432
) ELSE (
  SET DbPort=%3
)

IF [%4]==[] (
  SET DataOnly=-a
) ELSE (
  SET DataOnly= 
)

echo Password for user sau_geo
pg_dump -h %DbHost% -p %DbPort% -f %1 -Fc %DataOnly% -E UTF8 -U sau_geo -t %1 sau_geo -v
@ECHO ON
