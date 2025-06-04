#' @keywords internal
finish <- function(data) {
  format <- getOption("Rdatasets_class", default = "data.frame")
  assert_choice(format, choices = c("data.frame", "tibble", "data.table"))

  if (format == "data.frame") {
    return(data)
  } else if (format == "tibble") {
    assert_dependency("tibble")
    return(tibble::as_tibble(data))
  } else if (format == "data.table") {
    assert_dependency("data.table")
    return(data.table::as.data.table(data))
  }
}
