-- Select all animals monitored by vhf AND gps
SELECT *
  FROM main.animals
  where 
  gps_deployed = 't' and vhf_deployed = 't'

-- Select deployment info of animals monitored with both vhf and gps to verify that monitoring interval and capture dates are consistent
SELECT
  animals.animals_id, 
  animals.study_areas_id, 
  animals.first_capture_date, 
  gps_sensors_animals.start_time, 
  gps_sensors_animals.end_time, 
  gps_sensors_animals.mortality_code, 
  gps_sensors_animals.end_deployment_code, 
  vhf_sensors_animals.start_time, 
  vhf_sensors_animals.end_time, 
  vhf_sensors_animals.end_deployment_code, 
  vhf_sensors_animals.mortality_code
FROM 
  main.animals, 
  main.gps_sensors_animals, 
  main.vhf_sensors_animals
WHERE 
  animals.animals_id = gps_sensors_animals.animals_id AND
  animals.animals_id = vhf_sensors_animals.animals_id
ORDER BY
  animals.study_areas_id, 
  animals.animals_id
