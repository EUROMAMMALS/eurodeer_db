-- is capture timestamp larger than release timestamp
SELECT study_areas_id, animals_original_id, a.* 
FROM main.animals_captures a JOIN main.animals using (animals_id) 
WHERE capture_timestamp > release_timestamp 

-- animals for which handling_start is not between capture_timestamp and release_timestamp 
SELECT study_areas_id, animals_original_id, a.* 
FROM main.animals_captures a JOIN main.animals using (animals_id) 
WHERE handling_start not between capture_timestamp and release_timestamp 

-- animals for which handling_start is not between capture_timestamp and release_timestamp 
SELECT study_areas_id, animals_original_id, a.* 
FROM main.animals_captures a JOIN main.animals using (animals_id) 
WHERE handling_end not between capture_timestamp and release_timestamp 

-- animals for which heart_rate_start_timestamp is not between capture_timestamp and release_timestamp
SELECT study_areas_id, animals_original_id, a.* 
FROM main.animals_captures a JOIN main.animals using (animals_id) 
WHERE heart_rate_start_timestamp not between capture_timestamp and release_timestamp

-- animals for which heart_rate_end_timestamp is not between capture_timestamp and release_timestamp
SELECT study_areas_id, animals_original_id, a.* 
FROM main.animals_captures a JOIN main.animals using (animals_id) 
WHERE heart_rate_end_timestamp not between capture_timestamp and release_timestamp

