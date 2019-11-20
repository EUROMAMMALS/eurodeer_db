-- Select all animals monitored by vhf AND gps
SELECT *
  FROM main.animals
  where 
  gps_deployed = 't' and vhf_deployed = 't'

-- Select deployment info of animals monitored with both vhf and gps to verify that monitoring interval and capture dates are consistent
SELECT
  a.animals_id, a.study_areas_id,
  b.start_time, b.end_time,  b.end_deployment_code, 
  c.start_time, c.end_time, c.end_deployment_code
FROM 
  main.animals a JOIN main.gps_sensors_animals b USING (animals_id) JOIN main.vhf_sensors_animals c USING (animals_id)
ORDER BY
  a.study_areas_id, a.animals_id;

-- Is the first capture is later then a start_time of gps or vhf for animals monitored with both? 
--[original code removed because outdated, this query must be re-written]

-- overlap between vhf and gps deployment (not necessarily wrong)
SELECT study_areas_id, a.animals_id, a.vhf_sensors_id, a.start_time, a.end_time, b.gps_sensors_id, b.start_time, b.end_time  
FROM main.gps_sensors_animals b JOIN main.vhf_sensors_animals a USING (animals_id) join main.animals using (animals_id)
WHERE (a.end_time::date between b.start_time::date and b.end_time::date or a.start_time::date between b.start_time::date and b.end_time::date)
ORDER BY animals_id, a.start_time 
