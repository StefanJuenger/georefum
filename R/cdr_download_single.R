# cdr_download_single.R
#' Download single layers of environmental noise data for individual German
#' federal states in the CDR
#' @param data.path Place where the data will be stored
#' @param url.path Vector of urls that point to data subfolders of German
#' federal states in the CDR
#' @param file Vector of filenames (\code{length == url.path}) that should be
#' downloaded
#' @export
#'

cdr_download_single <- function(data.path = ".",
                                url.path = c(paste("https://cdr.eionet.europa.",
                                                   "eu/de/eu/noise/df8/",
                                                   "colvjswog/envvlltfa/",
                                                   sep = ""),
                                             paste("https://cdr.eionet.europa.",
                                                   "eu/de/eu/noise/df8/",
                                                   "colvjswog/envvk89vq/",
                                                   sep = "")),
                                file = c("DE_NW_ag14_Aggroad_Lden",
                                         "DE_BY_ag1_Aggroad_Lden")){

  for (i in url.path) {

    # download dbf -------------------------------------------------------------
    try(download.file(url = paste(i, file[which(url.path == i)], ".dbf",
                                  sep = ""),
                  destfile = paste(data.path, "/", file[which(url.path == i)],
                                   ".dbf", sep = ""),
                  method = "auto",
                  mode = "wb"))

    # download prj -------------------------------------------------------------
    try(download.file(url = paste(i, file[which(url.path == i)], ".prj",
                                  sep = ""),
                  destfile = paste(data.path, "/", file[which(url.path == i)],
                                   ".prj", sep = ""),
                  method = "auto",
                  mode = "wb"))

    # download dbf -------------------------------------------------------------
    try(download.file(url = paste(i, file[which(url.path == i)], ".shp",
                                  sep = ""),
                  destfile = paste(data.path, "/", file[which(url.path == i)],
                                   ".shp", sep = ""),
                  method = "auto",
                  mode = "wb"))

    # download dbf -------------------------------------------------------------
    try(download.file(url = paste(i, file[which(url.path == i)], ".shx",
                                  sep = ""),
                  destfile = paste(data.path, "/", file[which(url.path == i)],
                                   ".shx", sep = ""),
                  method = "auto",
                  mode = "wb"))
  }
}
