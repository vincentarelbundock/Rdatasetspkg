#' Open Dataset Documentation
#'
#' @description
#' Opens the documentation for a dataset from Rdatasets as an HTML page using `getOption("viewer")` or the Rstudio viewer.
#'
#' @inheritParams rdata
#' @template options
#' @details
#' The function attempts to open the documentation in the following order:
#' 1. RStudio's built-in viewer (if `rstudioapi` is available)
#' 2. The viewer specified in `getOption("viewer")`
#' 3. The default browser specified in `getOption("browser")`
#'
#' To control which viewer is used, you can set the following options:
#' * `options(viewer = function(url) { ... })` - Set a custom viewer function
#' * `options(browser = "firefox")` - Set the default browser (used as fallback)
#'
#' If no viewer is available, the function will stop with an error message.
#' @return Invisibly returns `NULL`. The function's primary purpose is to open the dataset documentation in a viewer window.
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
