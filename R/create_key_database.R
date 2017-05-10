# create_keys.R
#' Create keys
#' @param surv.dat Survey data Object
#' @param coord.dat Coordinates Data Object, stores as SpatialPointsDataFrame
#'@export

create_key_database <- function(surv.dat = NULL, coord.dat = NULL) {


  # case: no existing survey data with ids should be used ----------------------
  if (is.null(surv.dat)) {
    data(surv.dat)
  }

  # case: no existing coordinates data with ids should be used -----------------
  if (is.null(coord.dat)) {
    data(random.coords)
    coord.dat <- random.coords
  }

  # create key database
  return(
    data.frame(

      # id -----------------------------------------------------------------
      id = surv.dat$id,

      # id2 ----------------------------------------------------------------
      id2 = coord.dat@data$id2
    )
  )
}
