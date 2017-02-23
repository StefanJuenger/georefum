# census_download.R
#' Download
#'@param data.path Place where the data will be stored
#'@export census_download_1km
#'@export census_download_1km_cat 
#'@export census_download_100m

# download census 1km grid data ------------------------------------------------
census_download_1km <- function(data.path = "."){
  download.file(url = paste("https://www.zensus2011.de/SharedDocs/Downloads/",
                            "DE/Pressemitteilung/DemografischeGrunddaten/",
                            "csv_Zensusatlas_spitze_Werte_1km_Gitter.zip",
                            "?__blob=publicationFile&v=5",
                            sep = ""),
                destfile = paste(data.path, "/",
                                 "Zensusatlas_spitze_Werte_1km_Gitter.zip",
                                 sep = ""),
                method = "auto",
                mode = "wb")

  # extract downloaded zip file ------------------------------------------------
  unzip(paste(data.path, "/", "Zensusatlas_spitze_Werte_1km_Gitter.zip",
              sep = ""),
        exdir = paste(data.path))

  # remove downloaded zip file -------------------------------------------------
  file.remove(paste(data.path, "/", "Zensusatlas_spitze_Werte_1km_Gitter.zip",
                    sep = ""))
}

# download census 1km grid data (categorized) ----------------------------------
census_download_1km_cat <- function(data.path = "."){
  download.file(url = paste("https://www.zensus2011.de/SharedDocs/Downloads/",
                            "DE/Pressemitteilung/DemografischeGrunddaten/",
                            "csv_Zensusatlas_klassierte_Werte_1km_Gitter.zip",
                            "?__blob=publicationFile&v=8",
                            sep = ""),
                destfile = paste(data.path, "/",
                                 "Zensus_klassierte_Werte_1km-Gitter.zip",
                                 sep = ""),
                method = "auto",
                mode = "wb")

  # extract downloaded zip file ------------------------------------------------
  unzip(paste(data.path, "/", "Zensus_klassierte_Werte_1km-Gitter.zip",
              sep = ""),
        exdir = paste(data.path))

  # remove downloaded zip file -------------------------------------------------
  file.remove(paste(data.path, "/", "Zensus_klassierte_Werte_1km-Gitter.zip",
                    sep = ""))
}

# download census 100m grid data -----------------------------------------------
census_download_100m <- function(data.path = "."){
  download.file(url = paste("https://www.zensus2011.de/SharedDocs/Downloads/",
                            "DE/Pressemitteilung/DemografischeGrunddaten/",
                            "csv_Bevoelkerung_100m_Gitter.zip",
                            "?__blob=publicationFile&v=3",
                            sep = ""),
                destfile = paste(data.path, "/",
                                 "Bevoelkerung_100m_Gitter.zip",
                                 sep = ""),
                method = "auto",
                mode = "wb")

  # extract downloaded zip file ------------------------------------------------
  unzip(paste(data.path, "/", "Bevoelkerung_100m_Gitter.zip",
              sep = ""),
        exdir = paste(data.path))

  # remove downloaded zip file -------------------------------------------------
  file.remove(paste(data.path, "/", "Bevoelkerung_100m_Gitter.zip",
                    sep = ""))
}

# download inspire grid shapefile ----------------------------------------------
download_inspire_grid <- function(data.path = "."){
  download.file(url = paste("https://www.zensus2011.de/SharedDocs/Downloads/",
                            "DE/Shapefile/Inspire.zip",
                            "?__blob=publicationFile&v=5",
                            sep = ""),
                destfile = paste(data.path, "/",
                                 "Inspire.zip",
                                 sep = ""),
                method = "auto",
                mode = "wb")

  # extract downloaded zip file ------------------------------------------------
  unzip(paste(data.path, "/", "Inspire.zip",
              sep = ""),
        exdir = paste(data.path))

  # remove downloaded zip file -------------------------------------------------
  file.remove(paste(data.path, "/", "Inspire.zip",
                    sep = ""))
}

# download shapefile for municipalties -----------------------------------------
download_municipalties <- function(data.path = "."){
  download.file(url = paste("https://www.zensus2011.de/SharedDocs/Downloads/",
                            "DE/Shapefile/VG250_1Jan2011_UTM32.zip",
                            "?__blob=publicationFile&v=25",
                            sep = ""),
                destfile = paste(data.path, "/",
                                 "VG250_1Jan2011_UTM32.zip",
                                 sep = ""),
                method = "auto",
                mode = "wb")

  # extract downloaded zip file ------------------------------------------------
  unzip(paste(data.path, "/", "VG250_1Jan2011_UTM32.zip",
              sep = ""),
        exdir = paste(data.path))

  # remove downloaded zip file -------------------------------------------------
  file.remove(paste(data.path, "/", "VG250_1Jan2011_UTM32.zip",
                    sep = ""))

  # remove shapefiles of other boundaries --------------------------------------
  unlink(paste(data.path, "/", "VG250_Bundeslaender*",
              sep = ""))
  unlink(paste(data.path, "/", "VG250_Verwaltungsgemeinschaften*",
               sep = ""))
  unlink(paste(data.path, "/", "VG250_Kreise*",
               sep = ""))
}
