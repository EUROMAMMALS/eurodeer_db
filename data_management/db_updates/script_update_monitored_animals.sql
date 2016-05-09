-- Check if a new animal has an associated record in gps_sensors_animals. If yes, set gps_deployed to 'TRUE', otherwise to 'FALSE'

-- To re-initialize all the records, set the field gps_deployed to NULL for all the records, then run this code
-- UPDATE main.animals SET gps_deployed = NULL;
UPDATE main.animals
 SET gps_deployed='TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.gps_sensors_animals)
 and gps_deployed is NULL;

UPDATE main.animals
 SET gps_deployed='FALSE'
WHERE gps_deployed is NULL;

-- Same for GPS data
-- UPDATE main.animals SET gps_data = NULL;
UPDATE main.animals
 SET gps_data = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.gps_data_animals)
 and gps_data is NULL;

UPDATE main.animals
 SET gps_data = 'FALSE'
WHERE gps_data is NULL;

-- Activity sensors deployed
-- UPDATE main.animals SET activity_deployed = NULL;
UPDATE main.animals
 SET activity_deployed = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.activity_sensors_animals)
 and activity_deployed is NULL;

UPDATE main.animals
 SET activity_deployed = 'FALSE'
WHERE activity_deployed is NULL;

-- Activity data (from the different sub-tables)
-- UPDATE main.animals SET activity_data = NULL;
UPDATE main.animals
 SET activity_data = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.activity_data_animals_code01)
 and activity_data is NULL;
UPDATE main.animals
 SET activity_data = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.activity_data_animals_code02)
 and activity_data is NULL;
UPDATE main.animals
 SET activity_data = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.activity_data_animals_code03)
 and activity_data is NULL;
UPDATE main.animals
 SET activity_data = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.activity_data_animals_code04)
 and activity_data is NULL;  
UPDATE main.animals
 SET activity_data = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.activity_data_animals_code05)
 and activity_data is NULL;

UPDATE main.animals
 SET activity_data = 'FALSE'
WHERE activity_data is NULL;

-- VHF sensors deployed
-- UPDATE main.animals SET vhf_deployed = NULL;
UPDATE main.animals
 SET vhf_deployed = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.vhf_sensors_animals)
 and vhf_deployed is NULL;

UPDATE main.animals
 SET vhf_deployed = 'FALSE'
WHERE vhf_deployed is NULL;

-- VHF data
-- UPDATE main.animals SET vhf_data = NULL;
UPDATE main.animals
 SET vhf_data = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.vhf_data_animals)
 and vhf_data is NULL;

UPDATE main.animals
 SET vhf_data = 'FALSE'
WHERE vhf_data is NULL;

-- Check if the animal has a animals_captures record associated
-- UPDATE main.animals SET capture_data = NULL;
UPDATE main.animals
 SET capture_data = 'TRUE' 
WHERE animals_id in (SELECT DISTINCT animals_id FROM main.animals_captures)
 and capture_data is NULL;

UPDATE main.animals
 SET capture_data = 'FALSE'
WHERE capture_data is NULL;
