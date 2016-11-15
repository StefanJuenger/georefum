# cdr_harmonize.R
#' Harmonize CDR data
#' @param data.path Folder where the CDR shapefiles live
#' @param crs Definition of coordinate reference system
#' @export

cdr_harmonize <- function(data.path = ".",
                          which = "road",
                          when = "lden",
                          crs = '+init=epsg:3035'){

  # getting file list of shapefiles in data.path -------------------------------
  shp.files <- list.files(data.path, recursive = TRUE, full.names = TRUE)[
    intersect(
      intersect(
        grep(paste(which, "|", tools::toTitleCase(which), sep = ""),
             list.files(data.path, recursive = TRUE, full.names = TRUE)),
        grep(paste(when, "|", tools::toTitleCase(when), sep = ""),
             list.files(data.path, recursive = TRUE, full.names = TRUE))),
      grep(".shp|SHP",
           list.files(data.path, recursive = TRUE, full.names = TRUE)))]

  print(shp.files)

  # operation on each shapefile in order to merge into one shapefile -----------
  for (i in shp.files) {

    # case: initial shapefile does not exist yet -------------------------------
    if (!exists("dat")) {

      # load shapefile ---------------------------------------------------------
      dat <- rgdal::readOGR(basename(i),
                            basename(paste(substr(i, 1, nchar(i)-4), sep = '')))

      # convert to required coordinate reference system ------------------------
      dat <- sp::spTransform(dat, crs)

      # harmonize decibel value attribute name ---------------------------------
      names(dat)[names(dat) == "DB_LO" |
                   names(dat) == "db_low "|
                   names(dat) == "DB" |
                   names(dat) == "DBA"] <- paste(tools::toTitleCase(which),
                                                 "_",
                                                 tools::toTitleCase(when),
                                                 sep = "")

      # delete all other attributes (apart from "Road_lden") -------------------
      dat <- dat[, c(paste(tools::toTitleCase(which), "_",
                           tools::toTitleCase(when), sep = ""))]
    }

    # case: initial shapefile already exists -----------------------------------
    else {

      # load shapefile ---------------------------------------------------------
      tmp_dat <- rgdal::readOGR(basename(i),
                                basename(paste(substr(i, 1, nchar(i)-4),
                                               sep = '')))

      # convert to required coordinate reference system ------------------------
      tmp_dat <- sp::spTransform(tmp_dat, crs)


      # harmonize decibel value attribute name ---------------------------------
      names(tmp_dat)[names(tmp_dat) == "DB_LO" |
                       names(tmp_dat) == "db_low" |
                       names(tmp_dat) == "DB" |
                       names(tmp_dat) == "DBA"] <- paste(
                         tools::toTitleCase(which),
                         "_",
                         tools::toTitleCase(when),
                         sep = "")

      # delete all other attributes (apart from "Road_lden") -------------------
      tmp_dat <- tmp_dat[, c(paste(tools::toTitleCase(which), "_",
                                   tools::toTitleCase(when), sep = ""))]

    # merge data ---------------------------------------------------------------
    dat <- sp::rbind.SpatialPolygonsDataFrame(dat, tmp_dat,
                                              makeUniqueIDs = TRUE)

    # delete temporary shapefile ---------------------------------------------
    rm(tmp_dat)
    }
  }

  # return object --------------------------------------------------------------
  return(dat)
}


