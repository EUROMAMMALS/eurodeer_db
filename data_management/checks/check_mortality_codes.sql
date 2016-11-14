-- Statistics on end of monitoring and mortality (gps deployments)
SELECT
  b.mortality_code, mortality_description,
  c.end_deployment_code, end_deployment_description,
  count(*)
FROM 
  main.gps_sensors_animals a
  LEFT JOIN lu_tables.lu_mortality b USING (mortality_code)
  LEFT JOIN lu_tables.lu_end_deployment c USING (end_deployment_code)
GROUP BY 
  b.mortality_code, mortality_description,
  c.end_deployment_code, end_deployment_description
ORDER BY  
  end_deployment_description, mortality_description;


-- Explore suspicious combinations end of deployment/mortality (example gps)
SELECT * FROM main.gps_sensors_animals WHERE mortality_code = 7 AND end_monitoring_code = 1;

-- Explore in more detail: 
-- end_deployment_code = 8 AND mortality_code = 7
SELECT 
	study_areas_id, animals_original_id, animals_id, gps_sensors_original_id, gps_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes 
FROM 
	main.gps_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.gps_sensors USING (gps_sensors_id) 
WHERE end_deployment_code = 8 AND mortality_code = 7 

-- end_deployment_code = 9 AND mortality_code = 5,9
SELECT 
	study_areas_id, animals_original_id, animals_id, gps_sensors_original_id, gps_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes 
FROM 
	main.gps_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.gps_sensors USING (gps_sensors_id) 
WHERE 
	end_deployment_code = 9 AND mortality_code IN (5,9) 
  
-- end_deployment_code = 3 AND mortality_code = 8
SELECT 
	study_areas_id, animals_original_id, animals_id, gps_sensors_original_id, gps_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes 
FROM 
	main.gps_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.gps_sensors USING (gps_sensors_id) 
WHERE 
	end_deployment_code = 3 AND mortality_code = 8 


-- animals-sensors without end of deployment or mortality code
SELECT study_areas_id, a.*
FROM main.gps_sensors_animals a JOIN main.animals USING (animals_id)
WHERE end_deployment_code IS NULL OR mortality_code IS NULL
ORDER BY study_areas_id

-- number of animals-sensors without end of deployment or mortality code per study area
SELECT count(*), study_areas_id, end_deployment_code, mortality_code
FROM main.gps_sensors_animals a JOIN main.animals USING (animals_id)
WHERE end_deployment_code IS NULL OR mortality_code IS NULL
GROUP BY study_areas_id, end_deployment_code, mortality_code
ORDER BY count, study_areas_id


---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------

-- Statistics on end of deployment and mortality (vhf deployments)
SELECT
  b.mortality_code, mortality_description,
  c.end_deployment_code, end_deployment_description,
  count(*)
FROM 
  main.vhf_sensors_animals a
  LEFT JOIN lu_tables.lu_mortality b USING (mortality_code)
  LEFT JOIN lu_tables.lu_end_deployment c USING (end_deployment_code)
GROUP BY 
  b.mortality_code, mortality_description,
  c.end_deployment_code, end_deployment_description
ORDER BY  
  end_deployment_description, mortality_description;


-- Explore suspicious combinations end of monitoring/end of deployment (example vhf)
SELECT * FROM main.vhf_sensors_animals WHERE mortality_code = 7 AND end_monitoring_code = 1;

-- Explore in more detail: 
-- end_deployment_code = 6 AND mortality_code = 10
SELECT 
	study_areas_id, animals_original_id, animals_id, vhf_sensors_original_id, vhf_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes 
FROM 
	main.vhf_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.vhf_sensors USING (vhf_sensors_id) 
WHERE end_deployment_code = 6 AND mortality_code = 10 


-- animals-sensors without end of deployment or mortality code
SELECT study_areas_id, a.*
FROM main.vhf_sensors_animals a JOIN main.animals USING (animals_id)
WHERE end_deployment_code IS NULL OR mortality_code IS NULL
ORDER BY study_areas_id

-- number of animals-sensors without end of deployment or mortality code per study area
SELECT count(*), study_areas_id, end_deployment_code, mortality_code
FROM main.vhf_sensors_animals a JOIN main.animals USING (animals_id)
WHERE end_deployment_code IS NULL OR mortality_code IS NULL
GROUP BY study_areas_id, end_deployment_code, mortality_code
ORDER BY count, study_areas_id
