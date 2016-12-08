# census_linking_simple.R
#' Link Coordinates to German Census 2011 Data
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
#' @return A \code{data.frame} with census attributes for each coordinate
#' @importFrom SDMTools extract.data
#' @importFrom raster getValues
#' @import raster
#'@export

census_linking_simple <- function(download = FALSE,
                                  own.data = FALSE,
                                  which = c("Einwohner", "Alter_D", "unter18_A",
                                            "ab65_A", "Auslaender_A",
                                            "HHGroesse_D", "Leerstandsquote",
                                            "Wohnfl_Bew_D", "Wohnfl_Whg_D"),
                                  set.missings = TRUE,
                                  data.path = ".",
                                  coords.file = "",
                                  coords.object = "") {

  # workaround for internal raster function in SDMTools::extract.data ----------
  require(raster)

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
  if (set.missings == TRUE) {
    for (i in which) {
      eval(
        parse(
          text = paste("census.attr$", i, "[census.attr$", i, " <= -1] <- NA",
                       sep = "")))
    }
  }


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

  # link coordinates with census data ------------------------------------------

  # case: no own coordinates file was provided ---------------------------------
  if (coords.file == "" && coords.object == "") {

    # run linking on all census attributes -------------------------------------
    for (i in which) {

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

  # case: use own coordinates as csv -------------------------------------------
  if (coords.file != "" && coords.object == "") {

    # run linking on all census attributes -------------------------------------
    for (i in which) {

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

  # case: use own coordinates as object ----------------------------------------
  if (coords.file == "" && coords.object != "") {

    # run linking on all census attributes -------------------------------------
    for (i in which) {

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
