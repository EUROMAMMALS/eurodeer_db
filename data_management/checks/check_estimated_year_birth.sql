-- set of queries needed to detect inconsistencies in estimated year of birth, 
-- that in turn is needed to associate the correct age class at each capture.

-- Animals with inconsistent first capture date between animals & capture table 
WITH x as (
SELECT DISTINCT study_areas_id ,animals_id, animals_original_id, age_class_code_capture, first_capture_date first_capture_at, 
min(capture_timestamp::date) over (partition by animals_id ORDER BY capture_timestamp) first_capture_ct 
FROM main.animals JOIN main.animals_captures using (animals_id) ORDER BY study_areas_id, animals_id 
)
SELECT study_areas_id, animals_id, animals_original_id, age_class_code_capture, first_capture_at,
first_capture_ct, first_capture_at - first_capture_ct diff 
FROM x 
WHERE first_capture_at != first_capture_ct 
ORDER BY study_areas_id, animals_id  

-- Animals without age class at capture
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact
FROM main.animals
where age_class_code_capture is null
order by study_areas_id, year_birth;

-- Animals without estimated year_birth
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact
FROM main.animals
where age_class_code_capture is NOT null AND year_birth is null
order by study_areas_id, first_capture_date;

-- Animals without confirmation of estimated year_birth
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact
FROM main.animals
where age_class_code_capture is NOT null AND year_birth is NOT null AND year_birth_exact IS NULL
order by study_areas_id, year_birth;

-- Animals fawns at capture but estimated birth is not consistent
(
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth diff_capture_birth, 'type1' error_type
FROM main.animals
where extract(month from first_capture_date) < 4 AND
  extract(year from first_capture_date) - year_birth not in (1) AND
  age_class_code_capture = 1
order by extract(year from first_capture_date) - year_birth
) UNION ( 
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth diff_capture_birth, 'type2'
FROM main.animals
where extract(month from first_capture_date) >= 4 AND
  extract(year from first_capture_date) - year_birth not in (0) AND
  age_class_code_capture = 1
order by extract(year from first_capture_date) - year_birth
) order by error_type, study_areas_id


-- Animals yearling at capture but estimated birth is not consistent
(
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth diff_capture_birth, 'type1' error_type
FROM main.animals
where extract(month from first_capture_date) < 4 AND
  extract(year from first_capture_date) - year_birth not in (2) AND
  age_class_code_capture = 2
order by extract(year from first_capture_date) - year_birth
) UNION ( 
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth diff_capture_birth, 'type2'
FROM main.animals
where extract(month from first_capture_date) >= 4 AND
  extract(year from first_capture_date) - year_birth not in (1) AND
  age_class_code_capture = 2
order by extract(year from first_capture_date) - year_birth
) order by error_type, study_areas_id

-- Animals adult at capture but estimated birth is not consistent
(
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth, 'type1' error_type
FROM main.animals
where extract(month from first_capture_date) < 4 AND
  extract(year from first_capture_date) - year_birth < 3 AND
  age_class_code_capture = 3
order by extract(year from first_capture_date) - year_birth
) UNION (
SELECT study_areas_id, animals_id, animals_original_id, first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth, 'type2' error_type
FROM main.animals
where extract(month from first_capture_date) >= 4 AND
  extract(year from first_capture_date) - year_birth < 2 AND
  age_class_code_capture = 3
order by extract(year from first_capture_date) - year_birth
) order by error_type, study_areas_id

