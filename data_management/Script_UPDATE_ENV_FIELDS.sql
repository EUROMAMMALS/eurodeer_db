
update main.gps_data_animals 
set geom = st_setsrid(st_makepoint(longitude,latitude),4326)
where longitude is not null and latitude is not null AND gps_validity_code in (1,2,3) and geom is null;

UPDATE main.gps_data_animals
SET corine_land_cover_1990_code = st_value(rast,st_transform(geom,3035)) 
from env_data.corine_land_cover_1990
WHERE corine_land_cover_1990_code is null and gps_validity_code in (1,2,3) and st_intersects(st_transform(geom,3035), rast);

UPDATE main.gps_data_animals
SET corine_land_cover_2000_code = st_value(rast,st_transform(geom,3035)) 
from env_data.corine_land_cover_2000
WHERE corine_land_cover_2000_code is null and gps_validity_code in (1,2,3) and st_intersects(st_transform(geom,3035), rast);

UPDATE main.gps_data_animals
SET corine_land_cover_2006_code = st_value(rast,st_transform(geom,3035)) 
from env_data.corine_land_cover_2006
WHERE corine_land_cover_2006_code is null and gps_validity_code in (1,2,3) and st_intersects(st_transform(geom,3035), rast);

update main.gps_data_animals set sun_angle = tools.sun_elevation_angle(acquisition_time, geom) 
where sun_angle is null and gps_validity_code in (1,2,3);

update main.gps_data_animals set utm_srid = foo.a from
(select animals_id, tools.srid_utm(st_x(ST_Centroid(st_collect(geom))), st_y((ST_Centroid(st_collect(geom))))) as a from main.gps_data_animals where gps_validity_code in (1,2,3) group by animals_id) as foo 
where gps_data_animals.animals_id = foo.animals_id and gps_data_animals.utm_srid is null;

update main.gps_data_animals 
set utm_x = st_x(st_transform(geom, utm_srid)), utm_y = st_y(st_transform(geom, utm_srid))
where gps_validity_code in (1,2,3) and utm_x is null;

UPDATE main.gps_data_animals
SET altitude_srtm = st_value(rast,geom) 
from env_data.dem_srtm
WHERE altitude_srtm is null and gps_validity_code in (1,2,3) and st_intersects(geom, rast) and st_value(rast,geom) != 'NaN';

UPDATE main.gps_data_animals
SET slope_srtm = st_value(rast,geom) 
from env_data.slope_srtm
WHERE slope_srtm is null and gps_validity_code in (1,2,3) and st_intersects(geom, rast) and st_value(rast,geom) != 'NaN';

UPDATE main.gps_data_animals
SET aspect_srtm_east_ccw = st_value(rast,geom) 
from env_data.aspect_srtm
WHERE aspect_srtm_east_ccw is null and gps_validity_code in (1,2,3) and st_intersects(geom, rast) and st_value(rast,geom) != 'NaN';

UPDATE main.gps_data_animals
SET altitude_aster = st_value(rast,geom) 
from env_data.dem_aster
WHERE altitude_aster is null and gps_validity_code in (1,2,3) and st_intersects(geom, rast) and st_value(rast,geom) != 'NaN';

UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,geom) 
from env_data.slope_aster
WHERE slope_aster is null and gps_validity_code in (1,2,3) and st_intersects(geom, rast) and st_value(rast,geom) != 'NaN';

UPDATE main.gps_data_animals
SET aspect_aster_east_ccw = st_value(rast,geom) 
from env_data.aspect_aster
WHERE aspect_aster_east_ccw is null and gps_validity_code in (1,2,3) and st_intersects(geom, rast) and st_value(rast,geom) != 'NaN';

-- Update the study areas boundaries
update main.study_areas set geom = foo.qq from (select studies_id as ww, (st_multi(st_convexhull(st_collect(geom)))) qq from analysis.view_convexhull  
group by studies_id) as foo where defined_boundaries = 0 and study_areas.study_areas_id = foo.ww;

update main.study_areas set geom_mcp_individuals = foo.qq from (select studies_id as ww,st_multi(st_buffer((st_multi(st_union(geom)))::geometry(multipolygon, 4326)::geography, 500)::geometry)qq from analysis.view_convexhull group by studies_id) as foo where defined_boundaries = 0 and study_areas.study_areas_id = foo.ww;

-------------
-- FOR (the very few) LOCATIONS THAT ARE EXACLTY ACROSS TWO IMAGES, A *NULL* VALUE IS RETURNED WHEN INTERSECTED WITH ASTER slope and aspect IMAGES.
-- TO SOLVE THIS I FORCE A LITTLE TRANSLATION OF HALF A PIXEL
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,ST_Translate(geom, 0.000416, 0)) 
from env_data.slope_aster
WHERE slope_aster is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0.000416, 0), rast) and st_value(rast,ST_Translate(geom, 0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,ST_Translate(geom, -0.000416, 0)) 
from env_data.slope_aster
WHERE slope_aster is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, -0.000416, 0), rast) and st_value(rast,ST_Translate(geom, -0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,ST_Translate(geom, 0, -0.000416)) 
from env_data.slope_aster
WHERE slope_aster is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0, -0.000416), rast) and st_value(rast,ST_Translate(geom, 0, -0.000416)) != 'NaN';
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,ST_Translate(geom, 0, 0.000416)) 
from env_data.slope_aster
WHERE slope_aster is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0, -0.000416), rast) and st_value(rast,ST_Translate(geom, 0, 0.000416)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster_east_ccw = st_value(rast,ST_Translate(geom, 0.000416, 0)) 
from env_data.aspect_aster
WHERE aspect_aster_east_ccw is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0.000416, 0), rast) and st_value(rast,ST_Translate(geom, 0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster_east_ccw = st_value(rast,ST_Translate(geom, -0.000416, 0)) 
from env_data.aspect_aster
WHERE aspect_aster_east_ccw is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, -0.000416, 0), rast) and st_value(rast,ST_Translate(geom, -0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster_east_ccw = st_value(rast,ST_Translate(geom, 0, -0.000416)) 
from env_data.aspect_aster
WHERE aspect_aster_east_ccw is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0, -0.000416), rast) and st_value(rast,ST_Translate(geom, 0, -0.000416)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster_east_ccw = st_value(rast,ST_Translate(geom, 0, 0.000416)) 
from env_data.aspect_aster
WHERE aspect_aster_east_ccw is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0, -0.000416), rast) and st_value(rast,ST_Translate(geom, 0, 0.000416)) != 'NaN';
