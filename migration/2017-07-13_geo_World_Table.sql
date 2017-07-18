drop table geo.world;

CREATE TABLE geo.world (                   
  cell_id integer PRIMARY KEY,
  lon double precision,
  lat double precision,
  cell_row int,  -- "row" is a reserved word in pgplsql
  cell_col int,  -- renamed for consistency
  total_area double precision,
  water_area double precision,
  percent_water double precision,
  ele_min int,
  ele_max int,
  ele_avg int,
  elevation_min int,
  elevation_max int,
  elevation_mean int,
  bathy_min int,
  bathy_max int,
  bathy_mean int,
  fao_area_id int,
  lme_id int,
  bgcp double precision,
  distance double precision,
  coastal_prop double precision,
  shelf double precision,
  slope double precision,
  abyssal double precision,
  estuary double precision,
  mangrove double precision,
  seamount_saup double precision,
  seamount double precision,
  coral double precision,
  front double precision,
  pprod double precision,
  ice_con double precision,
  sst double precision,
  eez_count int,
  sst_2001 double precision,
  bt_2001 double precision,
  pp_10yr_avg double precision,
  sst_avg double precision,
  pp_annual double precision
);

\copy geo.world from 'WorldTable_fronts_2017-07-18.txt' with (format csv, header, delimiter E'\t')

VACUUM FULL ANALYZE geo.world;
