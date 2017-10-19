# calculate_inspire_grids.R
#' Calculate 1km and 100m INSPIRE Grid IDs from coordinates and add to data.frame
#' @param coords.file Path to file with coordinates; must be formatted as
#' csv text file with a 'X' and header...
#' @param coords.object An R object ("Rdata" or "rda") containing the
#' coordinates
#' @return data.frame
#' @export
#'

calculate_inspire_grids <- function(coords.file = "",
                                      coords.object = "") {

  # case: use random example coordinates ---------------------------------------
  if (coords.file == "" && coords.object == "") {
    data(random.coords)
    coords <- random.coords
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

  # create data.frame ----------------------------------------------------------
  dat <- as.data.frame(coords)

  # calculate 1km INSPIRE Grid ID ----------------------------------------------
  dat$INSPIRE_1km <- paste("1kmN",
                           substr(as.character(coords$y), 1, 4),
                           "E",
                           substr(as.character(coords$x), 1, 4),
                           sep = "")

  # calculate 100m INSPIRE Grid ID ---------------------------------------------
  dat$INSPIRE_100m <- paste("100mN",
                            substr(as.character(coords$y), 1, 5),
                            "E",
                            substr(as.character(coords$x), 1, 5),
                            sep = "")

  # return data.frame ----------------------------------------------------------
  return(dat)
}
