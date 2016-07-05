-- GPS deployments not associated with captures
SELECT 
  gps_sensors_animals.animals_id, 
  gps_sensors_animals.start_time, 
  animals_captures.gps_sensors_animals_id
FROM 
  main.gps_sensors_animals
left join 
  main.animals_captures
on 
  gps_sensors_animals.gps_sensors_animals_id = animals_captures.gps_sensors_animals_id
WHERE
  animals_captures.animals_id IS NULL;

-- Animals collared with GPS with no records in capture table
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
  animals._deployed 
ORDER BY 
    study_areas_id;

-- Captures associated to multiple GPS deployments
SELECT 
  gps_sensors_animals_id, count(gps_sensors_animals_id)
FROM 
  main.animals_captures
GROUP BY 
  gps_sensors_animals_id
HAVING 
  count(gps_sensors_animals_id) > 1;

-- Time shift between GPS deployments and captures > 1 day
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
  @(start_time::date - capture_timestamp::date) > 1
order by 
    gps_sensors_animals.animals_id, 
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
