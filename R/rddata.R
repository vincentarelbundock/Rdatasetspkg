#' Download and Read Datasets from Rdatasets
#'
#' @description
#' Downloads a dataset from the Rdatasets archive and returns it as a data frame.
#'
#' [https://vincentarelbundock.github.io/Rdatasets/](https://vincentarelbundock.github.io/Rdatasets/)
#'
#' @param dataset String. Name of the dataset to download from the Rdatasets archive. Use `rsearch()` to search available datasets.
#' @param package String. Package name that originally published the data. If NULL, the function will attempt to automatically detect the package by searching for an exact match in the Rdatasets index.
#' @template options
#' @return A data frame containing the dataset.
#' @details
#' If the \code{nanoparquet} package is installed, \code{rdata()} will use the
#' Parquet format, which is faster and uses less bandwidth to download. If
#' \code{nanoparquet} is not available, the function automatically falls back
#' to CSV format using base R functionality.
#' @examples
#' dat <- rdata("Titanic", "Stat2Data")
#' head(dat)
#' @export
rdata <- function(
  dataset,
  package = NULL
) {
  assert_string(dataset)
  assert_string(package, null.ok = TRUE)

  cache <- getOption("Rdatasets_cache", default = TRUE)
  assert_flag(cache)

  # If package is NULL, try to find exact match in Rdatasets
  if (is.null(package)) {
    matches <- rsearch(paste0("^", dataset, "$"))
    if (nrow(matches) == 1) {
      package <- matches$Package[1]
      dataset <- matches$Dataset[1]
    } else if (nrow(matches) > 1) {
      msg <- sprintf(
        "Multiple matches found for dataset '%s'. Please specify the package name. Available options: %s",
        dataset,
        paste(
          sprintf("  - %s::%s", matches$Package, matches$Dataset),
          collapse = "\\n"
        )
      )
      stop(msg, call. = FALSE)
    } else {
      msg <- sprintf(
        "Dataset '%s' not found. Please specify the package name, or use rsearch('...') to search available datasets",
        dataset
      )
      stop(msg, call. = FALSE)
    }
  }

  # Check cache first
  cache_key <- paste0("dataset_", package, "_", dataset)
  if (cache) {
    cached_data <- settings_get(cache_key)
    if (!is.null(cached_data)) {
      return(cached_data)
    }
  }

  # Download from Rdatasets
  stem <- "https://vincentarelbundock.github.io/Rdatasets/"
  stem <- getOption("Rdataset_path", default = stem)
  assert_string(stem)

  # Try parquet format first if nanoparquet is available
  if (requireNamespace("nanoparquet", quietly = TRUE)) {
    file <- sprintf("parquet/%s/%s.parquet", package, dataset)
    file <- file.path(stem, file)
    tmp <- tempfile(fileext = ".parquet")
    on.exit(unlink(tmp), add = TRUE)
    suppressWarnings(utils::download.file(
      file,
      destfile = tmp,
      quiet = TRUE,
      mode = "wb"
    ))
    file <- tmp
    data <- nanoparquet::read_parquet(file)
    data <- as.data.frame(data)
  } else {
    # Fall back to CSV format
    file <- sprintf("csv/%s/%s.csv", package, dataset)
    file <- file.path(stem, file)
    data <- utils::read.csv(file)
  }

  # Cache the dataset if caching is enabled
  if (cache) {
    settings_set(cache_key, data)
  }

  return(finish(data))
}
