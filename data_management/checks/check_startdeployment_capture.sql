-- Detect potential inconsistencies between capture date in capture table and first capture date in animals table

select a.animals_id, year_birth, year_birth_exact, age_class_code_capture, first_capture, first_capture_date, first_capture - first_capture_date, collared, first_capture - collared
from
(SELECT animals_id, min(capture_timestamp)::date first_capture, min(age_class_code) code
  FROM (select * from main.animals_captures order by capture_timestamp) a
   group by animals_id 
  order by animals_id) a
left join
(SELECT animals_id, year_birth, year_birth_exact, first_capture_date, age_class_code_capture
  FROM main.animals) b
  on b.animals_id = a.animals_id
left join 
(select animals_id, min(start_time)::date collared from 
		   ( SELECT *
		  FROM main.gps_sensors_animals
		  union
		  SELECT *
		  FROM main.vhf_sensors_animals) q
  group by animals_id) c
 on a.animals_id = c.animals_id
  where  first_capture - first_capture_date > 30 or first_capture - first_capture_date  < -30
  order by first_capture - first_capture_date;
