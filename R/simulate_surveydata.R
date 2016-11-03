# simulate_surveydata.R
#'
#'@export

simulate_surveydata <- function(N = 10000){

  # sinulate survey data attributes --------------------------------------------
  return(
    data.frame(

      # id -----------------------------------------------------------------
      id = stringr::str_pad(sample(1:N, N, replace = FALSE), nchar(N),
                            pad = "0"),

      # age ----------------------------------------------------------------
      age = round(rnorm(N, mean = 50, sd = 10)),

      # gender -------------------------------------------------------------
      gender = sample(1:2, 10000, replace = TRUE, prob = c(.5, .5)),

      # att1 ---------------------------------------------------------------
      att1 = sample(1:5, N, replace = TRUE,
                    prob = c(.4, .2, .3, .05, .05)),

      # att2 ---------------------------------------------------------------
      att2 = sample(1:5, N, replace = TRUE,
                    prob = c(.2, .2, .2, .3, .1)),

      # att3 ---------------------------------------------------------------
      att3 = sample(1:10, N, replace = TRUE,
                    prob = c(.05, .1, .4, .1, .05, .05, .1, .025, .025,
                             .05))
    )
  )
}
