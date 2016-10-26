# download.census.R
#'
#'@export

download.census.1km <- function(data.path = "."){
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
  unzip(paste(data.path, "/", "Zensusatlas_spitze_Werte_1km_Gitter.zip",
              sep = ""),
        exdir = paste(data.path))
  file.remove(paste(data.path, "/", "Zensusatlas_spitze_Werte_1km_Gitter.zip",
                    sep = ""))
}

download.census.100m <- function(data.path = "."){
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
  unzip(paste(data.path, "/", "Bevoelkerung_100m_Gitter.zip",
              sep = ""),
        exdir = paste(data.path))
  file.remove(paste(data.path, "/", "Bevoelkerung_100m_Gitter.zip",
                    sep = ""))
}
