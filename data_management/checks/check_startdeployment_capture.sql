-- GPS deployments not associated with captures
SELECT a.study_areas_id, b.animals_id, b.start_time, c.gps_sensors_animals_id
FROM main.animals a JOIN main.gps_sensors_animals b USING (animals_id)
LEFT JOIN main.animals_captures c USING (gps_sensors_animals_id) 
WHERE c.animals_id IS NULL 
ORDER BY study_areas_id;
  
-- Animals collared with GPS with no records in capture table
SELECT study_areas_id, a.animals_id
FROM main.animals a LEFT JOIN main.animals_captures c USING (animals_id)
WHERE c.animals_id IS NULL AND a.gps_deployed 
ORDER BY study_areas_id;

-- Captures associated to multiple GPS deployments
SELECT gps_sensors_animals_id, count(gps_sensors_animals_id)
FROM main.animals_captures
GROUP BY gps_sensors_animals_id
HAVING count(gps_sensors_animals_id) > 1;

-- Time shift between GPS deployments and captures > 1 day
SELECT 
  a.animals_id, 
  a.start_time, 
  b.gps_sensors_animals_id, 
  b.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM main.gps_sensors_animals a LEFT JOIN main.animals_captures b using (gps_sensors_animals_id) 
WHERE b.animals_id IS NOT NULL AND @(start_time::date - capture_timestamp::date) > 1
ORDER BY a.animals_id, @(start_time::date - capture_timestamp::date) DESC;

-- GPS deployments before related capture
SELECT 
  gps_sensors_animals.animals_id, 
  gps_sensors_animals.start_time, 
  animals_captures.gps_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.gps_sensors_animals
left join 
  main.animals_captures
on 
  gps_sensors_animals.gps_sensors_animals_id = animals_captures.gps_sensors_animals_id
WHERE
  animals_captures.animals_id IS NOT NULL AND
  start_time::date < capture_timestamp::date
order by 
  @(start_time::date - capture_timestamp::date) DESC;

-- GPS deployments before related capture
SELECT 
  gps_sensors_animals.animals_id, 
  gps_sensors_animals.start_time, 
  animals_captures.gps_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.gps_sensors_animals
left join 
  main.animals_captures
on 
  gps_sensors_animals.gps_sensors_animals_id = animals_captures.gps_sensors_animals_id
WHERE
  animals_captures.animals_id IS NOT NULL AND
  start_time::date < capture_timestamp::date
order by 
  @(start_time::date - capture_timestamp::date) DESC;

-- GPS deployments that start much later than capture
SELECT 
  gps_sensors_animals.animals_id, 
  gps_sensors_animals.start_time, 
  animals_captures.gps_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.gps_sensors_animals
left join 
  main.animals_captures
on 
  gps_sensors_animals.gps_sensors_animals_id = animals_captures.gps_sensors_animals_id
WHERE
  animals_captures.animals_id IS NOT NULL AND
  start_time::date - capture_timestamp::date > 30
order by 
  @(start_time::date - capture_timestamp::date) DESC;

-- GPS deployments without a direct link with captures, but with capture records for that animal
SELECT 
  gps_sensors_animals.animals_id, 
  gps_sensors_animals.start_time, 
  animals_captures.gps_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.gps_sensors_animals
left join 
  main.animals_captures
on 
  gps_sensors_animals.animals_id = animals_captures.animals_id  
WHERE 
  gps_sensors_animals.gps_sensors_animals_id IN
	 (SELECT 
	  animals_captures.gps_sensors_animals_id
	FROM 
	  main.gps_sensors_animals
	left join 
	  main.animals_captures
	on 
	  gps_sensors_animals.gps_sensors_animals_id = animals_captures.gps_sensors_animals_id
	WHERE
	  animals_captures.animals_id IS NULL);

-- vhf deployments not associated with captures
SELECT 
  vhf_sensors_animals.animals_id, 
  vhf_sensors_animals.start_time, 
  animals_captures.vhf_sensors_animals_id
FROM 
  main.vhf_sensors_animals
left join 
  main.animals_captures
on 
  vhf_sensors_animals.vhf_sensors_animals_id = animals_captures.vhf_sensors_animals_id
WHERE
  animals_captures.animals_id IS NULL;

-- Animals collared with vhf with no records in capture table
SELECT 
  study_areas_id, 
  animals.animals_id
FROM 
  main.animals
LEFT JOIN
  main.animals_captures
ON 
  animals.animals_id = animals_captures.animals_id
WHERE
  animals_captures.animals_id IS NULL AND 
  animals.vhf_deployed 
ORDER BY 
    study_areas_id;

-- Time shift between vhf deployments and captures > 1 day
SELECT 
  vhf_sensors_animals.animals_id, 
  vhf_sensors_animals.start_time, 
  animals_captures.vhf_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.vhf_sensors_animals
left join 
  main.animals_captures
on 
  vhf_sensors_animals.vhf_sensors_animals_id = animals_captures.vhf_sensors_animals_id
WHERE
  animals_captures.animals_id IS NOT NULL AND
  @(start_time::date - capture_timestamp::date) > 1
order by 
   vhf_sensors_animals.animals_id, 
  @(start_time::date - capture_timestamp::date) DESC;

-- vhf deployments before related capture
SELECT 
  vhf_sensors_animals.animals_id, 
  vhf_sensors_animals.start_time, 
  animals_captures.vhf_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.vhf_sensors_animals
left join 
  main.animals_captures
on 
  vhf_sensors_animals.vhf_sensors_animals_id = animals_captures.vhf_sensors_animals_id
WHERE
  animals_captures.animals_id IS NOT NULL AND
  start_time::date < capture_timestamp::date
order by 
  @(start_time::date - capture_timestamp::date) DESC;

-- vhf deployments before related capture
SELECT 
  vhf_sensors_animals.animals_id, 
  vhf_sensors_animals.start_time, 
  animals_captures.vhf_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.vhf_sensors_animals
left join 
  main.animals_captures
on 
  vhf_sensors_animals.vhf_sensors_animals_id = animals_captures.vhf_sensors_animals_id
WHERE
  animals_captures.animals_id IS NOT NULL AND
  start_time::date < capture_timestamp::date
order by 
  @(start_time::date - capture_timestamp::date) DESC;

-- vhf deployments that start much later than capture
SELECT 
  vhf_sensors_animals.animals_id, 
  vhf_sensors_animals.start_time, 
  animals_captures.vhf_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.vhf_sensors_animals
left join 
  main.animals_captures
on 
  vhf_sensors_animals.vhf_sensors_animals_id = animals_captures.vhf_sensors_animals_id
WHERE
  animals_captures.animals_id IS NOT NULL AND
  start_time::date - capture_timestamp::date > 30
order by 
  @(start_time::date - capture_timestamp::date) DESC;


-- vhf deployments without a direct link with captures, but with capture records for that animal
SELECT 
  vhf_sensors_animals.animals_id, 
  vhf_sensors_animals.start_time, 
  animals_captures.vhf_sensors_animals_id, 
  animals_captures.capture_timestamp,
  start_time - capture_timestamp as timeshift
FROM 
  main.vhf_sensors_animals
left join 
  main.animals_captures
on 
  vhf_sensors_animals.animals_id = animals_captures.animals_id  
WHERE 
  vhf_sensors_animals.vhf_sensors_animals_id IN
	 (SELECT 
	  animals_captures.vhf_sensors_animals_id
	FROM 
	  main.vhf_sensors_animals
	left join 
	  main.animals_captures
	on 
	  vhf_sensors_animals.vhf_sensors_animals_id = animals_captures.vhf_sensors_animals_id
	WHERE
	  animals_captures.animals_id IS NULL);

-- Inconsistencies between capture date in capture table and first capture date in animals table
-- Query needed to set the correct class age for each capture
select 
  q.animals_id, 
  q.year_birth, 
  q.year_birth_exact, 
  q.age_class_code_capture, 
  q.first_capture_date capture_old, 
  a.first_captured, 
  b.collared first_collar,
  q.first_capture_date  - a.first_captured AS difference_time_capture
FROM
  main.animals AS q
LEFT JOIN
	(SELECT animals_id, min(capture_timestamp)::date AS first_captured
	  FROM  main.animals_captures
	  group by animals_id) AS a
ON 
  q.animals_id = a.animals_id	  
left join 
	(select animals_id, min(start_time)::date collared from 
			   (SELECT animals_id, start_time
			  FROM main.gps_sensors_animals
			  union
			  SELECT animals_id, start_time
			  FROM main.vhf_sensors_animals) z
	  group by animals_id) b
 on 
   q.animals_id = b.animals_id
order by 
  difference_time_capture;
  
  
-- all animals with more than 1 deployment
WITH x AS ( 
SELECT count(*), animals_id FROM main.gps_sensors_animals group by animals_id HAVING count(*) > 1 
)
SELECT capture_timestamp - start_time, animals_id, gps_sensors_id, capture_timestamp, start_time, end_time, a.gps_sensors_animals_id sensor_animals,
b.gps_sensors_animals_id capture_sensor_animal, collared 
FROM x JOIN main.animals_captures b USING (animals_id) JOIN main.gps_sensors_animals a USING (animals_id)  
WHERE capture_timestamp::date between start_time::date -interval '1 day' and end_time::date - interval '1 day'
ORDER BY animals_id, gps_sensors_id, capture_timestamp

-- animals that have no capture event with an associated gps_sensors_animals_id or vhf_sensors_animals_id
-- i.e. none of the captures for this animal is related to a deployment (meaning that the animal should not be in the db (unless capture_results_code = 3?))
WITH z AS (
	WITH y AS (
		WITH x AS (
		SELECT animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, count(*) nr
		FROM main.animals_captures GROUP bY animals_id, gps_sensors_animals_id, vhf_sensors_animals_id ORDER BY animals_id
		)
	SELECT count(*) cnt, animals_id FROM x GROUP BY animals_id 
	)
	SELECT animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, count(*) nr, cnt
	FROM main.animals_captures JOIN y using (animals_id) 
	GROUP bY animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, cnt  
	ORDER BY animals_id
)
SELECT * FROM z WHERE gps_sensors_animals_id is null and vhf_sensors_animals_id is null and nr = 1 and cnt = 1 

-- animals that have no capture event with an associated vhf_sensors_animals_id (only animals which have an vhf_sensors_animals_id will be included)
-- VHF
WITH z AS ( 
	WITH y AS ( 
		WITH x AS (
		SELECT animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, count(*) nr
		FROM main.animals_captures GROUP bY animals_id, gps_sensors_animals_id, vhf_sensors_animals_id 
		ORDER BY animals_id
		)
		SELECT count(*) cnt, animals_id FROM x GROUP BY animals_id 
	)
	SELECT animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, count(*) nr, cnt
	FROM main.animals_captures JOIN y using (animals_id) 
	GROUP bY animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, cnt  
	ORDER BY animals_id
)
SELECT study_areas_id, animals_id, a.vhf_sensors_animals_id, b.animals_captures_id 
FROM z JOIN main.animals using (animals_id) JOIN main.vhf_sensors_animals a using (animals_id) JOIN main.animals_captures b USING (animals_id)
WHERE z.gps_sensors_animals_id is null and z.vhf_sensors_animals_id is null and nr = 1 and cnt = 1 ORDER bY animals_captures_id

-- animals that have no capture event with an associated gps_sensors_animals_id (only animals which have an gps_sensors_animals_id will be included)
-- GPS
WITH z AS (
	WITH y AS (
		WITH x AS (
		SELECT animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, count(*) nr
		FROM main.animals_captures GROUP bY animals_id, gps_sensors_animals_id, vhf_sensors_animals_id ORDER BY animals_id
		)
		SELECT count(*) cnt, animals_id FROM x GROUP BY animals_id 
	)
	SELECT animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, count(*) nr, cnt
	FROM main.animals_captures JOIN y using (animals_id) 
	GROUP bY animals_id, gps_sensors_animals_id, vhf_sensors_animals_id, cnt  
	ORDER BY animals_id
)
SELECT study_areas_id, animals_id, a.gps_sensors_animals_id, b.animals_captures_id 
FROM z JOIN main.animals using (animals_id) JOIN main.gps_sensors_animals a using (animals_id) JOIN main.animals_captures b USING (animals_id)
WHERE z.gps_sensors_animals_id is null and z.vhf_sensors_animals_id is null and nr = 1 and cnt = 1 ORDER bY animals_captures_id


-- animals which should have capture_result_code 2 
-- VHF deployed and animal died due to capture BUT the deployment interval > 1 minute   
SELECT animals_id, a.animals_captures_id, a.vhf_sensors_animals_id, gps_sensors_animals_id, 
death, injury, a.notes, death_description,start_time, end_time, capture_timestamp, 
end_deployment_code, mortality_code, end_time - start_time diff
FROM main.animals_captures a join main.vhf_sensors_animals using (animals_id) 
WHERE death = true and mortality_code = 10 and end_time - start_time > '1 minute' 
-- and capture_timestamp between start_time::date and end_time 

-- animals which should have capture_result_code 2 
-- GPS deployed and animal died due to capture BUT the deployment interval > 1 minute   
SELECT animals_id, a.animals_captures_id, a.gps_sensors_animals_id, vhf_sensors_animals_id, 
death, injury, a.notes, death_description,start_time, end_time, capture_timestamp, 
end_deployment_code, mortality_code, end_time - start_time diff
FROM main.animals_captures a join main.gps_sensors_animals using (animals_id) 
WHERE death = true and mortality_code = 10  and end_time - start_time > '1 minute' 
and capture_timestamp between start_time::date and end_time 
ORDER BY diff --capture_timestamp between start_time::date and end_time and end_time - start_time = '1 minute'


-- animals which should have capture_result_code 3 or 2? 
-- VHF deployed and animal died due to capture BUT the deployment interval > 1 minute   
SELECT animals_id, a.animals_captures_id, a.vhf_sensors_animals_id, gps_sensors_animals_id, 
death, injury, a.notes, death_description,start_time, end_time, capture_timestamp, 
end_deployment_code, mortality_code, end_time - start_time diff
FROM main.animals_captures a join main.vhf_sensors_animals using (animals_id) 
WHERE death = true and mortality_code = 10 and end_time - start_time = '1 minute' 
and capture_timestamp::date between start_time::date and end_time 

-- animals which should have capture_result_code 3 or 2? 
-- GPS deployed and animal died due to capture BUT the deployment interval > 1 minute   
SELECT animals_id, a.animals_captures_id, a.gps_sensors_animals_id, vhf_sensors_animals_id, 
death, injury, a.notes, death_description,start_time, end_time, capture_timestamp, 
end_deployment_code, mortality_code, end_time - start_time diff
FROM main.animals_captures a join main.gps_sensors_animals using (animals_id) 
WHERE death = true and mortality_code = 10  and end_time - start_time = '1 minute' 
and capture_timestamp::date between start_time::date and end_time 
ORDER BY diff 





