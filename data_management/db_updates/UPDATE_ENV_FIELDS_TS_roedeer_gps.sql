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

-------------------------
-- MODIS NDVI SMOOTHED --
-------------------------
UPDATE
main.gps_data_animals
SET
ndvi_modis_smoothed = (st_value(pre.rast, geom)*(post.acquisition_date - acquisition_time::date)/(post.acquisition_date - pre.acquisition_date) +
st_value(post.rast, geom)*(- (pre.acquisition_date - acquisition_time::date))/(post.acquisition_date - pre.acquisition_date))
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
