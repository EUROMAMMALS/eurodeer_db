-- CREATE TABLE FIRST TIME (1 year) [about 40 minutes]
CREATE TABLE env_data_ts.winter_severity AS
  SELECT
    ST_UNION(st_reclass(rast,1, '0:255, 1:255, 11:255, 25:0, 37:0, 39:0, 50:255, 100:0, 200:200, 254:255, 255:255','16BUI', 255), 'MEAN') AS rast,
    '2000-10-01'::date AS start_date,
    '2001-03-31'::DATE AS end_date,
    2000 AS reference_year
  FROM 
    env_data_ts.snow_modis
  WHERE 
    acquisition_date >= '2000-10-01' AND
    acquisition_date <= '2001-03-31'
  GROUP BY 
    st_convexhull(rast);
  
-- ADD PKEY, INDEX AND CONSTRAINTS
ALTER TABLE env_data_ts.winter_severity ADD COLUMN id SERIAL;
ALTER TABLE env_data_ts.winter_severity ADD CONSTRAINT winter_severity_pkey PRIMARY KEY(id);
SELECT AddRasterConstraints('env_data_ts'::name, 'winter_severity'::name, 'rast'::name,'srid', 'blocksize', 'pixel_types', 'nodata_values');
CREATE INDEX winter_severity_st_convexhull_idx ON env_data_ts.winter_severity USING gist (st_convexhull(rast));

-- INSERT NEW WINTERS (must be run every year, but this is the idea)
INSERT INTO env_data_ts.winter_severity (rast, start_date, end_date, reference_year)
  SELECT
    ST_UNION(st_reclass(rast,1, '0:255, 1:255, 11:255, 25:0, 37:0, 39:0, 50:255, 100:0, 200:200, 254:255, 255:255','16BUI', 255), 'MEAN') AS rast,
    '2001-10-01'::date AS start_date,
    '2002-03-31'::DATE AS end_date,
    2001 AS reference_year
  FROM 
    env_data_ts.snow_modis
  WHERE 
    acquisition_date >= '2001-10-01' AND
    acquisition_date <= '2002-03-31'
  GROUP BY 
    st_convexhull(rast);

-- EXPORT
-- First create a table where you union all the tiles of a single year
CREATE TABLE 
 temp.raster_export as
SELECT 
  st_union(rast) AS rast 
FROM 
  env_data_ts.winter_severity 
where 
  reference_year = 2001;
-- Then add constraint
SELECT AddRasterConstraints('temp'::name, 'raster_export'::name, 'rast'::name);

-- Now you can visualiz e.g. in QGIS (pretty fast) or export to a file using GDAL (very fast on the server, slow for remote users)
gdal_translate -of GTIFF "PG:host=localhost dbname='eurodeer_db' user='????' password='?????' schema='temp' table='raster_export' mode=2" E:\eurodeer_data\raster\remote_sensing\modis\winter_severity\winter_severity_2001.tif

-- Remove temp table
DROP TABLE temp.raster_export;
