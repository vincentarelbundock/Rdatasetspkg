#' Search Available Datasets
#'
#' @description
#' Search available datasets from the Rdatasets archive by regular expression.
#'
#' @param pattern String. Search pattern. Can be a regular expression or literal string depending on the \code{fixed} argument.
#' @param field String. Which field to search in. One of "package", "dataset", "title". If NULL (default), searches in all three fields.
#' @inheritParams base::grepl
#' @template options
#' @return A data frame with matching datasets.
#' @examples
#' # Search all fields (default behavior)
#' rsearch("iris")
#'
#' # Case-insensitive search
#' rsearch("(?i)titanic")
#'
#' # Search only in package names
#' rsearch("datasets", field = "package")
#'
#' # Search only in dataset names
#' rsearch("iris", field = "dataset")
#'
#' # Search only in titles
#' rsearch("Edgar Anderson", field = "title")
#' @export
rsearch <- function(pattern, field = NULL, fixed = FALSE, perl = FALSE, ignore.case = FALSE) {
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

  idx <- rindex()

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
