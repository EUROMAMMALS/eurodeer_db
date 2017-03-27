-- MISSING CONTACTS 
SELECT * FROM 
(SELECT study_areas_id, count(*) total FROM main.animals  
GROUP BY study_areas_id 
ORDER BY study_areas_id) c LEFT OUTER JOIN 

(SELECT study_areas_id, count(*) missing FROM main.animals WHERE animals_id not in  
(SELECT animals_id  FROM main.animals_contacts)
GROUP BY study_areas_id 
ORDER BY study_areas_id) b USING (study_areas_id) LEFT OUTER JOIN (

SELECT study_areas_id, count(*) not_missing FROM main.animals WHERE animals_id in  
(SELECT animals_id  FROM main.animals_contacts)
GROUP BY study_areas_id 
ORDER BY study_areas_id) a USING (study_areas_id)
