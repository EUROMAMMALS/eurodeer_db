# EURODEER USERS GUIDE

[SUMMARY here]

## EUROUNGULATES project
<logo_euroungulates.png>

EUROUNGULATES is an umbrella project that coordinates and connects different open, bottom-up projects that promote collaborative science among research institutes based on knowledge and data sharing to investigate the movement ecology of European ungulates in their different habitats and management regimes. At the moment (2017) the EUROUNGULATES network is made of three species specific projects: **EURODEER** (roe deer, *Capreolus capreolus*), **EUREDDEER** (red deer, *Cervus elaphus*), **EUROBOAR** (wild boar, *Sus scrofa*).

EUROUNGULATES is first of all an open network of researchers who collaborate sharing data and knowledge to produce better science. It is based on species-specific spatial database that store shared movement data and a wide set of additional information on each ungulate species to investigate variation in their behavioural ecology along environmental gradients or population responses to specific conditions, such as habitat changes, impact of human activities, different hunting regimes. EURODEER, EUREDDEER and EUROBOAR groups are trying to fully explore the opportunities given by the new monitoring technologies for conservation and management at both local and continental scale. 

Even if EURODEER, EUREDDEER and EUROBOAR are open projects, the data in the three database are accessible only by whom actively contributes with data or expertise, according to what is stated in the EURODEER and EUROBOAR Terms of Use. Permissions are specific to each of the three database (they who contribute to one of the three database, can access data only for that database.

The [EUROUNGULATES spatial databases](http://eurodeer2.fmach.it/phppgadmin/) are hosted at [Edmund Mach Foundation](http://www.fmach.it/).

More information on the projects, including activities, partners, outcomes and news can be found at their website:

* [www.euroungulates.org](www.euroungulates.org)
* [www.eurodeer.org](www.eurodeer.org)
* [www.eureddeer.org](www.eureddeer.org)
* [www.euroboar.org](www.euroboar.org) 

### EURODEER
<logo_eurodeer.png>

European roe deer is a very well studied species, because of its crucial role in European ecosystems and because it is a very good model species, both for ecological and evolutionary reasons. However, the time might have come for synthesising our knowledge into a wider and more complex picture, that would allow to clarify ecosystemic relationships (e.g., resource balance), reveal evolutionary patterns (e.g., animal performance), and underpin predictions on future scenarios (e.g., climate change effect). Recent technological advancement, such as GPS collars and activity sensors, allowed to obtain more data and of better quality. A spatial database populated with data from different areas can support the development of a complete picture of roe deer biology, within a ecological and evolutionary context. At the same time, it offers the opportunity to join the data of different research groups into a well supported repository, with transparent accessibility.
These are the premises of the EUropean ROe DEER Information System (EURODEER).

#### EURODEER TERMS OF USE
[short synthesis (ref to presentations? maybe up? and link to the document)]

### EUREDDEER
<logo_eureddeer.png>

[...]

### EUROBOAR
<logo_euroboar.png>

[...]


## Scope of this document
This manual is the reference documentation about the use of EURODEER database for EURODEER partners, but it is useful also for EUREDDEER and EUROBOAR database users, as the e-infrastructure is shared and large part of the database objects is similar. 

Note that this is not a comprehensive manual about database. It shortly describes the EURODEER database content and the main operations that can be done on it. There are also information on how to connect with the database and visualize/download the data but not on how data can be combined or processed with the database language (SQL). 

For more advanced operations, some (even minimal) knowledge of SQL is needed. It i possible to learn about SQL and database though one of the many open tutorials, guides and courses available on the web. For example:

* Example 1
* [www.sql.org](www.sql.org)
* Example 3

In addition, for they who want to understand the EURODEER database structure and tools or to get more skills on data management for wildlife tracking data, we suggest the book [Spatial Database for GPS Wildlife Tracking Data- A Practical Guide to Creating a Data Management System with PostgreSQL/PostGIS and R](https://www.springer.com/us/book/9783319037424) (Urbano & Cagnacci Ed., 2014). You can find a digital version of the chapetrs of the book in the EURODEER document repository (for EURODEER partners).

EUROUNGULATES database manager and data curators are always available for EUROUNGULATES databases users whenever technical support is needed.
  
## EURODEER Database - Introduction

The main goal of EURODEER project is to join in a common data repository, roe deer tracking data and additional information from different research groups (using different software tools) located in different European countries. To achieve this goal, we set up a software platform that enables all partners to access, manage and analyze the shared data in a cost-effective fashion. The main requirements of the project and the assessment of possible solutions are described in the paper [Wildlife tracking data management: a new vision ](http://rstb.royalsocietypublishing.org/content/365/1550/2177)(Urbano et al., 2013).

The result is a software platform based on a relational database management system with a spatial extension, built on the open source software [PostgreSQL](www.postgresql.org) (at 2017, version 9.5) and [PostGIS](www.postgis.org) (at 2017, version 2.3). It also includes the extension [Pl/R](https://github.com/postgres-plr/plr) that allows an integration of R tools into the database. The database is physically installed on a server at Edmund Mach Foundation, but it is accessible from everywhere in the world (with a password!). The database works as a centralized server that sends data, when requested, to specific client applications. A client is an application or system that accesses a remote service on another computer system, known as a server, by way of a network; a client application can be located anywhere and multiple connections to the database can be managed at the same time. Example of client applications are those used to manage the data (e.g., pgAdmin, phpPgAdmin), visualize spatial information (e.g., QGIS, ArcGIS) or perform analisys (e.g., R).

The server-client structure of the system offers the opportunity to build a very flexible and modular software platform, as any software able to connect to the central database can be integrated. Storing, managing, accessing and analysing GPS data from several research groups throughout Europe is thus possible, while each researcher can use the favourite software application. The most used applications to interact with the EUORDEER database are Desktop GIS, statistics and Web tools, as well as office suites. 

In the next chapters we will see some of these applications and how to connect them to EURODEER database, while in the next sections we go more in detail on database structure and content.

### Data collection

### Data harmonization

### Quality checks

### Data upload
who does it, continuos changes and improvements of the data with their use

### Some preliminary words on database for data management

#### Database and spatial database
A database is an application that can store and manage a large amount of data very efficiently and rapidly. The relational bit refers to how the data is stored in the database and how it is organized. In a relational database, all data is stored in tables. These have the same structure repeated in each row (like a spreadsheet) and it is the relations between the tables that make it a "relational" table. 

The use of a RDBMS has several advantages.

* It has a persistent and very large data storage capability.}
* It can implement automated procedures to receive, screen, and store data from GPS telemetry devices.
* GPS data can be linked to complex spatial and non-spatial data in a common data structure.
* Multiple users can simultaneously access to data with different permissions levels.
* It has the ability to manage different time and spatial reference systems in the same frame.
* It has fast data search and retrieval capabilities.
* It supports controls on data consistency and reduce errors.

Spatially enabled relational database management systems (also called "spatial database", "Spatial Relational DataBase Management System - SRDBMS", "geodatabase") are database designed to store, query, and manipulate spatial data. The main advantage of SRDBMS, as compared to flat file based data storage, is that they let a GIS build on the existing capabilities of RDBMS. This includes support for SQL and the ability to generate complex geospatial queries. While traditional GIS are focused on advanced data analysis and visualization, providing a rich set of spatial operations, on few data; spatial databases allow simple spatial operations which can be efficiently undertaken on a large set of elements. This approach suits perfectly the peculiarities of GPS data. Spatial database and GIS software can be integrated in the EURODEER platform, to take advantages of both approaches.

#### SQL
The database support SQL language. SQL is short for Structured Query Language and is a simple language that provides instructions for building and modifying the structure of databases and for retrieving and modifying the data stored in the tables. 

[...]

#### Main database objects
* Schemas
* Tables
* Indices, constraints, triggers
* Views
* Sequences, Functions, Domains
* Users
* 
#### The data model 

#### Why open source tools 
[RIVEDERE: PERCHE' SONO STAtI SCELTI: NO ADDITONAL RESOURCES (ALL IN DEVELOPMENT), VERY EFFECTIVE, INTEROPERABILITY, A STANDARD IN MANY SECTION IN RESEARCH, IN LINE WITH SHARING.
STILL POSSIBLE WITH OTHER TOOLS LIKE EXAMPLES...]

Although any application that support standard database connection can be used in the EURODEER software platform frame, the database itself and many powerful applications (e.g., R, GRASS) are open source. Open source software tools were selected, first of all, because the project started (and still run\dots) without any specific financial support for software licenses. Then, because open source tools in the domain of spatial data management and analysis are efficient, powerful and able to support a web-based multi-user environment. They meet all the requirements raised in the requirement analysis as they offer a complete set of software to efficiently implement ecological applications (\cite{tufto:opensource}). Another core characteristic of open source tools relevant to the project is the use of standards, specially in the case of database software, that ensure interoperability and thus enable all the project's participants to connect the database with a large set of client applications\footnote{Adopting international data and metadata standards is the only way to ensure interoperability between different information systems, both within and outside a single organization.}. 

Finally, open source philosophy is perfectly in line with data sharing perspective that guides EURODEER project. 

## EURODEER database content
[introduction]
### Sensor data
### Additional data on individuals and populations (to be detailed)
### Environmental data


## EURODEER database objects description
[Everything is described inside he database (visible with...).
A report generated with (link) is available in (link)]

## 3 Connecting with the database
### ?? 3.1 Introduction
### 3.2 Connection parameters
--> describe limitation of users

### 4.1.1 phpPgAdmin
connect
visualize
query
download

### 4.1.2 pgAdmin 3
connect
visualize
query
download

### 4.2.1 QGIS 
connect
visualize
download

### 4.3.1 LibreOffice Base
### 4.3.2 LibreOffice Calc
### 4.4.1 R
### Other tools 
mention pgadmin4, access, excel, arcgis

# 6. User support (?)

# 7. Further readings (?)

