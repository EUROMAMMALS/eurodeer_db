-- End of deployment and contact is 1 or 2 hours different (i.e. UTC vs local time)
-- this is because the contact information has been provided in local time while end of deployment information in UTC. 
SELECT study_areas_id, animals_id, animals_original_id, end_deployment_code, max - contact_timestamp death_after_deployment, max end_time, contact_timestamp FROM
    (
    SELECT * FROM
    (select * from main.animals_contacts) a
    JOIN
    (select * FROM (select max(end_time) over (partition by animals_id), animals_id, end_deployment_code, end_time FROM main.gps_sensors_animals) xx where max = end_time) b --subset to get the last gps deployment
    USING (animals_id)
    ) yy
    JOIN main.animals using (animals_id)
   
WHERE max - contact_timestamp between '-2 hour' and '-1 hours' and max - contact_timestamp != '00:00:00'
ORDER BY study_areas_id, death_after_deployment
