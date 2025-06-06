#' Search Available Datasets
#'
#' @description
#' Search available datasets from the Rdatasets archive by regular expression.
#'
#' @param pattern String. Search pattern. Can be a regular expression or literal string depending on the \code{fixed} argument.
#' @param field String. Which field to search in. One of "package", "dataset", "title". If NULL (default), searches in all three fields.
#' @inheritParams base::grepl
#' @template options
#' @return A data frame containing matching datasets with the following columns:
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
#' # Search all fields (default behavior)
#' rdsearch("iris")
#'
#' # Case-insensitive search
#' rdsearch("(?i)titanic")
#'
#' # Search only in package names
#' rdsearch("datasets", field = "package")
#'
#' # Search only in dataset names
#' rdsearch("iris", field = "dataset")
#'
#' # Search only in titles
#' rdsearch("Edgar Anderson", field = "title")
#' @export
rdsearch <- function(pattern, field = NULL, fixed = FALSE, perl = FALSE, ignore.case = FALSE) {
  assert_string(pattern)
  assert_flag(fixed)
  assert_flag(perl)
  assert_choice(
    field,
    choices = c("package", "dataset", "title"),
    null.ok = TRUE
  )

  cache <- getOption("Rdatasets_cache", default = TRUE)
  assert_flag(cache)

  idx <- rdindex()

  if (is.null(field)) {
    # Search in all three columns
    idx <- idx[
      grepl(pattern, idx$Dataset, fixed = fixed, perl = perl, ignore.case = ignore.case) |
        grepl(pattern, idx$Package, fixed = fixed, perl = perl, ignore.case = ignore.case) |
        grepl(pattern, idx$Title, fixed = fixed, perl = perl, ignore.case = ignore.case),
      ,
      drop = FALSE
    ]
  } else {
    # Search in specific field
    field_col <- switch(
      field,
      "package" = "Package",
      "dataset" = "Dataset",
      "title" = "Title"
    )
    idx <- idx[grepl(pattern, idx[[field_col]], fixed = fixed, perl = perl, ignore.case = ignore.case), , drop = FALSE]
  }

  return(finish(idx))
}
