#' Open Dataset Documentation
#'
#' @description
#' Opens the documentation for a dataset from Rdatasets as an HTML page using `getOption("viewer")` or the Rstudio viewer.
#'
#' @inheritParams rdata
#' @template options
#' @examplesIf FALSE
#' rddocs("Titanic", "Stat2Data")
#' rddocs("iris", "datasets")
#' @export
rddocs <- function(dataset, package = NULL) {
  # Validate dataset and package combination
  validated <- check_available_data(dataset, package)
  package <- validated$package
  dataset <- validated$dataset

  # Generate Rdatasets documentation URL
  documentation <- "https://vincentarelbundock.github.io/Rdatasets/doc/%s/%s.html"
  documentation <- sprintf(documentation, package, dataset)

  temp_doc <- tempfile(fileext = ".html")
  utils::download.file(documentation, temp_doc, mode = "w", quiet = TRUE)

  if (requireNamespace("rstudioapi")) {
    if (isTRUE(rstudioapi::isAvailable())) {
      rstudioapi::viewer(temp_doc)
    }
  }
  msg <- "Please choose a default browser with a command like: `options(browser = 'firefox')`"
  if (identical(getOption("browser"), "")) stop(msg, call. = FALSE)

  viewer <- getOption("viewer", utils::browseURL)
  if (!is.function(viewer)) stop(msg, call. = FALSE)

  viewer(temp_doc)
  return(invisible(NULL))
}
