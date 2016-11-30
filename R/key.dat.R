#' Simulated Key Database
#'
#' A dataset containing two id variables for 10000 individual respondents
#'
#' @usage data(georefum::key.dat)
#'
#' @format A data.frame with 10000 rows and 2 variables:
#' \describe{
#'   \item{id}{id for individual respondent}
#'   \item{id2}{second id for individual respondent that is used to merge
#'   with spatial attributes}
#' }
#' @source \code{georefum::simulate_surveydata()}, then
#' \code{georefum::create_keys()}
"key.dat"
