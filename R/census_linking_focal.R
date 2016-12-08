# census_linking_focal.R
#' Link Coordinates to German Census 2011 Data by Using Focal Analyses
#' @param download Download census data (calls
#' \code{georefum::download.census()})
#' @param own.data Use own already downloaded census data (calls
#' \code{georefum::rasterize.census()}, original filenames must be preserved)
#' @param which Vector of Census attributeses that should be linked to the data
#' @param set.missing Toggle whether to set missings on Census attributes
#' @param data.path Has to be defined when using option \code{download =} or
#' \code{own.data =}
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' andheader...
#' @param coords.object An R object ("Rdata" or "rda") containing the coordinates
#' @param focal.matrix Matrix on which upon focal analyses are computed; cells
#' can be weighted as well as set to \code{NA} (for details see function
#' \code{raster::focal()})
#' @param fun Function that is used in the focal analyses
#' @return A \code{data.frame} with census attributes based on focal analyses
#' for each coordinate
#'@export

census_linking_focal <- function(download = FALSE,
                                 own.data = FALSE,
                                 which = c("Einwohner", "Alter_D", "unter18_A",
                                           "ab65_A", "Auslaender_A",
                                           "HHGroesse_D", "Leerstandsquote",
                                           "Wohnfl_Bew_D", "Wohnfl_Whg_D"),
                                 set.missings = TRUE,
                                 data.path = ".",
                                 coords.file = "",
                                 coords.object = "",
                                 focal.matrix = matrix(c(1, 1, 1,
                                                         1, 1, 1,
                                                         1, 1, 1),
                                                       nr = 3, nc = 3),
                                 fun = "mean"){

  # workaround for internal raster function in SDMTools::extract.data ----------
  require(raster)

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
  if (set.missings == TRUE) {
    cat("Preparing data (set missings, etc.)... ")
    for (i in which) {
      eval(
        parse(
          text = paste("census.attr$", i, "[census.attr$", i, " <= -1] <- NA",
                       sep = "")))
    }
  }
  cat("done.\n")

  # case: use random example coordinates ---------------------------------------
  if (coords.file == "" && coords.object == "") {
    data(random.coords)
  }

  # case: use own coordinates as csv -------------------------------------------
  if (coords.file != "" && coords.object == "") {
    coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
    coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], coords,
                                     proj4string = CRS("+init=epsg:3035"))
  }

  # case: use own coordinates as object ----------------------------------------
  if (coords.file == "" && coords.object != "") {
    coords <- coords.object
    coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], coords,
                                     proj4string = CRS("+init=epsg:3035"))
  }

  # focal analyses -------------------------------------------------------------
  cat("Running focal analyses and merging to one data collection:\n")

  # case: no own coordinates file was provided ---------------------------------
  if (coords.file == "" && coords.object == "") {

    # run focal analyses on all census attributes ------------------------------
    for(i in which){

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
  if (coords.file != "" && coords.object == "") {

    # run focal analyses on all census attributes ------------------------------
    for(i in which){

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

  # case: own coordinates were provided ----------------------------------------
  if (coords.file == "" && coords.object != "") {

    # run focal analyses on all census attributes ------------------------------
    for(i in which){

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

