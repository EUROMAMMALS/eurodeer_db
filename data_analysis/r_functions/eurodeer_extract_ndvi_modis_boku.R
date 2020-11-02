#' save and load ndvi modis boku data from the database
#'
#' @param con connection to postgresql database
#' @param dir name of the directory, default is NDVI_<date>
#' @param schema schema where temporary tables are generated, default is the temp schema
#' @param sa sf object with the study areas of interest or the eurodeer study area identifier e.g., c(1,2) 
#' @param buffer a buffer expressed in meter around the study area, default is 25000  
#' @param period start and end time. e.g., c('2017-01-20', '2017-02-08')
#' @param load boolean whether a raster stack is generated in R, default is TRUE   
#'
#' @return rasters in png,tif,asc; a list of raster stacks, one stack per population
#'
#' @export
#'
#' @examples
#' 
#' # CONNECT TO THE DATABASE
#' con<-dbConnect("PostgreSQL",
#' dbname='eurodeer_db',
#' host='eurodeer2.fmach.it', 
#' user=u, # username
#' password=pw) # password
#' 
#' # EXTRACT NDVI MODIS BOKU USING STUDY AREAS ID
#' # EXAMPLE BAVARIAN FOREST
#' r <- eurodeer_extract_ndvi_modis_boku(con=con,
#'                                       #dir=paste0('NDVI_',gsub('-','',Sys.Date())), # name of the directory
#'                                       #schema='temp', # schema where temporary tables are generated
#'                                       sa = c(1,2), # eurodeer study area id
#'                                       buffer= 25000, # buffer around the study area
#'                                       period=c('2017-01-20', '2017-02-08'), # start and end time
#'                                       load=TRUE) # whether the rasters need to be loaded in R - TRUE/FALSE
#' 
#' # EXTRACT NDVI MODIS BOKU USING POLYGON
#' # A fake ID is generated for each polygon in the shapefile
#' # Note that NDVI rasters will be extracted for EACH polygon stored in the sf object.
#' pop <-st_read('~/StudyAreasBavaria.shp',crs=4326) # make sure to set the coordinate reference system correctly
#' r <- eurodeer_extract_ndvi_modis_boku(con=con,
#'                                       dir=paste0('NDVI_',gsub('-','',Sys.Date())),
#'                                       schema='temp',
#'                                       sa = pop, # SF object
#'                                       buffer= 25000,
#'                                       period=c('2017-01-20', '2017-02-08'),
#'                                       load=TRUE) # import them in R
eurodeer_extract_ndvi_modis_boku <- function(con = con, dir=paste0('NDVI_',gsub('-','',Sys.Date())),schema='temp', sa = c(1,2), buffer= 25000,period=c('2017-01-20', '2017-02-08'), load=TRUE){
  # con = database connection
  # dir = specify the directory name 
  # schema = where to store the temporary tables - standard in the temp schema 
  # sa = id's of the study areas or sf object with one polygon per study area
  # buffer = buffer in m around the populations 
  # period = time period for which NDVI MODIS BOKU raster layers need to be extracted
  
  library(rpostgis)
  library(raster)
  library(sf)
  
  # SELECT STUDY AREA
  
  # STUDY AREA ID IN THE DATABASE 
  if(is.numeric(sa)){
    sas <- paste0(sa,collapse=',')
    sa_query <- paste0("CREATE TABLE ",schema,".temp_bbox as (
                        SELECT study_areas_id, ST_TRANSFORM(ST_BUFFER(ST_TRANSFORM(ST_ConvexHull(ST_Collect(geom)),3035),",buffer,"),4326) buff_geom
                        FROM main.gps_data_animals join main.animals using (animals_id) 
                        WHERE study_areas_id in (", sas ,") AND gps_validity_code = 1 
                        GROUP BY study_areas_id);")
    dbSendQuery(con, sa_query)
  }
  # SHAPEFILE - SF 
  if('sf' %in% class(sa)){
    sa$study_areas_id <- c(1000:(1000+nrow(sa)-1)) 
    sa <- sa[,c('study_areas_id')]; colnames(sa) <- c('study_areas_id','geom'); st_geometry(sa) <- "geom"
    st_write(sa,con, c(schema,'temp_bbox_raw'))
    sa_query <- paste0("CREATE TABLE ", schema ,".temp_bbox as (
              SELECT study_areas_id, ST_TRANSFORM(ST_BUFFER(ST_TRANSFORM(ST_ConvexHull(ST_Collect(geom)),3035),",buffer,"),4326) buff_geom
              FROM ", schema ,".temp_bbox_raw
              GROUP BY study_areas_id);")
    dbSendQuery(con, sa_query)
    dbSendQuery(con, paste0("DROP TABLE ", schema ,".temp_bbox_raw;"))
  }
  
# NDVI TABLE FOR THIS BOUNDING BOX 
  ndviseries_query <- paste0("CREATE TABLE ",schema,".temp_ndvi_modis_boku AS (
    SELECT study_areas_id, a.rid, ST_clip(rast,st_envelope(buff_geom),true) rast, acquisition_date 
    FROM env_data_ts.ndvi_modis_boku a,",schema,".temp_bbox b
    WHERE 
    ST_Intersects(st_envelope(buff_geom),rast) and
    acquisition_date between '",period[1],"' and '",period[2],"'
    );")
  dbSendQuery(con, ndviseries_query)
  dbSendQuery(con, paste0("CREATE INDEX temp_bbox_gist ON ",schema,".temp_ndvi_modis_boku USING gist (ST_ConvexHull(rast));"))
  
  # REMOVE THE BBOX TABLE 
  dbSendQuery(con, paste0("DROP TABLE ",schema,".temp_bbox;"))

  # CREATE A FOLDER IN HOME DIRECTORY 
  setwd('~'); dir.create(dir); setwd(dir); dir.create('ndvi_modis_asc'); dir.create('ndvi_modis_tif'); dir.create('ndvi_modis_png')

  tab <- dbGetQuery(con, paste0("SELECT DISTINCT study_areas_id, acquisition_date FROM ",schema,".temp_ndvi_modis_boku ORDER BY study_areas_id, acquisition_date"))
  # loop to export ndvi layers per timestamp and study area
  for ( i in 1:nrow(tab)){
    # First import in the database a table with one record for a specific timestamp and study area
    dbWriteTable(con,tab[i,],name = c(schema,'temp_record'), overwrite=TRUE)
    # create a new table in the database with all the raster tiles for a specific timestamp and study area (one study area covers multiple tiles)
    if(i != 1){
    dbSendQuery(con, paste0("drop table ",schema,".temp_ndvi_samp"))
    }
    dbSendQuery(con, paste0("create table ",schema,".temp_ndvi_samp AS SELECT a.rid, a.rast, a.study_areas_id, a.acquisition_date FROM ",schema,".temp_record JOIN ",schema,".temp_ndvi_modis_boku a USING (study_areas_id, acquisition_date);"))
    # import the raster in r with pgGetRast, pgGetRast will automatically merge the tiles. 
    r <- pgGetRast(con,name =c(schema,'temp_ndvi_samp') ,rast='rast')
    
    
    # export raster data locally
    writeRaster(r, filename=paste0('ndvi_modis_asc/ndvi_modis_boku_sa',tab[i,'study_areas_id'],'_',gsub('-','',tab[i,'acquisition_date'])), format='ascii', overwrite=TRUE)
    writeRaster(r, filename=paste0('ndvi_modis_tif/ndvi_modis_boku_sa',tab[i,'study_areas_id'],'_',gsub('-','',tab[i,'acquisition_date'])), format='GTiff', overwrite=TRUE)
    # export as png to double check the output 
    png(paste0('ndvi_modis_png/ndvi_modis_boku_sa',tab[i,'study_areas_id'],'_',gsub('-','',tab[i,'acquisition_date'])))
    plot(r,paste0(tab[i,'study_areas_id'],'_',gsub('-','',tab[i,'acquisition_date']),'_',tab[i,'rid']))
    dev.off()
  }
  dbSendQuery(con, paste0("DROP TABLE ",schema,".temp_ndvi_modis_boku;"))
  dbSendQuery(con, paste0("DROP TABLE ",schema,".temp_record;"))
  dbSendQuery(con, paste0("DROP TABLE ",schema,".temp_ndvi_samp;"))
  
  # disconnect from the database 
  dbClearResult(dbListResults(con)[[1]])
  lapply(dbListConnections(drv = dbDriver("PostgreSQL")), function(x) {dbDisconnect(conn = con)})   

  # LOAD THE RASTER STACKS IN R 
  if(load){
  list_files <- list.files(path= paste0(getwd(),'/ndvi_modis_tif/') ,pattern='ndvi_modis_boku_sa')
  sa_names <- as.vector(unlist(lapply(strsplit(list_files, '_'), function(x) x[4])))
  list_files <- list.files(path= paste0(getwd(),'/ndvi_modis_tif/') ,pattern='ndvi_modis_boku_sa',full.names = T)
  list_files_l <- split(list_files, f=sa_names)
  if(length(unique(sa_names)) > 1){
     r <- lapply(list_files_l, function(x) stack(x))
     names(unique(sa_names))
   } else {
     if(length(unique(sa_names)) == 1){
       r <- stack(list_files)
     }
   }
  return(r)
  }
}





