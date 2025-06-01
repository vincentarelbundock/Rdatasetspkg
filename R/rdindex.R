#' Get Rdatasets Index
#'
#' @description
#' Downloads and returns the complete Rdatasets index as a data frame.
#'
#' @template options
#' @return A data frame containing all available datasets from Rdatasets with columns for Package, Dataset, Title, and other metadata.
#' @examples
#' idx <- rdindex()
#' head(idx)
#' @export
rdindex <- function() {
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
