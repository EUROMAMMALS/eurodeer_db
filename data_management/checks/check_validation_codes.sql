-- fixes outside deployment but not 14
select * from main.gps_data_animals where
gps_data_animals_id not in
(SELECT
gps_data_animals.gps_data_animals_id
FROM
main.gps_data_animals,
main.gps_sensors_animals
WHERE
gps_data_animals.animals_id = gps_sensors_animals.animals_id AND
gps_data_animals.gps_sensors_id = gps_sensors_animals.gps_sensors_id and
(gps_data_animals.acquisition_time between gps_sensors_animals.start_time and gps_sensors_animals.end_time)) and

gps_data_animals.gps_validity_code != 14
order by gps_validity_code;

-- fixes inside deployment but 14
select * from main.gps_data_animals where
gps_data_animals_id in
(SELECT
gps_data_animals.gps_data_animals_id
FROM
main.gps_data_animals,
main.gps_sensors_animals
WHERE
gps_data_animals.animals_id = gps_sensors_animals.animals_id AND
gps_data_animals.gps_sensors_id = gps_sensors_animals.gps_sensors_id and
(gps_data_animals.acquisition_time between gps_sensors_animals.start_time and gps_sensors_animals.end_time)) and

gps_data_animals.gps_validity_code = 14
order by gps_validity_code;

