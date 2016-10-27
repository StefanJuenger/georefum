# random.coordinates.R
#'
#'@export

random.coordinates <- function(obj.name = "random.coords", mun.N = 100,
                               resp.N = 100){

  # load municipalties shapefile -----------------------------------------------
  municipalities <- rgdal::readOGR("VG250_Gemeinden.shp", "VG250_Gemeinden",
                                   encoding = "UTF-8")

  # transform to EPSG:3035 -----------------------------------------------------
  municipalities <- spTransform(municipalities, '+init=epsg:3035')

  # draw random sample of municipalities ---------------------------------------
  municipalities.random <- municipalities[sample(nrow(municipalities), mun.N),]

  # draw random sample of random municipalities --------------------------------
  for(i in 1:nrow(municipalities.random)){

    # check whether coordinates object already exists --------------------------
    if(!exists("k")){

      # draw sample ------------------------------------------------------------
      k <- sp::spsample(municipalities.random[i,], 100, type = "random")
    }

    # if coordinates object already exists -------------------------------------
    else{

      # draw sample ------------------------------------------------------------
      k <- rbind(k, sp::spsample(municipalities.random[i,], 100,
                                 type = "random"))
    }

    # assign object name -------------------------------------------------------
    eval(parse(text = paste(obj.name, " <<- k", sep = "")))

  }
  rm(i, k)
}



# bla <- sp::spsample(municipalities, 1000, type = "clustered")
#
# mun2 <- municipalities[sample(nrow(municipalities), 3), ]
#
# setwd(data.path)

# inspire.grids <- rgdal::readOGR("DE_Gitter_ETRS89_LAEA_1km.shp",
#                                 "DE_Gitter_ETRS89_LAEA_1km")[, c("ID_1km")]



# municipalities <- rgdal::readOGR("VG250_Gemeinden.shp",
#                                 "VG250_Gemeinden",
#                                 encoding = "UTF-8")
#
# municipalities.random <- municipalities[sample(nrow(municipalities), 100),]
#
#
#
#
# for(i in 1:nrow(municipalities.random)){
#   if(!exists("k")){
#     #k <- list()
#     #k <- NULL
#     k <- sp::spsample(municipalities.random[i,], 100, type = "random")
#   }
#   else if(exists("k")){
#     k <- rbind(k, sp::spsample(municipalities.random[i,], 100,
#                                type = "random"))
#     # eval(parse(text = paste("k$", municipalities.random[i,], "<- ",
#     #                         "sp::spsample(municipalities.random[i,], 35, type = 'random')",
#     #                         sep = "")))
#   }
#   j <<- k
#
# }
# rm(i, k)


# rast <- raster(census.1km, layer = 1)
#
# rast2 <- as.factor(rast$Gitter_ID_1km)
#
# rastpol <- rasterToPolygons(rast)
#
# blubb <- ratify(rast)
#
# census.1km.b <- SpatialPolygonsDataFrame(census.1km)
