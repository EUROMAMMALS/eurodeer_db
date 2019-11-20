-- 1 DUPLICATE SENSORS 
-- GPS 
-- 1a List of all sensors with the same original id (in the same research group) -> potential duplicates
SELECT a.*
from
main.gps_sensors as a,
(SELECT gps_sensors_code, research_groups_id FROM main.gps_sensors group by gps_sensors_code, research_groups_id having count(*) > 1) as b
where a.gps_sensors_code = b.gps_sensors_code and a.research_groups_id = b.research_groups_id ORDER BY gps_sensors_code;

-- 1b Check which of those gps_sensor_ids are used in the gps_sensors_animals table 
SELECT DISTINCT gps_sensors_id from main.gps_sensors_animals where gps_sensors_id in (
SELECT gps_sensors_id 
from
main.gps_sensors as a,
(SELECT gps_sensors_code, research_groups_id FROM main.gps_sensors group by gps_sensors_code, research_groups_id having count(*) > 1) as b
where a.gps_sensors_code = b.gps_sensors_code and a.research_groups_id = b.research_groups_id) order by gps_sensors_id;

-- 1c Check which of those gps_sensor_ids are used in the gps_data_animals table 
SELECT DISTINCT gps_sensors_id from main.gps_data_animals where gps_sensors_id in (
SELECT gps_sensors_id 
from
main.gps_sensors as a,
(SELECT gps_sensors_code, research_groups_id FROM main.gps_sensors group by gps_sensors_code, research_groups_id having count(*) > 1) as b
where a.gps_sensors_code = b.gps_sensors_code and a.research_groups_id = b.research_groups_id) order by gps_sensors_id;


--VHF 
-- 1a List of all sensors with the same original id (in the same research group) -> potential duplicates
SELECT a.*
from
main.vhf_sensors as a,
(SELECT vhf_sensors_original_id, research_groups_id FROM main.vhf_sensors group by vhf_sensors_original_id, research_groups_id having count(*) > 1) as b
where a.vhf_sensors_original_id = b.vhf_sensors_original_id and a.research_groups_id = b.research_groups_id ORDER BY vhf_sensors_original_id;

-- 1b Check which of those vhf_sensor_ids are used in the vhf_sensors_animals table 
SELECT DISTINCT a.* from main.vhf_sensors_animals a where vhf_sensors_id in (
SELECT vhf_sensors_id 
from
main.vhf_sensors as a,
(SELECT vhf_sensors_original_id, research_groups_id FROM main.vhf_sensors group by vhf_sensors_original_id, research_groups_id having count(*) > 1) as b
where a.vhf_sensors_original_id = b.vhf_sensors_original_id and a.research_groups_id = b.research_groups_id) order by vhf_sensors_id;

-- 1c Check which of those vhf_sensor_ids are used in the vhf_data_animals table 
SELECT DISTINCT vhf_sensors_id from main.vhf_data_animals where vhf_sensors_id in (
SELECT vhf_sensors_id 
from
main.vhf_sensors as a,
(SELECT vhf_sensors_original_id, research_groups_id FROM main.vhf_sensors group by vhf_sensors_original_id, research_groups_id having count(*) > 1) as b
where a.vhf_sensors_original_id = b.vhf_sensors_original_id and a.research_groups_id = b.research_groups_id) order by vhf_sensors_id;

 
-- 2 DUPLICATE ANIMALS 
-- 2a List of all animals with the same original id (in the same study area) -> potential duplicates
SELECT a.* 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id
ORDER BY animals_original_id;

-- 2b Check which of those animals_ids are used in the gps_sensors_animals or vhf_sensors_animals table 
-- GPS
SELECT DISTINCT animals_id from main.gps_sensors_animals where animals_id in (
SELECT a.animals_id 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id) order by animals_id;
-- VHF
SELECT DISTINCT animals_id from main.vhf_sensors_animals where animals_id in (
SELECT a.animals_id 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id) order by animals_id;

-- 2c Check which of those animals_ids are used in the gps_sensors_animals or vhf_sensors_animals table 
-- GPS 
SELECT DISTINCT animals_id from main.gps_data_animals where animals_id in (
SELECT a.animals_id 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id) order by animals_id;
-- VHF
SELECT DISTINCT animals_id from main.vhf_data_animals where animals_id in (
SELECT a.animals_id 
from 
main.animals as a, 
(SELECT animals_original_id, study_areas_id FROM main.animals group by animals_original_id, study_areas_id having count(*) > 1) as b 
where a.animals_original_id = b.animals_original_id and a.study_areas_id = b.study_areas_id) order by animals_id;


-- 3 DUPLICATE ANIMALS-SENSORS 
-- 3a List of all animals-sensors with duplicate animals-sensors id (possible) -> check start and end times to confirm potential duplicates
-- GPS
SELECT a.*
from
main.gps_sensors_animals as a,
(SELECT animals_id, gps_sensors_id FROM main.gps_sensors_animals group by gps_sensors_id, animals_id having count(*) > 1) as b
where a.animals_id = b.animals_id and a.gps_sensors_id = b.gps_sensors_id;
-- VHF
SELECT a.*
from
main.vhf_sensors_animals as a,
(SELECT animals_id, vhf_sensors_id FROM main.vhf_sensors_animals group by vhf_sensors_id, animals_id having count(*) > 1) as b
where a.animals_id = b.animals_id and a.vhf_sensors_id = b.vhf_sensors_id;


-- 4 DUPLICATED CAPTURES 
-- Are there duplicate capture events? 
SELECT count(*), study_areas_id, animals_id, capture_timestamp
FROM main.animals_captures JOIN main.animals using (animals_id)
GROUP BY animals_id, capture_timestamp, study_areas_id
HAVING count(*) > 1
ORDER BY study_areas_id, animals_id;
-- Duplicated rows 
WITH x AS (
	SELECT count(*), study_areas_id, animals_id, capture_timestamp
	FROM main.animals_captures JOIN main.animals using (animals_id)
	GROUP BY animals_id, capture_timestamp, study_areas_id
	HAVING count(*) > 1
	ORDER BY study_areas_id, animals_id
	)
SELECT study_areas_id, a.*
from x join main.animals_captures a using (animals_id, capture_timestamp)
ORDER BY study_areas_id, animals_id, capture_timestamp;


-- 5 DUPLICATE CONTACTS 
-- Are there duplicate contacts? 
SELECT count(*), animals_id, contact_timestamp, study_areas_id
FROM main.animals_contacts join main.animals using (animals_id)
GROUP BY animals_id, contact_timestamp, study_areas_id
HAVING count(*) > 1;
-- Duplicated rows 
WITH x AS (
	SELECT count(*), animals_id, contact_timestamp, study_areas_id
	FROM main.animals_contacts join main.animals using (animals_id)
	GROUP BY animals_id, contact_timestamp, study_areas_id
	HAVING count(*) > 1
	)
SELECT a.* FROM x join main.animals_contacts a using (animals_id, contact_timestamp);
-- animals that died twice
SELECT count(*), study_areas_id, animals_id FROM main.animals_contacts 
JOIN main.animals using (animals_id)
GROUP BY study_areas_id,animals_id
HAVING count(*) > 1;
