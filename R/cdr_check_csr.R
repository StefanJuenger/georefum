# check.CSR.R
#' Check for missing corrdinate systems in shape files and export it to text
#' file
#' @export

check.CSR <- function(data.path, out.file){
  # create a list of all shp files
  shp.files <- list.files(data.path, recursive = TRUE, full.names = TRUE)[
    grep(c(".shp|SHP"), list.files(data.path, recursive = TRUE,
                                   full.names = TRUE))]
  lapply(shp.files, function(x){
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
