--TO UPDATE THE RED DEER DATA, REPLACE MAIN.GPS_DATA_ANIMALS WITH MAIN_REDDEER.GPS_DATA_ANIMALS

----------------
-- MODIS SNOW --
----------------

update main.gps_data_animals
set snow_modis = st_value(rast, geom)
from env_data_ts.snow_modis
where
gps_validity_code = 1 and 
snow_modis is null and 
st_intersects(geom, rast) and 
acquisition_time::date >= snow_modis.acquisition_date and  
acquisition_time::date <  
(case 
  when extract (year from (snow_modis.acquisition_date + INTERVAL '8 days')) = extract (year from (snow_modis.acquisition_date)) then (snow_modis.acquisition_date + INTERVAL '8 days')
  else ('1-1-' || extract (year from snow_modis.acquisition_date)+1)::date
END)  ;

----------------
-- MODIS NDVI --
----------------
update main.gps_data_animals
set ndvi_modis = st_value(rast, geom)
from env_data_ts.ndvi_modis
where
gps_validity_code = 1 and 
ndvi_modis is null and 
st_intersects(geom, rast) and 
acquisition_time::date >= ndvi_modis.acquisition_date and  
acquisition_time::date <  
(case 
  when extract (year from (ndvi_modis.acquisition_date + INTERVAL '16 days')) = extract (year from (ndvi_modis.acquisition_date)) then (ndvi_modis.acquisition_date + INTERVAL '16 days')
  else ('1-1-' || extract (year from ndvi_modis.acquisition_date)+1)::date
END)  ;

-------------------------
-- MODIS NDVI SMOOTHED --
-------------------------
update
main.gps_data_animals
set
ndvi_modis_smoothed =
(st_value(pre.rast, geom)*(post.acquisition_date - acquisition_time::date)/(post.acquisition_date - pre.acquisition_date) +
st_value(post.rast, geom)*(- (pre.acquisition_date - acquisition_time::date))/(post.acquisition_date - pre.acquisition_date)) * 0.0048 -0.2
from  
env_data_ts.ndvi_modis_smoothed pre,
env_data_ts.ndvi_modis_smoothed post
where
ndvi_modis_smoothed IS NULL AND 
gps_validity_code = 1 and 
st_intersects(geom, pre.rast) and 
st_intersects(geom, post.rast) and 
pre.acquisition_date = 
case 
when extract ('day' from acquisition_time) < 6 then (extract('year' from acquisition_time::date -6 )||'-'||extract ('month' from acquisition_time::date - 6)||'-26')::date
when extract ('day' from acquisition_time) < 16 then (extract('year' from acquisition_time::date)||'-'||extract ('month' from acquisition_time::date)||'-06')::date
when extract ('day' from acquisition_time) < 26 then (extract('year' from acquisition_time::date)||'-'||extract ('month' from acquisition_time::date)||'-16')::date
else  (extract('year' from acquisition_time::date)||'-'||extract ('month' from acquisition_time::date)||'-26')::date end
 and
post.acquisition_date = 
case 
when extract ('day' from acquisition_time) < 6 then (extract('year' from acquisition_time::date)||'-'||extract ('month' from acquisition_time::date)||'-06')::date
when extract ('day' from acquisition_time) < 16 then (extract('year' from acquisition_time::date)||'-'||extract ('month' from acquisition_time::date)||'-16')::date
when extract ('day' from acquisition_time) < 26 then (extract('year' from acquisition_time::date)||'-'||extract ('month' from acquisition_time::date)||'-26')::date
else  (extract('year' from acquisition_time::date+6)||'-'||extract ('month' from acquisition_time::date+6)||'-06')::date end;

---------------------
-- MODIS NDVI BOKU --
---------------------
update main.gps_data_animals
set ndvi_modis_boku =
trunc((st_value(pre.rast, geom) * (date_trunc('week', acquisition_time::date + 7)::date -acquisition_time::date)::integer +
st_value(post.rast, geom) * (acquisition_time::date - date_trunc('week', acquisition_time::date)::date))::integer/7)
from  
env_data_ts.ndvi_modis_boku pre,
env_data_ts.ndvi_modis_boku post,
where
ndvi_modis_boku IS NULL AND gps_validity_code = 1 and 
st_intersects(geom, pre.rast) and 
st_intersects(geom, post.rast) and 
date_trunc('week', acquisition_time::date)::date = pre.acquisition_date and 
date_trunc('week', acquisition_time::date + 7)::date = post.acquisition_date;





------------------------------------------
------------------------------------------
------------------------------------------
-- SPOT VEGETATION (not active anymore) --
------------------------------------------
update main.gps_data_animals
set fapar_vegetation = st_value(rast, geom)
from env_data_ts.fapar_vegetation
where fapar_vegetation is null and gps_validity_code = 1 and st_intersects(geom, rast) and  extract(year from fapar_vegetation.acquisition_date) = extract(year from gps_data_animals.acquisition_time)
and extract(month from fapar_vegetation.acquisition_date) = extract(month from gps_data_animals.acquisition_time)
and extract(day from fapar_vegetation.acquisition_date) = CASE
WHEN extract(day from gps_data_animals.acquisition_time) < 11 THEN 1
WHEN extract(day from gps_data_animals.acquisition_time) < 21 THEN 11
ELSE 21
END;

update main.gps_data_animals
set ndvi_vegetation = st_value(rast, geom)
from env_data_ts.ndvi_vegetation
where gps_validity_code = 1 and ndvi_vegetation is null and st_intersects(geom, rast) and  extract(year from ndvi_vegetation.acquisition_date) = extract(year from gps_data_animals.acquisition_time)
and extract(month from ndvi_vegetation.acquisition_date) = extract(month from gps_data_animals.acquisition_time)
and extract(day from ndvi_vegetation.acquisition_date) = CASE
WHEN extract(day from gps_data_animals.acquisition_time) < 11 THEN 1
WHEN extract(day from gps_data_animals.acquisition_time) < 21 THEN 11
ELSE 21
END;
