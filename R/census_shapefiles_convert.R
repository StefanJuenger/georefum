# census_shapefiles_convert
#' convert shapefiles
#' @param inspire.grids.convert Toggle conversion of inspire grids
#' @param municipalities.convert Toggle conversion of municipalties shapefile
#' @param download Toggle download of inspire grids and municipalties shapefile
#' @param data.path Place where downloaded files should be stored (only relevant
#' when \code{download} is toggled)
#' @export

census_shapefiles_convert <- function(inspire.grids.convert = TRUE,
                                      municipalities.convert = TRUE,
                                      download = TRUE,
                                      data.path = "."){

  old.path <- getwd()
  setwd(data.path)

  # case: inspire grids should be downloaded
  if(download == TRUE & inspire.grids.convert == TRUE){
    download_inspire_grid()
  }

  # case: municipalties should be downloaded
  if(download == TRUE & municipalities.convert == TRUE){
    download_municipalties()
  }


  # case: inspire.grids should be converted
  if(inspire.grids.convert == TRUE){
    inspire.grids <- rgdal::readOGR("DE_Gitter_ETRS89_LAEA_1km.shp",
                           "DE_Gitter_ETRS89_LAEA_1km",
                           encoding = "UTF-8")[, c("ID_1km")]
  }

  # case: municipalties should be converted
  if(municipalities.convert == TRUE){
    municipalities <- rgdal::readOGR("VG250_Gemeinden.shp", "VG250_Gemeinden",
                            encoding = "UTF-8")

    # transform to EPSG:3035 -----------------------------------------------------
    municipalities <- sp::spTransform(municipalities, '+init=epsg:3035')
  }
  setwd(old.path)
  return(list(inspire.grids = inspire.grids, municipalities = municipalities))
}


