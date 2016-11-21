-- ASSESSMENT OF ANIMALS MONITORED WITH GPS

-- List of animals derived from gps_data_animals (animals with data)
SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id;
-- List of animals derived from gps_sensors_animals (animals with deployment)
SELECT DISTINCT animals_id FROM main.gps_sensors_animals;

-- animals with a GPS deployed but there is no data
SELECT DISTINCT animals_id FROM main.gps_sensors_animals WHERE animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id);

-- Complete info on all animals with no data associated (NOTE: does not account for the deployment)
SELECT start_time - end_time, * FROM main.gps_sensors_animals WHERE animals_id IN (SELECT DISTINCT animals_id FROM main.gps_sensors_animals WHERE animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id)) ORDER BY start_time - end_time;

-- Summary with number of animals with no deployment of any sensors grouped per study area
-- This makes use of the new columns used to mark monitored/deployed animals, which is updated with the info from the related tables in the db
SELECT b.study_areas_id, b.study_name, a.num 
FROM main.study_areas b,
(SELECT study_areas_id , count(*) as num FROM main.animals where gps_deployed = 'f' and activity_deployed= 'f' and vhf_deployed = 'f' group by study_areas_id) a
WHERE a.study_areas_id = b.study_areas_id
order by b.study_areas_id;

-- Check animals with no info on any collar deployed (i.e. never collared) and without any record in the table animals_capture table
SELECT a.animals_id, a.study_areas_id, a.first_capture_date, b.* 
FROM (SELECT * FROM main.animals where gps_deployed = 'f' and activity_deployed= 'f' and vhf_deployed = 'f') a
LEFT JOIN main.animals_captures b USING (animals_id)
WHERE b.animals_id IS NULL
ORDER BY death, a.study_areas_id,  a.animals_id

-- Associations animals - GPS collars with no data
SELECT study_areas_id, end_deployment_code, start_time - end_time, * 
FROM main.gps_sensors_animals, main.animals 
WHERE gps_sensors_animals.animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id)
AND animals.animals_id = gps_sensors_animals.animals_id
ORDER BY end_deployment_code, abs(extract(epoch from start_time - end_time));

-- Number of deployments with no gps data associated per research group, with number of deployments longer/shorter then 5 days
SELECT study_areas_id, end_deployment_code, count(*) total_deployments,
sum( case WHEN abs(extract(epoch from start_time - end_time)) > 60*60*24*5 THEN 1 ELSE 0 end) as long_monitor
FROM main.gps_sensors_animals, main.animals 
WHERE gps_sensors_animals.animals_id NOT IN (SELECT animals_id FROM main.gps_data_animals GROUP BY animals_id)
AND animals.animals_id = gps_sensors_animals.animals_id
group by study_areas_id, end_deployment_code
ORDER BY study_areas_id;

-- Is there an overlap in end_time and start_time of consecutive deployments to a specific animal?
-- QUERY 1 - giving each gps_sensors_animals_id in different row 
WITH y AS (
  WITH x AS (
    SELECT *, end_time - lead(start_time) OVER (PARTITION BY animals_id ORDER BY animals_id, start_time),
    end_time - lead(start_time) OVER (PARTITION BY animals_id ORDER BY animals_id, start_time) > interval '00:00:00' bool 
    FROM main.gps_sensors_animals ORDER BY bool 
  )
  SELECT a.*,a.end_time - lead(a.start_time) OVER (PARTITION BY animals_id ORDER BY animals_id, a.start_time) > interval '00:00:00' bool2
  FROM x JOIN main.gps_sensors_animals a USING (animals_id) WHERE bool = TRUE 
  ORDER BY animals_id, start_time 
)
SELECT study_areas_id, gps_sensors_animals_id, animals_id, animals_original_id, gps_sensors_original_id, start_time, end_time 
FROM y JOIN main.animals USING (animals_id) JOIN main.gps_sensors USING (gps_sensors_id) 
WHERE (bool2 is null OR bool2 = TRUE)
ORDER BY animals_id, start_time
-- QUERY 2 - giving pairs of gps_sensors_animals_ids in each row 
-- end_time 1 overlaps with start_time2
WITH x AS (
    SELECT *, end_time - lead(start_time) OVER (PARTITION BY animals_id ORDER BY animals_id, start_time) overlap,
    lead(start_time) OVER (PARTITION BY animals_id ORDER BY animals_id, start_time) start_time2, 
    lead(end_time) OVER (PARTITION BY animals_id ORDER BY animals_id, start_time) end_time2,
    lead(gps_sensors_animals_id) OVER (PARTITION BY animals_id ORDER BY animals_id, start_time) gps_sensors_animals_id2,
    end_time - lead(start_time) OVER (PARTITION BY animals_id ORDER BY animals_id, start_time) > interval '00:00:00' bool 
    FROM main.gps_sensors_animals ORDER BY bool 
  )
  SELECT study_areas_id, animals_original_id, x.animals_id,gps_sensors_id, gps_sensors_animals_id, start_time start_time1, end_time end_time1, gps_sensors_animals_id2, start_time2, end_time2, overlap FROM x join main.animals USING (animals_id) WHERE bool = TRUE 
  ORDER BY study_areas_id, animals_id, start_time 






