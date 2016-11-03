# WARNING: obsolete, now in functions census_linking_simple.R and census_linking_focal.R


# spatial.linking.R
#'
#'@export

# linking function that support plain and simple spatial linking ---------------
simple.clinking <- function(#obj.name = "linked.data",
                            download = FALSE,
                            own.data = FALSE,
                            data.path = ".",
                            #rasterize = FALSE,
                            coords.file = "",
                            #create.raster = FALSE,
                            download.raster = FALSE){

  # case: census data should be downloaded -------------------------------------
  if(download == TRUE){
    cat("Downloading census data")
    download.census.1km()
    #download.census.100m()

    # rasterize downloaded data ------------------------------------------------
    rasterize.census(data.path)
  }

  # case: own, already downloaded census data should be used -------------------
  if(own.data == TRUE){
    rasterize.census(data.path)
  }

  # case: internal, already downloaded census data should be used --------------
  if(download == FALSE & own.data == FALSE){
    data(census.attr)
  }

  # set missing values in census data ------------------------------------------
  for(i in names(census.attr)){
    eval(
      parse(
        text = paste("census.attr$", i, "[census.attr$", i, "[] == -1] <- NA",
                     sep = "")))
    eval(
      parse(
        text = paste("census.attr$", i, "[census.attr$", i,"[] == -9] <- NA",
                     sep = "")))
  }

  # case: use random example coordinates ---------------------------------------
  if(coords.file == ""){
    data(random.coords)
  }

  # case: use own coordinates --------------------------------------------------
  else{
    coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
    coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                     proj4string = CRS("+init=epsg:3035"))
  }

  # link coordinates with census data ------------------------------------------

  # case: no own coordinates file was provided ---------------------------------
  if(coords.file == ""){

    # run linking on all census attributes -------------------------------------
    for(i in names(census.attr)){

      # case: object does not exist yet ----------------------------------------
      if(!exists("dat")){
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         " = SDMTools::extract.data(random.coords@coords,",
                         " census.attr$", i, "))")))
      }

      # case: object already exists --------------------------------------------
      else{
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat,", i,
                         " = SDMTools::extract.data(random.coords@coords,",
                         " census.attr$", i, ")))")))
      }
    }
  }

  # case: use own coordinates --------------------------------------------------
  else{

    # run linking on all census attributes -------------------------------------
    for(i in names(census.attr)){

      # case: object does not exist yet ----------------------------------------
      if(!exists("dat")){
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         " = SDMTools::extract.data(coords@coords,",
                         " census.attr$", i, "))")))
      }

      # case: object already exists --------------------------------------------
      else{
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat,", i,
                         " = SDMTools::extract.data(coords@coords,",
                         " census.attr$", i, ")))")))
      }
    }
  }

  # write to object in global environment --------------------------------------
  return(dat)

  # remove no longer needed internal datasets ----------------------------------
  if(exists("census.attr")){
    rm("census.attr", envir = globalenv())
  }
  if(exists("random.coords")){
    rm("random.coords", envir = globalenv())
  }
}

# linking function that supports focal analyses --------------------------------
focal.clinking <- function(#obj.name = "linked.data",
                           download = FALSE,
                           data.path = ".",
                           rasterize = FALSE,
                           coords.file = "",
                           create.raster = FALSE,
                           download.raster = FALSE,
                           focal.matrix = matrix(c(1, 1, 1,                                                                                                  1, 1, 1,
                                                   1, 1, 1), nr = 3, nc = 3),
                           fun = "mean"){

  # case: census data should be downloaded -------------------------------------
  if(download == TRUE){
    cat("Downloading census data")
    download.census.1km()
    #download.census.100m()

    # rasterize downloaded data ------------------------------------------------
    rasterize.census(data.path)
  }

  # case: own, already downloaded census data should be used -------------------
  if(own.data == TRUE){
    rasterize.census(data.path)
  }

  # case: internal, already downloaded census data should be used --------------
  if(download == FALSE & own.data == FALSE){
    data(census.attr)
  }

  # set missing values in census data ------------------------------------------
  for(i in names(census.attr)){
    eval(
      parse(
        text = paste("census.attr$", i, "[census.attr$", i, "[] == -1] <- NA",
                     sep = "")))
    eval(
      parse(
        text = paste("census.attr$", i, "[census.attr$", i, "[] == -9] <- NA",
                     sep = "")))
  }

  # case: use random example coordinates ---------------------------------------
  if(coords.file == ""){
    data(random.coords)
  }

  # case: use own coordinates --------------------------------------------------
  else{
    coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
    coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                     proj4string = CRS("+init=epsg:3035"))
  }

  # focal analyses -------------------------------------------------------------

  # case: no own coordinates file was provided ---------------------------------
  if(coords.file == ""){

    # run focal analyses on all census attributes ------------------------------
    for(i in names(census.attr)){

      # case: object does not exist yet ----------------------------------------
      if(!exists("dat")){
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         ".", fun, " = ",
                         "SDMTools::extract.data(random.coords@coords, ",
                         "raster::focal(census.attr$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))])})))",
                         sep = "")))
      }

      # case: object already exists --------------------------------------------
      else{
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat, ", i,
                         ".", fun, " = ",
                         "SDMTools::extract.data(random.coords@coords, ",
                         "raster::focal(census.attr$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))])}))))",
                         sep = "")))
      }

      # # write to object in global environment ----------------------------------
      # eval(parse(text = paste(obj.name, " <<- dat", sep = "")))
    }
  }

  # case: own coordinates were provided ----------------------------------------
  else{

    # run focal analyses on all census attributes ------------------------------
    for(i in names(census.attr)){

      # case: object does not exist yet ----------------------------------------
      if(!exists("dat")){
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         ".", fun, " = ",
                         "SDMTools::extract.data(coords@coords, ",
                         "raster::focal(census.attr$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))])})))",
                         sep = "")))
      }

      # case: object does not exist yet ----------------------------------------
      else{
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat, ", i,
                         ".", fun, " = ",
                         "SDMTools::extract.data(coords@coords, ",
                         "raster::focal(census.attr$", i,
                         ", w = focal.matrix, ",
                         "fun = ",
                         "function(x){", fun, "(x[-which(is.na(x))])}))))",
                         sep = "")))
      }

      # # write to object in global environment ----------------------------------
      # eval(parse(text = paste(obj.name, " <<- dat", sep = "")))
    }
  }

  # write to object in global environment --------------------------------------
  return(dat)

  # remove no longer needed internal datasets ----------------------------------
  if(exists("census.attr")){
    rm("census.attr", envir = globalenv())
  }
  if(exists("random.coords")){
    rm("random.coords", envir = globalenv())
  }
}

