# simple.linking.R
#'
#'@export

simple.linking <- function(obj.name = "linked.data",
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
}

#
# simple.linking <- function(data.path,
#                            coordinate.file,
#                            create.raster = FALSE,
#                            download.raster = FALSE,
#                            neighbourhood.matrix = c(1, 1, 1,
#                                                     1, 1, 1,
#                                                     1, 1, 1),
#                            fun = mean){
#   data(census.attr)
#
#
# }
