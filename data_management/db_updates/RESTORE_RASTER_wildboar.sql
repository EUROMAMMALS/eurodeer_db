-----------------
--> CORINE db <--
-----------------
-- I create a table to permanently store the polygons of the study area and fill it with the last version of the geometry
/* DROP TABLE if exists wildboar.temp_study_areas_mcp_individuals;
CREATE TABLE wildboar.temp_study_areas_mcp_individuals
(
  id integer NOT NULL,
  geom geometry(Polygon,3035),
  CONSTRAINT study_areas_pkey PRIMARY KEY (id)
);
CREATE INDEX sidx_study_areas_geom_mcp_individuals
  ON wildboar.temp_study_areas_mcp_individuals
  USING gist
  (geom);*/

TRUNCATE wildboar.temp_study_areas_mcp_individuals;
INSERT INTO wildboar.temp_study_areas_mcp_individuals
	SELECT row_number() over(), geom 
	FROM 
		(SELECT (st_dump(st_transform(st_union(geom),3035))).geom as geom
		FROM (select geom_mcp_individuals  as geom from wildboar.study_areas union select geom_vhf from wildboar.study_areas) a) b;

-- This is just to initialize (main.gps_data_animals and main.animals are loaded as foreign tables in schema wildboar)
/*CREATE OR REPLACE VIEW wildboar.view_corine_study_areas_mcp_individuals AS 
 SELECT row_number() OVER ()::integer AS id,
    a.clc_code,
    st_transform(a.geom, 4326)::geometry(Polygon,4326) AS geom
   FROM ( SELECT clc12_version_18_5.code_12 AS clc_code,
                CASE
                    WHEN st_within(clc12_version_18_5.geom, study_areas.geom) THEN (st_dump(clc12_version_18_5.geom)).geom::geometry(Polygon,3035)
                    ELSE (st_dump(st_intersection(clc12_version_18_5.geom, study_areas.geom))).geom::geometry(Polygon,3035)
                END AS geom
           FROM data.clc12_version_18_5,
            wildboar.temp_study_areas_mcp_individuals study_areas
          WHERE st_intersects(study_areas.geom, clc12_version_18_5.geom)) a;
		  
-- This is to fix a problem (in case it is referenced from other db
  ALTER FUNCTION st_intersects(geometry, geometry) SET search_path TO pg_catalog, public;
  ALTER FUNCTION st_transform(geometry, integer) SET search_path TO pg_catalog, public;
  ALTER FUNCTION st_dump(geometry) SET search_path TO pg_catalog, public; */

-- I make a physical table that must be updated every time locations far from existing ones are uploaded
/*DROP TABLE IF EXISTS wildboar.corine_study_areas_mcp_individuals;
CREATE TABLE  wildboar.corine_study_areas_mcp_individuals AS 
SELECT * from wildboar.view_corine_study_areas_mcp_individuals;*/
TRUNCATE wildboar.corine_study_areas_mcp_individuals;
INSERT INTO  wildboar.corine_study_areas_mcp_individuals 
SELECT * FROM wildboar.view_corine_study_areas_mcp_individuals;  

----------------------------
--> This is EUROBOAR db <--
----------------------------
/*CREATE FOREIGN TABLE env_data.corine_land_cover_2012_vector 
(  id integer,
  clc_code character varying(3),
  geom geometry(Polygon,4326))
SERVER corine_fdw
 OPTIONS (schema_name 'wildboar', table_name 'corine_study_areas_mcp_individuals');*/

-- Then I need a local table (to speed up), that must be updated every time that study areas are updated (to be created just when I initialize)
/*DROP TABLE IF EXISTS env_data.corine_land_cover_2012_vector_imp;
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
  (geom);*/
TRUNCATE env_data.corine_land_cover_2012_vector_imp;
INSERT INTO env_data.corine_land_cover_2012_vector_imp
SELECT id, clc_code::integer, geom FROM env_data.corine_land_cover_2012_vector;
 
--------------------
-- FOREST DENSITY --
--------------------
-- I create the subimages using the view main.view_import_forest_density;

-- Now I import all the subimages and create the table
-- Remove the table if exists
DROP TABLE IF EXISTS env_data.forest_density;

-- Then I import all the images (again form the view;
raster2pgsql -c -R -F -C -I -x -t 128x128 -N 255 -M E:\eurodeer_data\raster\remote_sensing\forestcover\copernicus\local_data\forest_density_wildboar_*.tif env_data.forest_density| psql -d euroboar_db -U postgres  -p 5432

-- Add reference to study area
ALTER TABLE env_data.forest_density ADD COLUMN study_areas_id integer;

CREATE INDEX study_areas_forest_density_index
  ON env_data.forest_density
  USING btree
  (study_areas_id);

UPDATE env_data.forest_density SET study_areas_id = (substring(filename FROM 25 FOR 2))::integer;

----------------------------
-- DEM-RELATED COPERNICUS --
----------------------------
-- [sub images are clip from the image over whole europe, then single subimages are imported as external] 
-- [slope and aspect are calculated with gdaldem, for subimages only]

-- I create the sub-images using the view main.view_import_dem;

DROP TABLE IF EXISTS env_data.dem_copernicus;
DROP TABLE IF EXISTS env_data.slope_copernicus;
DROP TABLE IF EXISTS env_data.aspect_copernicus;

E:\PostgreSQL\9.5\bin\raster2pgsql.exe -c -R -F -C -I -x -t 128x128 -N 32768 -M E:\eurodeer_data\raster\dem\copernicus\local_data\dem_wildboar*.tif env_data.dem_copernicus | E:\PostgreSQL\9.5\bin\psql.exe -d euroboar_db -U postgres  -p 5432
E:\PostgreSQL\9.5\bin\raster2pgsql.exe -c -R -F -C -I -x -t 128x128 -N -9999 -M E:\eurodeer_data\raster\dem\copernicus\local_data\aspect_wildboar*.tif env_data.aspect_copernicus | E:\PostgreSQL\9.5\bin\psql.exe -d euroboar_db -U postgres  -p 5432
E:\PostgreSQL\9.5\bin\raster2pgsql.exe -c -R -F -C -I -x -t 128x128 -N -9999 -M E:\eurodeer_data\raster\dem\copernicus\local_data\slope_wildboar*.tif env_data.slope_copernicus | E:\PostgreSQL\9.5\bin\psql.exe -d euroboar_db -U postgres  -p 5432

-- I add info on study area
ALTER TABLE env_data.dem_copernicus ADD COLUMN study_areas_id integer;
CREATE INDEX study_areas_dem_copernicus_index
  ON env_data.dem_copernicus
  USING btree
  (study_areas_id);
UPDATE env_data.dem_copernicus SET study_areas_id = (substring(filename FROM 14 FOR 2))::integer;

ALTER TABLE env_data.slope_copernicus ADD COLUMN study_areas_id integer;
CREATE INDEX study_areas_slope_copernicus_index
  ON env_data.slope_copernicus
  USING btree
  (study_areas_id);
UPDATE env_data.slope_copernicus SET study_areas_id = (substring(filename FROM 16 FOR 2))::integer;

ALTER TABLE env_data.aspect_copernicus ADD COLUMN study_areas_id integer;
CREATE INDEX study_areas_aspect_copernicus_index
  ON env_data.aspect_copernicus
  USING btree
  (study_areas_id);
UPDATE env_data.aspect_copernicus SET study_areas_id = (substring(filename FROM 18 FOR 2))::integer;

----------------------------
--> This is EURODEER db <--
----------------------------
-- Create connection with EURODEER database
-- I add the view with list of points with missing values
CREATE FOREIGN TABLE analysis.gps_update_env_fields_wildboar
   (gps_data_animals_id integer ,
    acquisition_time timestamp with time zone ,
    geom geometry(point,4326) ,
    gps_validity_code smallint ,
    corine_land_cover_2006_code integer ,
    corine_land_cover_2000_code integer ,
    corine_land_cover_1990_code integer ,
    corine_land_cover_2012_code integer ,
    ndvi_modis_boku double precision ,
    ndvi_modis_smoothed double precision ,
    snow_modis integer )
   SERVER euroboar_fdw
   OPTIONS (schema_name 'main', table_name 'view_gps_update_env_fields_wildboar');
-- I create the phisical table to store the list (and update the values)
CREATE TABLE env_data.wildboar_update_gps_update_env_fields
(
  gps_data_animals_id integer,
  acquisition_time timestamp with time zone,
  geom geometry(Point,4326),
  gps_validity_code smallint,
  corine_land_cover_2006_code integer,
  corine_land_cover_2000_code integer,
  corine_land_cover_1990_code integer,
  corine_land_cover_2012_code integer,
  ndvi_modis_boku double precision,
  ndvi_modis_smoothed double precision,
  snow_modis integer,
  geom_3035 geometry
);
ALTER TABLE env_data.wildboar_update_gps_update_env_fields
  ADD CONSTRAINT wildboar_update_gps_update_env_fields_pkey PRIMARY KEY(gps_data_animals_id);
CREATE INDEX wildboar_update_gps_update_env_fields_geom_gist
  ON env_data.wildboar_update_gps_update_env_fields
  USING gist
  (geom);
CREATE INDEX wildboar_update_gps_update_env_fields_geom3035_gist
  ON env_data.wildboar_update_gps_update_env_fields
  USING gist
  (st_transform(geom, 3035));
  
----------------------------
--> This is EUREDDER db <--
----------------------------
-- I link back the updated table
CREATE FOREIGN TABLE env_data.wildboar_update_gps_update_env_fields
   (gps_data_animals_id integer ,
    acquisition_time timestamp with time zone ,
    geom geometry(point,4326) ,
    gps_validity_code smallint ,
    corine_land_cover_2006_code integer ,
    corine_land_cover_2000_code integer ,
    corine_land_cover_1990_code integer ,
    corine_land_cover_2012_code integer ,
    ndvi_modis_boku double precision ,
    ndvi_modis_smoothed double precision ,
    snow_modis integer ,
    geom_3035 geometry(point,3035) )
   SERVER eurodeer_fdw
   OPTIONS (schema_name 'env_data', table_name 'wildboar_update_gps_update_env_fields');
