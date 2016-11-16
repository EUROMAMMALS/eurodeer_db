-- Select all animals monitored by vhf AND gps
SELECT *
  FROM main.animals
  where 
  gps_deployed = 't' and vhf_deployed = 't'

-- Select deployment info of animals monitored with both vhf and gps to verify that monitoring interval and capture dates are consistent
SELECT
  a.animals_id, a.study_areas_id, a.first_capture_date, 
  b.start_time, b.end_time, b.mortality_code, b.end_deployment_code, 
  c.start_time, c.end_time, c.end_deployment_code, c.mortality_code
FROM 
  main.animals a JOIN main.gps_sensors_animals b USING (animals_id) JOIN main.vhf_sensors_animals c USING (animals_id)
ORDER BY
  a.study_areas_id, a.animals_id;

-- Is there a first_capture_date that is later then a start_time of gps or vhf for animals monitored with both? 
WITH x AS (
SELECT
  a.animals_id, a.study_areas_id, a.first_capture_date, 
  (first_capture_date - b.start_time) <= interval '00:00:00' deployment_after_first_capture_gps,
  b.start_time, b.end_time, b.mortality_code, b.end_deployment_code, 
  (first_capture_date - c.start_time) <= interval '00:00:00' deployment_after_first_capture_vhf,
  c.start_time, c.end_time, c.end_deployment_code, c.mortality_code
FROM 
  main.animals a JOIN main.gps_sensors_animals b USING (animals_id) JOIN main.vhf_sensors_animals c USING (animals_id)
ORDER BY
  a.study_areas_id, a.animals_id)
SELECT * FROM x WHERE (deployment_after_first_capture_gps = FALSE OR deployment_after_first_capture_vhf = FALSE)  
