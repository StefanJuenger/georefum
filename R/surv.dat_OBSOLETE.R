#' Simulated Survey Data
#'
#' A dataset containing simulated attributes of an ordinary survey with 10000
#' individual respondents
#'
#' @usage data(georefum::surv.dat)
#'
#' @format A data.frame with 10000 rows and 6 variables:
#' \describe{
#'   \item{id}{id for individual respondent}
#'   \item{age}{age of respondent, in years}
#'   \item{gender}{gender of respondent, 1 = male and 2 = female}
#'   \item{att1}{phantasy attribute 1, ordinal scale (1-5)}
#'   \item{att2}{phantasy attribute 2, ordinal scale (1-5)}
#'   \item{att3}{phantasy attribute 3, ordinal scale (1-10)}
#' }
#' @source \code{georefum::simulate_surveydata()}
"surv.dat"
