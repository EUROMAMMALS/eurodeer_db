-- fixes outside deployment but not 14
select * from main.gps_data_animals where
gps_data_animals_id not in
(SELECT gps_data_animals_id
FROM main.gps_data_animals a JOIN main.gps_sensors_animals b USING (animals_id, gps_sensors_id)
WHERE acquisition_time between start_time and end_time) and gps_validity_code != 14
order by gps_validity_code;

-- fixes inside deployment but 14
select * from main.gps_data_animals where
gps_data_animals_id in
(SELECT gps_data_animals.gps_data_animals_id
FROM main.gps_data_animals a JOIN main.gps_sensors_animals USING (animals_id, gps_sensors_id)
WHERE acquisition_time between start_time and end_time) and gps_validity_code = 14
order by gps_validity_code;

