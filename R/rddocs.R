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
  assert_string(dataset)
  assert_string(package, null.ok = TRUE)

  # If package is NULL, try to find exact match in Rdatasets
  if (is.null(package)) {
    matches <- rsearch(paste0("^", dataset, "$"))
    if (nrow(matches) == 1) {
      package <- matches$Package[1]
      dataset <- matches$Dataset[1]
    } else if (nrow(matches) > 1) {
      msg <- sprintf(
        "Multiple matches found for dataset '%s'. Please specify the package name.\\nAvailable options:\\n%s",
        dataset,
        paste(
          sprintf("  - %s::%s", matches$Package, matches$Dataset),
          collapse = "\\n"
        )
      )
      stop(msg, call. = FALSE)
    } else {
      msg <- sprintf(
        "Dataset '%s' not found. Please:\\n1. Specify the package name, or\\n2. Use rsearch('...') to search available datasets",
        dataset
      )
      stop(msg, call. = FALSE)
    }
  }

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
