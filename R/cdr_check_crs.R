# cdr_check_crs.R
#' Check for missing coordinate systems in shape files and export it to text
#' file
#' @description Check for missing coordinate systems in shape files and export 
#' it to text file. Initially developed for environmental noise data from the 
#' CDR it also can be used for all locations storing a bunch of ESRI shapefiles.
#' @param data.path Directory to check for missing CRS
#' @param out.file Location and name of output text file
#' @export

cdr_check_crs <- function(data.path, out.file) {
  
  # create recursive list of all shp files in data.path ------------------------
  shp.files <- list.files(data.path, recursive = TRUE, full.names = TRUE)[
    grep(c(".shp|SHP"), list.files(data.path, recursive = TRUE,
                                   full.names = TRUE))]
  
  # read in all shp files, check for missing CSR and write in list -------------
  lapply(shp.files, function (x) {
    setwd(dirname(x))
    data <- readOGR(basename(x),
                    basename(paste(substr(x, 1, nchar(x)-4), sep = "")))
    if(is.na(proj4string(data))){
      cat(x, file = out.file,
          sep = "\n", append = TRUE)
    }
    rm(data)
  })
}
