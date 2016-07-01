-- Inconsistencies between capture date in capture table and first capture date in animals table
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
