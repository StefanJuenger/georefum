# create_keys.R
#' Create keys
#' @param use.existing.surv.dat Path to survey data that is stored in the comma
#' separated values (CSV) file format; a variable/attribute/column named "id"
#' with uniquie IDs ist required, otherwise the function will fail
#' @param N Number of unique IDs that should be computed
#'@export

create_keys <- function(use.existing.surv.dat = "",
                        N = 10000) {

  # case: no existing survey data with ids should be used ----------------------
  if (use.existing.surv.dat == "") {
  data(surv.dat)
  }

  # case: existing survey data with ids should be used -------------------------
  else {
    surv.dat <- read.table(use.existing.surv.dat, sep = ";", dec = ",",
                           header = TRUE)
  }

  # create key dataset
 return(
   data.frame(

      # id -----------------------------------------------------------------
      id = surv.dat$id,

      # id2 ----------------------------------------------------------------
      id2 = stringr::str_pad(sample(1:N, N, replace = FALSE), nchar(N),
                             pad = "0")
   )
 )
}
