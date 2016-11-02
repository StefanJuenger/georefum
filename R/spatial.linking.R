# spatial.linking.R
#'
#'@export

# linking function that support plain and simple spatial linking ---------------
simple.clinking <- function(obj.name = "linked.data",
                           download = FALSE,
                           data.path = ".",
                           rasterize = FALSE,
                           coords.file = FALSE,
                           create.raster = FALSE,
                           download.raster = FALSE){

  # download census data from zensus2011.de if toggled -------------------------
  if(download == TRUE){
    cat("Downloading census data")
    download.census.1km()
    #download.census.100m()
  } else{
    data(census.attr)
  }

  # rasterize data? ------------------------------------------------------------
  if(rasterize == TRUE){
    rasterize.census(data.path)
  }

  # use example coordinates? ---------------------------------------------------
  if(coords.file == FALSE){
  data(random.coords)
  } else{
    coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
    coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                     proj4string = CRS("+init=epsg:3035"))
  }

  # set missing values in census data ------------------------------------------
  for(i in names(census.attr)){
    eval(parse(text = paste("census.attr$", i, "[census.attr$", i,
                            "== -1] <- NA", sep = "")))
    eval(parse(text = paste("census.attr$", i, "[census.attr$", i,
                            "[] == -9] <- NA", sep = "")))
  }

  # link coordinates with census data ------------------------------------------
  for(i in names(census.attr)){
    if(!exists("dat")){
      eval(parse(text = paste("dat <- data.frame(", i,
                              " = SDMTools::extract.data(random.coords@coords,",
                              " census.attr$", i, "))")))
    }
    else{
      eval(parse(text = paste("dat <- data.frame(cbind(dat,", i,
                              " = SDMTools::extract.data(random.coords@coords,",
                              " census.attr$", i, ")))")))
    }
    # assign object name -------------------------------------------------------
    eval(parse(text = paste(obj.name, " <<- dat", sep = "")))
  }
  # detach no longer needed internal datasets
  detach(census.attr)
  detach(random.coords)
}

# linking function that supports focal analyses --------------------------------
focal.clinking <- function(obj.name = "linked.data",
                           download = FALSE,
                           data.path = ".",
                           rasterize = FALSE,
                           coords.file = FALSE,
                           create.raster = FALSE,
                           download.raster = FALSE,
                           focal.matrix = matrix(c(1, 1, 1,                                                                                                  1, 1, 1,
                                                   1, 1, 1), nr = 3, nc = 3),
                           fun = "mean"){

  # download census data from zensus2011.de if toggled -------------------------
  if(download == TRUE){
    cat("Downloading census data")
    download.census.1km()
    #download.census.100m()
  } else{
    data(census.attr)
  }

  # rasterize data? ------------------------------------------------------------
  if(rasterize == TRUE){
    rasterize.census(data.path)
  }

  # use example coordinates? ---------------------------------------------------
  if(coords.file == FALSE){
    data(random.coords)
  } else{
    coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
    coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                     proj4string = CRS("+init=epsg:3035"))
  }

  # set missing values in census data ------------------------------------------
  for(i in names(census.attr)){
    eval(parse(text = paste("census.attr$", i, "[census.attr$", i,
                            "[] == -1] <- NA", sep = "")))
    eval(parse(text = paste("census.attr$", i, "[census.attr$", i,
                            "[] == -9] <- NA", sep = "")))
  }

  # focal analyses -------------------------------------------------------------
  if(fun == "mean"){
    for(i in names(census.attr)){
      if(!exists("dat")){
        eval(parse(text = paste("dat <- data.frame(", i,
                                ".mean = ",
                                "SDMTools::extract.data(random.coords@coords, ",
                                "raster::focal(census.attr$", i,
                                ", w = focal.matrix, ",
                                "fun = ",
                                "function(x){mean(x[-which(is.na(x))])})))",
                                sep = "")))
      } else{
        eval(parse(text = paste("dat <- data.frame(cbind(dat, ", i,
                                ".mean = ",
                                "SDMTools::extract.data(random.coords@coords, ",
                                "raster::focal(census.attr$", i,
                                ", w = focal.matrix, ",
                                "fun = ",
                                "function(x){mean(x[-which(is.na(x))])}))))",
                                sep = "")))
      }
      eval(parse(text = paste(obj.name, " <<- dat", sep = "")))
    }
  }

  # detach no longer needed internal datasets
  detach(census.attr)
  detach(random.coords)
}

