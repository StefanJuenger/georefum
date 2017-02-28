# cdr_check_lines.R
#' Check for line data in shape files
#' @param data.path Directory to check for shapefiles with lines only
#' @param out.file Location and name of output text file
#' @param threads Number of threads used for scanning the files. Use with caution as
#' the more threads are used the more system RAM is used as well. In addition,
#' only works on Windows or GNU/Linux operating systems (I don't know about MAC, to be 
#' honest...)
#' @export

cdr_check_lines <- function(data.path, out.file, threads = 1) {
  
  # setwd() has to be changed; in order to reset it tempdir() has to be
  # preserved ------------------------------------------------------------------
  old.wd <- setwd(tempdir())
  
  # check.lines for windows operating systems ----------------------------------
  if (.Platform$OS.type == "windows") {
    
    # enable multi-threading as defined in threads variable --------------------
    c1 <- parallel::makeCluster(threads)
    doSNOW::registerDoSNOW(c1)
    
    # create a list of all shp files -------------------------------------------
    shp.files <- list.files(data.path, recursive = TRUE, full.names = TRUE)[
      grep(c(".shp|SHP"), list.files(data.path, recursive = TRUE,
                                     full.names = TRUE))]
    
    # check if shape files contain lines; if true write it to out.file ---------
    foreach::foreach(x = shp.files, .verbose = TRUE) %dopar% {
      setwd(dirname(x))
      if(.hasSlot(rgdal::readOGR(basename(x),
                                 basename(paste(substr(x, 1, nchar(x)-4),
                                                sep = ""))),
                  "lines")){
        cat(x, file = out.file,
            sep = "\n", append = TRUE)
      }
      
      # garbage collection -----------------------------------------------------
      gc()
    }
    
    # stop multi-threading -----------------------------------------------------
    parallel::stopCluster(c1)
  }
  
  # check.lines for windows unix operating systems -----------------------------
  if(.Platform$OS.type == "unix"){
    
    # enable multi-threading as defined in threads variable --------------------
    
    doMC::registerDoMC(threads)
    
    # create a list of all shp files -------------------------------------------
    shp.files <- list.files(data.path, recursive = TRUE, full.names = TRUE)[
      grep(c(".shp|SHP"), list.files(data.path, recursive = TRUE,
                                     full.names = TRUE))]
    
    # check if shape files contain lines; if true write it to out.file ---------
    foreach::foreach(x = shp.files, .verbose = TRUE) %dopar% {
      setwd(dirname(x))
      if(.hasSlot(rgdal::readOGR(basename(x),
                                 basename(paste(substr(x, 1, nchar(x)-4),
                                                sep = ""))),
                  "lines")){
        cat(x, file = out.file,
            sep = "\n", append = TRUE)
      }
      
      # garbage collection -----------------------------------------------------
      gc()
    }
  }
  
  # reset tempdir --------------------------------------------------------------
  on.exit(setwd(old.wd), add = TRUE)
}
