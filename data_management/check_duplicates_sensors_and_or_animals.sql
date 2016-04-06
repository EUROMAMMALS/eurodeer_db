-- 1 DUPLICATE SENSORS 

-- 1a List of all sensors with the same original id (in the same research group) -> potential duplicates
SELECT a.*
from
main.gps_sensors as a,
(SELECT gps_sensors_original_id, research_groups_id FROM main.gps_sensors group by gps_sensors_original_id, research_groups_id having count(*) > 1) as b
where a.gps_sensors_original_id = b.gps_sensors_original_id and a.research_groups_id = b.research_groups_id ORDER BY gps_sensors_original_id;

-- 1b Check which of those gps_sensor_ids are used in the gps_sensors_animals table 
SELECT DISTINCT gps_sensors_id from main.gps_sensors_animals where gps_sensors_id in (
SELECT gps_sensors_id 
from
main.gps_sensors as a,
(SELECT gps_sensors_original_id, research_groups_id FROM main.gps_sensors group by gps_sensors_original_id, research_groups_id having count(*) > 1) as b
where a.gps_sensors_original_id = b.gps_sensors_original_id and a.research_groups_id = b.research_groups_id) order by gps_sensors_id;

-- 1c Check which of those gps_sensor_ids are used in the gps_data_animals table 
SELECT DISTINCT gps_sensors_id from main.gps_data_animals where gps_sensors_id in (
SELECT gps_sensors_id 
from
main.gps_sensors as a,
(SELECT gps_sensors_original_id, research_groups_id FROM main.gps_sensors group by gps_sensors_original_id, research_groups_id having count(*) > 1) as b
where a.gps_sensors_original_id = b.gps_sensors_original_id and a.research_groups_id = b.research_groups_id) order by gps_sensors_id;

-- 2 DUPLICATE ANIMALS 
-- 2a List of all animals with the same original id (in the same study area) -> potential duplicates
SELECT a.* 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id
ORDER BY animals_original_id;

-- 2b Check which of those animals_ids are used in the gps_sensors_animals table 
SELECT DISTINCT animals_id from main.gps_sensors_animals where animals_id in (
SELECT a.animals_id 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id) order by animals_id;

-- 2c Check which of those animals_ids are used in the gps_sensors_animals table 
SELECT DISTINCT animals_id from main.gps_data_animals where animals_id in (
SELECT a.animals_id 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id) order by animals_id;

-- DUPLICATE ANIMALS-SENSORS 
-- 2 List of all animals-sensors with duplicate animals-sensors id (possible) -> check start and end times to confirm potential duplicates
SELECT a.*
from
main.gps_sensors_animals as a,
(SELECT animals_id, gps_sensors_id FROM main.gps_sensors_animals group by gps_sensors_id, animals_id having count(*) > 1) as b
where a.animals_id = b.animals_id and a.gps_sensors_id = b.gps_sensors_id;











