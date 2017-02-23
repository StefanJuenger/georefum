# census_rasterize_1km.R
#' Convert German Census 2011 files into raster grids files
#' @param data.path Has to be defined when using option \code{download =} or
#' \code{own.data =}
#' @param download Download census data (calls
#' \code{georefum::download.census()})
#' @param save Toggle whether Census rasters should be stored as individual
#' raster files on hard disk
#' @param save.format Define which raster data format should be used for
#' storing
#' @param save.overwrite Will overwrite existing files if they exist
#' @export

census_rasterize_1km <- function(data.path = ".",
                             download = FALSE,
                             save = FALSE,
                             save.format = "GTiff",
                             save.overwrite = FALSE) {

  # download census data from zensus2011.de if toggled -------------------------
  if (download == TRUE) {
    cat("Downloading census data")
    georefum::census_download_1km()
    #download.census.100m()
  }

  # set path -------------------------------------------------------------------
  setwd(data.path)

  # load census data -----------------------------------------------------------
  cat("Loading data... ")
  census.1km <- read.table("Zensus_spitze_Werte_1km-Gitter.csv", sep = ";",
                           dec = ",", header = TRUE)[, -1]

  # census100m <- read.table("Zensus_Bevoelkerung_100m-Gitter.csv", sep = ";",
  #                          dec = ",", header = TRUE)[, -1]
  cat("done. \n")

  # define coordinates, CRS and whether data is gridded ------------------------
  cat("Converting to raster datasets... ")
  sp::coordinates(census.1km) <- ~ x_mp_1km + y_mp_1km
  sp::proj4string(census.1km) <- sp::CRS('+init=epsg:3035')
  sp::gridded(census.1km) <- TRUE

  # sp::coordinates(census100m) <- ~ x_mp_100m + y_mp_100m
  # sp::proj4string(census100m) <- sp::CRS('+init=epsg:3035')
  # sp::gridded(census100m) <- TRUE
  cat("done. \n")

  # delete inspire ids as they are not convertable to raster format ------------
  # census.1km <- census.1km[, -1]
  # census100m <- census100m[, -1]

  # convert each layer in single variable raster file and add to list ----------
  for (i in names(census.1km)) {

    # check if raster list already exists --------------------------------------
    if (!exists("census.rasters")) {

      # create raster list -----------------------------------------------------
      census.rasters <- list()

      # check if saving is toggled ---------------------------------------------
      if (save == TRUE) {

        cat("Saving... ")

        # load i raster in raster list -----------------------------------------
        eval(parse(text = paste("census.rasters$", i, "<- ",
                                "raster::raster(census.1km, layer = '", i, "')",
                                sep = "")))

        # save i as raster file ------------------------------------------------
        eval(parse(text = paste("raster::writeRaster(census.rasters$", i,
                                ", filename = 'census.", i,
                                ".tif', format = '", save.format, "',
                                overwrite = ", save.overwrite, ")",
                                sep = "")))
      }

      # code if saving is not toggled ------------------------------------------
      else {

        cat("Save in list... ")

        # load i raster in raster list -----------------------------------------
        eval(parse(text = paste("census.rasters$", i, "<- ",
                                "raster::raster(census.1km, layer = '", i, "')",
                                sep = "")))
      }
    }

    # code if list already exists ----------------------------------------------
    else {

      # check if saving is toggled ---------------------------------------------
      if (save == TRUE) {

        # load i raster in raster list -----------------------------------------
        eval(parse(text = paste("census.rasters$", i, "<- ",
                                "raster::raster(census.1km, layer = '", i, "')",
                                sep = "")))

        # save i as raster file ------------------------------------------------
        eval(parse(text = paste("raster::writeRaster(census.rasters$", i,
                                ", filename = 'census.", i,
                                ".tif', format = '", save.format, "',
                                overwrite = ", save.overwrite, ")",
                                sep = "")))
      }

      # code if saving is not toggled ------------------------------------------
      else {

        # load i raster in raster list -----------------------------------------
        eval(parse(text = paste("census.rasters$", i, "<- ",
                                "raster::raster(census.1km, layer = '", i, "')",
                                sep = "")))
      }
    }
  }

  cat("done.")

  # case: raster files should not be stored as individual files ----------------
  if (save == FALSE) {
    return(census.rasters)
  }
}
