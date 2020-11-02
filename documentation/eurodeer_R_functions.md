# Download NDVI MODIS BOKU raster layers 

```R
# LOAD FUNCTION
library(RCurl)
script <- getURL("https://raw.githubusercontent.com/feurbano/eurodeer_db/master/data_analysis/r_functions/eurodeer_extract_ndvi_modis_boku.R", ssl.verifypeer= FALSE)
eval(parse(text = script))

# CONNECT TO THE DATABASE
con<-dbConnect("PostgreSQL",
dbname='eurodeer_db',
host='eurodeer2.fmach.it',
user=u, # username
password=pw) # password

# EXTRACT NDVI MODIS BOKU USING STUDY AREAS ID
# EXAMPLE BAVARIAN FOREST (study area 2) AND BONDONE (study area 1)
r <- eurodeer_extract_ndvi_modis_boku(con=con,
                                      #dir=paste0('NDVI_',gsub('-','',Sys.Date())), # name of the directory where to download the rasters to
                                      #schema='temp', # schema where temporary tables are generated
                                      sa = c(1,2), # eurodeer study area id
                                      buffer= 25000, # buffer around the study area
                                      period=c('2017-01-20', '2017-02-08'), # start and end time
                                      load=TRUE) # whether the rasters need to be loaded in R - TRUE/FALSE
# rescale original scale (0-250) to the NDVI scale (-0.2 to 1). Values larger than 1 are missing values (255=1.024) or water (251=1.0048; 252=1.0096)
r <- lapply(r, function(x) x * 0.0048 - 0.2) # rescale between -0.2 and 1 
for(i in 1:length(r)){r[[i]][r[[i]] > 1] <- NA} # replace values > 1 with NA (water or missing values)


# EXTRACT NDVI MODIS BOKU USING POLYGON
# A fake ID is generated for each polygon in the shapefile
# Note that NDVI rasters will be extracted for EACH polygon stored in the sf object.
pop <-st_read('~/StudyAreasBavaria.shp',crs=4326) # make sure to set the coordinate reference system correctly
r <- eurodeer_extract_ndvi_modis_boku(con=con,
                                      dir=paste0('NDVI_',gsub('-','',Sys.Date())),
                                      schema='temp',
                                      sa = pop, # SF object
                                      buffer= 25000,
                                      period=c('2017-01-20', '2017-02-08'),
                                      load=TRUE) # import them in R
```
