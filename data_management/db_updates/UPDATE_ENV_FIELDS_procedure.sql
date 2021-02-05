-- Check that all vrecords are ok
SELECT * from env_data.gps_data_animals_imp 
where gps_validity_code not in (1,2,3) or gps_validity_code is null;

SELECT * from env_data.gps_data_animals_imp 
where geom is null or acquisition_time is null;

-- Update field geom (from lat/long)
UPDATE env_data.gps_data_animals_imp 
SET geom = st_setsrid(st_makepoint(longitude,latitude),4326)
where longitude IS NOT NULL AND latitude IS NOT NULL AND geom IS NULL;

-- Update sun angle
UPDATE env_data.gps_data_animals_imp 
SET sun_angle = tools.sun_elevation_angle(acquisition_time, geom) 
WHERE sun_angle IS NULL;

-- Update reference utm zone and related X/Y coordinates
UPDATE env_data.gps_data_animals_imp 
SET utm_srid = foo.a 
FROM
	(SELECT euro_db, animals_id, tools.srid_utm(st_x(ST_Centroid(st_collect(geom))), st_y((ST_Centroid(st_collect(geom))))) AS a 
	FROM env_data.gps_data_animals_imp where utm_srid is null
	GROUP BY euro_db, animals_id) AS foo 
WHERE gps_data_animals_imp.animals_id = foo.animals_id and gps_data_animals_imp.euro_db = foo.euro_db;

UPDATE env_data.gps_data_animals_imp 
SET utm_x = st_x(st_transform(geom, utm_srid)), utm_y = st_y(st_transform(geom, utm_srid));

-- I update the geom srid 3035 to speed up intersection with copernicus layers
update env_data.gps_data_animals_imp set geom_3035 = st_transform(geom,3035);

-- CORINE raster
UPDATE env_data.gps_data_animals_imp 
SET corine_land_cover_1990_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_1990
WHERE corine_land_cover_1990_code IS NULL AND st_intersects(geom_3035, rast);
UPDATE env_data.gps_data_animals_imp 
SET corine_land_cover_2000_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2000
WHERE corine_land_cover_2000_code IS NULL  AND st_intersects(geom_3035, rast);
UPDATE env_data.gps_data_animals_imp 
SET corine_land_cover_2006_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2006
WHERE corine_land_cover_2006_code IS NULL  AND st_intersects(geom_3035, rast);
UPDATE env_data.gps_data_animals_imp 
SET corine_land_cover_2012_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2012
WHERE corine_land_cover_2012_code IS NULL AND st_intersects(geom_3035, rast);
UPDATE env_data.gps_data_animals_imp 
SET corine_land_cover_2018_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2018
WHERE corine_land_cover_2018_code IS NULL AND st_intersects(geom_3035, rast);

-- Copernicus layer (I have first to clip and import the areas of interest from the huge original layers)
-- First I generate a bounding box for each area
-- Then I create the gdal commands to clip the raster 
-- Then I import the raster and run the intersection

-- Bounding boxes (might take 1-2 minutes)
drop table if exists env_data.box_union_imp;
create table env_data.box_union_imp as
with convex_hull_box as
(select 
(row_number() over())::integer as id,
euro_db,
animals_id,
euro_db||'_'||
animals_id as code,
(ST_Expand(st_envelope(st_transform(st_convexhull(st_collect(geom)),3035)), 5000))::geometry(polygon,3035)
as geom_3035
from 
env_data.gps_data_animals_imp
group by 
euro_db,
animals_id)
Select (row_number() over())::integer as id, geom_3035
 from 
 (select (st_envelope((st_dump(st_union(geom_3035))).geom))::geometry(polygon,3035) geom_3035 from 
 (select (st_envelope((st_dump(st_union(geom_3035))).geom))::geometry(polygon,3035) geom_3035 from 
 (select (st_envelope((st_dump(st_union(geom_3035))).geom))::geometry(polygon,3035) geom_3035
 from convex_hull_box) a
 where st_geometrytype (geom_3035) = 'ST_Polygon') b) c;
 ALTER TABLE  env_data.box_union_imp ADD PRIMARY KEY (id);
ALTER TABLE  env_data.box_union_imp OWNER TO data_curators_eurodeer;

-- FOREST DENSITY

-- I generate the gdal command to clip the raster image (copy past the results from the query output file into GDAL dos on the server)
-- Clear the folder E:\eurodeer_data\raster\local_intersection\ before you run the gdal command 

with bbox_20 as
(SELECT id, 
            right(((id+1000)::text),3) AS code,
    floor(st_xmin(geom_3035::box3d) / 2560::double precision) * 2560::double precision AS xmin,
    ceil(st_xmax(geom_3035::box3d) / 2560::double precision) * 2560::double precision AS xmax,
    floor(st_ymin(geom_3035::box3d) / 2560::double precision) * 2560::double precision AS ymin,
    ceil(st_ymax(geom_3035::box3d) / 2560::double precision) * 2560::double precision AS ymax
   FROM env_data.box_union_imp)
SELECT ((((((((((('gdal_translate -ot BYTE -a_nodata 255 -projwin '::text || xmin) || ' '::text) || ymax) || ' '::text) || xmax) || ' '::text) || ymin) || ' -co "TILED=YES" -co "BLOCKXSIZE=128" -co "BLOCKYSIZE=128" E:\eurodeer_data\raster\remote_sensing\forestcover\copernicus\forest_density.tif E:\eurodeer_data\raster\local_intersection\forest_density_'::text))) ||code::text) || '.tif'::text AS query
   FROM bbox_20;

-- In the database
DROP TABLE IF EXISTS env_data.forest_density;
-- In DOS
raster2pgsql -c -R -F -C -I -x -t 128x128 -N 255 -M E:\eurodeer_data\raster\local_intersection\forest_density_*.tif env_data.forest_density| psql -d eurodeer_db -U postgres  -p 5432
-- In the databse
ALTER TABLE  env_data.env_data.forest_density OWNER TO data_curators_eurodeer;

-- Intersection
UPDATE main.env_data.gps_data_animals_imp
SET forest_density = st_value(forest_density.rast, geom_3035)
FROM env_data.forest_density
WHERE forest_density IS NULL AND st_intersects(forest_density.rast,geom_3035);

-- Update DEM+SLOPE+ASPECT (Copernicus layer)

-- First I generate the tiles that I need, as for forest density
-- I copy past the result of the query into gdal prompt to generate the .tif files
 WITH bbox_clip_25 AS (
 SELECT id, 
            right(((id+1000)::text),3) AS code,
    floor(st_xmin(geom_3035) / 3200::double precision) * 3200::double precision AS xmin,
    ceil(st_xmax(geom_3035) / 3200::double precision) * 3200::double precision AS xmax,
    floor(st_ymin(geom_3035) / 3200::double precision) * 3200::double precision AS ymin,
    ceil(st_ymax(geom_3035) / 3200::double precision) * 3200::double precision AS ymax
   FROM env_data.box_union_imp)
SELECT query from(
 SELECT ((((((((((('gdal_translate -ot Int16 -a_nodata -32768 -projwin '::text || bbox_clip_25.xmin) || ' '::text) || bbox_clip_25.ymax) || ' '::text) || bbox_clip_25.xmax) || ' '::text) || bbox_clip_25.ymin) || ' -co "TILED=YES" -co "BLOCKXSIZE=128" -co "BLOCKYSIZE=128" E:\eurodeer_data\raster\dem\copernicus\eudem_dem_3035_europe.tif E:\eurodeer_data\raster\local_intersection\dem_'::text) )) || bbox_clip_25.code::text) || '.tif'::text AS query,
    1 AS orderx
   FROM bbox_clip_25
UNION
 SELECT ((((((('gdaldem slope -co "TILED=YES" -co "BLOCKXSIZE=128" -co "BLOCKYSIZE=128"  E:\eurodeer_data\raster\local_intersection\dem_'::text )) || bbox_clip_25.code::text) || '.tif E:\eurodeer_data\raster\local_intersection\slope_'::text))) || bbox_clip_25.code::text) || '.tif'::text AS query,
    2 AS orderx
   FROM bbox_clip_25
UNION
 SELECT ((((((('gdaldem aspect -co "TILED=YES" -co "BLOCKXSIZE=128" -co "BLOCKYSIZE=128" E:\eurodeer_data\raster\local_intersection\dem_'::text )) || bbox_clip_25.code::text) || '.tif E:\eurodeer_data\raster\local_intersection\aspect_'::text))) || bbox_clip_25.code::text) || '.tif'::text AS query,
    3 AS orderx
   FROM bbox_clip_25) a
  ORDER BY orderx, query;

-- In the database
DROP TABLE IF EXISTS env_data.dem_copernicus;
DROP TABLE IF EXISTS env_data.slope_copernicus;
DROP TABLE IF EXISTS env_data.aspect_copernicus;
-- In GDAL DOS
raster2pgsql -c -R -F -C -I -x -t 128x128 -N 255 -M E:\eurodeer_data\raster\local_intersection\dem_*.tif env_data.dem_copernicus| psql -d eurodeer_db -U postgres  -p 5432

-- In GDAL DOS
raster2pgsql -c -R -F -C -I -x -t 128x128 -N 255 -M E:\eurodeer_data\raster\local_intersection\slope_*.tif env_data.slope_copernicus| psql -d eurodeer_db -U postgres  -p 5432

-- In GDAL DOS
raster2pgsql -c -R -F -C -I -x -t 128x128 -N 255 -M E:\eurodeer_data\raster\local_intersection\aspect_*.tif env_data.aspect_copernicus| psql -d eurodeer_db -U postgres  -p 5432

-- In the database
ALTER TABLE  env_data.dem_copernicus OWNER TO data_curators_eurodeer;
ALTER TABLE  env_data.slope_copernicus OWNER TO data_curators_eurodeer;
ALTER TABLE  env_data.aspect_copernicus OWNER TO data_curators_eurodeer;

-- Intersection
UPDATE env_data.gps_data_animals_imp
SET altitude_copernicus = st_value(dem_copernicus.rast, geom_3035)
FROM env_data.dem_copernicus
WHERE altitude_copernicus IS NULL AND st_intersects(dem_copernicus.rast,geom_3035);

UPDATE env_data.gps_data_animals_imp 
SET slope_copernicus = st_value(slope_copernicus.rast, geom_3035)
FROM env_data.slope_copernicus
WHERE slope_copernicus IS NULL AND st_intersects(slope_copernicus.rast,geom_3035);

UPDATE env_data.gps_data_animals_imp
SET aspect_copernicus = st_value(aspect_copernicus.rast, geom_3035)
FROM env_data.aspect_copernicus
WHERE aspect_copernicus IS NULL AND st_intersects(aspect_copernicus.rast,geom_3035);

-- MODIS SNOW 
UPDATE 
env_data.gps_data_animals_imp 
SET snow_modis = st_value(rast, geom)
FROM env_data_ts.snow_modis
WHERE
  snow_modis is null and 
  st_intersects(geom, rast) and 
  acquisition_time::date >= snow_modis.acquisition_date and  
  acquisition_time::date <  
    (case 
      WHEN extract (year FROM (snow_modis.acquisition_date + INTERVAL '8 days')) = extract (year FROM (snow_modis.acquisition_date)) then (snow_modis.acquisition_date + INTERVAL '8 days')
      else ('1-1-' || extract (year FROM snow_modis.acquisition_date)+1)::date
    END);

-- MODIS NDVI SMOOTHED --
UPDATE
env_data.gps_data_animals_imp 
SET
ndvi_modis_smoothed = (st_value(pre.rast, geom)*(post.acquisition_date - acquisition_time::date)/(post.acquisition_date - pre.acquisition_date) +
st_value(post.rast, geom)*(- (pre.acquisition_date - acquisition_time::date))/(post.acquisition_date - pre.acquisition_date)) * 0.0048 -0.2
FROM env_data_ts.ndvi_modis_smoothed pre, env_data_ts.ndvi_modis_smoothed post
WHERE
  ndvi_modis_smoothed IS NULL AND 
  st_intersects(geom, pre.rast) and 
  st_intersects(geom, post.rast) and 
  pre.acquisition_date = 
    case 
    WHEN extract ('day' FROM acquisition_time) < 6 then (extract('year' FROM acquisition_time::date -6 )||'-'||extract ('month' FROM acquisition_time::date - 6)||'-26')::date
    WHEN extract ('day' FROM acquisition_time) < 16 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-06')::date
    WHEN extract ('day' FROM acquisition_time) < 26 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-16')::date
    else  (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-26')::date end and
  post.acquisition_date = 
    case 
    WHEN extract ('day' FROM acquisition_time) < 6 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-06')::date
    WHEN extract ('day' FROM acquisition_time) < 16 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-16')::date
    WHEN extract ('day' FROM acquisition_time) < 26 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-26')::date
    else  (extract('year' FROM acquisition_time::date+6)||'-'||extract ('month' FROM acquisition_time::date+6)||'-06')::date end;
	
-- MODIS NDVI BOKU --
UPDATE env_data.gps_data_animals_imp 
SET ndvi_modis_boku = (trunc((st_value(pre.rast, geom) * (date_trunc('week', acquisition_time::date + 7)::date -acquisition_time::date)::integer +
st_value(post.rast, geom) * (acquisition_time::date - date_trunc('week', acquisition_time::date)::date))::integer/7)) * 0.0048 -0.2
FROM env_data_ts.ndvi_modis_boku pre, env_data_ts.ndvi_modis_boku post
WHERE
  st_intersects(geom, pre.rast) and 
  st_intersects(geom, post.rast) and 
  date_trunc('week', acquisition_time::date)::date = pre.acquisition_date and 
  date_trunc('week', acquisition_time::date + 7)::date = post.acquisition_date;

----------------------------------------------
-- CODE TO GENERATE THE TABLE TO BE UPDATED --
----------------------------------------------

CREATE TABLE env_data.gps_data_animals_imp
(
  euro_db character varying NOT NULL,
  gps_data_animals_id integer NOT NULL,
  animals_id integer,
  study_areas_id integer
  acquisition_time timestamp with time zone,
  latitude double precision,
  longitude double precision,
  geom geometry(Point,4326),
  gps_validity_code smallint,
  snow_modis integer,
  sun_angle double precision,
  utm_srid integer,
  utm_x integer,
  utm_y integer,
  corine_land_cover_2006_code integer,
  corine_land_cover_2000_code integer,
  corine_land_cover_1990_code integer,
  corine_land_cover_2012_code integer,
  corine_land_cover_2012_vector_code integer,
  corine_land_cover_2018_code integer,
  ndvi_modis_boku double precision,
  ndvi_modis_smoothed double precision,
  update_core_timestamp timestamp with time zone,
  altitude_copernicus integer,
  slope_copernicus double precision,
  aspect_copernicus integer,
  forest_density integer,
  gps_sensors_animals_id integer,
  CONSTRAINT gps_data_animals_impx_pkey PRIMARY KEY (gps_data_animals_id, euro_db)
);
CREATE INDEX acquisition_time_index
  ON env_data.gps_data_animals_imp
  USING btree
  (acquisition_time);
CREATE INDEX animal_index
  ON env_data.gps_data_animals_imp
  USING btree
  (animals_id);
CREATE INDEX geom_indice
  ON env_data.gps_data_animals_imp
  USING gist
  (geom);
ALTER TABLE env_data.gps_data_animals_imp ADD COLUMN geom_3035 geometry(Point,3035);
CREATE INDEX geom3035_indice
  ON env_data.gps_data_animals_imp
  USING gist
  (geom);
