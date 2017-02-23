# cdr_linking_simple.R
#' Link Coordinates to data downloaded from the CDR
#' @param file
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' andheader...
#' @return A \code{data.frame} with environmental noise attributes for each 
#'         coordinate
#' @export

cdr_linking_simple <- function(file = "",
                               coords.file = "") {

  # case: internal, already downloaded cdr data should be used -----------------
  if (file == "") {
    data(cdr.road.lden.dat)

    # case: use random example coordinates -------------------------------------
    if (coords.file == "") {

      # load coordinates in workspace ------------------------------------------
      data("random.coords")

      # link coordinates to environmental noise data ---------------------------
      dat <- cbind(id2 = random.coords@data[, c("id2")],
                   sp::over(random.coords, cdr.road.lden.dat))
    }

    # case: use own coordinates ------------------------------------------------
    else {

      # load coordinates in workspace ------------------------------------------
      coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
      coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                       proj4string = CRS("+init=epsg:3035"))

      # link coordinates to environmental noise data ---------------------------
      dat <- cbind(id2 = coords@data[, c("id2")],
                   sp::over(coords, cdr.road.lden.dat))

    }

  }

  # case: own, already prepared cdr data should be used ------------------------
  else {
    cdr.dat <- rgdal::readOGR(rgdal::readOGR(basename(file),
                                             basename(paste(
                                               substr(file, 1, nchar(file)-4),
                                               sep = ''))))

    # case: use random example coordinates -------------------------------------
    if (coords.file == "") {

      # load coordinates in workspace ------------------------------------------
      data("random.coords")

      # link coordinates to environmental noise data ---------------------------
      dat <- cbind(id2 = random.coords@data[, c("id2")],
                   sp::over(random.coords, cdr.dat))
    }

    # case: use own coordinates ------------------------------------------------
    else {

      # load coordinates in workspace ------------------------------------------
      coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
      coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                       proj4string = CRS("+init=epsg:3035"))

      # link coordinates to environmental noise data ---------------------------
      dat <- cbind(id2 = coords@data[, c("id2")],
                   sp::over(coords, cdr.dat))

    }
  }

  # remove no longer needed internal datasets ----------------------------------
  if (exists("random.coords")) {
    rm("random.coords", envir = globalenv())
  }
  if(exists("cdr.road.lden.dat")) {
    rm("census.shapes", envir = globalenv())
  }

  # return object --------------------------------------------------------------
  return(dat)
}
