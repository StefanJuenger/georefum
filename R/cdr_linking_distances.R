# cdr_linking_distances.R
#' Link Coordinates to data downloaded from the CDR by calculating distances
#' @param file
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' andheader...
#' @return A \code{data.frame} with geographic distances for each coordinate
#'@export

cdr_linking_simple <- function(file = "",
                               level = 65,
                               coords.file = "") {
  
  # case: internal, already downloaded cdr data should be used -----------------
  if (file == "") {
    data(cdr.road.lden.dat)
    
    # remove features ----------------------------------------------------------
    cdr.road.lden.dat <- 
      cdr.road.lden.dat[cdr.road.lden.dat@data$Road_Lden == level,]
    
    # case: use random example coordinates -------------------------------------
    if (coords.file == "") {
      
      # load coordinates in workspace ------------------------------------------
      data("random.coords")
      
      # calculate distances ----------------------------------------------------
      ldists <- list()
      for (i in 1:dim(random.coords)[1]) {
        dists <- vector()
        dists <- append(dists, rgeos::gDistance(random.coords[i,], 
                                                cdr.road.lden.dat))
        ldists[[i]] <- dists
      }
      
      ldists <- unlist(lapply(ldists, FUN = function (x) min(x)[1]))
      
      # link coordinates to environmental noise data ---------------------------
      dat <- cbind(id2 = random.coords@data[, c("id2")],
                   ldists)
    }
    
    # case: use own coordinates ------------------------------------------------
    else {
      
      # load coordinates in workspace ------------------------------------------
      coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
      coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                       proj4string = CRS("+init=epsg:3035"))
      
      # calculate distances ----------------------------------------------------
      ldists <- list()
      for (i in 1:dim(coords)[1]) {
        dists <- vector()
        dists <- append(dists, rgeos::gDistance(coords[i,], 
                                                cdr.road.lden.dat))
        ldists[[i]] <- dists
      }
      
      ldists <- unlist(lapply(ldists, FUN = function (x) min(x)[1]))
      
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
    
    # remove features ----------------------------------------------------------
    cdr.dat <- 
      cdr.dat[cdr.dat@data$Road_Lden == level,]
    
    # case: use random example coordinates -------------------------------------
    if (coords.file == "") {
      
      # load coordinates in workspace ------------------------------------------
      data("random.coords")
      
      # calculate distances ----------------------------------------------------
      ldists <- list()
      for (i in 1:dim(random.coords)[1]) {
        dists <- vector()
        dists <- append(dists, rgeos::gDistance(random.coords[i,], 
                                                cdr.dat))
        ldists[[i]] <- dists
      }
      
      ldists <- unlist(lapply(ldists, FUN = function (x) min(x)[1]))
      
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
      
      # calculate distances ----------------------------------------------------
      ldists <- list()
      for (i in 1:dim(coords)[1]) {
        dists <- vector()
        dists <- append(dists, rgeos::gDistance(coords[i,], 
                                                cdr.dat))
        ldists[[i]] <- dists
      }
      
      ldists <- unlist(lapply(ldists, FUN = function (x) min(x)[1]))
      
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
