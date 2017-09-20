update main.vhf_data_animals 
set geom = st_setsrid(st_makepoint(longitude,latitude),4326)
where longitude is not null and latitude is not null AND vhf_validity_code in (1,2,3,5,6) and geom is null;

update main.vhf_data_animals set utm_srid = foo.a from
(select animals_id, tools.srid_utm(st_x(ST_Centroid(st_collect(geom))), st_y((ST_Centroid(st_collect(geom))))) as a from main.vhf_data_animals where vhf_validity_code in (1,2,3) group by animals_id) as foo 
where vhf_data_animals.animals_id = foo.animals_id and vhf_data_animals.utm_srid is null and vhf_validity_code in (1,2,3,5,6) ;

update main.vhf_data_animals 
set utm_x = st_x(st_transform(geom, utm_srid)), utm_y = st_y(st_transform(geom, utm_srid))
where vhf_validity_code in (1,2,3) and (utm_x is null or utm_y is null);

update main.vhf_data_animals set sun_angle = tools.sun_elevation_angle(acquisition_time, geom) 
where sun_angle is null and vhf_validity_code in (1,2,3);

UPDATE main.vhf_data_animals
SET altitude_copernicus = st_value(dem_copernicus.rast, st_transform(vhf_data_animals.geom,3035))
FROM env_data.dem_copernicus,   main.animals
WHERE altitude_copernicus IS NULL AND vhf_validity_code IN (1,2,3,5,6) AND animals.animals_id = vhf_data_animals.animals_id AND animals.study_areas_id = dem_copernicus.study_areas_id AND st_intersects(dem_copernicus.rast,st_transform(vhf_data_animals.geom,3035));

UPDATE main.vhf_data_animals 
SET slope_copernicus = st_value(slope_copernicus.rast, st_transform(vhf_data_animals.geom,3035))
FROM env_data.slope_copernicus, main.animals
WHERE slope_copernicus IS NULL AND vhf_validity_code IN (1,2,3,5,6) AND animals.animals_id = vhf_data_animals.animals_id AND animals.study_areas_id = slope_copernicus.study_areas_id AND st_intersects(slope_copernicus.rast,st_transform(vhf_data_animals.geom,3035));

UPDATE main.vhf_data_animals
SET aspect_copernicus = st_value(aspect_copernicus.rast, st_transform(vhf_data_animals.geom,3035))
FROM env_data.aspect_copernicus, main.animals
WHERE aspect_copernicus IS NULL AND vhf_validity_code IN (1,2,3,5,6) AND animals.animals_id = vhf_data_animals.animals_id AND animals.study_areas_id = aspect_copernicus.study_areas_id AND st_intersects(aspect_copernicus.rast,st_transform(vhf_data_animals.geom,3035));

UPDATE main.vhf_data_animals
SET forest_density = st_value(forest_density.rast, st_transform(vhf_data_animals.geom,3035))
FROM env_data.forest_density, main.animals
WHERE forest_density IS NULL AND vhf_validity_code IN (1,2,3,5,6) AND animals.animals_id = vhf_data_animals.animals_id AND animals.study_areas_id = forest_density.study_areas_id AND st_intersects(forest_density.rast,st_transform(vhf_data_animals.geom,3035));

UPDATE main.vhf_data_animals
SET corine_land_cover_2012_vector_code = corine_land_cover_2012_vector.clc_code::integer
FROM env_data.corine_land_cover_2012_vector
WHERE st_coveredby(vhf_data_animals.geom, corine_land_cover_2012_vector.geom) AND vhf_validity_code IN (1,2,3,5,6) AND corine_land_cover_2012_vector_code IS NULL;

----------------------
--> IN EURODEER DB <--
----------------------
-- I import into EURODEER all the locations with missing values

TRUNCATE env_data.reddeer_update_vhf_update_env_fields;
INSERT INTO env_data.reddeer_update_vhf_update_env_fields
SELECT vhf_data_animals_id, acquisition_time, geom, vhf_validity_code, corine_land_cover_2006_code, corine_land_cover_2000_code, corine_land_cover_1990_code, corine_land_cover_2012_code, ndvi_modis_boku, ndvi_modis_smoothed,  snow_modis, st_transform(geom,3035) as geom_3035
FROM analysis.vhf_update_env_fields_reddeer;

-- CORINE raster
UPDATE env_data.reddeer_update_vhf_update_env_fields 
SET corine_land_cover_1990_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_1990
WHERE corine_land_cover_1990_code IS NULL AND st_intersects(geom_3035, rast);
UPDATE env_data.reddeer_update_vhf_update_env_fields 
SET corine_land_cover_2000_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2000
WHERE corine_land_cover_2000_code IS NULL  AND st_intersects(geom_3035, rast);
UPDATE env_data.reddeer_update_vhf_update_env_fields 
SET corine_land_cover_2006_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2006
WHERE corine_land_cover_2006_code IS NULL  AND st_intersects(geom_3035, rast);
UPDATE env_data.reddeer_update_vhf_update_env_fields 
SET corine_land_cover_2012_code = st_value(rast,geom_3035) 
FROM env_data.corine_land_cover_2012
WHERE corine_land_cover_2012_code IS NULL AND st_intersects(geom_3035, rast);


-- MODIS SNOW 
UPDATE env_data.reddeer_update_vhf_update_env_fields
SET snow_modis = st_value(rast, geom)
FROM env_data_ts.snow_modis
WHERE
  vhf_validity_code in (1,2,3) and 
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
env_data.reddeer_update_vhf_update_env_fields
SET
ndvi_modis_smoothed = (st_value(pre.rast, geom)*(post.acquisition_date - acquisition_time::date)/(post.acquisition_date - pre.acquisition_date) +
st_value(post.rast, geom)*(- (pre.acquisition_date - acquisition_time::date))/(post.acquisition_date - pre.acquisition_date)) * 0.0048 -0.2
FROM env_data_ts.ndvi_modis_smoothed pre, env_data_ts.ndvi_modis_smoothed post
WHERE
  ndvi_modis_smoothed IS NULL AND 
  vhf_validity_code in (1,2,3) and 
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
UPDATE env_data.reddeer_update_vhf_update_env_fields
SET ndvi_modis_boku = (trunc((st_value(pre.rast, geom) * (date_trunc('week', acquisition_time::date + 7)::date -acquisition_time::date)::integer +
st_value(post.rast, geom) * (acquisition_time::date - date_trunc('week', acquisition_time::date)::date))::integer/7)) * 0.0048 -0.2
FROM env_data_ts.ndvi_modis_boku pre, env_data_ts.ndvi_modis_boku post
WHERE
  ndvi_modis_boku IS NULL AND vhf_validity_code in (1,2,3) and 
  st_intersects(geom, pre.rast) and 
  st_intersects(geom, post.rast) and 
  date_trunc('week', acquisition_time::date)::date = pre.acquisition_date and 
  date_trunc('week', acquisition_time::date + 7)::date = post.acquisition_date;

  
-----------------------
--> IN EUREDDEER DB <--
-----------------------
UPDATE main.vhf_data_animals
   SET corine_land_cover_2006_code=a.corine_land_cover_2006_code, 
       snow_modis=a.snow_modis,
       corine_land_cover_2000_code=a.corine_land_cover_2000_code, 
       corine_land_cover_1990_code=a.corine_land_cover_1990_code, 
       ndvi_modis_boku=a.ndvi_modis_boku, 
       ndvi_modis_smoothed=a.ndvi_modis_smoothed, 
       corine_land_cover_2012_code=a.corine_land_cover_2012_code
FROM
env_data.reddeer_update_vhf_update_env_fields a
WHERE 
a.vhf_data_animals_id = vhf_data_animals.vhf_data_animals_id;
