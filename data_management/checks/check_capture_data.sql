-- is capture timestamp larger than release timestamp
SELECT study_areas_id, animals_original_id, a.* FROM main.animals_captures a JOIN main.animals using (animals_id) WHERE capture_timestamp > release_timestamp 
