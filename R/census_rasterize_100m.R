# census_rasterize_100m.R
#' Convert German Census 2011 files into raster grids files
#' @param data.path Has to be defined when using option \code{download =} or
#' \code{own.data =}
#' @param download Download census data (calls
#' \code{georefum::download_census_100m()})
#' @param save Toggle whether Census rasters should be stored as individual
#' raster files on hard disk
#' @param save.format Define which raster data format should be used for
#' storing
#' @param save.overwrite Will overwrite existing files if they exist
#' @export

census_rasterize_100m <- function(data.path = ".",
                                  download = FALSE,
                                  save = FALSE,
                                  save.format = "GTiff",
                                  save.overwrite = FALSE) {

  # download census data from zensus2011.de if toggled -------------------------
  if (download == TRUE) {
    cat("Downloading census data")
    georefum::download_census_100m()
  }

  # set path -------------------------------------------------------------------
  setwd(data.path)

  # load census data -----------------------------------------------------------
  cat("Loading data... ")
  census100m <- read.table("Zensus_Bevoelkerung_100m-Gitter.csv", sep = ";",
                           dec = ",", header = TRUE)[, -1]
  cat("done. \n")

  # define coordinates, CRS and whether data is gridded ------------------------
  cat("Converting to raster datasets... ")
  sp::coordinates(census100m) <- ~ x_mp_100m + y_mp_100m
  sp::proj4string(census100m) <- sp::CRS('+init=epsg:3035')
  sp::gridded(census100m) <- TRUE
  cat("done. \n")

  # convert Einwohner layer into raster file / object --------------------------

  # check if saving is toggled -------------------------------------------------
  if (save == TRUE) {

    # create raster
    census.Einw.100m <- raster::raster(census100m, layer = "Einwohner")

    # save raster
    raster::writeRaster(census.Einw.100m,
                        filename = "census.Einw.100m.tif",
                        format = save.format, overwrite = save.overwrite)
  } else {

    # create raster
    census.Einw.100m <- raster::raster(census100m, layer = "Einwohner")
    cat("done.")
    return(census.Einw.100m)
  }

}
