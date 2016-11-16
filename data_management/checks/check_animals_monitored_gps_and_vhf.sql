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
