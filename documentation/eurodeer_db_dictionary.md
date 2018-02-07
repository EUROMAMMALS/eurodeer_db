# DATABASE REPORT: eurodeer_db SCHEMAS and TABLES
## SCHEMA: main  
**The schema "main" is the place where all the core information of the main objects are stored: data from sensors (at the moment, GPS, VHF, activity), sensors, animals, studies, research groups.**  

### TABLE: main.activity\_data\_animals\_code01  
Table with activity data associated to animals with sensor mode code = 1 (see table lu\_tables.lu\_activity\_sensor\_mode). Data come from different type of sensors, thus the information must be properly precessed to be correctly analysized. There is 1 table per sensor mode code to reduce the overall size and to keep different things separated.  

#### COLUMNS 


* **activity\_data\_animals\_code01\_id** [integer]: *Eurodeer identifier for the activity record.* 
* **animals\_id** [integer]: *Eurodeer identifier for the animal.* 
* **activity\_sensors\_id** [integer]: *Eurodeer identifier for the activity sensor.* 
* **act\_1** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the X axis accellerometer.* 
* **act\_2** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the y axis accellerometer.* 
* **act\_3** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the z axis accellerometer.* 
* **acquisition\_time** [timestamp without time zone]: *Date and time of acquisition of the activity data (with time zone).* 
* **temperature\_activity** [double precision]: *Temperature measured by the sensor associated to the accelerometer.* 
* **gps\_positions\_animals\_id** [bigint]: *This filed links the activity record to the (closer in time) valid GPS position.* 
* **activity\_sensor\_mode\_code** [integer]: *This field explains the meaning of the act1,2,3. There 3  values can have a different meaning according to the sensor and in case also to the operational mode the sensor is used. See table activity\_sensor\_mode.* 
* **activity\_validity\_code** [integer]: *This field marks each record as valid or invalid for different reasons: record registered when the sensor was not deployed on the animal, record with impossible values, etc.* 
### TABLE: main.activity\_data\_animals\_code02  
Table with activity data associated to animals with sensor mode code = 2 (see table lu\_tables.lu\_activity\_sensor\_mode). Data come from different type of sensors, thus the information must be properly precessed to be correctly analysized. There is 1 table per sensor mode code to reduce the overall size and to keep different things separated.  

#### COLUMNS 


* **activity\_data\_animals\_code02\_id** [integer]: *Eurodeer identifier for the activity record.* 
* **animals\_id** [integer]: *Eurodeer identifier for the animal.* 
* **activity\_sensors\_id** [integer]: *Eurodeer identifier for the activity sensor.* 
* **act\_1** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the X axis accellerometer.* 
* **act\_2** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the y axis accellerometer.* 
* **act\_3** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the z axis accellerometer.* 
* **acquisition\_time** [timestamp without time zone]: *Date and time of acquisition of the activity data (with time zone).* 
* **temperature\_activity** [double precision]: *Temperature measured by the sensor associated to the accelerometer.* 
* **gps\_positions\_animals\_id** [bigint]: *This filed links the activity record to the (closer in time) valid GPS position.* 
* **activity\_sensor\_mode\_code** [integer]: *This field explains the meaning of the act1,2,3. There 3  values can have a different meaning according to the sensor and in case also to the operational mode the sensor is used. See table activity\_sensor\_mode.* 
* **activity\_validity\_code** [integer]: *This field marks each record as valid or invalid for different reasons: record registered when the sensor was not deployed on the animal, record with impossible values, etc.* 
### TABLE: main.activity\_data\_animals\_code03  
Table with activity data associated to animals with sensor mode code = 3 (see table lu\_tables.lu\_activity\_sensor\_mode). Data come from different type of sensors, thus the information must be properly precessed to be correctly analysized. There is 1 table per sensor mode code to reduce the overall size and to keep different things separated.  

#### COLUMNS 


* **activity\_data\_animals\_code03\_id** [integer]: *Eurodeer identifier for the activity record.* 
* **animals\_id** [integer]: *Eurodeer identifier for the animal.* 
* **activity\_sensors\_id** [integer]: *Eurodeer identifier for the activity sensor.* 
* **act\_1** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the X axis accellerometer.* 
* **act\_2** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the y axis accellerometer.* 
* **act\_3** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the z axis accellerometer.* 
* **acquisition\_time** [timestamp without time zone]: *Date and time of acquisition of the activity data (with time zone).* 
* **temperature\_activity** [double precision]: *Temperature measured by the sensor associated to the accelerometer.* 
* **gps\_positions\_animals\_id** [bigint]: *This filed links the activity record to the (closer in time) valid GPS position.* 
* **activity\_sensor\_mode\_code** [integer]: *This field explains the meaning of the act1,2,3. There 3  values can have a different meaning according to the sensor and in case also to the operational mode the sensor is used. See table activity\_sensor\_mode.* 
* **activity\_validity\_code** [integer]: *This field marks each record as valid or invalid for different reasons: record registered when the sensor was not deployed on the animal, record with impossible values, etc.* 
### TABLE: main.activity\_data\_animals\_code04  
Table with activity data associated to animals with sensor mode code = 4 (see table lu\_tables.lu\_activity\_sensor\_mode). Data come from different type of sensors, thus the information must be properly precessed to be correctly analysized. There is 1 table per sensor mode code to reduce the overall size and to keep different things separated.  

#### COLUMNS 


* **activity\_data\_animals\_code04\_id** [integer]: *Eurodeer identifier for the activity record.* 
* **animals\_id** [integer]: *Eurodeer identifier for the animal.* 
* **activity\_sensors\_id** [integer]: *Eurodeer identifier for the activity sensor.* 
* **act\_1** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the X axis accellerometer.* 
* **act\_2** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the y axis accellerometer.* 
* **act\_3** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the z axis accellerometer.* 
* **acquisition\_time** [timestamp without time zone]: *Date and time of acquisition of the activity data (with time zone).* 
* **temperature\_activity** [double precision]: *Temperature measured by the sensor associated to the accelerometer.* 
* **gps\_positions\_animals\_id** [bigint]: *This filed links the activity record to the (closer in time) valid GPS position.* 
* **activity\_sensor\_mode\_code** [integer]: *This field explains the meaning of the act1,2,3. There 3  values can have a different meaning according to the sensor and in case also to the operational mode the sensor is used. See table activity\_sensor\_mode.* 
* **activity\_validity\_code** [integer]: *This field marks each record as valid or invalid for different reasons: record registered when the sensor was not deployed on the animal, record with impossible values, etc.* 
### TABLE: main.activity\_data\_animals\_code05  
Table with activity data associated to animals with sensor mode code = 5 (see table lu\_tables.lu\_activity\_sensor\_mode). Data come from different type of sensors, thus the information must be properly precessed to be correctly analysized. There is 1 table per sensor mode code to reduce the overall size and to keep different things separated.  

#### COLUMNS 


* **activity\_data\_animals\_code05\_id** [integer]: *Eurodeer identifier for the activity record.* 
* **animals\_id** [integer]: *Eurodeer identifier for the animal.* 
* **activity\_sensors\_id** [integer]: *Eurodeer identifier for the activity sensor.* 
* **act\_1** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the X axis accellerometer.* 
* **act\_2** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the y axis accellerometer.* 
* **act\_3** [double precision]: *The meaning of this field depends on the sensor\_mode. Usually it is the z axis accellerometer.* 
* **acquisition\_time** [timestamp without time zone]: *Date and time of acquisition of the activity data (with time zone).* 
* **temperature\_activity** [double precision]: *Temperature measured by the sensor associated to the accelerometer.* 
* **gps\_positions\_animals\_id** [bigint]: *This filed links the activity record to the (closer in time) valid GPS position.* 
* **activity\_sensor\_mode\_code** [integer]: *This field explains the meaning of the act1,2,3. There 3  values can have a different meaning according to the sensor and in case also to the operational mode the sensor is used. See table activity\_sensor\_mode.* 
* **activity\_validity\_code** [integer]: *This field marks each record as valid or invalid for different reasons: record registered when the sensor was not deployed on the animal, record with impossible values, etc.* 
### TABLE: main.activity\_sensors  
Catalogue of activity sensors. Each sensor belongs to a research group. The attributes include the brand and model. The id used in the original data set is also included.  

#### COLUMNS 


* **activity\_sensors\_id** [integer]: *Eurodeer identifier for activity sensor.* 
* **research\_groups\_id** [integer]: *Id of the research group that owns the activity sensor.* 
* **vendor** [character varying]: *Company that produced the sensor.* 
* **activity\_sensors\_original\_id** [character varying]: *Identifier of the activity sensor in the original data set.* 
* **model** [character varying]: *Model of the activity sensor.* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **gps\_sensors\_id** [integer]: *In case the activity sensor is integrated with a GPS sensor, this field reports the Eurodeer code of the GPS sensor (in any case this relationship is implicitly contained in the two deployment tables.* 
### TABLE: main.activity\_sensors\_animals  
Table with the information on the deployments of activity sensors on animals (starting and ending date and time of the deployment).  

#### COLUMNS 


* **activity\_sensors\_animals\_id** [integer]: *Eurodeer identifier of the deployment.* 
* **activity\_sensors\_id** [integer]: *Eurodeer identifier of the activity sensor.* 
* **animals\_id** [integer]: *Eurodeer identifier of the animal.* 
* **start\_time** [timestamp with time zone]: *Time and date of the start of the deployment.* 
* **end\_time** [timestamp with time zone]: *Time and date of the end of the deployment.* 
* **notes** [character varying]: *Open field where general notes on the deployment can be added.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **insert\_user** [character varying]: *User who created the record.* 
* **update\_user** [character varying]: *User who modified the record (last time).* 
* **animals\_captures\_id** [integer]: *Reference to the capture when the sensor was deployed on the animal.* 
### TABLE: main.animals  
Table with the information on the animals.  

#### COLUMNS 


* **animals\_id** [integer]: *Database id of population. Each animal belongs to a population, which is part of a study area. The same study area can have multiple populations. Linked with the table main.populations.* 
* **study\_areas\_id** [integer]: *Study area where the animal is located (reference to table main.study\_area).* 
* **animals\_original\_id** [character varying]: *Identifier of the animal in the original data set.* 
* **animals\_original\_name** [character varying]: *Nome of the animal in the original data set.* 
* **sex** ["char"]: *Code for sex. It can be either "f" (female) or "m" (male). When the sex is not known, the field can be left empty.* 
* **notes** [character varying]: *Open field where general notes on the animals can be added.* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **reintroduction** [integer]: *If 1, the animal has been reintroduced, if 0, the animal is not reintroduced.* 
* **year\_birth** [integer]: *Year of birth (when known). In the year\_birth\_exact field it is described if this is the exact year of birth of just an extimation (minimum year of birth).* 
* **year\_birth\_exact** [boolean]: *Flag (yes/no) that specifies if the year of birth is exact (yes) or just an estimation (no) (e.g. when I know that the animal is at least 4 years old but I do not know the exact age.* 
* **insert\_user** [character varying]: *User who created the record.* 
* **update\_user** [character varying]: *User who modified the record (last time).* 
* **gps\_deployed** [boolean]: *If a gps sensor was deployed on an animal, which does not necessarily generated data (e.g. death at capture), then this filed is tagged as "1". If no data are associated, it is tagged with "0". This value is updated by the function tools.eurodeer\_monitored\_animals that (at the moment) is not associated by any automatic procedure, so it has to be run on users' request.* 
* **gps\_data** [boolean]: *If the animals has gps data associated, then this filed is tagged as "1". If no data are associated, it is tagged with "0". This value is updated by the function tools.eurodeer\_monitored\_animals that (at the moment) is not associated by any automatic procedure, so it has to be run on users' request.* 
* **activity\_deployed** [boolean]: *If an activity sensor was deployed on an animal, which does not necessarily generated data (e.g. death at capture), then this filed is tagged as "1". If no data are associated, it is tagged with "0". This value is updated by the function tools.eurodeer\_monitored\_animals that (at the moment) is not associated by any automatic procedure, so it has to be run on users' request.* 
* **activity\_data** [boolean]: *If the animals has activity data associated, then this filed is tagged as "1". If no data are associated, it is tagged with "0". This value is updated by the function tools.eurodeer\_monitored\_animals that (at the moment) is not associated by any automatic procedure, so it has to be run on users' request.* 
* **vhf\_deployed** [boolean]: *If a vhf sensor was deployed on an animal, which does not necessarily generated data (e.g. death at capture), then this filed is tagged as "1". If no data are associated, it is tagged with "0". This value is updated by the function tools.eurodeer\_monitored\_animals that (at the moment) is not associated by any automatic procedure, so it has to be run on users' request.* 
* **vhf\_data** [boolean]: *If the animals has vhf data associated, then this filed is tagged as "1". If no data are associated, it is tagged with "0". This value is updated by the function tools.eurodeer\_monitored\_animals that (at the moment) is not associated by any automatic procedure, so it has to be run on users' request.* 
* **capture\_data** [boolean]: *If the animals has capture data associated, then this field is tagged as "1". If no data are associated, it is tagged with "0". This value is updated by the function tools.monitored\_animals that (at the moment) is not associated by any automatic procedure, so it has to be run on users' request.* 
* **update\_relatedinfo\_timestamp** [timestamp with time zone]: *Date and time when the related info was updated last time, these includes: gps\_deployed; gps\_data; activity\_deployed; activity\_data; vhf\_deployed; vhf\_data; capture\_data;. This info is automatically updated when the function tools.monitored\_animals() is run.* 
### TABLE: main.animals\_captures  
Table with the information on captures. Every animal can be captured more than once. Only captures of animals related to monitoring are included. This includes successful collaring, but also recapture of a collared animal or failed collaring because for example the death of the animal during the capture (it is possible to have a capture event without any deployment registered). All capture events of monitored animals are recorded in this table.  

#### COLUMNS 


* **animals\_captures\_id** [integer]: *Database ID of the capture of an animal. Each animal can have multiple captures.* 
* **animals\_id** [integer]: *Database ID of the animal (external key to the table main.animals).* 
* **capture\_timestamp** [timestamp with time zone]: *Time and date (with time zone) when the animal was captured (animal fall in the trap, box, net, etc.).* 
* **release\_timestamp** [timestamp with time zone]: *Time and date (with time zone) when the animal was released (animal taken out from the box, trap, net etc. or put back into a transportation box).* 
* **handling\_start** [timestamp with time zone]: *Time and date (with time zone) when the animal handling started (taken out from the box, trap, net etc. and is in direct contact with people).* 
* **handling\_end** [timestamp with time zone]: *Time and date (with time zone) when the animal handling ended (animals is no more in direct contact with people for marking and measurements or it is released or put back in to a transportation box).* 
* **longitude\_captures** [double precision]: *Coordinate of the capture (can be an approximation).* 
* **latitude\_captures** [double precision]: *Coordinate of the capture (can be an approximation).* 
* **geom\_capture** [USER-DEFINED]: *Location (point) of the capture (can be an approximation).* 
* **first\_capture** [boolean]: *Specify if this is the first capture of the animal (yes/no).* 
* **gps\_sensors\_animals\_id** [integer]: *In case the animal has been collared with GPS, this is the id of the related deployment.* 
* **sedation** [boolean]: *Specify if the animal was sedated (yes/no).* 
* **sampling\_faeces** [boolean]: *Specify a sample was taken for faeces.* 
* **sampling\_biopsy** [boolean]: *Specify a sample was taken for biopsy (tissue).* 
* **sampling\_blood** [boolean]: *Specify a sample was taken for blood.* 
* **sampling\_hair** [boolean]: *Specify a sample was taken for hair.* 
* **sampling\_notes** [character varying]: *Description of the samples taken.* 
* **injury** [boolean]: *Specify if the animal was injured during the capture.* 
* **injury\_description** [character varying]: *Description of the injury (in any).* 
* **death** [boolean]: *Specify if the animal died during the capture.* 
* **death\_description** [character varying]: *Description of the death (if this occurred).* 
* **behavior\_handling\_code** [integer]: *Code of he behavior during handling (linked to a look up table).* 
* **behavior\_release\_code** [integer]: *Code of he behavior during the release (linked to a look up table).* 
* **heart\_rate\_start** [double precision]: *First measure of the heart rate (beats/min).* 
* **heart\_rate\_start\_timestamp** [timestamp with time zone]: *Timestamp when the first heart rate was measured.* 
* **heart\_rate\_end** [double precision]: *Last measure of the heart rate (beats/min).* 
* **heart\_rate\_end\_timestamp** [timestamp with time zone]: *Timestamp when the last heart rate was measured.* 
* **hindfoot\_length\_cm** [double precision]: *Measure of the hind foot (cm).* 
* **body\_mass\_kg** [double precision]: *Measure of the body mass (Kg).* 
* **rectal\_temperature\_c** [double precision]: *Measure of the rectal temperature (°C).* 
* **notes** [character varying]: *General notes on the capture.* 
* **capture\_methods\_code** [integer]: *Method used for the capture (linked to a look up table).* 
* **vhf\_sensors\_animals\_id** [integer]: *In case the animal has been collared with VHF, this is the id of the related deployment.* 
* **capture\_result\_code** [integer]: *Code of the result of the capture. Only animals that are monitored or that were captured to be monitored are included in the data base. This field specifies what happened (animal collared, animal death, etc).* 
* **longitude\_release** [double precision]: *Coordinate of the release after capture (can be an approximation). In case of relocation this will be different from the coordinates of actual capture.* 
* **latitude\_release** [double precision]: *Coordinate of the release after capture (can be an approximation). In case of relocation this will be different from the coordinates of actual capture.* 
* **relocated** [boolean]: *If the animal has been relocated after capture (e.g. for reintroduction).* 
* **release\_type\_code** [integer]: *How the animal has been released (e.g. soft release/hard release). Coded in a look up table.* 
* **age\_class\_code** [integer]: *Code of the age class (reference to table lu\_tables.lu\_age\_class) at the time of the capture. This information must be consistent at the different captures of the same animal and with the year\_birth defined in the main.animals table. In a way, this info is partially redundant  (year\_birth and year\_birth\_exact are sufficient to define the age) but is kept to be sure that this important info is correct.* 
* **derived\_from\_deployment** [boolean]: *In case we have no direct information on the capture but we have a deployment, we create a capture to match the deployment event (and register this in this field with TRUE).* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **activity\_sensors\_animals\_id** [integer]: *In case the animal has been collared with activity, this is the id of the related deployment.* 
### TABLE: main.animals\_captures\_sedation  
Table with the information on sedations during captures.  

#### COLUMNS 


* **animals\_captures\_sedation\_id** [integer]: *Database ID of the sedation of an animal during the capture.* 
* **animals\_captures\_id** [integer]: *Database ID of the capture of an animal (external key to the table main.animals\_captures).* 
* **sedation\_drug** [boolean]: *Specify if the animal was sedated (yes/no).* 
* **sedation\_drug\_used** [character varying]: *Specify what drug was used.* 
* **sedation\_drug\_quantity** [double precision]: *Specify the amount of drug used (ml).* 
* **sedation\_drug\_timestamp** [timestamp with time zone]: *Time and date (with time zone) when the animal was sedated.* 
* **antidote\_drug** [boolean]: *Specify if an antidote was given to the animal (yes/no).* 
* **antidote\_drug\_used** [character varying]: *Specify what drug was used as antidote.* 
* **antidote\_drug\_quantity** [double precision]: *Specify the amount of antidote drug used (ml).* 
* **antidote\_drug\_timestamp** [timestamp with time zone]: *Time and date (with time zone) when the animal was given the antidote.* 
* **notes** [character varying]: *General notes on th sedation.* 
### TABLE: main.animals\_contacts  
Table with the information on contacts with animals. These can be both sightings of the animal – dead or alive – or the finding of the sensor, or others. This information is specially useful for survival analysis. All contacts with the animal are reported here with the exception of the contacts when the animal is captured. the view main.view\_survival join the information in animals\_contacts and animals\_captures for a complete history of the contacts with the animal. If a deployment ends because of the death of an animal, while this is marked in the end\_deployment\_code in the deployment table, the information on the death (i.e. the reason) is recorded in this table.  

#### COLUMNS 


* **animals\_contacts\_id** [integer]: *Database ID of the contact with the animal. Each animal can have multiple contacts.* 
* **animals\_id** [integer]: *Database ID of the animal (external key to the table main.animals).* 
* **mortality\_code** [integer]: *If the contact is with a dead animal (death = TRUE), this field specifies the reason of the death (code described in the look up table lu\_tables.lu\_mortality).* 
* **contact\_timestamp** [timestamp with time zone]: *Time and date of the contact.* 
* **notes** [character varying]: *Open field where general notes on the contact can be added.* 
* **geom** [USER-DEFINED]: *Location (point) of the contactif available (can be an approximation).* 
* **death** [boolean]: *Status of the animal recorder at contact (true = dead, false = alive).* 
* **contact\_mode\_code** [integer]: *This field specifies the type of contact with the animals. It is a code described in the lu table lu\_table.lu\_contact\_mode.* 
* **latitude** [double precision]: *Latitude of the point of contact (redundant as it is already in the field geom).* 
* **longitude** [double precision]: *Longitude of the point of contact (redundant as it is already in the field geom).* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
### TABLE: main.feeding\_sites  
This is the table containing all the information on the management of the feeding sites, where these are used (i.e ten study areas).  

#### COLUMNS 


* **feeding\_site\_id** [integer]: *Primary key of the table.* 
* **research\_groups\_id** [integer]: *The id of the research group from which the information of the feeding site comes. The id is the same used in the table main.research\_groups.* 
* **study\_areas\_id** [integer]: *It is the same code used in the table main.study\_areas to identify the study areas.* 
* **study\_name** [character varying]: * name of the study area, as indicated in the table main.study\_areas.* 
* **project** [character varying]: *Name of the specific project within the study area.* 
* **feeding\_site\_original\_id** [character varying]: *Name of the feeding site as it was provided by data owners.* 
* **fs\_id** [character varying]: *New created id for each feeding site, for simplicity in analysis and database management. It is the primary key of the table.* 
* **year\_start** [integer]: *First year of management.* 
* **year\_end** [integer]: * last year of management.* 
* **feeding\_site\_code** [integer]: *It indicates if the site is a proper feeding station (1) or a box trap (2). See look up table feeding\_site\_type for details.* 
* **moving\_site** [boolean]: *It indicates if the feeding site is moved (1) or not (0) during the management period.* 
* **feeding\_management** [integer]: *It indicates if the feeding site is foraged ad libitum (1) or on an  occasional basis (2).* 
* **feeding\_frequency\_code** [integer]: *It indicates the code of frequency with whom the feeding site is provided with food. See look up table feeding\_ frequency\_categorized for details.* 
* **food\_items** [character varying]: *It indicates the food items with whom the feeding sites are filled, as provided by data owners.* 
* **food\_energy\_code** [character varying]: *Classification of food quality according to energetic values of the items provided. See look up table feeding\_site\_feeding quality for details.* 
* **day\_start\_feeding** [integer]: *Activation day of management, does not change from year to year in case of multiple years of management.* 
* **month\_start\_feeding** [integer]: *Activation month of management, does not change from year to year in case of multiple years of management.* 
* **day\_end\_feeding** [integer]: *Deactivation day of management, does not change from year to year in case of multiple years of management.* 
* **month\_end\_feeding** [integer]: *Deactivation month of management, does not change from year to year in case of multiple years of management.* 
* **species\_excluded** [character varying]: *It indicates if and what species are excluded from access to the feding site.* 
* **other\_feeders** [character varying]: *It indicates if and what other species feed on the feeding site.* 
* **potential\_competition** [boolean]: *If there are other ungulates (red deer, muflon, wild boar, bisons) feeding on the station AND they are not prevented from access to food, then 1, otherwise 0.* 
* **predator\_species** [character varying]: *It indicates if and what predators live in the proximity of feeding sites.* 
* **potential\_predation** [boolean]: * if among the predators there are any which is of relevance for roe deer, then 1, otherwise 0.* 
* **managed\_by** [character varying]: *Managers of the feeding sites.* 
* **latitude** [double precision]: *Latitude of the feeding site.* 
* **longitude** [double precision]: *Longitude of the feeding site.* 
* **utm\_y** [integer]: *Coordinate of the feeding site in utm.* 
* **utm\_x** [integer]: *Coordinate of the feeding site in utm.* 
* **srid\_code** [integer]: *Epsg code on the utm zone of the fs.* 
* **notes** [character varying]: 
* **geom** [USER-DEFINED]: *Geometry of the location (point).* 
* **corine\_land\_cover\_2006\_code** [integer]: *Code of the Corine lad cover class produced in 2006 (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **altitude\_srtm** [integer]: *Meters above sea level (from SRTM project).* 
* **altitude\_aster** [integer]: *Meters above sea level (from ASTER project).* 
* **slope\_srtm** [double precision]: *Degrees (from SRTM project).* 
* **aspect\_srtm** [integer]: *Degrees calculated counterclockwise from east (source: SRTM project).* 
* **slope\_aster** [double precision]: *Degrees (from ASTER project).* 
* **aspect\_aster** [integer]: *Degrees calculated counterclockwise from east (source: ASTER project).* 
* **corine\_land\_cover\_2000\_code** [integer]: *Code of the Corine lad cover class produced in 2000 (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **corine\_land\_cover\_1990\_code** [integer]: *Code of the Corine lad cover class produced in 1990 (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
### TABLE: main.gps\_data\_animals  
Table with GPS locations data associated to animals and with a list of derived ancillary information calculated using the information on coordinates and acquisition time, and intersecting with environmental layers.  

#### COLUMNS 


* **gps\_data\_animals\_id** [integer]: *Eurodeer identifier for the location.* 
* **animals\_id** [integer]: *Eurodeer identifier for the animal.* 
* **gps\_sensors\_id** [integer]: *Eurodeer identifier for the GPS sensor.* 
* **acquisition\_time** [timestamp with time zone]: *Date and time of acquisition of the GPS coordinates (with time zone).* 
* **x\_original\_reference** [double precision]: *Coordinate X as computed by the software connected to the GPS sensor (in the srid\_original\_reference).* 
* **y\_original\_reference** [double precision]: *Coordinate Y as computed by the software connected to the GPS sensor (in the srid\_original\_reference).* 
* **srid\_original\_reference** [integer]: *Reference system of the projected coordinates provided by the software connected to the GPS sensor.* 
* **latitude** [double precision]: *Latitude recorded by the GPS sensor.* 
* **longitude** [double precision]: *Longitude recorded by the GPS sensor.* 
* **altitude\_gps** [integer]: *Altitude recorded by the GPS sensor (related to the centre of the earth).* 
* **dop** [double precision]: *Dilution Of Precision.* 
* **sats** [integer]: *Number of satellites used by the GPS sensor to calculate the coordinates.* 
* **temperature\_sensor** [double precision]: *Temperature as measured by the sensor associated to the GPS.* 
* **geom** [USER-DEFINED]: *Geometry of the location (point).* 
* **gps\_validity\_code** [smallint]: *This field tags the record according to its "validity" or degree of reliability (explanation of codes in lu\_tables.lu\_gps\_validity).* 
* **corine\_land\_cover\_2006\_code** [integer]: *Code of the Corine lad cover class produced in 2006 (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **ndvi\_modis** [real]: *NDVI derived from MODIS (16-daily, non smoothed, assciated to the closest [in time] image). For analysis, it is recommended to use smoothed data (smoothed or boku).* 
* **ndvi\_vegetation** [real]: *NDVI derived from SPOT VEGETATION. SPOT Vegetation sensor does not record any information sine end of 2014.* 
* **snow\_modis** [integer]: *Snow coverage (25:land; 50:cloud; 200:snow).* 
* **sun\_angle** [double precision]: *Sun angle above (or below) the horizon (in degrees) as computed by the function tools.sun\_elevation\_angle\_function.* 
* **utm\_srid** [integer]: *SRID code of the UTM zone of the centroid of the locations for the animal.* 
* **utm\_x** [integer]: *X coordinate projected in the utm\_srid UTM zone.* 
* **utm\_y** [integer]: *Y coordinate projected in the utm\_srid UTM zone.* 
* **altitude\_srtm** [integer]: *Meters above sea level (from SRTM project).* 
* **slope\_srtm** [double precision]: *Degrees (from SRTM project).* 
* **aspect\_srtm\_east\_ccw** [integer]: *Degrees calculated counterclockwise from east, -1 means no aspect (flat) (source: SRTM project).* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **altitude\_aster** [integer]: *Meters above sea level (from ASTER project).* 
* **slope\_aster** [double precision]: *Degrees (from ASTER project).* 
* **aspect\_aster\_east\_ccw** [integer]: *Degrees calculated counterclockwise from east, -1 means no aspect (flat)(source: ASTER project).* 
* **corine\_land\_cover\_2000\_code** [integer]: *Code of the Corine lad cover class produced in 2000 (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **corine\_land\_cover\_1990\_code** [integer]: *Code of the Corine lad cover class produced in 1990 (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **fapar\_vegetation** [real]: *FAPAR derived from SPOT VEGETATION.SPOT Vegetation sensor does not record any information sine end of 2014.* 
* **ndvi\_modis\_boku** [double precision]: *NDVI derived from MODIS as processed by Boku (smoothed weekly images). NDVI is interpolated between the two closest images.* 
* **ndvi\_modis\_smoothed** [double precision]: *Values are taken from the table env\_data\_ts.ndvi\_modis\_smoothed. They come from the 16daily modis ndvi from nasa, then a smoothing (swets) is applied using SPIRITS software that also convert 16 daily to 10daily.* 
* **update\_core\_user** [character varying]: *User who modified the core elements of record (last time): animals\_id, geometry, latitude, longitude, timestamp, validity code.* 
* **update\_user** [character varying]: *User who modified the record (last time).* 
* **insert\_user** [character varying]: *User who created the record.* 
* **update\_core\_timestamp** [timestamp with time zone]: *Date and time when the core elements of record was updated (last time): animals\_id, geometry, latitude, longitude, timestamp, validity code.* 
* **aspect\_srtm\_north\_cw** [integer]: *Degrees calculated clockwise from north, -1 means no aspect (flat) (source: SRTM project).* 
* **aspect\_aster\_north\_cw** [integer]: *Degrees calculated clockwise from north, -1 means no aspect (flat)(source: ASTER project).* 
* **altitude\_copernicus** [integer]: *Forest cover(from copernicus project, 0: all non-tree areas1-100: tree cover density; 254: unclassifiable (no satellite image available, clouds, shadows or snow); 255: outside area).* 
* **slope\_copernicus** [double precision]: *Degrees, -9999 (NULL), (from copernicus project, v1.0), generated with gdaldem.* 
* **aspect\_copernicus** [integer]: *Degrees calculated clockwise from north, -9999 (NULL) means no aspect (flat) (source: copernicus project, v1.0), generated with gdaldem.* 
* **corine\_land\_cover\_2012\_code** [integer]: *Code of the Corine lad cover class produced in 2000, from raster version resolution 100 meters (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **corine\_land\_cover\_2012\_vector\_code** [integer]: *Code of the Corine lad cover class produced in 2000, from original vector layer (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **forest\_density** [integer]: 
### TABLE: main.gps\_sensors  
Catalogue of GPS sensors. Each sensor belongs to a research group. The attributes include the brand and the model. The id used in the original data set is also included.  

#### COLUMNS 


* **gps\_sensors\_id** [integer]: *Eurodeer identifier for GPS sensors.* 
* **research\_groups\_id** [integer]: *Id of the research group that owns the GPS sensor.* 
* **gps\_sensors\_original\_id** [character varying]: *Identifier of the GPS sensor in the original data set.* 
* **vendor** [character varying]: *Company that produced the sensor.* 
* **model** [character varying]: *Model of the GPS sensor.* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
### TABLE: main.gps\_sensors\_animals  
Table with the information on the deployments of GPS sensors on animals (starting and ending date and time of the deployment), reason of the end of deployment, reference capture. In case of mortality, the event will be reported in the table main.animals\_contacts.  

#### COLUMNS 


* **gps\_sensors\_animals\_id** [integer]: *Eurodeer identifier of the deployment.* 
* **gps\_sensors\_id** [integer]: *Eurodeer identifier of the GPS sensor.* 
* **animals\_id** [integer]: *Eurodeer identifier of the animal.* 
* **start\_time** [timestamp with time zone]: *Time and date of the start of the deployment.* 
* **end\_time** [timestamp with time zone]: *Time and date of the end of the deployment.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **notes** [character varying]: *Open field where general notes on the deployment can be added.* 
* **mortality\_code** [integer]: *If the reason of the end of deployment is dead, this field specifies the reason of the death (code described in the look up table lu\_tables.lu\_mortality.* 
* **end\_deployment\_code** [integer]: *Code for the reason of the end of deployment (reference to the look up table lu\_tables.lu\_end\_deployment).* 
* **insert\_user** [character varying]: *User who created the record.* 
* **update\_user** [character varying]: *User who modified the record (last time).* 
* **animals\_captures\_id** [integer]: *Reference to the capture when the sensor was deployed on the animal.* 
### TABLE: main.research\_groups  
Research groups are the highest level in the hierarchy of the database. Each research group can have many study areas and can own many collars.  

#### COLUMNS 


* **research\_groups\_id** [integer]: *Eurodeer identifier for research groups.* 
* **research\_group\_name** [character varying]: *Name of the research group.* 
* **contact** [character varying]: *Contact person of the research group for the Eurodeer project.* 
* **institution** [character varying]: *Institute of the research group.* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **short\_name** [character varying]: *Short name of the research group.* 
* **country** [character varying]: *Country of the research group.* 
* **geom** [USER-DEFINED]: *Approximate location of the research group.* 
* **year\_joined** [integer]: *Year when the group joined the Eurodeer project.* 
* **data\_roedeer** [boolean]: *Red deer data in the database.* 
* **data\_reddeer** [boolean]: 
### TABLE: main.species  
List of species with common name, scientific name, genus, family, order, class. This informmation is used by different tables in the database to reference species with a database id.  

#### COLUMNS 


* **species\_id** [integer]: *Database id that uniquely identifies each species.* 
* **common\_name** [character varying]: *The column shows the species common name in English.* 
* **species\_scientific\_name** [character varying]: *The column shows the scientific name of the species.* 
* **species\_genus** [character varying]: *The column shows the genus of the species.* 
* **species\_family** [character varying]: *This column shows the family of the species.* 
* **species\_order** [character varying]: *This column shows the order name of the species.* 
* **species\_class** [character varying]: *This column shows the class of the species.* 
* **note** [character varying]: *Notes related to the species.* 
### TABLE: main.study\_areas  
Study areas are the areas monitored by research groups. Each study area can have many animals. Study areas can have defined, approximated, or no specific spatial boundaries.  

#### COLUMNS 


* **study\_areas\_id** [integer]: *Eurodeer identifier for study areas.* 
* **study\_name** [character varying]: *Name of the study area.* 
* **geom** [USER-DEFINED]: *Multi polygons layer of study areas. This spatial layer can be used as a reference to locate the study areas. Study areas can have defined boundaries (e.g. fenced). In this case, the field "defined\_bundaries" is set to 1. Otherwise a reference boundary is created as the convex hull polygon (plus a buffer of 1 km) of the existing locations. These boundaries should be updated whenever a new set of locations is uploaded in the database.* 
* **research\_groups\_id** [integer]: *Indentifier of the research group that is monitoring animals in this study area.* 
* **defined\_boundaries** [integer]: *If the study area boundaries are defined by research groups (e.g. areas fenced, or know area of animals' movement), this filed is set to 1. There polygons are not modified if new locations are uploaded. For areas with non defined boundaries (tag = 0), the boundaries are calculated on the convex hull polygon of the existing locations, and thus are updated whenever new locations are uploaded.* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **short\_name** [character varying]: *Short version of the study area name for maps and short reports.* 
* **geom\_mcp\_individuals** [USER-DEFINED]: *Multi polygons layer with an alternative representation of study areas. In this case, the MCP of each individual is calulated, then al mcp are merged and 500 meters buffer is added. These boundaries should be updated whenever a new set of locations is uploaded in the database. the code to update: update main.study\_areas set geom\_mcp\_individuals = st\_multi(foo.qq) from (select studies\_id as ww,st\_buffer(((st\_multi(st\_union(geom))))::geometry(multipolygon, 4326)::geography, 500)::geometry qq from analysis.view\_convexhull group by studies\_id) as foo where defined\_boundaries = 0 and study\_areas.study\_areas\_id = foo.ww;* 
* **geom\_traj\_buffer** [USER-DEFINED]: *Multi polygons layer with an alternative representation of study areas. In this case, the buffer of 1 km (on both sides) is calculated from the trajectories of all the animals (1 location every 24 hours is considered). Th polygons of the same study area are then merged to generate a multipolygon for each study area). These boundaries should be updated whenever a new set of locations is uploaded in the database.
DROP TABLE IF EXISTS temp.locations\_12h\_traj;
CREATE TABLE temp.locations\_24h\_traj AS
SELECT animals\_id,
    study\_areas\_id ,
    foo2.geom::geometry(LineString,4326) AS geom
   FROM ( SELECT foo.animals\_id,study\_areas\_id,
            st\_makeline(foo.geom) AS geom
           FROM ( SELECT study\_areas\_id, geom,
                    animals\_id,
                    acquisition\_time
                   FROM temp.locations\_24h
                  ORDER BY study\_areas\_id, animals\_id, acquisition\_time) foo
          GROUP BY foo.animals\_id, study\_areas\_id) foo2
  WHERE st\_geometrytype(foo2.geom) = 'ST\_LineString'::text;
  
ALTER TABLE temp.locations\_24h\_traj ADD COLUMN geom\_buffer geometry(polygon,4326);
UPDATE temp.locations\_24h\_traj set geom\_buffer = (st\_buffer(st\_simplify(geom, 0.001)::geography, 1000))::geometry

DROP TABLE IF EXISTS  temp.locations\_24h\_studyareas;
CREATE TABLE temp.locations\_24h\_studyareas AS
SELECT study\_areas\_id, 
st\_multi(st\_union(geom\_buffer))::geometry(multipolygon, 4326) geom from
temp.locations\_24h\_traj
group by study\_areas\_id;

update main.study\_areas set geom\_traj\_buffer = locations\_24h\_studyareas.geom
from temp.locations\_24h\_studyareas
where defined\_boundaries = 0 and study\_areas.study\_areas\_id = locations\_24h\_studyareas.study\_areas\_id;* 
* **geom\_grid300** [USER-DEFINED]: *Multi polygons layer with an alternative representation of study areas. In this case, trajectories (1 location every 12 hours) are intersected with a grid of 250 meters (modis grid). Only cells with a minimum of time spent on it are kept. A final buffer of 1 km is added. These boundaries should be updated whenever a new set of locations is uploaded in the database.* 
* **geom\_kernel95\_5km\_buffer** [USER-DEFINED]: *Multi polygons layer with an alternative representation of study areas. In this case, the kernel home range is calculated using all the data of a study area (1 location every 12 hours) + a buffer of 5 km. These boundaries should be updated whenever a new set of locations is uploaded in the database.* 
* **geom\_vhf** [USER-DEFINED]: *Multi polygons layer of study areas for vhf locations. This spatial layer can be used as a reference to locate the study areas. Study areas can have defined boundaries (e.g. fenced). In this case, the field "defined\_bundaries" is set to 1. Otherwise a reference boundary is created as the convex hull polygon (plus a buffer of 1 km) of the existing locations. These boundaries should be updated whenever a new set of locations is uploaded in the database.* 
### TABLE: main.subareas  
Table with the list of subareas. Each study area can have multiple subareas. Each subarea is characterized by a set of information (human disturbance, performance, predators, interspecific competition, hunting pressure, rad density, which are collected every one or more years.  

#### COLUMNS 


* **subareas\_id** [integer]: *Database id that uniquely identifies each subarea.* 
* **study\_areas\_id** [integer]: *Database id that uniquely identifies each subarea. Linked with the table main.study\_areas.* 
* **geom** [USER-DEFINED]: *Area of the subarea, defined as the union of the MCP of all the animals belonging to the subarea, plus a buffer of 200 meters.* 
* **subarea\_name** [character varying]: *Extended name of the subarea (if any).* 
* **note** [character varying]: *Note related to the subarea.* 
* **hunting** [boolean]: *Presence (yes/no) of roe deer hunting. More information should then be provided in the tables subareas.hunting\_pressure and subareas.hunting\_stats.* 
* **hunting\_others** [boolean]: *Presence (yes/no) of hunting of species differet from roe deer. More information should then be provided in the table subareas.hunting\_pressure\_others.* 
### TABLE: main.subareas\_density  
Table with estimation of roe deer density. The information is linked to the method of estimation, and can have an estimation per year per methodof estimation. If know, also the start and end date of the sampling is reported, otherwise only the year and optionally the season.  

#### COLUMNS 


* **subareas\_density\_id** [integer]: *Database id of each record of the subarea density table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
* **reference\_year** [integer]: *Reference year when data were collected/estimated.* 
* **seasons\_code** [integer]: *Season when the sampling was done (linked to a look up table).* 
* **start\_date** [date]: *Start date of the sampling (if known).* 
* **end\_date** [date]: *End date of the sampling (if known).* 
* **density** [double precision]: *Roe deer densinty (individuals per squared kilometre).* 
* **density\_se** [double precision]: *Standard error of roe deer density.* 
* **sampling\_methods\_code** [integer]: *Sampling method used for the estimation (linked to a look up table).* 
* **note** [character varying]: *Notes related to the subarea density for a defined year.* 
### TABLE: main.subareas\_environment  
Table with the description of the environment of each subarea based on the intersection between the boundaries of the subarea's area and the environmental layers stored in the urodeer database. The table stil has to be developed.  

#### COLUMNS 


* **subareas\_environment\_id** [integer]: *Database id of each record of the environmental characterization table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
### TABLE: main.subareas\_human\_disturbance  
Table with data related to human disturbance (tourism agriculture, forestry works). This is connected to each subarea (you can have multiple subarea in the same study area). This information is expected to change very slowly, but a reference year is given in case a long term monitoring is possible.  

#### COLUMNS 


* **subareas\_human\_disturbance\_id** [integer]: *Database id of each record of the human disturcance table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
* **tourism\_summer** [boolean]: *Presence of tourists during summer (yes/no).* 
* **tourism\_summer\_pressure** [integer]: *Estimation of the number of tourists during summer.* 
* **tourism\_winter** [boolean]: *Presence of tourists during winter (yes/no).* 
* **tourism\_winter\_pressure** [integer]: *Estimation of the number of tourists during winter.* 
* **farming\_code** [integer]: *Type of farming, related to a look up table.* 
* **forestry\_work\_code** [integer]: *Type of forestry work, related to a look up table.* 
* **note** [character varying]: *Notes related to human disturbance.* 
* **farming** [boolean]: 
* **forestry\_work** [boolean]: 
* **reference\_year\_start** [integer]: *Reference start year when data were collected/estimated and are considered valid.* 
* **reference\_year\_end** [integer]: *Reference end year when data were collected/estimated and are considered valid.* 
### TABLE: main.subareas\_hunting\_pressure  
Table with the description of the hunting periods per sex (male and female) per subarea. The periods have a start (and end) month and day. More than a period per year is possible. If the period is across years, it should be devided in two sub periods (until 31 december and from 1st of january) As this information can change (e.g. modification to the hunting regulation) the time interval of validity can also be specified.  

#### COLUMNS 


* **subareas\_hunting\_pressure\_id** [integer]: *Database id of each record of the subarea hunting pressure table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
* **validity\_start\_date** [date]: *Start date of the validity of the hunting intervals (i.e. start of validity of the regulation).* 
* **validity\_end\_date** [date]: *End date of the validity of the hunting intervals (i.e. end of validity of the regulation). This is null if the regulation is still valid.* 
* **hunting\_start\_month** [integer]: *Start month of the hunting period.* 
* **hunting\_start\_day** [integer]: *Start day of the hunting period.* 
* **hunting\_end\_month** [integer]: *End date of the hunting period.* 
* **hunting\_end\_day** [integer]: *End date of the hunting period.* 
* **dogs** [boolean]: *Presence (yes/no) of dogs.* 
* **sex** [character varying]: *Code for sex. It can be either "f" (female) or "m" (male). When the sex is not known, the field can be left empty.* 
* **note** [character varying]: *Notes related to the subarea hunting pressure.* 
* **hunting\_presence** [boolean]: 
* **hunting\_marked\_animals** [boolean]: 
* **hunting\_method\_code** [integer]: 
### TABLE: main.subareas\_hunting\_pressure\_method  
Table with the list of hunting methods used in a hunting period (table main.subarea\_hunting\_pressure). Each hunting period can have more than one hunting method.  

#### COLUMNS 


* **subareas\_hunting\_pressure\_method\_id** [integer]: *Database id of each record of the subarea hunting pressure table (external key).* 
* **subareas\_hunting\_pressure\_id** [integer]: 
* **hunting\_method\_code** [integer]: *Hunting method (linked to a look up table).* 
* **note** [character varying]: *Notes related to the subarea hunting method.* 
### TABLE: main.subareas\_hunting\_pressure\_others  
Table with the description of the hunting periods for species different from roe deer. The species is not reported. The periods have a start (and end) month and day. More than a period per year is possible. If the period is across years, it should be devided in two sub periods (until 31 december and from 1st of january) As this information can change (e.g. modification to the hunting regulation) the time interval of validity can also be specified.  

#### COLUMNS 


* **subareas\_hunting\_pressure\_others\_id** [integer]: *Database id of each record of the subarea hunting (for species different from roe deer) table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
* **validity\_start\_date** [date]: *Start date of the validity of the hunting intervals (i.e. start of validity of the regulation).* 
* **validity\_end\_date** [date]: *End date of the validity of the hunting intervals (i.e. end of validity of the regulation). This is null if the regulation is still valid.* 
* **hunting\_start\_month** [integer]: *Start month of the hunting period.* 
* **hunting\_start\_day** [integer]: *Start day of the hunting period.* 
* **hunting\_end\_month** [integer]: *End date of the hunting period.* 
* **hunting\_end\_day** [integer]: *End date of the hunting period.* 
* **dogs** [boolean]: *Presence (yes/no) of dogs.* 
* **note** [character varying]: *Notes related to the subarea hunting pressure.* 
* **hunting\_presence** [boolean]: 
### TABLE: main.subareas\_hunting\_stats  
Table with information of statistics taken from animals hunted and measured for biometry related to a specific year. This is connected to subareas.  

#### COLUMNS 


* **subareas\_hunting\_stats\_id** [integer]: *Database id of each record of the hunting statistcs table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
* **reference\_year** [integer]: *Reference year when data were collected/estimated.* 
* **males\_hunted** [integer]: *Number of adult males hunted and measured for biometry.* 
* **females\_hunted** [integer]: *Number of adult females hunted and measured for biometry.* 
* **fawns\_hunted** [integer]: *Number of fawns (<1 year) hunted and measured for biometry.* 
* **males\_bodymass\_avg** [double precision]: *Average body mass (in kg) of adult males, from hunting statistics.* 
* **males\_bodymass\_se** [double precision]: *Standard error of the body mass of adult males, from hunting statistics.* 
* **females\_bodymass\_avg** [double precision]: *Average body mass (in kg) of adult females, from hunting statistics.* 
* **females\_bodymass\_se** [double precision]: *Standard error of the body mass of adult females, from hunting statistics.* 
* **fawns\_bodymass\_avg** [double precision]: *Average body mass (in kg) of fawns, from hunting statistics.* 
* **fawns\_bodymass\_se** [double precision]: *Standard error of the body mass of fawns, from hunting statistics.* 
* **males\_hindfootlenght\_avg** [double precision]: *Average hindfoot lenght (in cm) of adult males, from hunting statistics.* 
* **males\_hindfootlenght\_se** [double precision]: *Standard error of the hindfoot lenght of adult males, from hunting statistics.* 
* **females\_hindfootlenght\_avg** [double precision]: *Average hindfoot lenght (in cm) of adult females, from hunting statistics.* 
* **females\_hindfootlenght\_se** [double precision]: *Standard error of the hindfoot lenght of adult females, from hunting statistics.* 
* **fawns\_hindfootlenght\_avg** [double precision]: *Average hindfoot lenght (in cm) of fawns, from hunting statistics.* 
* **fawns\_hindfootlenght\_se** [double precision]: *Standard error of the hindfoot lenght of fawns, from hunting statistics.* 
* **females\_fawns\_hunting** [boolean]: *Yes if adult females and fawns are hunted in the same period.* 
* **note** [character varying]: *Notes related to hunting statistcs for a defined year.* 
### TABLE: main.subareas\_interspecific\_competitors  
Table with estimation of roe deer interspecific competitors. The information is linked to the method of estimation, and can have an estimation per year per methodof estimation. If know, also the start and end date of the sampling is reported, otherwise only the year and optionally the season.  

#### COLUMNS 


* **subareas\_interspecific\_competitors\_id** [integer]: *Database id of each record of the subarea interspecific\_competitors table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
* **species\_id** [integer]: *Id of the species of the competitor (linked to main.species).* 
* **reference\_year** [integer]: *Reference year when data were collected/estimated.* 
* **seasons\_code** [integer]: *Season when the sampling was done (linked to a look up table).* 
* **start\_date** [date]: *Start date of the sampling (if known).* 
* **end\_date** [date]: *End date of the sampling (if known).* 
* **competitors\_presence** [boolean]: *Presence (yes/no) of the specific competitor.* 
* **competitors\_density\_code** [integer]: *Class of density of the competitor (linked to a look up table).* 
* **competitors\_density** [double precision]: *Competitor density (individuals per squared kilometre) if available.* 
* **competitors\_density\_se** [double precision]: *Standard error of roe deer interspecific\_competitors.* 
* **sampling\_methods\_code** [integer]: *Sampling method used for the estimation of the competitor density (linked to a look up table).* 
* **note** [character varying]: *Notes related to the interspecific competitors for a defined year/sampling method.* 
### TABLE: main.subareas\_predators  
Table with estimation of predators density. Each estimation for each predator for each year and for each sampling method corresonds to a row. The id of the species is linked with main.species where all the species are listed. If available, an estimation of the density is given as class and (if possible) number of individual per squared kilometre, otherwise only presence/absence is reported.  

#### COLUMNS 


* **subareas\_predators\_id** [integer]: *Database id of each record of the predators table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
* **reference\_year** [integer]: *Reference year when data were collected/estimated.* 
* **species\_id** [integer]: *Id of the species of the predator (linked to main.species).* 
* **predators\_presence** [boolean]: *Presence (yes/no) of the specific predator.* 
* **predators\_density\_code** [integer]: *Class of density of the predator (linked to a look up table).* 
* **predators\_density** [double precision]: *Density of the predators (individual per squared kilometre) if available.* 
* **predators\_density\_se** [double precision]: *Standard error of predator density (if available).* 
* **sampling\_methods\_code** [integer]: *Sampling method used for the estimation (linked to a look up table).* 
* **note** [character varying]: *Notes related to the predator density for a defined year/sampling method.* 
### TABLE: main.subareas\_roads\_density  
Table with estimation of road density density in the study area of a specific subarea. The value is linked to a specific year. It might change both because the road network change or because the areal of the subarea changes.  

#### COLUMNS 


* **subareas\_roads\_density\_id** [integer]: *Database id of each record of the subarea roads density table.* 
* **subareas\_id** [integer]: *Database id of each subarea (linked to main.subareas table).* 
* **density** [double precision]: *Road density in the study area (kilometres of roads per squared kilometre).* 
* **density\_se** [double precision]: *Standard error of road density.* 
* **data\_source** [character varying]: *Data used to estimate the road density (description).* 
* **note** [character varying]: *Notes related to the road density.* 
* **reference\_year\_start** [integer]: *Reference start year when data were collected/estimated and are considered valid.* 
* **reference\_year\_end** [integer]: *Reference end year when data were collected/estimated and are considered valid.* 
### TABLE: main.vhf\_data\_animals  
Table with VHF locations data, inluding a list of derived ancillary infomation calculated using the information on coordinates and acquisition time, and intersecting with environmental layers.  

#### COLUMNS 


* **vhf\_data\_animals\_id** [integer]: *Eurodeer identifier for the VHF location.* 
* **animals\_id** [integer]: *Eurodeer identifier for the animal.* 
* **vhf\_sensors\_id** [integer]: *Eurodeer identifier for the VHF sensor.* 
* **geom** [USER-DEFINED]: *Geometry of the location (point).* 
* **acquisition\_time** [timestamp with time zone]: *Date and time of acquisition of the VHF coordinates (with time zone).* 
* **x\_original\_reference** [double precision]: *Coordinate X as originally recorded (in the srid\_original\_reference).* 
* **y\_original\_reference** [double precision]: *Coordinate Y as originally recorded (in the srid\_original\_reference).* 
* **srid\_original\_reference** [integer]: *Reference system of the projected coordinates used in the orignal coordinate recording.* 
* **latitude** [double precision]: *Latitude of the VHF location.* 
* **longitude** [double precision]: *Longitude of the VHF location.* 
* **vhf\_validity\_code** [integer]: *This field tags the record according to its source ir validity, which is a measure of the degree of reliability (explanation of codes in lu\_tables.lu\_vhf\_validity).* 
* **notes** [character varying]: *General comments about the specific location.* 
* **sun\_angle** [double precision]: *Sun angle above (or below) the horizon (in degrees) as computed by the function tools.sun\_elevation\_angle\_function.* 
* **snow\_modis** [integer]: *Snow coverage (25:land; 50:cloud; 200:snow).* 
* **utm\_y** [integer]: *Y coordinate projected in the utm\_srid UTM zone.* 
* **utm\_x** [integer]: *X coordinate projected in the utm\_srid UTM zone.* 
* **utm\_srid** [integer]: *SRID code of the UTM zone of the centroid of the locations for the animal.* 
* **corine\_land\_cover\_2006\_code** [integer]: *Code of the Corine lad cover class (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **ndvi\_modis\_boku** [double precision]: *NDVI derived from MODIS as processed by Boku (smoothed weekly images). NDVI is interpolated between the two closest images.* 
* **ndvi\_modis\_smoothed** [double precision]: *Values are taken from the table env\_data\_ts.ndvi\_modis\_smoothed. They come from the 16daily modis ndvi from nasa, then a smoothing (swets) is applied using SPIRITS software that also convert 16 daily to 10daily.* 
* **corine\_land\_cover\_1990\_code** [integer]: *Code of the Corine lad cover class produced in 1990 (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **corine\_land\_cover\_2000\_code** [integer]: *Code of the Corine lad cover class produced in 2000 (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **altitude\_copernicus** [integer]: *Meters above sea level (from copernicus project, v1.0).* 
* **slope\_copernicus** [double precision]: *Degrees, -9999 (NULL), (from copernicus project, v1.0), generated with gdaldem.* 
* **aspect\_copernicus** [integer]: *Degrees calculated clockwise from north, -9999 (NULL) means no aspect (flat) (source: copernicus project, v1.0), generated with gdaldem.* 
* **corine\_land\_cover\_2012\_code** [integer]: *Code of the Corine lad cover class produced in 2000, from raster version resolution 100 meters (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
* **forest\_density** [integer]: 
* **corine\_land\_cover\_2012\_vector\_code** [integer]: *Code of the Corine lad cover class produced in 2000, from original vector layer (in env\_data.corine\_land\_cover\_legend there is a complete description of these codes).* 
### TABLE: main.vhf\_sensors  
Catalogue of VHF sensors. Each sensor belongs to a research group. The attributes include the brand and the model. The id used in the original data set is also included.  

#### COLUMNS 


* **vhf\_sensors\_id** [integer]: *Eurodeer identifier for VHF sensors.* 
* **research\_groups\_id** [integer]: *Id of the research group that owns the VHF sensor.* 
* **vhf\_sensors\_original\_id** [character varying]: *Identifier of the VHF sensor in the original data set.* 
* **vendor** [character varying]: *Company that produced the sensor.* 
* **model** [character varying]: *Model of the VHF sensor.* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
### TABLE: main.vhf\_sensors\_animals  
Table with the information on the deployments of VHF sensors on animals (starting and ending date and time of the deployment), reason of the end of deployment, reference capture. In case of mortality, the event will be reported in the table main.animals\_contacts.  

#### COLUMNS 


* **vhf\_sensors\_animals\_id** [integer]: *Eurodeer identifier of the deployment.* 
* **vhf\_sensors\_id** [integer]: *Eurodeer identifier of the vhf sensor.* 
* **animals\_id** [integer]: *Eurodeer identifier of the animal.* 
* **start\_time** [timestamp with time zone]: *Time and date of the start of the deployment.* 
* **end\_time** [timestamp with time zone]: *Time and date of the end of the deployment.* 
* **update\_timestamp** [timestamp with time zone]: *Date and time when the record was updated (last time).* 
* **insert\_timestamp** [timestamp with time zone]: *Date and time when the record was uploaded into the database.* 
* **notes** [character varying]: *Open field where general notes on the deployment can be added.* 
* **end\_deployment\_code** [integer]: *Code for the reason of the end of deployment (reference to the look up table lu\_tables.lu\_end\_deployment).* 
* **mortality\_code** [integer]: *If the reason of the end of deployment is dead, this field specifies the reason of the death (code described in the look up table lu\_tables.lu\_mortality - THIS FIELD MUST BE REMOVED AS IT MOVED TO MAIN.ANIMALS\_CONTACTS.* 
* **insert\_user** [character varying]: *User who created the record.* 
* **update\_user** [character varying]: *User who modified the record (last time).* 
* **animals\_captures\_id** [integer]: *Reference to the capture when the sensor was deployed on the animal.* 
### VIEW: main.view\_eurodeer\_gps\_positions  
Animal locations with valid coordinates and information on animals (study area, research group, age and sex).  


### VIEW: main.view\_import\_dem  
  


### VIEW: main.view\_import\_forest\_density  
  


### VIEW: main.view\_locations\_set  
View that stores the core information of locations data (id of the animal, the acquisition time and the geometry). Non valid records are represented without the geometry. Duplicated timestamps are excluded.  


### VIEW: main.view\_mortality  
Animals and study areas for which mortality data are currently avaialable.  


### VIEW: main.view\_reasearch\_groups\_euroungulates  
  


### VIEW: main.view\_study\_areas\_bbox\_20  
  


### VIEW: main.view\_study\_areas\_bbox\_25  
  


### VIEW: main.view\_survival  
  


### VIEW: main.view\_survival\_bavaria\_pivot  
  



## SCHEMA: lu\_tables  
**The schema "lu_tables" is where the look up tables (lu_tables) are stored. These tables store the list and the description of codes referenced by other tables in the database and are a kind of valid domain for specific fields.**  

### TABLE: lu\_tables.lu\_action  
Look up table for action\_code field (table tools.log\_dbchanges): it specifies the meaning of the code used to identify the action (change) done to the daatbase).  

#### COLUMNS 


* **action\_code** [integer]: *Code for the action (change done to the db).* 
* **action\_description** [character varying]: *Desciption of action (change done to the db).* 
### TABLE: lu\_tables.lu\_activity\_sensor\_mode  
  

#### COLUMNS 


* **activity\_sensor\_mode\_code** [integer]: 
* **activity\_sensor\_mode\_description** [character varying]: 
### TABLE: lu\_tables.lu\_activity\_validity  
Look up table for activity data validity.  

#### COLUMNS 


* **activity\_validity\_code** [integer]: *Code of the activity data validity.* 
* **activity\_validity\_description** [character varying]: *Description of the activity data validity.* 
### TABLE: lu\_tables.lu\_age\_class  
Look up table for age\_class\_code field (table main.animals): it specifies the meaning of the code used to identify the age class of the roe deer).  

#### COLUMNS 


* **age\_class\_code** [integer]: *Code for the age class.* 
* **age\_class\_description** [character varying]: *Desciption of the age class.* 
* **age\_class\_comment** [character varying]: *Description of the meaning of the age class.* 
### TABLE: lu\_tables.lu\_age\_class\_reddeer  
Look up table for age\_class\_code field (table main\_reddeer.animals): it specifies the meaning of the code used to identify the age class of the red deer).  

#### COLUMNS 


* **age\_class\_code** [integer]: *Code for the age class.* 
* **age\_class\_description** [character varying]: *Desciption of the age class.* 
* **age\_class\_comment** [character varying]: *Description of the meaning of the age class.* 
### TABLE: lu\_tables.lu\_behavior\_handling  
Look up table for behavior\_handling types.  

#### COLUMNS 


* **behavior\_handling\_code** [integer]: *Code of the behavior during handling (capture event) type.* 
* **behavior\_handling\_description** [character varying]: *Description of the behavior handling (capture event) type.* 
### TABLE: lu\_tables.lu\_behavior\_release  
Look up table for behavior\_release types.  

#### COLUMNS 


* **behavior\_release\_code** [integer]: *Code of the behavior at release (during capture event) type.* 
* **behavior\_release\_description** [character varying]: *Description of the behavior at release (during capture event) type.* 
### TABLE: lu\_tables.lu\_capture\_methods  
Look up table for capture\_methods types.  

#### COLUMNS 


* **capture\_methods\_code** [integer]: *Code of the capture method.* 
* **capture\_methods\_description** [character varying]: *Description of the capture method.* 
* **capture\_methods\_note** [character varying]: *Additional notes on the capture method.* 
### TABLE: lu\_tables.lu\_capture\_result  
Look up table for capture\_result types (animals\_captures table). Only animals that are monitored or that were captured to be monitored are included in the data base. This LU specifies the possible results of the capture.  

#### COLUMNS 


* **capture\_result\_code** [integer]: *Code of the capture result.* 
* **capture\_result\_description** [character varying]: *Description of the capture result.* 
* **capture\_result\_note** [character varying]: *Additional notes on the capture result.* 
### TABLE: lu\_tables.lu\_competitor\_density  
Look up table for predators density types.  

#### COLUMNS 


* **competitor\_density\_code** [integer]: *Code of the density type.* 
* **competitor\_density\_description** [character varying]: *Description of the density type.* 
* **competitor\_density\_note** [character varying]: *Additional notes of the density type.* 
### TABLE: lu\_tables.lu\_contact\_mode  
Look up table for contact\_mode\_code field (table main.animals\_contacts): it specifies the meaning of the code used to identify the contact\_mode of the animal.  

#### COLUMNS 


* **contact\_mode\_code** [integer]: *Code for the type of contact with the animal.* 
* **contact\_mode\_description** [character varying]: *Desciption of the type of contact with the animal.* 
### TABLE: lu\_tables.lu\_data\_curators  
Look up table for data\_curators\_code field (table tools.log\_dbchanges): it specifies the meaning of the code used to identify the data curators.  

#### COLUMNS 


* **data\_curators\_code** [integer]: *Code for the data\_curators.* 
* **data\_curators\_description** [character varying]: *Desciption of data\_curators.* 
### TABLE: lu\_tables.lu\_end\_deployment  
Look up table for end\_deployment\_code field: it specifies the meaning of the code used to identify the reasons of the end of deployment.  

#### COLUMNS 


* **end\_deployment\_code** [integer]: *Code for the reason of the end of deployment.* 
* **end\_deployment\_description** [character varying]: *Desciption of the reason of the end of deployment.* 
* **note** [text]: 
### TABLE: lu\_tables.lu\_farming  
Look up table for farming types.  

#### COLUMNS 


* **farming\_code** [integer]: *Code of the farming type.* 
* **farming\_description** [character varying]: *Description of the farming type.* 
### TABLE: lu\_tables.lu\_forestry\_work  
Look up table for forestry work types.  

#### COLUMNS 


* **forestry\_work\_code** [integer]: *Code of the forestry work type.* 
* **forestry\_work\_description** [character varying]: *Description of the forestry work type.* 
### TABLE: lu\_tables.lu\_gps\_validity  
Look up table for GPS locations validity.  

#### COLUMNS 


* **gps\_validity\_code** [integer]: *Code of the GPS locations validity.* 
* **gps\_validity\_description** [character varying]: *Description of the GPS locations validity code.* 
### TABLE: lu\_tables.lu\_hunting\_method  
Look up table for hunting method types.  

#### COLUMNS 


* **hunting\_method\_code** [integer]: *Code of the hunting method type.* 
* **hunting\_method\_description** [character varying]: *Description of the hunting method type.* 
### TABLE: lu\_tables.lu\_mortality  
Look up table for mortality\_code field (table main.animals\_contacts): it specifies the meaning of the code used to identify the reasons of the death of the animal.  

#### COLUMNS 


* **mortality\_code** [integer]: *Code for the reason of the death of the animal.* 
* **mortality\_description** [character varying]: *Desciption of the reason of the death of the animal.* 
### TABLE: lu\_tables.lu\_predators\_density  
Look up table for predators density types.  

#### COLUMNS 


* **predators\_density\_code** [integer]: *Code of the predators density type.* 
* **predators\_density\_description** [character varying]: *Description of the predators density type.* 
* **predators\_density\_note** [character varying]: *Additional notes of the predators density type.* 
### TABLE: lu\_tables.lu\_release\_type  
Look up table for release\_type\_code field: it specifies how the animal has been released after capture.  

#### COLUMNS 


* **release\_type\_code** [integer]: *Code for the type of release.* 
* **release\_type\_description** [character varying]: *Desciption of the type of release.* 
### TABLE: lu\_tables.lu\_sampling\_methods  
Look up table for sampling methods types.  

#### COLUMNS 


* **sampling\_methods\_code** [integer]: *Code of the sampling methods type.* 
* **sampling\_methods\_description** [character varying]: *Description of the sampling methods type.* 
### TABLE: lu\_tables.lu\_seasons  
Seasons of the year.  

#### COLUMNS 


* **seasons\_code** [integer]: *Code of the seasons type.* 
* **seasons\_description** [character varying]: *Description of the seasons type.* 
### TABLE: lu\_tables.lu\_vhf\_validity  
Look up table for vhf locations source and validity.  

#### COLUMNS 


* **vhf\_validity\_code** [integer]: *Code of the vhf locations validity.* 
* **vhf\_validity\_description** [character varying]: *Description of the vhf locations validity and source code.* 
## SCHEMA: env\_data  
**The schema "env_data" hosts all the (static) environmental and socio economic layers. Raster time series are stored in separated schemas (env_data_ts).**  

### TABLE: env\_data.administrative\_units  
Boundaries of administrative units (3rd, 4th, or 5th level according to the country) for the countries of Eurodeer study areas (source: www.gadm.org).  

#### COLUMNS 


* **administrative\_units\_id** [integer]: 
* **id\_0** [integer]: 
* **iso** [character varying]: 
* **name\_0** [character varying]: 
* **id\_1** [integer]: 
* **name\_1** [character varying]: 
* **type\_1** [character varying]: 
* **id\_2** [integer]: 
* **name\_2** [character varying]: 
* **type\_2** [character varying]: 
* **id\_3** [integer]: 
* **name\_3** [character varying]: 
* **type\_3** [character varying]: 
* **id\_4** [integer]: 
* **name\_4** [character varying]: 
* **type\_4** [character varying]: 
* **id\_5** [integer]: 
* **name\_5** [character varying]: 
* **type\_5** [character varying]: 
* **geom** [USER-DEFINED]: 
### TABLE: env\_data.aspect\_copernicus  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
* **study\_areas\_id** [integer]: 
### TABLE: env\_data.aster\_index  
Schema of available Aster tiles.  

#### COLUMNS 


* **aster\_index\_id** [integer]: 
* **Image** [character varying]: 
* **XYSize** [character varying]: 
* **BandTypes** [character varying]: 
* **ResSpatial** [character varying]: 
* **in\_db** [integer]: 
* **geom** [USER-DEFINED]: 
### TABLE: env\_data.corine\_land\_cover\_1990  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
### TABLE: env\_data.corine\_land\_cover\_2000  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
### TABLE: env\_data.corine\_land\_cover\_2006  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
### TABLE: env\_data.corine\_land\_cover\_2012  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
### TABLE: env\_data.corine\_land\_cover\_2012\_vector\_imp  
  

#### COLUMNS 


* **id** [integer]: 
* **clc\_code** [integer]: 
* **geom** [USER-DEFINED]: 
### TABLE: env\_data.corine\_land\_cover\_legend  
Legend of Corine land cover. Corine is a EU project that produced a continental land cover map in 1990, 2000, and 2006. These three layers are stored in Eurodeer as raster at 100 meters resolution in etrs\_1989\_laea projection. The legend can be used to extract the meaning of each land cover class at 3 different semantic levels.  

#### COLUMNS 


* **grid\_code** [integer]: *Code stored in the raster layers.* 
* **clc\_l3\_code** [character varying]: *Official Corine code (level 3).* 
* **label1** [character varying]: *Description of the corine class at level 1.* 
* **label2** [character varying]: *Description of the corine class at level 2.* 
* **label3** [character varying]: *Description of the corine class at level 3.* 
### TABLE: env\_data.dem\_copernicus  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
* **study\_areas\_id** [integer]: 
### TABLE: env\_data.forest\_density  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
* **study\_areas\_id** [integer]: 
### TABLE: env\_data.ndvi\_constancy  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
### TABLE: env\_data.ndvi\_contingency  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
### TABLE: env\_data.ndvi\_predictability  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
### TABLE: env\_data.reddeer\_update\_gps\_update\_env\_fields  
  

#### COLUMNS 


* **gps\_data\_animals\_id** [integer]: 
* **acquisition\_time** [timestamp with time zone]: 
* **geom** [USER-DEFINED]: 
* **gps\_validity\_code** [smallint]: 
* **corine\_land\_cover\_2006\_code** [integer]: 
* **corine\_land\_cover\_2000\_code** [integer]: 
* **corine\_land\_cover\_1990\_code** [integer]: 
* **corine\_land\_cover\_2012\_code** [integer]: 
* **ndvi\_modis\_boku** [double precision]: 
* **ndvi\_modis\_smoothed** [double precision]: 
* **snow\_modis** [integer]: 
* **geom\_3035** [USER-DEFINED]: 
### TABLE: env\_data.reddeer\_update\_vhf\_update\_env\_fields  
  

#### COLUMNS 


* **vhf\_data\_animals\_id** [integer]: 
* **acquisition\_time** [timestamp with time zone]: 
* **geom** [USER-DEFINED]: 
* **vhf\_validity\_code** [smallint]: 
* **corine\_land\_cover\_2006\_code** [integer]: 
* **corine\_land\_cover\_2000\_code** [integer]: 
* **corine\_land\_cover\_1990\_code** [integer]: 
* **corine\_land\_cover\_2012\_code** [integer]: 
* **ndvi\_modis\_boku** [double precision]: 
* **ndvi\_modis\_smoothed** [double precision]: 
* **snow\_modis** [integer]: 
* **geom\_3035** [USER-DEFINED]: 
### TABLE: env\_data.slope\_copernicus  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
* **study\_areas\_id** [integer]: 
### TABLE: env\_data.srtm\_index  
Schema of available SRTM tiles.  

#### COLUMNS 


* **srtm\_index\_id** [integer]: 
* **Image** [character varying]: 
* **XYSize** [character varying]: 
* **BandTypes** [character varying]: 
* **ResSpatial** [character varying]: 
* **in\_db** [integer]: 
* **geom** [USER-DEFINED]: 
### TABLE: env\_data.world\_countries  
Boundaries of all the countries of the world.  

#### COLUMNS 


* **world\_countries\_id** [integer]: 
* **name** [character varying]: 
* **iso3** [character varying]: 
* **iso2** [character varying]: 
* **continent** [character varying]: 
* **geom** [USER-DEFINED]: 
### TABLE: env\_data.world\_countries\_simplified  
Boundaries of all the countries of the world, simplified (using ST\_SimplifyPreserveTopology, 0.01 as parameter).  

#### COLUMNS 


* **world\_countries\_simplified\_id** [integer]: 
* **name** [character varying]: 
* **iso3** [character varying]: 
* **iso2** [character varying]: 
* **continent** [character varying]: 
* **geom** [USER-DEFINED]: 
### VIEW: env\_data.study\_areas\_ref  
  




## SCHEMA: env\_data\_ts  
**the schema "env_data_ts" stores environmental layers in form of raster time series.**  

### TABLE: env\_data\_ts.ndvi\_modis  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
* **acquisition\_date** [date]: 
### TABLE: env\_data\_ts.ndvi\_modis\_boku  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
* **acquisition\_date** [date]: 
* **filepath** [character varying]: 
### TABLE: env\_data\_ts.ndvi\_modis\_boku\_grid  
  

#### COLUMNS 


* **tiles\_grid\_id** [integer]: 
* **geom** [USER-DEFINED]: 
* **big\_tiles** [character varying]: 
* **small\_tile** [character varying]: 
* **tile** [character varying]: 
* **acquired** [integer]: 
* **imported** [integer]: 
### TABLE: env\_data\_ts.ndvi\_modis\_smoothed  
  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
* **acquisition\_date** [date]: 
### TABLE: env\_data\_ts.snow\_modis  
Table that stores information on snow from Modis.  

#### COLUMNS 


* **rid** [integer]: 
* **rast** [USER-DEFINED]: 
* **filename** [text]: 
* **acquisition\_date** [date]: 
### TABLE: env\_data\_ts.snow\_modis\_legend  
Codes of the Modis Snow time series.  

#### COLUMNS 


* **modis\_snow\_code** [integer]: *Code stored in the raster TS (as produced by NASA).* 
* **modis\_snow\_description** [character varying]: *Description of the Modis Snow code.* 
### TABLE: env\_data\_ts.winter\_severity  
  

#### COLUMNS 


* **rast** [USER-DEFINED]: 
* **start\_date** [date]: 
* **end\_date** [date]: 
* **reference\_year** [integer]: 
* **id** [integer]: 
## SCHEMA: analysis  
**The schema "analysis" stores the results of analysis (home range, trajectories, and statistics).**  

### TABLE: analysis.test\_home\_ranges  
Table that stores the home range polygons derived from a set of possible methods. A set of fieldsis  used as metadata to identify the source data: the animal (which is considered the basic "unit" for the home range computation), the time range that is used to select locations considered in the analysis,, and the total number of locations that generated the home range (this can be modified to accept a more general SQL select statements where any criteria can be used, not just starting time and ending time; this option must be discussed to identify the best implementation to satisfy NINA's requirements). The computation method is stored in a specific (coded in a look up table) field connected to other fields where are stored the parameters (the table has generic fields "parametr\_1, parameter\_2, parameter\_3,  parameter\_4, the meaning of these parameters depend on the method and are explained in the look up tables of the method code). New parameters (e.g. parameter\_5) can be added at any time. The area (in hectars) is computed and stored in the filed "area". These other fields are used to carachterize the analysis: user who performed the analysis, timestamp when the analysis was performed, and a general description. For home ranges that derive from a probability surface (e.g. kernel home range), the reference probability surface (raster) is stored. Note that the key is a serial number, therefore the same analysis can be performed twice and the results will be both stored in the database. The field obsolete\_code will be supported by a function to detect obsolete analysis (checking the number of locations that originated the home range, and verifying that none of the original data is newer that the date of the analysis).  

#### COLUMNS 


* **home\_ranges\_id** [integer]: *Code that identifies uniquely each home\_ranges record. This information is a serial number generated by postgresql. This field is the primary key of the table.* 
* **animals\_id** [integer]: *Animal to which is related the information.* 
* **start\_time** [timestamp without time zone]: *Starting timestamp used as a selection criteria applied to the data source.* 
* **end\_time** [timestamp without time zone]: *Ending timestamp used as a selection criteria applied to the data source.* 
* **hr\_method\_code** [integer]: *Meethod used to compute the home range. Many methods are available, and this filed records a code that reference the table lu\_tables.lu\_hr\_method where each code is explained. The fields "parameter\_1", "parameter\_2", "parameter\_3", "parameter\_4" (described lu\_tables.lu\_hr\_method) specify the values of the parameters (if any) used in the home range method. If a method with futher parameters is used, new "parametr\_x" fileds can be added.* 
* **description** [character varying]: *Text field where users can comment and describe the analysis. This field can be used to "tag" the analysis in order to retrieve theme easier.* 
* **prob\_surfaces\_id** [integer]: *If the home range derive from a probability surface (e.g. kernel methods), here the raster is referenced. Note that many home ranges can be related to the same probability surface.* 
* **ref\_user** [character varying]: *Name of the user who performed the analysis.* 
* **num\_locations** [integer]: *Number of locations used to do the analysis (as a product of selection criteria applied to the data source.* 
* **area** [numeric]: *Area of the home range computed in km^2 (with 5 decimals).* 
* **geom** [USER-DEFINED]: *Geometry field (st\_multipolygon, 2 dimension, SRID 4326 - geographic coordinates datum WGS84).* 
* **obsolete\_code** [integer]: *A function can compare the number of locations used for the computation with the number of locations available at any moment using the same selection parameter. At the same time, it is possible to see if any new location is available or has been updated since the analysis was performed. If one of these conditions is met, it means that the result of the analysis is no more updated and should be run again.* 
* **insert\_timestamp** [timestamp without time zone]: *Timestamp (in UTC zone) when the record was inserted in the table.* 
* **original\_data\_set** [character varying]: *Source of data used for the selection (by default: main.view\_locations\_set). If a more complex source is used, e.g. a "select" statement, the whole select statement is recorded.* 
* **parameter\_1** [character varying]: *This field specify the values of the second parameter (if used) of the home range function.* 
* **parameter\_4** [character varying]: 
* **parameter\_3** [character varying]: 
* **parameter\_2** [character varying]: 
### VIEW: analysis.view\_animals\_days  
Number of locations per animal per day.  


### VIEW: analysis.view\_convexhull  
View with the convex hull of all valid locations per all the animals of Eurodeer dataset.  


### VIEW: analysis.view\_convexhull\_vhf  
View with the convex hull of all valid locations per all the animals of red deer vhf dataset.  


### VIEW: analysis.view\_locations\_12h  
View with a fix sequence at intervals of no less than 12 hrs, i.e. all locations at higher frequency are excluded (it uses the view view\_locations\_12h\_calculation).  


### VIEW: analysis.view\_locations\_12h\_calculation  
Regularized selection of valid locations (1 every -at least- 12 hours).  


### VIEW: analysis.view\_locations\_1h  
View with a fix sequence at intervals of no less than 1 hrs, i.e. all locations at higher frequency are excluded (it uses the view view\_locations\_1h\_calculation).  


### VIEW: analysis.view\_locations\_1h\_calculation  
Regularized selection of valid locations (1 every -at least- 1 hour).  


### VIEW: analysis.view\_locations\_24h  
View with a fix sequence at intervals of no less than 24 hrs, i.e. all locations at higher frequency are excluded (it uses the view view\_locations\_24h\_calculation).  


### VIEW: analysis.view\_locations\_24h\_calculation  
Regularized selection of valid locations (1 every -at least- 24 hours).  


### VIEW: analysis.view\_locations\_4h  
View with a fix sequence at intervals of no less than 4 hrs, i.e. all locations at higher frequency are excluded (it uses the view view\_locations\_4h\_calculation).  


### VIEW: analysis.view\_locations\_4h\_calculation  
Regularized selection of valid locations (1 every -at least- 4 hours).  


### VIEW: analysis.view\_ltraj\_class  
This view extracts a subset of fields from main.view\_locations\_set in order to have an object of class "ltraj" in the adehabitat package in R (animals\_id integer,  acquisition\_time as second from 1am 1970 1st january, x and y coordinates in the proper UTM zone). This view can be used in R to create a ltraj class with no bursts. here an example: 
get the data 
data\_traj\_raw <- sqlQuery(channel, "SELECT *  FROM analysis.view\_ltraj\_class;"); create a ltraj object 
create an ltraj object
data\_traj<- as.ltraj(xy=data\_traj\_raw[,c("x","y")], date=as.POSIXct(data\_traj\_raw[,"acquisition\_epoch"],  origin="1970-01-01 01:00:00"), id =data\_traj\_raw[,"animals\_id"])
Any "where" clause can be added to "SELECT *  FROM analysis.view\_ltraj\_class" to limits animals (e.g. "where animals\_id in (1,2,3,6,7)") or starting and ending time.
To create ltraj objces with bursts identificator, you have to use the tools.sam\_traj\_bursts function.  


### VIEW: analysis.view\_statistics\_animals  
Statistics with summarized information on each animal.  


### VIEW: analysis.view\_statistics\_studies  
Statistics with summarized information on each study area.  


### VIEW: analysis.view\_study\_animals\_sensors\_summary  
Summary with animals, sensors, start and end valid fix (no 14) for each study.  


### VIEW: analysis.view\_subarea\_hunting\_pressure\_by\_year  
Subarea\_hunting\_pressure table transformed into 1 record per hunting season including hunting\_start\_date and hunting\_end\_date both for males and females. With this table it is easier to determine the hunting season for each fix at a given timestamp.  


### VIEW: analysis.view\_test\_homeranges\_points  
This view taked the "probability" grid in "view\_test\_probability\_grid\_points" and extract the subset of cells that cover a defined percentage (in this test case, 80%) of the total hours. It selects the cell with most hours, then the second, and so on until the cumuated sum of hours (compared to the totl number of hours) is equal to the desired threshold.  


### VIEW: analysis.view\_test\_probability\_grid\_points  
This view presents the sql code to calculate the time spent by an animal on every cell of a defined resolution, which correspond to a probability surface. In this case, points are considered. Each point represents half of the time between the same point and the next point and the same point and th previous point. The view "view\_test\_homerange" select just the cells that represent a defined, cumulare value (like the home range tool in adehabitat). This view calls the function "tools.reate\_grid". At the montent, it is a view with pure SQL, but this tool can be coded into a function that using temporary tables ad some other optimized approach, can speed up the processing time. (in this example, animals 1 and 2 are considered).  


### VIEW: analysis.view\_test\_probability\_grid\_traj  
This view presents the sql code to calculate the time spent by an animal on every cell of a defined resolution, which correspond to a probability surface. In this case, trajectory (segments between locations) is considered. Each segment represents the time spent between the two locations. This view calls the function "tools.reate\_grid". At the montent, it is a view with pure SQL, but htis tool can be coded into a function that using temporary tables ad some other optimized approach, can speed up the processing time. In this case, animals 1 and 2 are cosidered.  


### VIEW: analysis.view\_trajectories  
Complete trajectories as linear spatial features per each of the animals of Eurodeer dataset.  






## SCHEMA: tools  
**The schema "tools" hosts all the functions and tools that are used throughout the database to manage, massage, analyse and query data.**  

### TABLE: tools.log\_dbchanges  
Table that reports (and keeps track of) all the changes made to the database (import of new data, update of existing data, change in the data structure, creation of a tool, etc with reference to the data curator that did the change and the date. At the moment, a single table is used for both eurodeer and eureddeer.  

#### COLUMNS 


* **log\_dbchanges\_id** [integer]: *Database id of db changes.* 
* **date\_change** [date]: *Date when the change was made.* 
* **data\_curators\_code** [integer]: *Code of the data curator that did the change.* 
* **action\_code** [integer]: *Code for the type of change that was made to the database.* 
* **change\_description** [text]: *Description of the change.* 
## SCHEMA: activity\_data\_raw  
**This schema stores the raw activity data that have still to be (partially) processed to be analyzed and merged together.**  

## SCHEMA: temp  
**This schema stores temporary objects (tables, functions, ...) used for analysis or for testing purposes. Elements stored in this schema can be deleted at any time by the database administrator.**  

## SCHEMA: public  
**standard public schema**  

