# census_linking_100m.R
#' Link Coordinates to German Census 2011 Data
#' @description This function performs spatial linking based on coordinates data
#' and raster grid cell data from the German Census 2011. By default it uses
#' simulated coordinates data for demonstration purposes. Own coordinates, however,
#' can be used as well.
#' @param own.data Use own already downloaded census data (calls
#' \code{georefum::rasterize.census()}, original filenames must be preserved)
#' @param which Vector of Census attributeses that should be linked to the data
#' @param set.missing Toggle whether to set missings on Census attributes
#' @param data.path Has to be defined when using option \code{download =} or
#' \code{own.data =}
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' andheader...
#' @param coords.object An R object ("Rdata" or "rda") containing the coordinates
#' @return A \code{data.frame} with census attributes for each coordinate
#' @importFrom SDMTools extract.data
#' @importFrom raster getValues
#' @import raster
#'@export

census_linking_100m <- function(own.data = FALSE,
                                set.missings = TRUE,
                                data.path = ".",
                                coords.file = "",
                                coords.object = "",
                                suffix = "") {

  # workaround for internal raster function in SDMTools::extract.data ----------
  require(raster)

  # case: own, already downloaded census data should be used -------------------
  if (own.data == TRUE) {
    georefum::census_rasterize_100m(data.path)
  }

  # case: internal, already downloaded census data should be used --------------
  if (own.data == FALSE) {
    data(census.Einw.100m)
    census.data <- census.Einw.100m
  }

  # set missing values in census data ------------------------------------------
  if (set.missings == TRUE) {
    census.data$Einwohner <- raster::reclassify(census.data,
                                                cbind(-1, NA))
  }

  message("done.\n")

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

    # case: coords.object is no SpatialPointsDataFrame
    if (class(coords) != "SpatialPointsDataFrame") {
      coords <- SpatialPointsDataFrame(coords[, c("x", "y" )], coords,
                                       proj4string = CRS("+init=epsg:3035"))
    }
  }

  # link coordinates with census data ------------------------------------------
  message("Link census 100m attributes to coordinates:\n")

  # case: no own coordinates file was provided ---------------------------------
  if (coords.file == "" && coords.object == "") {

    eval(
      parse(
        text = paste("dat <- data.frame(Einwohner", suffix,
                     " = SDMTools::extract.data(random.coords@coords,",
                     " census.data$Einwohner))", sep = "")))
  }

  # case: use own coordinates as csv -------------------------------------------
  if (coords.file != "" && coords.object == "") {

    eval(
      parse(
        text = paste("dat <- data.frame(Einwohner", suffix,
                     " = SDMTools::extract.data(coords@coords,",
                     " census.data$Einwohner))", sep = "")))
  }

  # case: use own coordinates as object ----------------------------------------
  if (coords.file == "" && coords.object != "") {

    eval(
      parse(
        text = paste("dat <- data.frame(Einwohner", suffix,
                     " = SDMTools::extract.data(coords@coords,",
                     " census.data$Einwohner))", sep = "")))
  }

  # remove no longer needed internal datasets ----------------------------------
  if (exists("census.Einw.100m")) {
    rm(census.attr, envir = globalenv())
  }
  if (exists("random.coords")) {
    rm(random.coords, envir = globalenv())
  }

  # write to object in global environment --------------------------------------
  return(dat)
}
