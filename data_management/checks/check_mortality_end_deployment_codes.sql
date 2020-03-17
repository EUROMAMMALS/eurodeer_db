-- End_deployment_codes 
select * from lu_tables.lu_end_deployment order by 1;
-- Statistics deployment 
SELECT a.end_deployment_code, a.end_deployment_description, count(*) 
FROM main.gps_sensors_animals JOIN lu_tables.lu_end_deployment a USING (end_deployment_code) 
GROUP BY 1,2 ORDER BY 3;

-- Explore suspicious combinations end of deployment/mortality (example gps)
-- End of deployment is death but mortality code is alive 
SELECT 	study_areas_id, animals_original_id, animals_id,  gps_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes 
FROM 	main.gps_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.gps_sensors USING (gps_sensors_id) 
WHERE 	end_deployment_code = 4 AND mortality_code = 0;

-- End of deployment is not death but mortality is not alive
SELECT 	study_areas_id, animals_original_id, animals_id,  gps_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes, death_date 
FROM 	main.gps_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.gps_sensors USING (gps_sensors_id) 
WHERE 	end_deployment_code != 4 AND mortality_code != 0;

-- animals-sensors without end of deployment or mortality code
SELECT study_areas_id, a.*
FROM main.gps_sensors_animals a JOIN main.animals USING (animals_id)
WHERE end_deployment_code IS NULL OR mortality_code IS NULL
ORDER BY study_areas_id;

-- Number of animals-sensors without end of deployment or mortality code per study area
SELECT count(*), study_areas_id, end_deployment_code, mortality_code
FROM main.gps_sensors_animals a JOIN main.animals USING (animals_id)
WHERE end_deployment_code IS NULL OR mortality_code IS NULL
GROUP BY study_areas_id, end_deployment_code, mortality_code
ORDER BY count, study_areas_id

-- Are there animals that have an end_deployment_code which assumes no data that has data?
SELECT DISTINCT a.* 
FROM main.gps_sensors_animals a JOIN main.gps_data_animals USING (animals_id,gps_sensors_id) 
WHERE end_deployment_code in (6,9,11) 
-- one animal (SA 24 - 2C2T33)

-- MORE SPECIFIC EXPLORATION  
-- Check animals that are poached. 
SELECT study_areas_id, a.* 
FROM main.gps_sensors_animals a JOIN main.animals USING (animals_id) 
WHERE (a.notes LIKE ('%poach%') OR mortality_code = 9)
ORDER BY study_areas_id, notes

-- Check all animals-sensors with additional comments for data harmonization 
SELECT 	study_areas_id, animals_original_id, animals_id, gps_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes 
FROM 	main.gps_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.gps_sensors USING (gps_sensors_id) 
WHERE 	a.notes is not null
ORDER BY end_deployment_code, study_areas_id, a.notes;



-- Explore suspicious combinations end of monitoring/end of deployment (example vhf)
-- End of deployment is death but mortality code is alive 
SELECT 	study_areas_id, animals_original_id, animals_id, vhf_sensors_original_id, vhf_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes 
FROM 	main.vhf_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.vhf_sensors USING (vhf_sensors_id) 
WHERE 	end_deployment_code = 4 AND mortality_code = 0 ;

-- End of deployment is not death but mortality is not alive
SELECT 	study_areas_id, animals_original_id, animals_id, vhf_sensors_original_id, vhf_sensors_id, 
	start_time, end_time, end_deployment_code, mortality_code, a.notes 
FROM 	main.vhf_sensors_animals a JOIN main.animals USING (animals_id) 
	JOIN main.vhf_sensors USING (vhf_sensors_id) 
WHERE 	end_deployment_code != 4 AND mortality_code != 0 ;


-- animals-sensors without end of deployment or mortality code
SELECT study_areas_id, a.*
FROM main.vhf_sensors_animals a JOIN main.animals USING (animals_id)
WHERE end_deployment_code IS NULL OR mortality_code IS NULL
ORDER BY study_areas_id;

-- number of animals-sensors without end of deployment or mortality code per study area
SELECT count(*), study_areas_id, end_deployment_code, mortality_code
FROM main.vhf_sensors_animals a JOIN main.animals USING (animals_id)
WHERE end_deployment_code IS NULL OR mortality_code IS NULL
GROUP BY study_areas_id, end_deployment_code, mortality_code
ORDER BY count, study_areas_id

-- are there animals that have an end_deployment_code which assumes no data that has data?
SELECT DISTINCT a.* 
FROM main.vhf_sensors_animals a JOIN main.vhf_data_animals USING (animals_id,vhf_sensors_id) 
WHERE end_deployment_code in (6,9,11) ;


