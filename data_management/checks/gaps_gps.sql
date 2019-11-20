-- deployments with more than 60 days with no data and more than 100 days of monitoring interval
select study_areas.study_areas_id, study_areas.study_name, a.animals_id, gps_sensors_id, min(datex) as start, max(datex) as end, max(datex) - min(datex) days_monitored, count(datex) - 1 days_with_data, max(datex) - min(datex) - count(datex) as missing_days
from
(
SELECT distinct animals_id, gps_sensors_id, acquisition_time::date datex
  FROM main.gps_data_animals
  where gps_validity_code in (0,1) and
    (animals_id, gps_sensors_id) in
(SELECT  animals.animals_id, gps_sensors_id
  FROM main.gps_sensors_animals, main.animals where animals.animals_id = gps_sensors_animals.animals_id and end_time::date - start_time::date  > 100)
) a,
main.animals,
main.study_areas
where a.animals_id = animals.animals_id and animals.study_areas_id = study_areas.study_areas_id
group by
study_areas.study_areas_id, study_areas.study_name, a.animals_id, gps_sensors_id, reintroduction
having  (max(datex) - min(datex) - count(datex)) > 60
order by
days_monitored desc;

-- record per months for specific animals (to check missing months, see the time series)
SELECT  animals_id, gps_sensors_id, extract(year from acquisition_time), extract(month from acquisition_time), count(*) as n
  FROM main.gps_data_animals where animals_id in (2545, 865)
  and gps_validity_code in (0,1)
  group by 
   animals_id, gps_sensors_id,  extract(year from acquisition_time),extract(month from acquisition_time)
  order by  animals_id, extract(year from acquisition_time),
 extract(month from acquisition_time);