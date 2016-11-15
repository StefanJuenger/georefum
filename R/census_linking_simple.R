# census_linking_simple.R
#' Link Coordinates to German Census 2011 Data
#' @param download Download census data (calls
#' \code{georefum::download.census()})
#' @param own.data Use own already downloaded census data (calls
#' \code{georefum::rasterize.census()}, original filenames must be preserved)
#' @param data.path Has to be defined when using option \code{download =} or
#' \code{own.data =}
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' andheader...
#' @return A \code{data.frame} with census attributes for each coordinate
#' @importFrom SDMTools extract.data
#'@export

census_linking_simple <- function(download = FALSE,
                                  own.data = FALSE,
                                  data.path = ".",
                                  coords.file = "") {

  # case: census data should be downloaded -------------------------------------
  if (download == TRUE) {
    cat("Downloading census data")
    georefum::download.census.1km()
    #download.census.100m()

    # rasterize downloaded data ------------------------------------------------
    georefum::rasterize.census(data.path)
  }

  # case: own, already downloaded census data should be used -------------------
  if (own.data == TRUE) {
    georefum::rasterize.census(data.path)
  }

  # case: internal, already downloaded census data should be used --------------
  if (download == FALSE & own.data == FALSE) {
    data(census.attr)
  }

  # set missing values in census data ------------------------------------------
  for (i in names(census.attr)) {

    eval(
      parse(
        text = paste("census.attr$", i, " @data@values", "[census.attr$", i,
                     "@data@values <= -1] <- NA", sep = "")))
  }


  # case: use random example coordinates ---------------------------------------
  if (coords.file == "") {
    data(random.coords)
  }

  # case: use own coordinates --------------------------------------------------
  else {
    coords <- read.table(coords.file, sep = ";", dec = ",", header = TRUE)
    coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], dat,
                                     proj4string = CRS("+init=epsg:3035"))
  }

  # link coordinates with census data ------------------------------------------

  # case: no own coordinates file was provided ---------------------------------
  if (coords.file == "") {

    # run linking on all census attributes -------------------------------------
    for (i in names(census.attr)) {

      # case: object does not exist yet ----------------------------------------
      if (!exists("dat")) {
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         " = SDMTools::extract.data(random.coords@coords,",
                         " census.attr$", i, "))")))
      }

      # case: object already exists --------------------------------------------
      else {
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat,", i,
                         " = SDMTools::extract.data(random.coords@coords,",
                         " census.attr$", i, ")))")))
      }
    }
  }

  # case: use own coordinates --------------------------------------------------
  else {

    # run linking on all census attributes -------------------------------------
    for (i in names(census.attr)) {

      # case: object does not exist yet ----------------------------------------
      if (!exists("dat")) {
        eval(
          parse(
            text = paste("dat <- data.frame(", i,
                         " = SDMTools::extract.data(coords@coords,",
                         " census.attr$", i, "))")))
      }

      # case: object already exists --------------------------------------------
      else {
        eval(
          parse(
            text = paste("dat <- data.frame(cbind(dat,", i,
                         " = SDMTools::extract.data(coords@coords,",
                         " census.attr$", i, ")))")))
      }
    }
  }

  # remove no longer needed internal datasets ----------------------------------
  if (exists("census.attr")) {
    rm("census.attr", envir = globalenv())
  }
  if (exists("random.coords")) {
    rm("random.coords", envir = globalenv())
  }

  # write to object in global environment --------------------------------------
  return(dat)
}
