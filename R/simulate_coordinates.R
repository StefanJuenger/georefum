# simulate_coordinates.R
#'
#'@export

simulate_coordinates <- function(mun.N = 100,
                                 resp.N = 100){

  # tmp
  setwd("C:/Users/mueller2/Desktop/")

  # load municipalties shapefile -i----------------------------------------------
  municipalities <- rgdal::readOGR("VG250_Gemeinden.shp", "VG250_Gemeinden",
                                   encoding = "UTF-8")

  # transform to EPSG:3035 -----------------------------------------------------
  municipalities <- sp::spTransform(municipalities, '+init=epsg:3035')

  # load inhabitants data ------------------------------------------------------
  # inhab <- read.table(paste("C:/Users/mueller2/Desktop/csv_Bevoelkerung/",
  #                           "Zensus11_Datensatz_Bevoelkerung.csv", sep = ""),
  #                     sep = ";",
  #                     dec = ",", header = TRUE)[, c("AGS_12", "AEWZ")]
  #
  # names(inhab)[names(inhab) == "AGS_12"] <- "RS"
  #
  # inhab <- inhab[!(nchar(inhab$RS) < 11),]
  #
  #
  # stringr::str_pad(inhab$RS, 12, pad = "0")
  # stringr::str_pad(municipalities@data$RS, 12, pad = "0")

  # # merge with municipalties ---------------------------------------------------
  # municipalities.bla <- sp::merge(municipalities, inhab, by = "RS",
  #                                 all.x = FALSE)

  # draw random sample of municipalities ---------------------------------------
  municipalities.random <- municipalities[sample(nrow(municipalities), mun.N),]

  # municipalities$weights <- municipalities$AEWZ / 80000000

  # # weighted
  # municipalities.random <- municipalities[sample(nrow(municipalities), mun.N,
  #                                                prob = (municipalities$AEWZ /
  #                                                  80000000)),]

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
  }

  # assign random id to every case ---------------------------------------------


  # return object --------------------------------------------------------------
  return(k)
}
