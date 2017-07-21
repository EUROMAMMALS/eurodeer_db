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

-- Update CORINE 1990-2000-2006-2012 from raster 100m resolution
UPDATE main.gps_data_animals
SET corine_land_cover_1990_code = st_value(rast,st_transform(geom,3035)) 
FROM env_data.corine_land_cover_1990
WHERE corine_land_cover_1990_code IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(st_transform(geom,3035), rast);
UPDATE main.gps_data_animals
SET corine_land_cover_2000_code = st_value(rast,st_transform(geom,3035)) 
FROM env_data.corine_land_cover_2000
WHERE corine_land_cover_2000_code IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(st_transform(geom,3035), rast);
UPDATE main.gps_data_animals
SET corine_land_cover_2006_code = st_value(rast,st_transform(geom,3035)) 
FROM env_data.corine_land_cover_2006
WHERE corine_land_cover_2006_code IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(st_transform(geom,3035), rast);
UPDATE main.gps_data_animals
SET corine_land_cover_2012_code = st_value(rast,st_transform(geom,3035)) 
FROM env_data.corine_land_cover_2012
WHERE corine_land_cover_2012_code IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(st_transform(geom,3035), rast);
-- Update CORINE 2012 from vector layer
UPDATE main.gps_data_animals
SET corine_land_cover_2012_vector_code = corine_study_areas_mcp_INdividuals.clc_code::integer
FROM env_data.corine_study_areas_mcp_INdividuals
WHERE st_coveredby(gps_data_animals.geom, corine_study_areas_mcp_INdividuals.geom) AND gps_validity_code IN (1,2,3) AND corine_land_cover_2012_vector_code IS NULL;

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
-- geom_traj_buffer: union of trajectories of all animals with a buffer of 1000 meters
-- This definition involves additional calculations and is a bit slow
DROP TABLE IF EXISTS temp.locations_24h_traj;
CREATE TABLE temp.locations_24h_traj AS
	SELECT animals_id, study_areas_id , foo2.geom::geometry(LineString,4326) AS geom
	FROM 
		(SELECT foo.animals_id,study_areas_id, st_makeline(foo.geom) AS geom
		FROM 
			(SELECT study_areas_id, geom, animals_id, acquisition_time
			FROM temp.locations_24h
			ORDER BY study_areas_id, animals_id, acquisition_time) foo
		GROUP BY foo.animals_id, study_areas_id) foo2
	WHERE st_geometrytype(foo2.geom) = 'ST_LineString'::text;
ALTER TABLE temp.locations_24h_traj ADD COLUMN geom_buffer geometry(polygon,4326);
UPDATE temp.locations_24h_traj 
SET geom_buffer = (st_buffer(st_simplify(geom, 0.001)::geography, 1000))::geometry;
DROP TABLE IF EXISTS  temp.locations_24h_studyareas;
CREATE TABLE temp.locations_24h_studyareas AS
	SELECT study_areas_id, st_multi(st_union(geom_buffer))::geometry(multipolygon, 4326) geom 
	FROM temp.locations_24h_traj
	GROUP BY study_areas_id;
UPDATE main.study_areas 
SET geom_traj_buffer = locations_24h_studyareas.geom
FROM temp.locations_24h_studyareas
WHERE defined_boundaries = 0 AND study_areas.study_areas_id = locations_24h_studyareas.study_areas_id; 
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

 -------------------------------
-- UPDATE CORINE vector 2012  --
--------------------------------
-- This must be run if new locations are outside the boundaries of the previous one.
-- I refresh the table with the last available data
-- In CORINE db
TRUNCATE roedeer.temp_study_areas_mcp_individuals;
INSERT INTO roedeer.temp_study_areas_mcp_individuals
	SELECT row_number() over(), geom 
	FROM 
		(SELECT (st_dump(st_transform(st_union(geom_mcp_individuals),3035))).geom as geom
		FROM roedeer.study_areas) a;

TRUNCATE analysis.corine_study_areas_mcp_individuals;
INSERT INTO analysis.corine_study_areas_mcp_individuals
	SELECT * 
	FROM analysis.view_corine_study_areas_mcp_individuals;
-- In eurodeer db
TRUNCATE env_data.corine_study_areas_mcp_individuals;
INSERT INTO env_data.corine_study_areas_mcp_individuals
	SELECT * 
	FROM env_data.corine_2012_vector_mcp_individuals;

--------------------------------------------------------------------
--DEPRECATED: CODE TO UPDATE ASTER AND SRTM DEM_RELATED VARIABLES --
--------------------------------------------------------------------
UPDATE main.gps_data_animals
SET altitude_srtm = st_value(rast,geom) 
FROM env_data.dem_srtm
WHERE altitude_srtm IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(geom, rast) AND st_value(rast,geom) != 'NaN';
UPDATE main.gps_data_animals
SET slope_srtm = st_value(rast,geom) 
FROM env_data.slope_srtm
WHERE slope_srtm IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(geom, rast) AND st_value(rast,geom) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_srtm_east_ccw = st_value(rast,geom) 
FROM env_data.aspect_srtm
WHERE aspect_srtm_east_ccw IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(geom, rast) AND st_value(rast,geom) != 'NaN';
UPDATE main.gps_data_animals
SET altitude_aster = st_value(rast,geom) 
FROM env_data.dem_aster
WHERE altitude_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(geom, rast) AND st_value(rast,geom) != 'NaN';
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,geom) 
FROM env_data.slope_aster
WHERE slope_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(geom, rast) AND st_value(rast,geom) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster_east_ccw = st_value(rast,geom) 
FROM env_data.aspect_aster
WHERE aspect_aster_east_ccw IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(geom, rast) AND st_value(rast,geom) != 'NaN';
-- FOR (the very few) LOCATIONS THAT ARE EXACLTY ACROSS TWO IMAGES, A *NULL* VALUE IS RETURNED WHEN INTERSECTED WITH ASTER slope AND aspect IMAGES.
-- TO SOLVE THIS I FORCE A LITTLE TRANSLATION OF HALF A PIXEL
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,ST_Translate(geom, 0.000416, 0)) 
FROM env_data.slope_aster
WHERE slope_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(ST_Translate(geom, 0.000416, 0), rast) AND st_value(rast,ST_Translate(geom, 0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,ST_Translate(geom, -0.000416, 0)) 
FROM env_data.slope_aster
WHERE slope_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(ST_Translate(geom, -0.000416, 0), rast) AND st_value(rast,ST_Translate(geom, -0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,ST_Translate(geom, 0, -0.000416)) 
FROM env_data.slope_aster
WHERE slope_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(ST_Translate(geom, 0, -0.000416), rast) AND st_value(rast,ST_Translate(geom, 0, -0.000416)) != 'NaN';
UPDATE main.gps_data_animals
SET slope_aster = st_value(rast,ST_Translate(geom, 0, 0.000416)) 
FROM env_data.slope_aster
WHERE slope_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(ST_Translate(geom, 0, -0.000416), rast) AND st_value(rast,ST_Translate(geom, 0, 0.000416)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster = st_value(rast,ST_Translate(geom, 0.000416, 0)) 
FROM env_data.aspect_aster
WHERE aspect_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(ST_Translate(geom, 0.000416, 0), rast) AND st_value(rast,ST_Translate(geom, 0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster = st_value(rast,ST_Translate(geom, -0.000416, 0)) 
FROM env_data.aspect_aster
WHERE aspect_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(ST_Translate(geom, -0.000416, 0), rast) AND st_value(rast,ST_Translate(geom, -0.000416, 0)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster = st_value(rast,ST_Translate(geom, 0, -0.000416)) 
FROM env_data.aspect_aster
WHERE aspect_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(ST_Translate(geom, 0, -0.000416), rast) AND st_value(rast,ST_Translate(geom, 0, -0.000416)) != 'NaN';
UPDATE main.gps_data_animals
SET aspect_aster = st_value(rast,ST_Translate(geom, 0, 0.000416)) 
FROM env_data.aspect_aster
WHERE aspect_aster IS NULL AND gps_validity_code IN (1,2,3) AND st_intersects(ST_Translate(geom, 0, -0.000416), rast) AND st_value(rast,ST_Translate(geom, 0, 0.000416)) != 'NaN';
-- UPDATE the value of aspect to -1 where the slope IS NULL or aspect = 0 (convention used in GRASS)
-- I also UPDATE aspect calculated FROM north clockwise (in grass is from east counterclockwise)
UPDATE main.gps_data_animals
SET aspect_srtm_east_ccw= -1
WHERE aspect_srtm_east_ccw = 0 or (slope_srtm = 0 AND aspect_srtm_east_ccw > -1);
UPDATE main.gps_data_animals
SET aspect_aster_east_ccw= -1
WHERE aspect_aster_east_ccw = 0 or (slope_aster = 0 AND aspect_aster_east_ccw > -1);
UPDATE main.gps_data_animals
SET aspect_srtm_north_cw = case when aspect_srtm_east_ccw = -1 then -1 When aspect_srtm_east_ccw < 90 then (90 - aspect_srtm_east_ccw) When aspect_srtm_east_ccw >= 90 Then (450 - aspect_srtm_east_ccw) END
WHERE aspect_srtm_north_cw IS NULL AND aspect_srtm_east_ccw IS NOT NULL;
UPDATE main.gps_data_animals
SET aspect_aster_north_cw = case when aspect_aster_east_ccw = -1 then -1 When aspect_aster_east_ccw < 90 then (90 - aspect_aster_east_ccw) When aspect_aster_east_ccw >= 90 Then (450 - aspect_aster_east_ccw) END
WHERE aspect_aster_north_cw IS NULL AND aspect_aster_east_ccw IS NOT NULL;

