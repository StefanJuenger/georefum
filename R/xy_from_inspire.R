# xy_from_inspire.R
#' Retreive centroid geocoordiantes from 1km² INSPIRE Grid IDs from coordinates and add to data.frame
#' @param id.file Path to file with INSPIRE IDs as one column; must be formatted as
#' csv text file with a ';' as separator
#' @param id.object An R object ("Rdata" or "rda") containing the
#' INSPIRE IDs as one column; must be loaded into the environment
#' @return data.frame
#' @export

xy_from_inspire <- function(id.file = "",
                            id.object = "",
                            col.name = "INSPIRE_1km") {


  # case: use own inspire ids as csv -------------------------------------------
  if (id.file != "" && id.object == "") {

    ids <- read.table(id.file, sep = ";", dec = ",", header = TRUE)

  }

  # case: use own inspire ids as object ----------------------------------------
  if (id.file == "" && id.object != "") {

    ids <- id.object

  }

  # calculate 1km INSPIRE centroid geocoordinates ------------------------------
  eval(
    parse(
      text = paste0(
        "ids$x <- paste0(substr(ids$", col.name, ", 10, 13), '00');
         ids$y <- paste0(substr(ids$", col.name, ", 5, 8), '00')"
      )
    )
  )

  # return data.frame ----------------------------------------------------------
  return(ids)
}
