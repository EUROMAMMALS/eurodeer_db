## SQL code to run quality checks - examples
Short description of the functionality of each SQL code stored in this repository
Please extend the list!! Store new code for quality checking if you develop it.

* **check_animals_monitored_gps.sql**: set of queries that identifies inconsistencies in deployments and list animals with no information associated [last check 2019-11-20]
* **check_animals_monitored_gps_and_vhf.sql**: queries that compare VHF and GPS deployment info [last check 2019-11-20]
* **check_capture_data.sql**: verify consistency of the time of the capture events [last check 2019-11-20]
* **check_deployment_vs_capture_vs_gps_data.sql**: check consistency between deployment, capture and gps data [last check 2019-11-20]
* **check_duplicates.sql**: check for duplicated elements in the database (animals, sensors, depoyments, ...) [last check 2019-11-20]
* **check_geometry.sql**: verify consistency of geom attribute (GPS locations) [last check 2019-11-20]
* **check_mortality_end_deployment_codes.sql**: explore and compare info on mortality and end of deployment (the code work but to get useful results it might need some adaptation as info on death was moved to animals table) [last check 2019-11-20]
* **check_validation_codes.sql**: check that all the valid GPS locations are inside the deployment interval (and locations are excluded) [last check 2019-11-20]
* **contacts.sql**: verify informations on contacts [last check 2019-11-20]
* **death_inconsistencies.sql**: verify consistency between end of deployment and mortality [last check 2019-11-20]
* **local_time.sql**: verify consistency between end of deployment and contact [last check 2019-11-20]
* **gaps_gps.sql**: identify gaps in the deployment interval (long series of missing information) [last check 2019-11-20]