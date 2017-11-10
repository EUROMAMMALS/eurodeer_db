-- animals with end time later than contact_timestamp while animals are tagged as dead at end of deployment 
SELECT study_areas_id,animals_original_id, x.* FROM
(select animals_id, animals_contacts_id,gps_sensors_animals_id,end_time, contact_timestamp, a.mortality_code mort_dep, end_deployment_code,c.mortality_code mort_cont, end_time > contact_timestamp  FROM main.animals_contacts c JOIN

(SELECT * FROM (SELECT animals_id, gps_Sensors_animals_id, end_time, end_deployment_code,mortality_code, row_number() over (partition by animals_id order by end_time desc) FROM main.gps_sensors_animals WHERE mortality_code != 0) a WHERE row_number = 1) a USING (animals_id)
 
WHERE end_time::date > contact_timestamp::date and c.mortality_code  != 0) x JOIN main.animals USING (animals_id);

-- animals with end time later than contact_timestamp while animals are tagged as dead at end of deployment 
SELECT animals_original_id, x.*, end_time - contact_timestamp FROM
(select animals_id, animals_contacts_id,vhf_sensors_animals_id,end_time, contact_timestamp, a.mortality_code mort_dep, end_deployment_code,c.mortality_code mort_cont, end_time > contact_timestamp  FROM main.animals_contacts c JOIN

(SELECT * FROM (SELECT animals_id, vhf_Sensors_animals_id, end_time, end_deployment_code,mortality_code, row_number() over (partition by animals_id order by end_time desc) FROM main.vhf_sensors_animals WHERE mortality_code != 0) a WHERE row_number = 1) a USING (animals_id)
 
WHERE end_time::date > contact_timestamp::date and c.mortality_code  != 0) x JOIN main.animals USING (animals_id);
