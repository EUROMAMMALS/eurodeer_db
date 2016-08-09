-- set of queries needed to detect inconsistencies in estimated year of birth, 
-- that in turn is needed to associate the correct age class at each capture.

-- Animals without age class at capture
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact
FROM main.animals
where age_class_code_capture is null
order by year_birth;

-- Animals without estimated year_birth
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact
FROM main.animals
where age_class_code_capture is NOT null AND year_birth is null
order by year_birth;

-- Animals without confirmation of estimated year_birth
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact
FROM main.animals
where age_class_code_capture is NOT null AND year_birth is NOT null AND year_birth_exact IS NULL
order by year_birth;

-- Animals fawns at capture but estimated birth is not consistent
-- (Question: are both 1 and 0 possible?)
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth
FROM main.animals
where 
  extract(year from first_capture_date) - year_birth not in (0,1)AND
  age_class_code_capture = 1
order by extract(year from first_capture_date) - year_birth;

-- ANSWER to Question: are both 1 and 0 possible? Shouldn't it be rather like this:
(
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth diff_capture_birth, 'type1' error_type
FROM main.animals
where extract(month from first_capture_date) < 4 AND
  extract(year from first_capture_date) - year_birth not in (1) AND
  age_class_code_capture = 1
order by extract(year from first_capture_date) - year_birth
) UNION ( 
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth diff_capture_birth, 'type2'
FROM main.animals
where extract(month from first_capture_date) >= 4 AND
  extract(year from first_capture_date) - year_birth not in (0) AND
  age_class_code_capture = 1
order by extract(year from first_capture_date) - year_birth
) order by error_type, study_areas_id


-- Animals yearling at capture but estimated birth is not consistent
-- (Question: are both 2 and 1 possible?)
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth
FROM main.animals
where 
  extract(year from first_capture_date) - year_birth not in (2,1)AND
  age_class_code_capture = 2
order by extract(year from first_capture_date) - year_birth;

-- ANSWER to Question: are both 2 and 1 possible? Shouldn't it be rather like this:
(
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth diff_capture_birth, 'type1' error_type
FROM main.animals
where extract(month from first_capture_date) < 4 AND
  extract(year from first_capture_date) - year_birth not in (2) AND
  age_class_code_capture = 2
order by extract(year from first_capture_date) - year_birth
) UNION ( 
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth diff_capture_birth, 'type2'
FROM main.animals
where extract(month from first_capture_date) >= 4 AND
  extract(year from first_capture_date) - year_birth not in (1) AND
  age_class_code_capture = 2
order by extract(year from first_capture_date) - year_birth
) order by error_type, study_areas_id

-- Animals adult at capture but estimated birth is not consistent
-- (Question: is 2 possible for year difference?)
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth
FROM main.animals
where 
  extract(year from first_capture_date) - year_birth < 2 AND
  age_class_code_capture = 3
order by extract(year from first_capture_date) - year_birth;

-- ANSWER Question: is 2 possible for year difference? Shouldn't it be like this? 
(
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth, 'type1' error_type
FROM main.animals
where extract(month from first_capture_date) < 4 AND
  extract(year from first_capture_date) - year_birth < 3 AND
  age_class_code_capture = 3
order by extract(year from first_capture_date) - year_birth
) UNION (
SELECT study_areas_id, animals_id,  first_capture_date, age_class_code_capture,  year_birth, year_birth_exact, extract(year from first_capture_date) - year_birth, 'type2' error_type
FROM main.animals
where extract(month from first_capture_date) >= 4 AND
  extract(year from first_capture_date) - year_birth < 2 AND
  age_class_code_capture = 3
order by extract(year from first_capture_date) - year_birth
) order by error_type, study_areas_id

