# simulate_coordinates.R
#' Simulate coordinates
#'@param mun.N Number of municipalties that should be sampled
#'@param resp.N Number of respondents that should be sampled within the already
#'sampled municipalities
#'@export

simulate_coordinates <- function(mun.N = 98,
                                 resp.N = 100) {

  # load census shape for sampling ---------------------------------------------
  data(census.shapes)

  # draw random sample of municipalities ---------------------------------------
  municipalities.random <- sp::rbind.SpatialPolygonsDataFrame(
    census.shapes$municipalities[
      sample(nrow(census.shapes$municipalities), mun.N),],
    census.shapes$municipalities[
      census.shapes$municipalities@data$GEN == "Köln" |
        census.shapes$municipalities@data$GEN == "München",])

  # draw random sample of random municipalities --------------------------------
  for (i in 1:nrow(municipalities.random)) {

    # check whether coordinates object already exists --------------------------
    if (!exists("k")) {

      # draw sample ------------------------------------------------------------
      k <- sp::spsample(municipalities.random[i,], 100, type = "random")
    }

    # if coordinates object already exists -------------------------------------
    else {

      # draw sample ------------------------------------------------------------
      k <- sp::rbind.SpatialPoints(k, sp::spsample(municipalities.random[i,],
                                                   100, type = "random"))
    }
  }

  # assign random id to every case ---------------------------------------------
  data(key.dat)

  k <- sp::SpatialPointsDataFrame(coords = k@coords,
                                    data = as.data.frame(key.dat$id2),
                                    proj4string = sp::CRS('+init=epsg:3035'))
  names(k) <- "id2"

  # remove no longer needed internal datasets ----------------------------------
  if (exists("key.dat")) {
    rm("key.dat", envir = globalenv())
  }
  if(exists("census.shapes")) {
    rm("census.shapes", envir = globalenv())
  }

  # return object --------------------------------------------------------------
  return(k)
}
