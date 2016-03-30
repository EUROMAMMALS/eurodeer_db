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
