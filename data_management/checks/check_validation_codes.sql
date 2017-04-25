-- fixes outside deployment but not 14,22,23
select * from main.gps_data_animals where
gps_data_animals_id not in
(SELECT gps_data_animals_id
FROM main.gps_data_animals a JOIN main.gps_sensors_animals b USING (animals_id, gps_sensors_id)
WHERE acquisition_time between start_time and end_time) and gps_validity_code not in (14,22,23)
order by gps_validity_code;

-- fixes inside deployment but 14
select * from main.gps_data_animals where
gps_data_animals_id in
(SELECT gps_data_animals_id
FROM main.gps_data_animals a JOIN main.gps_sensors_animals USING (animals_id, gps_sensors_id)
WHERE acquisition_time between start_time and end_time) and gps_validity_code in (14,22,23)
order by gps_validity_code;

-- Fixes outside deployment but not 14,22,23
-- UPDATE main.gps_data_animals d SET gps_validity_code = 14 FROM (
SELECT study_areas_id, gps_data_animals_id, longitude, latitude,b.gps_sensors_id, b.animals_id, b.acquisition_time, b.gps_validity_code  
FROM main.gps_data_animals b LEFT OUTER JOIN 
(
  -- all fixes that are within the deployment interval
  SELECT a.animals_id, a.gps_sensors_id, gps_sensors_animals_id, acquisition_time, start_time, end_time, gps_validity_code 
    FROM main.gps_data_animals a, main.gps_sensors_animals b
  WHERE a.animals_id = b.animals_id and a.gps_sensors_id = b.gps_sensors_id and acquisition_time between start_time and end_time 
  ORDER BY animals_id, acquisition_time
) c USING (animals_id, gps_sensors_id, acquisition_time) JOIN main.animals using (animals_id)
WHERE c.acquisition_time is null and b.gps_validity_code not in (14,22,23) order by b.animals_id, b.acquisition_time
--) e WHERE d.gps_data_animals_id = e.gps_data_animals_id 






