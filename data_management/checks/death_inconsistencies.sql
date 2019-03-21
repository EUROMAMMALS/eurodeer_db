-- DEATH INCONSISTENCIES 
-- animals death_date before capture_timestamp
SELECT animals_id, death_date, death_time, capture_timestamp
FROM main.animals JOIN main.animals_captures USING (animals_id) 
WHERE  capture_timestamp > (death_date || ' ' ||death_time )::timestamp with time zone;

-- GPS 
-- capture after death for animals with end of deployment reason 'death'
SELECT animals_id, start_time, end_time, capture_timestamp
FROM main.animals_captures JOIN main.gps_sensors_animals USING (animals_id) 
WHERE end_deployment_code = 4 and capture_timestamp > end_time;

-- end of deployment and death date inconsistent
SELECT animals_id, death_date, end_time FROM main.animals JOIN main.gps_sensors_animals USING (animals_id)
WHERE end_deployment_code = 4 and end_time != (death_date || ' ' || death_time)::timestamp with time zone;

-- VHF
-- capture after death for animals with end of deployment reason 'death'
SELECT study_areas_id, study_name, animals_id, start_time, end_time, capture_timestamp, end_deployment_code
FROM main.animals_captures JOIN main.vhf_sensors_animals USING (animals_id) 
join main.animals using (animals_id) join main.study_Areas using (study_areas_id)
WHERE end_deployment_code = 4 and capture_timestamp > end_time;

-- end of deployment and death date inconsistent
SELECT animals_id, death_date, end_time FROM main.animals JOIN main.vhf_sensors_animals USING (animals_id)
WHERE end_deployment_code = 4 and end_time != (death_date || ' ' || death_time)::timestamp with time zone;

-- END OF DEPLOYMENT - CONTACT INCONSISTENCIES 

-- GPS
SELECT study_areas_id, animals_original_id, animals_id, contact_timestamp, end_time, death_date 
FROM main.animals_contacts JOIN main.gps_sensors_animals using (animals_id) JOIN main.animals using (animals_id) 
WHERE end_time > contact_timestamp  

-- VHF 
SELECT study_areas_id, animals_original_id, animals_id, contact_timestamp, end_time, death_date 
FROM main.animals_contacts JOIN main.vhf_sensors_animals using (animals_id) JOIN main.animals using (animals_id) 
WHERE end_time > contact_timestamp  




-- capture after contact (captures should not be reported in the contacts table, only in the captures table)
SELECT animals_contacts_id, study_areas_id, animals_id, contact_mode_code, capture_timestamp, contact_timestamp, death_date, contact_timestamp - capture_timestamp 
FROM main.animals_captures JOIN main.animals_contacts USING (animals_id)
JOIN main.animals using (animals_id) 
WHERE capture_timestamp > contact_timestamp


