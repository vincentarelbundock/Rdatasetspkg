#' @section Global Options:
#' The following global options control package behavior:
#' 
#' - `Rdatasets_cache`: Logical
#'   - Whether to cache downloaded data and index for faster subsequent access. Default: `TRUE`. Please keep this option TRUE as it makes repeated access faster and avoids overloading the Rdatasets server. Only set to FALSE if local memory is severely limited.
#'   - Ex: `options(Rdatasets_cache = TRUE)``
#' - `Rdatasets_class`: String
#'   - Output class of the returned data. One of "data.frame" (default), "tibble", or "data.table". Default: `"data.frame"`. Requires the respective packages to be installed for "tibble" or "data.table" formats.
#'   - Ex: `options(Rdatasets_class = "tibble")`
#' - `Rdataset_path`: String.
#'   - Base URL for the Rdatasets archive. Default: `"https://vincentarelbundock.github.io/Rdatasets/"`. Advanced users can set this to use a different mirror or local copy.
#'   - Ex: `options(Rdataset_path = "https://vincentarelbundock.github.io/Rdatasets/")`
#' 
