# cdr_download_whole.R
#' Download
#'@param data.path Place where the data will be stored
#'@export
#'

cdr_download_whole <- function(data.path = "."){


  # 0. root data path ------------------------------------------------------- ##
  if(!exists(data.path)){
    dir.create(data.path, recursive = TRUE, showWarnings = FALSE)
  }

  # 1. BB data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "BB/", sep = ""))){
    dir.create(paste(data.path, "/", "BB/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  BB.path <- paste(data.path, "/", "BB/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi2ug/envelope_zip", sep = ""),
                paste(BB.path, "BB.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(BB.path, "BB.zip", sep = ""),
        exdir = substr(BB.path, 1, (nchar(BB.path) - 1)))

  file.remove(paste(BB.path, "BB.zip", sep = ""))

  # 2. BE data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "BE/", sep = ""))){
    dir.create(paste(data.path, "/", "BE/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  BE.path <- paste(data.path, "/", "BE/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi2rw/envelope_zip", sep = ""),
                paste(BE.path, "BE.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(BE.path, "BE.zip", sep = ""),
        exdir = substr(BE.path, 1, (nchar(BE.path) - 1)))

  file.remove(paste(BE.path, "BE.zip", sep = ""))

  # 3. BW data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "BW/", sep = ""))){
    dir.create(paste(data.path, "/", "BW/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  BW.path <- paste(data.path, "/", "BW/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi2ow/envelope_zip", sep = ""),
                paste(BW.path, "BW.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(BW.path, "BW.zip", sep = ""),
        exdir = substr(BW.path, 1, (nchar(BW.path) - 1)))

  file.remove(paste(BW.path, "BW.zip", sep = ""))

  # 4. BY data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "BY/", sep = ""))){
    dir.create(paste(data.path, "/", "BY/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  BY.path <- paste(data.path, "/", "BY/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi2lg/envelope_zip", sep = ""),
                paste(BY.path, "BY.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(BY.path, "BY.zip", sep = ""),
        exdir = substr(BY.path, 1, (nchar(BY.path) - 1)))

  file.remove(paste(BY.path, "BY.zip", sep = ""))

  # 5. HB data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "HB/", sep = ""))){
    dir.create(paste(data.path, "/", "HB/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  HB.path <- paste(data.path, "/", "HB/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi2iq/envelope_zip", sep = ""),
                paste(HB.path, "HB.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(HB.path, "HB.zip", sep = ""),
        exdir = substr(HB.path, 1, (nchar(HB.path) - 1)))

  file.remove(paste(HB.path, "HB.zip", sep = ""))

  # 6. HE data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "HE/", sep = ""))){
    dir.create(paste(data.path, "/", "HE/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  HE.path <- paste(data.path, "/", "HE/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi2fq/envelope_zip", sep = ""),
                paste(HE.path, "HE.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(HE.path, "HE.zip", sep = ""),
        exdir = substr(HE.path, 1, (nchar(HE.path) - 1)))

  file.remove(paste(HE.path, "HE.zip", sep = ""))

  # 7. HH data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "HH/", sep = ""))){
    dir.create(paste(data.path, "/", "HH/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  HH.path <- paste(data.path, "/", "HH/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi2cg/envelope_zip", sep = ""),
                paste(HH.path, "HH.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(HH.path, "HH.zip", sep = ""),
        exdir = substr(HH.path, 1, (nchar(HH.path) - 1)))

  file.remove(paste(HH.path, "HH.zip", sep = ""))

  # 8. MV data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "MV/", sep = ""))){
    dir.create(paste(data.path, "/", "MV/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  MV.path <- paste(data.path, "/", "MV/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi2aa/envelope_zip", sep = ""),
                paste(MV.path, "MV.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(MV.path, "MV.zip", sep = ""),
        exdir = substr(MV.path, 1, (nchar(MV.path) - 1)))

  file.remove(paste(MV.path, "MV.zip", sep = ""))

  # 9. NI data -------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "NI/", sep = ""))){
    dir.create(paste(data.path, "/", "NI/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  NI.path <- paste(data.path, "/", "NI/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi19q/envelope_zip", sep = ""),
                paste(NI.path, "NI.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(NI.path, "NI.zip", sep = ""),
        exdir = substr(NI.path, 1, (nchar(NI.path) - 1)))

  file.remove(paste(NI.path, "NI.zip", sep = ""))

  # 10. NW data ------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "NW/", sep = ""))){
    dir.create(paste(data.path, "/", "NW/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  NW.path <- paste(data.path, "/", "NW/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi16a/envelope_zip", sep = ""),
                paste(NW.path, "NW.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(NW.path, "NW.zip", sep = ""),
        exdir = substr(NW.path, 1, (nchar(NW.path) - 1)))

  file.remove(paste(NW.path, "NW.zip", sep = ""))

  # 11. RP data ------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "RP/", sep = ""))){
    dir.create(paste(data.path, "/", "RP/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  RP.path <- paste(data.path, "/", "RP/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi13a/envelope_zip", sep = ""),
                paste(RP.path, "RP.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(RP.path, "RP.zip", sep = ""),
        exdir = substr(RP.path, 1, (nchar(RP.path) - 1)))

  file.remove(paste(RP.path, "RP.zip", sep = ""))

  # 12. SH data ------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "SH/", sep = ""))){
    dir.create(paste(data.path, "/", "SH/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  SH.path <- paste(data.path, "/", "SH/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi1zq/envelope_zip", sep = ""),
                paste(SH.path, "SH.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(SH.path, "SH.zip", sep = ""),
        exdir = substr(SH.path, 1, (nchar(SH.path) - 1)))

  file.remove(paste(SH.path, "SH.zip", sep = ""))

  # 13. SL data ------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "SL/", sep = ""))){
    dir.create(paste(data.path, "/", "SL/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  SL.path <- paste(data.path, "/", "SL/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi1vg/envelope_zip", sep = ""),
                paste(SL.path, "SL.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(SL.path, "SL.zip", sep = ""),
        exdir = substr(SL.path, 1, (nchar(SL.path) - 1)))

  file.remove(paste(SL.path, "SL.zip", sep = ""))

  # 14. SN data ------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "SN/", sep = ""))){
    dir.create(paste(data.path, "/", "SN/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  SN.path <- paste(data.path, "/", "SN/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi1rw/envelope_zip", sep = ""),
                paste(SL.path, "SN.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(SN.path, "SN.zip", sep = ""),
        exdir = substr(SN.path, 1, (nchar(SN.path) - 1)))

  file.remove(paste(SN.path, "SN.zip", sep = ""))

  # 15. ST data ------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "ST/", sep = ""))){
    dir.create(paste(data.path, "/", "ST/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  ST.path <- paste(data.path, "/", "ST/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi1oa/envelope_zip", sep = ""),
                paste(ST.path, "ST.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(ST.path, "ST.zip", sep = ""),
        exdir = substr(ST.path, 1, (nchar(ST.path) - 1)))

  file.remove(paste(ST.path, "ST.zip", sep = ""))

  # 16. TH data ------------------------------------------------------------- ##
  if(!exists(paste(data.path, "/", "TH/", sep = ""))){
    dir.create(paste(data.path, "/", "TH/", sep = ""),
               recursive = TRUE, showWarnings = FALSE)
  }

  TH.path <- paste(data.path, "/", "TH/", sep = "")

  download.file(paste("http://cdr.eionet.europa.eu/de/eu/noise/df8/",
                      "colvi7k8q/envvi1oa/envelope_zip", sep = ""),
                paste(TH.path, "TH.zip", sep = ""),
                method = "wget",
                mode = "wb")

  unzip(paste(TH.path, "TH.zip", sep = ""),
        exdir = substr(TH.path, 1, (nchar(TH.path) - 1)))

  file.remove(paste(TH.path, "TH.zip", sep = ""))
}

