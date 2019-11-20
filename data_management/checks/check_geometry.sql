-- LONGITUDE LATITUDE
-- longitude/latitude is null but geometry is not NULL
SELECT animals_id, latitude, longitude, geom FROM main.gps_data_animals WHERE (longitude is null or latitude is null) and geom is not null;

-- geom and longitude/latitude do not correspond
SELECT gps_data_animals_id, study_areas_id, animals_id, latitude, longitude, geom, st_y(geom),st_x(geom), gps_validity_code 
FROM main.gps_data_animals join main.animals using (animals_id) WHERE latitude != st_y(geom); 
SELECT gps_data_animals_id, study_areas_id, animals_id, latitude, longitude, geom, st_y(geom),st_x(geom), gps_validity_code 
FROM main.gps_data_animals join main.animals using (animals_id) WHERE longitude != st_x(geom); 
-- UPDATE main.gps_data_animals SET latitude = st_y(geom), longitude = st_x(geom) WHERE latitude != st_y(geom) and longitude != st_x(geom)

-- UTM_X and UTM_Y
-- gps_validity_code is 0 but utm_x and utm_y is provided 
SELECT * from main.gps_data_animals where gps_validity_code in (0) and utm_x is not null;
-- UPDATE main.gps_data_animals SET utm_x = NULL, utm_y = NULL WHERE gps_validity_code in (0) and utm_x is not null; 

-- check if utm_x is consistent with the geom
SELECT animals_id, latitude, longitude, geom, gps_validity_code, utm_x, utm_y,
st_x(st_transform(geom,utm_srid))::integer,st_y(st_transform(geom,utm_srid))::integer FROM main.gps_data_animals 
WHERE utm_x != st_x(st_transform(geom,utm_srid))::integer and gps_validity_code = 1; 
-- check if utm_y is consistent with the geom
SELECT animals_id, latitude, longitude, geom, gps_validity_code, utm_x, utm_y,
st_x(st_transform(geom,utm_srid))::integer,st_y(st_transform(geom,utm_srid))::integer FROM main.gps_data_animals 
WHERE utm_y != st_y(st_transform(geom,utm_srid))::integer and gps_validity_code = 1;
