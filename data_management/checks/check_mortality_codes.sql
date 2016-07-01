-- Statistics on end of monitoring and mortality (gps deployments)
SELECT
  lu_mortality.mortality_code,
  mortality_description,
  lu_end_monitoring.end_monitoring_code,
  end_monitoring_description,
  count(*)
FROM 
  main.gps_sensors_animals 
left join 
  lu_tables.lu_mortality
on 
  lu_mortality.mortality_code = gps_sensors_animals.mortality_code
left join  
  lu_tables.lu_end_monitoring
ON 
  lu_end_monitoring.end_monitoring_code = gps_sensors_animals.end_monitoring_code
group by 
  lu_mortality.mortality_code,
  mortality_description,
  lu_end_monitoring.end_monitoring_code,
  end_monitoring_description
order by 
  end_monitoring_description,
  mortality_description;

-- Explore suspicious combinations end of monitoring/end of deployment (example gps)
SELECT *
FROM 
  main.gps_sensors_animals 
WHERE
  mortality_code = 7
AND
  end_monitoring_code = 1;

-- Statistics on end of monitoring and mortality (vhf deployments)
SELECT
  lu_mortality.mortality_code,
  mortality_description,
  lu_end_monitoring.end_monitoring_code,
  end_monitoring_description,
  count(*)
FROM 
  main.vhf_sensors_animals 
left join 
  lu_tables.lu_mortality
on 
  lu_mortality.mortality_code = vhf_sensors_animals.mortality_code
left join  
  lu_tables.lu_end_monitoring
ON 
  lu_end_monitoring.end_monitoring_code = vhf_sensors_animals.end_monitoring_code
group by 
  lu_mortality.mortality_code,
  mortality_description,
  lu_end_monitoring.end_monitoring_code,
  end_monitoring_description
order by 
  end_monitoring_description,
  mortality_description;

-- Explore suspicious combinations end of monitoring/end of deployment (example vhf)
SELECT *
FROM 
  main.vhf_sensors_animals 
WHERE
  mortality_code = 7
AND
  end_monitoring_code = 1;
