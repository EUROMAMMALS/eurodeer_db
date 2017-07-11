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

UPDATE main.gps_data_animals
SET corine_land_cover_2012_code = st_value(rast,st_transform(geom,3035)) 
from env_data.corine_land_cover_2012
WHERE corine_land_cover_2012_code is null and gps_validity_code in (1,2,3) and st_intersects(st_transform(geom,3035), rast);

update main.gps_data_animals set sun_angle = tools.sun_elevation_angle(acquisition_time, geom) 
where sun_angle is null and gps_validity_code in (1,2,3);

update main.gps_data_animals set utm_srid = foo.a from
(select animals_id, tools.srid_utm(st_x(ST_Centroid(st_collect(geom))), st_y((ST_Centroid(st_collect(geom))))) as a from main.gps_data_animals where gps_validity_code in (1,2,3) group by animals_id) as foo 
where gps_data_animals.animals_id = foo.animals_id and gps_data_animals.utm_srid is null;

update main.gps_data_animals 
set utm_x = st_x(st_transform(geom, utm_srid)), utm_y = st_y(st_transform(geom, utm_srid))
where gps_validity_code in (1,2,3) and utm_x is null;

-- DEM+SLOPE+ASPECT COPERNICUS
update
  main.gps_data_animals
set
  altitude_copernicus = st_value(dem_copernicus.rast, st_transform(gps_data_animals.geom,3035))
FROM
  env_data.dem_copernicus, 
  main.animals
WHERE 
  altitude_copernicus is null and
  and gps_validity_code in (1,2,3) AND
  animals.animals_id = gps_data_animals.animals_id AND
  animals.study_areas_id = dem_copernicus.study_areas_id and
  st_intersects(dem_copernicus.rast,st_transform(gps_data_animals.geom,3035));

update
  main.gps_data_animals
set
  slope_copernicus = st_value(slope_copernicus.rast, st_transform(gps_data_animals.geom,3035))
FROM
  env_data.slope_copernicus, 
  main.animals
WHERE 
  slope_copernicus is null and
  and gps_validity_code in (1,2,3) AND
  animals.animals_id = gps_data_animals.animals_id AND
  animals.study_areas_id = slope_copernicus.study_areas_id and
  st_intersects(slope_copernicus.rast,st_transform(gps_data_animals.geom,3035));

update
  main.gps_data_animals
set
  aspect_copernicus = st_value(aspect_copernicus.rast, st_transform(gps_data_animals.geom,3035))
FROM
  env_data.aspect_copernicus, 
  main.animals
WHERE 
  aspect_copernicus is null and
  and gps_validity_code in (1,2,3) AND
  animals.animals_id = gps_data_animals.animals_id AND
  animals.study_areas_id = aspect_copernicus.study_areas_id and
  st_intersects(aspect_copernicus.rast,st_transform(gps_data_animals.geom,3035));

-- Update the study areas boundaries
update main.study_areas set geom = foo.qq from (select studies_id as ww, (st_multi(st_convexhull(st_collect(geom)))) qq from analysis.view_convexhull  
group by studies_id) as foo where defined_boundaries = 0 and study_areas.study_areas_id = foo.ww;

--
update main.study_areas set geom_mcp_individuals = foo.qq from (select studies_id as ww,st_multi(st_buffer((st_multi(st_union(geom)))::geometry(multipolygon, 4326)::geography, 500)::geometry)qq from analysis.view_convexhull group by studies_id) as foo where defined_boundaries = 0 and study_areas.study_areas_id = foo.ww;

-- 
DROP TABLE IF EXISTS temp.locations_24h;
CREATE TABLE temp.locations_24h AS 
SELECT study_areas_id, animals_id, geom, acquisition_time FROM (
    SELECT animals_id, geom, study_areas_id, row_number() over (partition by study_areas_id, animals_id, acquisition_time::date order by study_areas_id, animals_id, acquisition_time) rownr, acquisition_time ù
    FROM main.gps_data_animals join main.animals using (animals_id) 
    WHERE gps_validity_code = 1) x
WHERE rownr = 1 order by study_areas_id, animals_id, acquisition_time;


DROP TABLE IF EXISTS temp.locations_24h_traj;
CREATE TABLE temp.locations_24h_traj AS
SELECT animals_id,
    study_areas_id ,
    foo2.geom::geometry(LineString,4326) AS geom
   FROM ( SELECT foo.animals_id,study_areas_id,
            st_makeline(foo.geom) AS geom
           FROM ( SELECT study_areas_id, geom,
                    animals_id,
                    acquisition_time
                   FROM temp.locations_24h
                  ORDER BY study_areas_id, animals_id, acquisition_time) foo
          GROUP BY foo.animals_id, study_areas_id) foo2
  WHERE st_geometrytype(foo2.geom) = 'ST_LineString'::text;
ALTER TABLE temp.locations_24h_traj ADD COLUMN geom_buffer geometry(polygon,4326);
UPDATE temp.locations_24h_traj set geom_buffer = (st_buffer(st_simplify(geom, 0.001)::geography, 1000))::geometry

DROP TABLE IF EXISTS  temp.locations_24h_studyareas;
CREATE TABLE temp.locations_24h_studyareas AS
SELECT study_areas_id, 
st_multi(st_union(geom_buffer))::geometry(multipolygon, 4326) geom from
temp.locations_24h_traj
group by study_areas_id;

update main.study_areas set geom_traj_buffer = locations_24h_studyareas.geom
from temp.locations_24h_studyareas
where defined_boundaries = 0 and study_areas.study_areas_id = locations_24h_studyareas.study_areas_id; 

-- missing code for geom_grid300

-- geom_kernel95_5km_buffer

--
update main.study_areas set geom_vhf = foo.qq from (select studies_id as ww, (st_multi(st_convexhull(st_collect(geom)))) qq from analysis.view_convexhull_vhf  
group by studies_id) as foo where defined_boundaries = 0 and study_areas.study_areas_id = foo.ww;

-------------------------------------------
--DEPRECATED: NOW COPERNICUS DEM IS USED --
-------------------------------------------
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
SET aspect_aster = st_value(rast,ST_Translate(geom, 0.000416, 0)) 
from env_data.aspect_aster
WHERE aspect_aster is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0.000416, 0), rast) and st_value(rast,ST_Translate(geom, 0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster = st_value(rast,ST_Translate(geom, -0.000416, 0)) 
from env_data.aspect_aster
WHERE aspect_aster is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, -0.000416, 0), rast) and st_value(rast,ST_Translate(geom, -0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster = st_value(rast,ST_Translate(geom, 0, -0.000416)) 
from env_data.aspect_aster
WHERE aspect_aster is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0, -0.000416), rast) and st_value(rast,ST_Translate(geom, 0, -0.000416)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster = st_value(rast,ST_Translate(geom, 0, 0.000416)) 
from env_data.aspect_aster
WHERE aspect_aster is null and gps_validity_code in (1,2,3) and st_intersects(ST_Translate(geom, 0, -0.000416), rast) and st_value(rast,ST_Translate(geom, 0, 0.000416)) != 'NaN';

-- Update the value of aspect to -1 where the slope is null or aspect = 0 (convention used in GRASS)
-- I also update aspect calculated from north clockwise (in grass is from east counterclockwise)
UPDATE main.gps_data_animals
   SET aspect_srtm_east_ccw= -1
 WHERE aspect_srtm_east_ccw = 0 or (slope_srtm = 0 and aspect_srtm_east_ccw > -1);
 
 UPDATE main.gps_data_animals
   SET aspect_aster_east_ccw= -1
 WHERE aspect_aster_east_ccw = 0 or (slope_aster = 0 and aspect_aster_east_ccw > -1);

 UPDATE main.gps_data_animals
   SET aspect_srtm_north_cw = case 
     when aspect_srtm_east_ccw = -1 then -1
     When aspect_srtm_east_ccw < 90 then (90 - aspect_srtm_east_ccw)
     When aspect_srtm_east_ccw >= 90 Then (450 - aspect_srtm_east_ccw) END
 WHERE aspect_srtm_north_cw is null and aspect_srtm_east_ccw is not null;

 UPDATE main.gps_data_animals
   SET aspect_aster_north_cw = case 
     when aspect_aster_east_ccw = -1 then -1
     When aspect_aster_east_ccw < 90 then (90 - aspect_aster_east_ccw)
     When aspect_aster_east_ccw >= 90 Then (450 - aspect_aster_east_ccw) END
 WHERE aspect_aster_north_cw is null and aspect_aster_east_ccw is not null;

