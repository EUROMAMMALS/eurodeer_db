-- Update field geom (from lat/long)
UPDATE main.gps_data_animals 
SET geom = st_setsrid(st_makepoint(longitude,latitude),4326)
where longitude IS NOT NULL AND latitude IS NOT NULL AND (gps_validity_code IN (1,2,3) OR gps_validity_code is null) AND geom IS NULL;

-- Update sun angle
UPDATE main.gps_data_animals 
SET sun_angle = tools.sun_elevation_angle(acquisition_time, geom) 
WHERE sun_angle IS NULL AND gps_validity_code IN (1,2,3);

-- Update reference utm zone and related X/Y coordinates
UPDATE main.gps_data_animals 
SET utm_srid = foo.a 
FROM
	(SELECT animals_id, tools.srid_utm(st_x(ST_Centroid(st_collect(geom))), st_y((ST_Centroid(st_collect(geom))))) AS a 
	FROM main.gps_data_animals 
	WHERE gps_validity_code IN (1,2,3) 
	GROUP BY animals_id) AS foo 
WHERE gps_data_animals.animals_id = foo.animals_id AND gps_data_animals.utm_srid IS NULL;
UPDATE main.gps_data_animals 
SET utm_x = st_x(st_transform(geom, utm_srid)), utm_y = st_y(st_transform(geom, utm_srid))
WHERE gps_validity_code IN (1,2,3) AND utm_x IS NULL;


---------------------------------------
-- UPDATE the study areas boundaries --
---------------------------------------
-- Many definition are possible, all related geom must be updated
-- Basic definition (geom): MCP of all points of the study area
UPDATE main.study_areas 
SET geom = foo.qq 
FROM 
	(SELECT studies_id AS ww, (st_multi(st_convexhull(st_collect(geom)))) qq 
	FROM analysis.view_convexhull 
	GROUP BY studies_id) AS foo 
WHERE defined_boundaries = 0 AND study_areas.study_areas_id = foo.ww;
-- geom_mcp_individuals: union of individual MCP of all animals + buffer of 500 meters
UPDATE main.study_areas 
SET geom_mcp_individuals = foo.qq FROM 
	(SELECT studies_id AS ww,st_multi(st_buffer((st_multi(st_union(geom)))::geometry(multipolygon, 4326)::geography, 500)::geometry)qq 
	FROM analysis.view_convexhull 
	GROUP BY studies_id) AS foo 
WHERE defined_boundaries = 0 AND study_areas.study_areas_id = foo.ww;
-- geom_vhf: study areas defined by vhf locations (MCP of all locations)
UPDATE main.study_areas 
SET geom_vhf = foo.qq 
FROM 
	(SELECT studies_id AS ww, (st_multi(st_convexhull(st_collect(geom)))) qq 
	FROM analysis.view_convexhull_vhf 
	GROUP BY studies_id) AS foo 
WHERE defined_boundaries = 0 AND study_areas.study_areas_id = foo.ww;
-- geom_grid300:  trajectories (1 location every 12 hours) are intersected with a grid of 250 meters (modis grid) and only cells with a minimum of time spent on it are kept + a buffer of 1 km
--> missing code
-- geom_kernel95_5km_buffer: kernel home range is calculated using all the data of a study area (1 location every 12 hours) + buffer of 5 km
--> missing code

-- Update forest density (Copernicus layer)
-- If new study areas or new animals far from the other are uploaded, it is necessary to run the procedure to derive the reference layer
UPDATE main.gps_data_animals
SET forest_density = st_value(forest_density.rast, st_transform(gps_data_animals.geom,3035))
FROM env_data.forest_density, main.animals
WHERE forest_density IS NULL AND gps_validity_code IN (1,2,3) AND animals.animals_id = gps_data_animals.animals_id AND animals.study_areas_id = forest_density.study_areas_id AND st_intersects(forest_density.rast,st_transform(gps_data_animals.geom,3035));

-- Update DEM+SLOPE+ASPECT (Copernicus layer)
-- If new study areas or new animals far from the other are uploaded, it is necessary to run the procedure to derive the reference layer
UPDATE main.gps_data_animals
SET altitude_copernicus = st_value(dem_copernicus.rast, st_transform(gps_data_animals.geom,3035))
FROM env_data.dem_copernicus,   main.animals
WHERE altitude_copernicus IS NULL AND gps_validity_code IN (1,2,3) AND animals.animals_id = gps_data_animals.animals_id AND animals.study_areas_id = dem_copernicus.study_areas_id AND st_intersects(dem_copernicus.rast,st_transform(gps_data_animals.geom,3035));

UPDATE main.gps_data_animals 
SET slope_copernicus = st_value(slope_copernicus.rast, st_transform(gps_data_animals.geom,3035))
FROM env_data.slope_copernicus, main.animals
WHERE slope_copernicus IS NULL AND gps_validity_code IN (1,2,3) AND animals.animals_id = gps_data_animals.animals_id AND animals.study_areas_id = slope_copernicus.study_areas_id AND st_intersects(slope_copernicus.rast,st_transform(gps_data_animals.geom,3035));

UPDATE main.gps_data_animals
SET aspect_copernicus = st_value(aspect_copernicus.rast, st_transform(gps_data_animals.geom,3035))
FROM env_data.aspect_copernicus, main.animals
WHERE aspect_copernicus IS NULL AND gps_validity_code IN (1,2,3) AND animals.animals_id = gps_data_animals.animals_id AND animals.study_areas_id = aspect_copernicus.study_areas_id AND st_intersects(aspect_copernicus.rast,st_transform(gps_data_animals.geom,3035));

-- Update CORINE 2012 from vector layer
UPDATE analysis.gps_update_env_fields 
SET corine_land_cover_2012_vector_code = corine_study_areas_mcp_individuals.clc_code::integer
FROM env_data.corine_study_areas_mcp_individuals_imp
WHERE st_coveredby(gps_data_animals.geom, corine_study_areas_mcp_individuals.geom) AND gps_validity_code IN (1,2,3) AND corine_land_cover_2012_vector_code IS NULL;

----------------------
--> IN EURODEER DB <--
----------------------
-- I import into EURODEER all the locations with missing values
TRUNCATE env_data.reddeer_update_gps_update_env_fields;
INSERT INTO env_data.reddeer_update_gps_update_env_fields
SELECT gps_data_animals_id, acquisition_time, geom, gps_validity_code, corine_land_cover_2006_code, corine_land_cover_2000_code, corine_land_cover_1990_code, corine_land_cover_2012_code, ndvi_modis_boku, ndvi_modis_smoothed,  snow_modis, st_transform(geom,3035) as geom_3035
FROM analysis.gps_update_env_fields_reddeer;

-- CORINE raster
UPDATE env_data.reddeer_update_gps_update_env_fields 
SET corine_land_cover_1990_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_1990
WHERE corine_land_cover_1990_code IS NULL AND st_intersects(geom_3035, rast);
UPDATE env_data.reddeer_update_gps_update_env_fields 
SET corine_land_cover_2000_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2000
WHERE corine_land_cover_2000_code IS NULL  AND st_intersects(geom_3035, rast);
UPDATE env_data.reddeer_update_gps_update_env_fields 
SET corine_land_cover_2006_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2006
WHERE corine_land_cover_2006_code IS NULL  AND st_intersects(geom_3035, rast);
UPDATE env_data.reddeer_update_gps_update_env_fields 
SET corine_land_cover_2012_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2012
WHERE corine_land_cover_2012_code IS NULL AND st_intersects(geom_3035, rast);
-- MODIS SNOW 
UPDATE analysis.gps_update_env_fields
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
-- MODIS NDVI --
UPDATE analysis.gps_update_env_fields
SET ndvi_modis = (st_value(rast, geom))/10000
FROM env_data_ts.ndvi_modis
WHERE
  gps_validity_code in (1,2,3) and 
  ndvi_modis is null and 
  st_intersects(geom, rast) and 
  acquisition_time::date >= ndvi_modis.acquisition_date and  
  acquisition_time::date <  
    (case 
    WHEN extract (year FROM (ndvi_modis.acquisition_date + INTERVAL '16 days')) = extract (year FROM (ndvi_modis.acquisition_date)) then (ndvi_modis.acquisition_date + INTERVAL '16 days')
    else ('1-1-' || extract (year FROM ndvi_modis.acquisition_date)+1)::date
    END)  ;
-- MODIS NDVI SMOOTHED --
UPDATE
analysis.gps_update_env_fields
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
UPDATE analysis.gps_update_env_fields
SET ndvi_modis_boku = (trunc((st_value(pre.rast, geom) * (date_trunc('week', acquisition_time::date + 7)::date -acquisition_time::date)::integer +
st_value(post.rast, geom) * (acquisition_time::date - date_trunc('week', acquisition_time::date)::date))::integer/7)) * 0.0048 -0.2
FROM env_data_ts.ndvi_modis_boku pre, env_data_ts.ndvi_modis_boku post
WHERE
  ndvi_modis_boku IS NULL AND gps_validity_code in (1,2,3) and 
  st_intersects(geom, pre.rast) and 
  st_intersects(geom, post.rast) and 
  date_trunc('week', acquisition_time::date)::date = pre.acquisition_date and 
  date_trunc('week', acquisition_time::date + 7)::date = post.acquisition_date;

-----------------------
--> IN EUREDDEER DB <--
-----------------------
UPDATE main.gps_data_animals
   SET corine_land_cover_2006_code=a.corine_land_cover_2006_code, 
       snow_modis=a.snow_modis,
       corine_land_cover_2000_code=a.corine_land_cover_2000_code, 
       corine_land_cover_1990_code=a.corine_land_cover_1990_code, 
       ndvi_modis_boku=a.ndvi_modis_boku, 
       ndvi_modis_smoothed=a.ndvi_modis_smoothed, 
       corine_land_cover_2012_code=a.corine_land_cover_2012_code
FROM
env_data.reddeer_update_gps_update_env_fields a
WHERE 
a.gps_data_animals_id = gps_data_animals.gps_data_animals_id;
