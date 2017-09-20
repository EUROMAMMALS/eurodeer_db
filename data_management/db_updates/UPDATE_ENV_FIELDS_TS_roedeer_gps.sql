----------------
-- MODIS SNOW --
----------------
UPDATE main.gps_data_animals
SET snow_modis = st_value(rast, geom)
FROM env_data_ts.snow_modis
WHERE
  gps_validity_code in (1,2,3) and 
  snow_modis is null and 
  st_intersects(geom, rast) and 
  acquisition_time::date >= snow_modis.acquisition_date and  
  acquisition_time::date <  
    (case 
      WHEN extract (year FROM (snow_modis.acquisition_date + INTERVAL '8 days')) = extract (year FROM (snow_modis.acquisition_date)) then (snow_modis.acquisition_date + INTERVAL '8 days')
      else ('1-1-' || extract (year FROM snow_modis.acquisition_date)+1)::date
    END);

----------------
-- MODIS NDVI --
----------------
UPDATE main.gps_data_animals
SET ndvi_modis = (st_value(rast, geom))/10000
FROM env_data_ts.ndvi_modis
WHERE
  gps_validity_code in (1,2,3) and 
  ndvi_modis is null and 
  st_intersects(geom, rast) and 
  acquisition_time::date >= ndvi_modis.acquisition_date and  
  acquisition_time::date <  
    (case 
    WHEN extract (year FROM (ndvi_modis.acquisition_date + INTERVAL '16 days')) = extract (year FROM (ndvi_modis.acquisition_date)) then (ndvi_modis.acquisition_date + INTERVAL '16 days')
    else ('1-1-' || extract (year FROM ndvi_modis.acquisition_date)+1)::date
    END)  ;

-------------------------
-- MODIS NDVI SMOOTHED --
-------------------------
UPDATE
main.gps_data_animals
SET
ndvi_modis_smoothed = (st_value(pre.rast, geom)*(post.acquisition_date - acquisition_time::date)/(post.acquisition_date - pre.acquisition_date) +
st_value(post.rast, geom)*(- (pre.acquisition_date - acquisition_time::date))/(post.acquisition_date - pre.acquisition_date)) * 0.0048 -0.2
FROM env_data_ts.ndvi_modis_smoothed pre, env_data_ts.ndvi_modis_smoothed post
WHERE
  ndvi_modis_smoothed IS NULL AND 
  gps_validity_code in (1,2,3) and 
  st_intersects(geom, pre.rast) and 
  st_intersects(geom, post.rast) and 
  pre.acquisition_date = 
    case 
    WHEN extract ('day' FROM acquisition_time) < 6 then (extract('year' FROM acquisition_time::date -6 )||'-'||extract ('month' FROM acquisition_time::date - 6)||'-26')::date
    WHEN extract ('day' FROM acquisition_time) < 16 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-06')::date
    WHEN extract ('day' FROM acquisition_time) < 26 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-16')::date
    else  (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-26')::date end and
  post.acquisition_date = 
    case 
    WHEN extract ('day' FROM acquisition_time) < 6 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-06')::date
    WHEN extract ('day' FROM acquisition_time) < 16 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-16')::date
    WHEN extract ('day' FROM acquisition_time) < 26 then (extract('year' FROM acquisition_time::date)||'-'||extract ('month' FROM acquisition_time::date)||'-26')::date
    else  (extract('year' FROM acquisition_time::date+6)||'-'||extract ('month' FROM acquisition_time::date+6)||'-06')::date end;

---------------------
-- MODIS NDVI BOKU --
---------------------
UPDATE main.gps_data_animals
SET ndvi_modis_boku = (trunc((st_value(pre.rast, geom) * (date_trunc('week', acquisition_time::date + 7)::date -acquisition_time::date)::integer +
st_value(post.rast, geom) * (acquisition_time::date - date_trunc('week', acquisition_time::date)::date))::integer/7)) * 0.0048 -0.2
FROM env_data_ts.ndvi_modis_boku pre, env_data_ts.ndvi_modis_boku post
WHERE
  ndvi_modis_boku IS NULL AND gps_validity_code in (1,2,3) and 
  st_intersects(geom, pre.rast) and 
  st_intersects(geom, post.rast) and 
  date_trunc('week', acquisition_time::date)::date = pre.acquisition_date and 
  date_trunc('week', acquisition_time::date + 7)::date = post.acquisition_date;

----------------
-- DEPRECATED --
----------------
----------------------
--  SPOT VEGETATION --
----------------------
UPDATE main.gps_data_animals
SET fapar_vegetation = st_value(rast, geom)
FROM env_data_ts.fapar_vegetation
WHERE fapar_vegetation is null and gps_validity_code = 1 and st_intersects(geom, rast) and  extract(year FROM fapar_vegetation.acquisition_date) = extract(year FROM gps_data_animals.acquisition_time)
and extract(month FROM fapar_vegetation.acquisition_date) = extract(month FROM gps_data_animals.acquisition_time)
and extract(day FROM fapar_vegetation.acquisition_date) = CASE
WHEN extract(day FROM gps_data_animals.acquisition_time) < 11 THEN 1
WHEN extract(day FROM gps_data_animals.acquisition_time) < 21 THEN 11
ELSE 21
END;
UPDATE main.gps_data_animals
SET ndvi_vegetation = st_value(rast, geom)
FROM env_data_ts.ndvi_vegetation
WHERE gps_validity_code = 1 and ndvi_vegetation is null and st_intersects(geom, rast) and  extract(year FROM ndvi_vegetation.acquisition_date) = extract(year FROM gps_data_animals.acquisition_time)
and extract(month FROM ndvi_vegetation.acquisition_date) = extract(month FROM gps_data_animals.acquisition_time)
and extract(day FROM ndvi_vegetation.acquisition_date) = CASE
WHEN extract(day FROM gps_data_animals.acquisition_time) < 11 THEN 1
WHEN extract(day FROM gps_data_animals.acquisition_time) < 21 THEN 11
ELSE 21
END;
