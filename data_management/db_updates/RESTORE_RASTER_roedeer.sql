------------
-- CORINE --
------------
-- generate table '-c' instead of '-a' and add '-C -I -x' --> next time load as external
raster2pgsql -a -t 64x64 -R -M E:\eurodeer_data\raster\land_cover\corine\g100_06.tif env_data.corine_land_cover_2006| psql -d eurodeer_db -U postgres  -p 5432
raster2pgsql -a -t 64x64 -R -M E:\eurodeer_data\raster\land_cover\corine\g100_00.tif env_data.corine_land_cover_2000| psql -d eurodeer_db -U postgres  -p 5432
raster2pgsql -a -t 64x64 -R -M E:\eurodeer_data\raster\land_cover\corine\g100_90.tif env_data.corine_land_cover_1990| psql -d eurodeer_db -U postgres  -p 5432
raster2pgsql -a -t 64x64 -R -M E:\eurodeer_data\raster\land_cover\corine\g100_12.tif env_data.corine_land_cover_2012| psql -d eurodeer_db -U postgres  -p 5432

gdal_translate -a_srs EPSG:3035 -co "TILED=YES" -co "BLOCKXSIZE=256" -co "BLOCKYSIZE=256" -co COMPRESS=PACKBITS E:\eurodeer_data\raster\land_cover\corine\g100_clc12_V18_5.tif E:\eurodeer_data\raster\land_cover\corine\g100_12_c.tif
raster2pgsql -c -R -C -I -x -t 256x256 -M E:\eurodeer_data\raster\land_cover\corine\g100_12.tif env_data.corine_land_cover_2012| psql -d eurodeer_db -U postgres  -p 5432

-----------------
--> CORINE db <--
-----------------
-- import VECTOR layer in a separate db
ogr2ogr -f "PostgreSQL" PG:"host=localhost port=5432 dbname=corine user=postgres" E:/eurodeer_data/vector/corine/clc12_Version_18_5.gdb -overwrite -progress --config PG_USE_COPY YES

-- I create a table to permanently store the polygons of the study area and fill it with the last version of the geometry
/*DROP TABLE if exists roedeer.temp_study_areas_mcp_individuals;
CREATE TABLE roedeer.temp_study_areas_mcp_individuals
(
  id integer NOT NULL,
  geom geometry(Polygon,3035),
  CONSTRAINT study_areas_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_study_areas_geom_mcp_individuals
  ON roedeer.temp_study_areas_mcp_individuals
  USING gist
  (geom);*/

TRUNCATE roedeer.temp_study_areas_mcp_individuals;
INSERT INTO roedeer.temp_study_areas_mcp_individuals
	SELECT row_number() over(), geom 
	FROM 
		(SELECT (st_dump(st_transform(st_union(geom),3035))).geom as geom
FROM (select geom_mcp_individuals as geom from roedeer.study_areas union select geom_vhf from roedeer.study_areas) a) b;;

-- This is just to initialize 
CREATE OR REPLACE VIEW roedeer.view_corine_study_areas_mcp_individuals AS 
 SELECT row_number() OVER ()::integer AS id,
    a.clc_code,
    st_transform(a.geom, 4326)::geometry(Polygon,4326) AS geom
   FROM ( SELECT clc12_version_18_5.code_12 AS clc_code,
                CASE
                    WHEN st_within(clc12_version_18_5.geom, study_areas.geom) THEN (st_dump(clc12_version_18_5.geom)).geom::geometry(Polygon,3035)
                    ELSE (st_dump(st_intersection(clc12_version_18_5.geom, study_areas.geom))).geom::geometry(Polygon,3035)
                END AS geom
           FROM data.clc12_version_18_5,
            roedeer.temp_study_areas_mcp_individuals study_areas
          WHERE st_intersects(study_areas.geom, clc12_version_18_5.geom)) a;
		  
-- this is to fix a problem (in case it is referenced from other db
  ALTER FUNCTION st_intersects(geometry, geometry) SET search_path TO pg_catalog, public;
  ALTER FUNCTION st_transform(geometry, integer) SET search_path TO pg_catalog, public;
  ALTER FUNCTION st_dump(geometry) SET search_path TO pg_catalog, public; 

-- I make a physical table that must be updated every time locations far from existing ones are uploaded
DROP TABLE IF EXISTS roedeer.corine_study_areas_mcp_individuals;
CREATE TABLE  roedeer.corine_study_areas_mcp_individuals AS 
SELECT * from roedeer.view_corine_study_areas_mcp_individuals;

---------------------------
--> This is EURODEER db <--
---------------------------
CREATE FOREIGN TABLE env_data.corine_land_cover_2012_vector 
(  id integer,
  clc_code character varying(3),
  geom geometry(Polygon,4326))
SERVER corine_fdw
 OPTIONS (schema_name 'roedeer', table_name 'corine_study_areas_mcp_individuals'); 

-- Then I need a local table (to speed up), that must be updated every time that study areas are updated (to be created just when I initialize)
DROP TABLE IF EXISTS env_data.corine_land_cover_2012_vector_imp;
CREATE TABLE env_data.corine_land_cover_2012_vector_imp
(
  id integer NOT NULL,
  clc_code integer,
  geom geometry(Polygon,4326),
  CONSTRAINT corine_land_cover_2012_vector_imp_pkey PRIMARY KEY (id)
);
CREATE INDEX corine_land_cover_2012_vector_imp_gist
  ON env_data.corine_land_cover_2012_vector_imp
  USING gist
  (geom);

INSERT INTO env_data.corine_land_cover_2012_vector_imp
SELECT id, clc_code::integer, geom FROM env_data.corine_land_cover_2012_vector;
 
--------------------
-- FOREST DENSITY --
--------------------
-- I generate a compressed file with correct georeference info
gdal_translate -a_srs EPSG:3035 -co "TILED=YES" -co "BLOCKXSIZE=128" -co "BLOCKYSIZE=128" -co COMPRESS=LZW -co BIGTIFF=YES  -ot BYTE E:\eurodeer_data\raster\remote_sensing\forestcover\copernicus\TCD_eur_020m_fin.tif E:\eurodeer_data\raster\remote_sensing\forestcover\copernicus\forest_density.tif

-- I create the subimages using the view main.view_import_forest_density;

-- Now I import all the subimages and create the table
-- Remove the table if exists
DROP TABLE IF EXISTS env_data.forest_density;

-- Then I import all the images (again form the view;
raster2pgsql -c -R -F -C -I -x -t 128x128 -N 255 -M E:\eurodeer_data\raster\remote_sensing\forestcover\copernicus\local_data\forest_density_roe_*.tif env_data.forest_density| psql -d eurodeer_db -U postgres  -p 5432

-- Add reference to study area
ALTER TABLE env_data.forest_density ADD COLUMN study_areas_id integer;

CREATE INDEX study_areas_forest_density_index
  ON env_data.forest_density
  USING btree
  (study_areas_id);

UPDATE env_data.forest_density SET study_areas_id = (substring(filename FROM 20 FOR 2))::integer;

----------------------------
-- DEM-RELATED COPERNICUS --
----------------------------
-- [sub images are clip from the image over whole europe, then single subimages are imported as external] 
-- [slope and aspect are calculated with gdaldem, for subimages only]

-- I create the sub-images using the view main.view_import_dem;

DROP TABLE IF EXISTS env_data.dem_copernicus;
DROP TABLE IF EXISTS env_data.slope_copernicus;
DROP TABLE IF EXISTS env_data.aspect_copernicus;

E:\PostgreSQL\9.5\bin\raster2pgsql.exe -c -R -F -C -I -x -t 128x128 -N 32768 -M E:\eurodeer_data\raster\dem\copernicus\local_data\dem_roe*.tif env_data.dem_copernicus | E:\PostgreSQL\9.5\bin\psql.exe -d eurodeer_db -U postgres  -p 5432
E:\PostgreSQL\9.5\bin\raster2pgsql.exe -c -R -F -C -I -x -t 128x128 -N -9999 -M E:\eurodeer_data\raster\dem\copernicus\local_data\aspect_roe*.tif env_data.aspect_copernicus | E:\PostgreSQL\9.5\bin\psql.exe -d eurodeer_db -U postgres  -p 5432
E:\PostgreSQL\9.5\bin\raster2pgsql.exe -c -R -F -C -I -x -t 128x128 -N -9999 -M E:\eurodeer_data\raster\dem\copernicus\local_data\slope_roe*.tif env_data.slope_copernicus | E:\PostgreSQL\9.5\bin\psql.exe -d eurodeer_db -U postgres  -p 5432

-- I add info on study area
ALTER TABLE env_data.dem_copernicus ADD COLUMN study_areas_id integer;
CREATE INDEX study_areas_dem_copernicus_index
  ON env_data.dem_copernicus
  USING btree
  (study_areas_id);
UPDATE env_data.dem_copernicus SET study_areas_id = (substring(filename FROM 9 FOR 2))::integer;

ALTER TABLE env_data.slope_copernicus ADD COLUMN study_areas_id integer;
CREATE INDEX study_areas_slope_copernicus_index
  ON env_data.slope_copernicus
  USING btree
  (study_areas_id);
UPDATE env_data.slope_copernicus SET study_areas_id = (substring(filename FROM 11 FOR 2))::integer;

ALTER TABLE env_data.aspect_copernicus ADD COLUMN study_areas_id integer;
CREATE INDEX study_areas_aspect_copernicus_index
  ON env_data.aspect_copernicus
  USING btree
  (study_areas_id);
UPDATE env_data.aspect_copernicus SET study_areas_id = (substring(filename FROM 12 FOR 2))::integer;


----------------------
-- NDVI VARIABILITY --
----------------------
E:\PostgreSQL\9.3\bin\raster2pgsql.exe -t 256x256 -C -F -M -R -r -I E:\eurodeer_data\raster\remote_sensing\modis\ndvi_variability\constancy.tif env_data.ndvi_constancy | E:\PostgreSQL\9.3\bin\psql.exe -d eurodeer_db -U postgres  -p 5432
E:\PostgreSQL\9.3\bin\raster2pgsql.exe -t 256x256 -C -F -M -R -r -I E:\eurodeer_data\raster\remote_sensing\modis\ndvi_variability\constancy.tif env_data.ndvi_predictability | E:\PostgreSQL\9.3\bin\psql.exe -d eurodeer_db -U postgres  -p 5432
E:\PostgreSQL\9.3\bin\raster2pgsql.exe -t 256x256 -C -F -M -R -r -I E:\eurodeer_data\raster\remote_sensing\modis\ndvi_variability\contingency.tif env_data.ndvi_contingency | E:\PostgreSQL\9.3\bin\psql.exe -d eurodeer_db -U postgres  -p 5432

---------------------
-- WINTER SEVERITY --
---------------------
-- Queary that generates all the query (just change the range in the generate_series)
SELECT 'INSERT INTO env_data_ts.winter_severity(rast, start_date, end_date, reference_year)
SELECT  
  ST_UNION(st_reclass(rast,1, ''0:255, 1:255, 11:255, 25:0, 37:0,39:0, 50:255, 100:0, 200:200, 254:255, 255:255'',''16BUI'', 255), ''MEAN'') AS rast,
  '''||yearx||'-10-01''::date AS start_date,
  '''||yearx + 1||'-03-31''::DATE AS end_date,
  '||yearx||' AS reference_year
FROM
  env_data_ts.snow_modis
WHERE
  acquisition_date >= '''||yearx||'-10-01'' AND
  acquisition_date <= '''||yearx +1||'-03-31''
GROUP BY
  st_convexhull(rast);'
FROM
  (select generate_series(2000,2016,1) yearx) a

----------------
-- MODIS SNOW --
----------------
-- generate table '-c' instead of '-a' and add '-C -I -x' and use '*.tif' as name of file
raster2pgsql -a -t 100x100 -F -M -R E:\eurodeer_data\raster\remote_sensing\modis\snow\MOD10A2_2014_03_06.Maximum_Snow_Extent.tif env_data_ts.snow_modis| psql -d eurodeer_db -U postgres  -p 5432

--------------------
-- MODIS SMOOTHED -- [data are already de-scaled]
--------------------
DELETE FROM env_data_ts.ndvi_modis_smoothed WHERE acquisition date > DATEX --(or you can delete all and reload)
-- an option is to delete all those of the concerned years to use 2016*
raster2pgsql.exe -a -F -M -R -t 128x128 -N -99 E:\eurodeer_data\raster\remote_sensing\modis\ndvi_smoothed\modis*.tif env_data_ts.ndvi_modis_smoothed | psql -p 5432 -d eurodeer_db -U postgres

raster2pgsql.exe -a -F -M -R -t 128x128 -N -99 E:\eurodeer_data\raster\remote_sensing\modis\ndvi_smoothed\modis*.tif env_data_ts.ndvi_modis_smoothed | psql -p 5432 -d eurodeer_db -U postgres
-- DO NOT USE -s BUT TO DO SO HDR MUST HAVE CORRECT INFORMATION ON SRID.
-- I have to adapt header
--> map info = {Geographic Lat/Lon, 1, 1, -10, 65, 0.0020833, 0.0020833, WGS-84,units=Degrees}
--> no coordinate system string (see SPIRITS scenario)

-- generate table for initialization (first time)
raster2pgsql.exe -c -F -M -R -C -x -t 128x128 -N -99 E:\eurodeer_data\raster\remote_sensing\modis\ndvi_smoothed\modis*ndvi_spirits.tif env_data_ts.ndvi_modis_smoothed | psql -p 5432 -d eurodeer_db -U postgres								  
ALTER TABLE env_data_ts.ndvi_modis_smoothed ADD COLUMN acquisition_date date;
UPDATE env_data_ts.ndvi_modis_smoothed SET acquisition_date = to_date(substring(filename from 6 for 8), 'YYYYMMDD')+5;
								  
CREATE INDEX ndvi_modis_smoothed_acquisition_date_index
  ON env_data_ts.ndvi_modis_smoothed
  USING btree
  (acquisition_date);

CREATE TRIGGER insert_ts_modis_smoothed
  BEFORE INSERT
  ON env_data_ts.ndvi_modis_smoothed
  FOR EACH ROW
  EXECUTE PROCEDURE tools.update_timestamp_ts_modis_smoothed();

----------------
-- MODIS BOKU -- [here I have to set null values: 251 (water), 252 (water) and 255 (null)]
----------------
-- host: 
-- user: 
-- pass: 

-- it checks all the tiles tagged as imported, then generate virtual references to images at each date and keep only those that are not already into the database
-- the only thing to set is the max date (in virtual date) -> date of REFMIDw (3 months earlier because of the smoothing) 


with 
existing_images as
(SELECT distinct filename, acquisition_date, filepath
  FROM env_data_ts.ndvi_modis_boku
order by acquisition_date),

virtual_date AS
(select datex, to_char(datex, 'YYYYDDD') datey from
(select '2000-09-25'::date + 7 * generate_series(1, 1000 , 1) datex) x
where datex <= to_Date('2017100', 'YYYYDDD')),

existing_tiles AS
(SELECT tile  FROM env_data_ts.ndvi_modis_boku_grid where imported = 1),

virtual_images as
(select tile, datex, datey
from virtual_date, existing_tiles),

missing_images AS
(select tile, datex, datey from
virtual_images left join existing_images
on  filename = 'MCD13Q1.A'|| datey || '.005.' || tile ||'.250m_7_days_NDVI.REFMIDw.tif'
where filename is null)

select 
'E:\PostgreSQL\9.5\bin\raster2pgsql.exe -a -t 48x48 -F -R E:\eurodeer_data\raster\remote_sensing\modis\modis_boku\' ||tile|| '\REFMIDw\MCD13Q1.A'||datey||'.005.'|| tile ||'.250m_7_days_NDVI.REFMIDw.tif env_data_ts.ndvi_modis_boku| E:\PostgreSQL\9.5\bin\psql.exe -d eurodeer_db -U postgres  -p 5432'
from missing_images
order by datex, tile;

------------------------------------------'

-- **************************************
-- ******** MODIS BUKU INITIALIZE *******
-- **************************************
E:\PostgreSQL\9.5\bin\raster2pgsql.exe -p -t 48x48 -N 255 -F -M -I -R E:\eurodeer_data\raster\remote_sensing\modis\modis_boku\H17V04_h09v03\REFMIDw\MCD13Q1.A2000269.005.H17V04_h09v03.250m_7_days_NDVI.REFMIDw.tif env_data_ts.ndvi_modis_boku| E:\PostgreSQL\9.5\bin\psql.exe -d eurodeer_db -U postgres  -p 5432

ALTER TABLE env_data_ts.ndvi_modis_boku ADD COLUMN filepath character varying(13);
ALTER TABLE env_data_ts.ndvi_modis_boku ADD COLUMN acquisition_date date;

CREATE INDEX ndvi_modis_boku_acquisition_date_index
  ON env_data_ts.ndvi_modis_boku
  USING btree
  (acquisition_date);

CREATE OR REPLACE FUNCTION tools.ndvi_acquisition_date_boku_update()
  RETURNS trigger AS
$BODY$
BEGIN
NEW.acquisition_date = to_date(substring(new.filename FROM 10 FOR 7) , 'YYYYDDD');
NEW.filepath = 'E:\eurodeer_data\raster\remote_sensing\modis\modis_boku\'|| substring(new.filename, 22, 13) ||'\REFMIDw\';
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION tools.ndvi_acquisition_date_boku_update()
  OWNER TO postgres;
COMMENT ON FUNCTION tools.ndvi_acquisition_date_boku_update() IS 'This function is raised whenever a new record is inserted into the MODIS NDVI Boku time series table in order to define the acquisition date. It is derived from the original filename (that has the structure MCD13Q1.AYYYYDDD.005.H17V04_h09v03.250m_7_days_NDVI.REFMIDw.tif.)';

CREATE TRIGGER update_ndvi_boku_acquisition_date
  BEFORE INSERT
  ON env_data_ts.ndvi_modis_boku
  FOR EACH ROW
  EXECUTE PROCEDURE tools.ndvi_acquisition_date_boku_update();

select 
AddRasterConstraints('env_data_ts'::name,'ndvi_modis_boku'::name, 'rast'::name, 'srid', 'scale_x', 'scale_y', 'blocksize_x', 'blocksize_y', 'same_alignment', 'regular_blocking', 'num_bands' , 'pixel_types', 'out_db') 

-- **** vacuum analyze *****
  VACUUM (VERBOSE, ANALYZE) env_data_ts.ndvi_modis_boku;


------------------------------------------'  
----------------
-- DEPRECATED --
----------------
--------------
-- DEM SRTM --
--------------
-- generate table '-c' instead of '-a' and add '-C -I -x'
raster2pgsql -a -t 50x50 -F -M -R E:\eurodeer_data\raster\dem\srtm_dem\dem\*.tif env_data.dem_srtm| psql -d eurodeer_db -U postgres  -p 5432
raster2pgsql -a -t 50x50 -F -M -R E:\eurodeer_data\raster\dem\srtm_dem\slope\*.tif env_data.slope_srtm| psql -d eurodeer_db -U postgres  -p 5432
raster2pgsql -a -t 50x50 -F -M -R E:\eurodeer_data\raster\dem\srtm_dem\aspect\*.tif env_data.aspect_srtm| psql -d eurodeer_db -U postgres  -p 5432

---------------
-- DEM ASTER --
---------------
-- generate table '-c' instead of '-a' and add '-C -I -x'
raster2pgsql -a -t 50x50 -F -M -R E:\eurodeer_data\raster\dem\aster_dem\dem\*.tif env_data.dem_aster| psql -d eurodeer_db -U postgres  -p 5432
raster2pgsql -a -t 50x50 -F -M -R E:\eurodeer_data\raster\dem\aster_dem\slope\*.tif env_data.slope_aster| psql -d eurodeer_db -U postgres  -p 5432
raster2pgsql -a -t 50x50 -F -M -R E:\eurodeer_data\raster\dem\aster_dem\aspect\*.tif env_data.aspect_aster| psql -d eurodeer_db -U postgres  -p 5432

----------------
-- SPOT fAPAR -- deprecated
----------------
-- generate table '-c' instead of '-a' and add '-C -I -x'
raster2pgsql -a -t 100x100 -F -M -R E:\eurodeer_data\raster\remote_sensing\vegetation\fapar\*.tif env_data_ts.fapar_vegetation| psql -d eurodeer_db -U postgres  -p 5432

--------------
-- SPOT VGT -- deprecated
--------------
-- generate table '-c' instead of '-a' and add '-C -I -x'
raster2pgsql -a -t 100x100 -F -M -R E:\eurodeer_data\raster\remote_sensing\vegetation\ndvi\*.tif env_data_ts.ndvi_vegetation| psql -d eurodeer_db -U postgres  -p 5432

----------------
-- MODIS NDVI -- not used anymore as raw data are of no interest for eurodeer users
----------------
-- generate table '-c' instead of '-a' and add '-C -I -x' and use '*.tif' as name of file
raster2pgsql -a -t 100x100 -F -M -R -N -3000 E:\eurodeer_data\raster\remote_sensing\modis\ndvi\MOD13Q1_2015_04_07.250m_16_days_NDVI.tif env_data_ts.ndvi_modis| psql -d eurodeer_db -U postgres  -p 5432

raster2pgsql -a -t 100x100 -F -M -R -N -3000 E:\eurodeer_data\raster\remote_sensing\modis\ndvi\MOD13Q1_*.250m_16_days_NDVI.tif env_data_ts.ndvi_modis| psql -d eurodeer_db -U postgres  -p 5436


