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

-- Update forest density (Copernicus layer)
-- If new study areas or new animals far from the other are uploaded, it is necessary to run the procedure to derive the reference layer
UPDATE env_data.gps_data_animals_imp
SET forest_density = st_value(forest_density.rast, st_transform(gps_data_animals_imp.geom,3035))
FROM env_data.forest_density, env_data.animals
WHERE forest_density IS NULL AND gps_validity_code IN (1,2,3) AND animals.animals_id = gps_data_animals_imp.animals_id AND animals.study_areas_id = forest_density.study_areas_id AND st_intersects(forest_density.rast,st_transform(gps_data_animals_imp.geom,3035));

-- Update DEM+SLOPE+ASPECT (Copernicus layer)
-- If new study areas or new animals far from the other are uploaded, it is necessary to run the procedure to derive the reference layer
UPDATE env_data.gps_data_animals_imp
SET altitude_copernicus = st_value(dem_copernicus.rast, st_transform(gps_data_animals_imp.geom,3035))
FROM env_data.dem_copernicus,   env_data.animals
WHERE altitude_copernicus IS NULL AND gps_validity_code IN (1,2,3) AND animals.animals_id = gps_data_animals_imp.animals_id AND animals.study_areas_id = dem_copernicus.study_areas_id AND st_intersects(dem_copernicus.rast,st_transform(gps_data_animals_imp.geom,3035));

UPDATE env_data.gps_data_animals_imp 
SET slope_copernicus = st_value(slope_copernicus.rast, st_transform(gps_data_animals_imp.geom,3035))
FROM env_data.slope_copernicus, env_data.animals
WHERE slope_copernicus IS NULL AND gps_validity_code IN (1,2,3) AND animals.animals_id = gps_data_animals_imp.animals_id AND animals.study_areas_id = slope_copernicus.study_areas_id AND st_intersects(slope_copernicus.rast,st_transform(gps_data_animals_imp.geom,3035));

UPDATE env_data.gps_data_animals_imp
SET aspect_copernicus = st_value(aspect_copernicus.rast, st_transform(gps_data_animals_imp.geom,3035))
FROM env_data.aspect_copernicus, env_data.animals
WHERE aspect_copernicus IS NULL AND gps_validity_code IN (1,2,3) AND animals.animals_id = gps_data_animals_imp.animals_id AND animals.study_areas_id = aspect_copernicus.study_areas_id AND st_intersects(aspect_copernicus.rast,st_transform(gps_data_animals_imp.geom,3035));

-- Update CORINE 2012 from vector layer
UPDATE env_data.gps_data_animals_imp
SET corine_land_cover_2012_vector_code = corine_land_cover_2012_vector.clc_code::integer
FROM env_data.corine_land_cover_2012_vector
WHERE st_coveredby(gps_data_animals_imp.geom, corine_land_cover_2012_vector.geom) AND gps_validity_code IN (1,2,3) AND corine_land_cover_2012_vector_code IS NULL;


-- MODIS SNOW 
UPDATE 
env_data.gps_data_animals_imp 
SET snow_modis = st_value(rast, geom)
FROM env_data_ts.snow_modis
WHERE
  gps_validity_code in (1,2,3) and 
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
  gps_validity_code in (1,2,3) and 
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
  ndvi_modis_boku IS NULL AND gps_validity_code in (1,2,3) and 
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
