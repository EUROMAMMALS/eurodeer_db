-- ASSESSMENT OF ANIMALS MONITORED WITH GPS

-- List of animals derived from gps_data_animals (animals with data)
SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id;

-- List of animals derived from gps_sensors_animals (animals with deployment)
SELECT DISTINCT animals_id FROM main.gps_sensors_animals;

-- List of animals derived from table animals (animals tagged as monitored with GPS)
-- Note: the flag is not automatically updated, so it can be potentially incorrect/not synchronized with data existing in the database
SELECT animals_id FROM main.animals WHERE monitored_gps = 1;

-- Animals marked as monitored that are not monitored
SELECT animals_id FROM main.gps_data_animals WHERE animals_id NOT IN (SELECT animals_id FROM main.animals WHERE monitored_gps = 1) GROUP BY animals_id;

-- Animals marked as non monitored that are monitored
SELECT animals_id FROM main.animals WHERE monitored_gps = 1 AND animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id);

-- GPS deployed but no data
SELECT DISTINCT animals_id FROM main.gps_sensors_animals WHERE animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id);

-- Complete info on all deployments with no data associated
SELECT start_time - end_time, * FROM main.gps_sensors_animals WHERE animals_id IN (SELECT DISTINCT animals_id FROM main.gps_sensors_animals WHERE animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id)) ORDER BY start_time - end_time;

-- Summary with number of animals with no deployment of any sensors grouped per study area
-- This makes use of the new columns used to mark monitored/deployed animals, which is updated with the info from the related tables in the db
SELECT b.study_areas_id, b.study_name, a.num 
FROM main.study_areas b,
(SELECT study_areas_id , count(*) as num FROM main.animals where gps_deployed = 'f' and activity_deployed= 'f' and vhf_deployed = 'f' group by study_areas_id) a
WHERE a.study_areas_id = b.study_areas_id
order by b.study_areas_id;

-- List of all animals with the same original id (in the same study area) -> potential duplicates
SELECT a.* 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id
ORDER BY animals_original_id;

-- Check if data with no info or collars deployed have a record in animals_capture table
SELECT 
a.animals_id, a.study_areas_id, a.first_capture_date, b.* 
FROM 
(SELECT * FROM main.animals where gps_deployed = 'f' and activity_deployed= 'f' and vhf_deployed = 'f') a
LEFT JOIN
main.animals_captures b
ON
a.animals_id = b.animals_id
order by 
b.animals_id, a.study_areas_id

-- Associations animals - GPS collars with no data
SELECT study_areas_id, end_monitoring_code, start_time - end_time, * 
FROM main.gps_sensors_animals, main.animals 
WHERE gps_sensors_animals.animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id)
AND animals.animals_id = gps_sensors_animals.animals_id
ORDER BY end_monitoring_code, abs(extract(epoch from start_time - end_time));

-- Number of deployments with no gps data associated per research group, with number of deployments longer/shorter then 5 days
SELECT study_areas_id, end_monitoring_code, count(*) total_deployments,
sum( case WHEN abs(extract(epoch from start_time - end_time)) > 60*60*24*5 THEN 1 ELSE 0 end) as long_monitor
FROM main.gps_sensors_animals, main.animals 
WHERE gps_sensors_animals.animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id)
AND animals.animals_id = gps_sensors_animals.animals_id
group by study_areas_id, end_monitoring_code
ORDER BY study_areas_id;

