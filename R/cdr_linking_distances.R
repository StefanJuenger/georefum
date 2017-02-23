# cdr_linking_distances.R
#' Link Coordinates to data downloaded from the CDR by calculating minimal 
#' distances to next specified noise source
#' @param file
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' andheader...
#' @return A \code{data.frame} with minimal geographic distances for each 
#' coordinate
#'@export

cdr_linking_distances <- function(file = "",
                                  level = 65,
                                  feature.name = "Road_Lden",
                                  coords.file = "") {
  
  # case: internal, already downloaded cdr data should be used -----------------
  if (file == "") {
    message("Loading CDR data...")
    data(cdr.road.lden.dat)
    message("done.")
    
    # remove features ----------------------------------------------------------
    cdr.road.lden.dat <- 
      cdr.road.lden.dat[paste("cdr.road.lden.dat@data$", feature.name, sep = "")
                        == level,]
    
    # case: use random example coordinates -------------------------------------
    if (coords.file == "") {
      
      # load coordinates in workspace ------------------------------------------
      data("random.coords")
      
      # calculate distances ----------------------------------------------------
      message("Calculating distances...")
      ldists <- list()
      for (i in 1:dim(random.coords)[1]) {
        dists <- vector()
        dists <- append(dists, rgeos::gDistance(random.coords[i,], 
                                                cdr.road.lden.dat))
        ldists[[i]] <- dists
      }
      
      ldists <- unlist(lapply(ldists, FUN = function (x) min(x)[1]))
      message("done.")
      
      
      # link coordinates to environmental noise data ---------------------------
      dat <- as.data.frame(cbind(id2 = random.coords@data[, c("id2")],
                   ldists))
      names(dat) <- c("id2", paste("minimal_dist_", feature.name, "_", level, 
                                   sep = ""))
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
      dat <- as.data.frame(cbind(id2 = coords@data[, c("id2")],
                                 ldists))
      names(dat) <- c("id2", paste("minimal_dist_", feature.name, "_", level, 
                                   sep = ""))
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
      cdr.dat[paste("cdr.dat@data$", feature.name, sep = "")
              == level,]
    
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
      dat <- as.data.frame(cbind(id2 = random.coords@data[, c("id2")],
                                 ldists))
      names(dat) <- c("id2", paste("minimal_dist_", feature.name, "_", level, 
                                   sep = ""))
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
      dat <- as.data.frame(cbind(id2 = coords@data[, c("id2")],
                                 ldists))
      names(dat) <- c("id2", paste("minimal_dist_", feature.name, "_", level, 
                                   sep = ""))
    }
  }
  
  # remove no longer needed internal datasets ----------------------------------
  if (exists("random.coords")) {
    rm("random.coords", envir = globalenv())
  }
  if(exists("cdr.road.lden.dat")) {
    rm("cdr.road.lden.dat", envir = globalenv())
  }
  
  # return object --------------------------------------------------------------
  return(dat)
}
