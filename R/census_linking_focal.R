# census_linking_focal.R
#' Link Coordinates to German Census 2011 Data by Using Focal Analyses
#' @param download Download census data (calls
#' \code{georefum::download.census()})
#' @param own.data Use own already downloaded census data (calls
#' \code{georefum::rasterize.census()}, original filenames must be preserved)
#' @param data.path Has to be defined when using option \code{download =} or
#' \code{own.data =}
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' andheader...
#' @param focal.matrix Matrix on which upon focal analyses are computed; cells
#' can be weighted as well as set to \code{NA} (for details see function
#' \code{raster::focal()})
#' @param fun Function that is used in the focal analyses
#' @return A \code{data.frame} with census attributes based on focal analyses
#' for each coordinate
#'@export

census_linking_focal <- function(download = FALSE,
                                 own.data = FALSE,
                                 data.path = ".",
                                 coords.file = "",
                                 focal.matrix = matrix(c(1, 1, 1,                                                                                                  1, 1, 1,
                                                         1, 1, 1),
                                                       nr = 3, nc = 3),
                                 fun = "mean"){

  # case: census data should be downloaded -------------------------------------
  if(download == TRUE){
    cat("Downloading and rasterizing census data... ")
    download.census.1km()
    #download.census.100m()

    # rasterize downloaded data ------------------------------------------------
    rasterize.census(data.path)
    cat("done.\n")
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
  cat("Preparing data (set missings, etc.)... ")
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
  cat("done.\n")

  # case: use random example coordinates ---------------------------------------
  if(coords.file == ""){
    cat("Using random example coordinates... ")
    data(random.coords)
    cat("done.\n")
  }

  # case: use own coordinates --------------------------------------------------
  else{
    cat("Using and preparing own coordinates... ")
    coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
    coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                     proj4string = CRS("+init=epsg:3035"))
    cat("done.\n")
  }

  # focal analyses -------------------------------------------------------------
  cat("Running focal analyses and merging to one data collection:\n")

  # case: no own coordinates file was provided ---------------------------------
  if(coords.file == ""){

    # run focal analyses on all census attributes ------------------------------
    for(i in names(census.attr)){

      # case: object does not exist yet ----------------------------------------
      if(!exists("dat")){
        cat(paste(i, "... ", sep = ""))
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
        cat("done.\n")
      }

      # case: object already exists --------------------------------------------
      else{
        cat(paste(i, "... ", sep = ""))
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
        cat("done.\n")
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
        cat(paste(i, "... ", sep = ""))
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
        cat("done.\n")
      }

      # case: object does not exist yet ----------------------------------------
      else{
        cat(paste(i, "... ", sep = ""))
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
        cat("done.\n")
      }
    }
  }

  # remove no longer needed internal datasets ----------------------------------
  if(exists("census.attr")){
    rm("census.attr", envir = globalenv())
  }
  if(exists("random.coords")){
    rm("random.coords", envir = globalenv())
  }

  # write to object in global environment --------------------------------------
  return(dat)
}

