#' Get Rdatasets Index
#'
#' @description
#' Downloads and returns the complete Rdatasets index as a data frame.
#'
#' @template options
#' @return A data frame containing all available datasets from Rdatasets with the following columns:
#' * `Package`: Character. The name of the R package that contains the dataset
#' * `Dataset`: Character. The name of the dataset
#' * `Title`: Character. A descriptive title for the dataset
#' * `Rows`: Integer. Number of rows in the dataset
#' * `Cols`: Integer. Number of columns in the dataset
#' * `n_binary`: Integer. Number of binary variables in the dataset
#' * `n_character`: Integer. Number of character variables in the dataset
#' * `n_factor`: Integer. Number of factor variables in the dataset
#' * `n_logical`: Integer. Number of logical variables in the dataset
#' * `n_numeric`: Integer. Number of numeric variables in the dataset
#' * `CSV`: Character. URL to download the dataset in CSV format
#' * `Doc`: Character. URL to the dataset's documentation
#' @examples
#' idx <- rindex()
#' head(idx)
#' @export
rindex <- function() {
  cache <- getOption("Rdatasets_cache", default = TRUE)
  assert_flag(cache)

  cache_key <- "Rdatasets_index"

  if (cache) {
    idx <- settings_get(cache_key)
    if (!is.null(idx)) {
      return(idx)
    }
  }

  url <- "https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/datasets.csv"
  idx <- utils::read.csv(url)

  # Rename Item column to Dataset
  names(idx)[names(idx) == "Item"] <- "Dataset"

  if (cache) {
    settings_set(cache_key, idx)
  }

  return(finish(idx))
}
