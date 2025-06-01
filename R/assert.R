#' @keywords internal
assert_string <- function(
  x,
  null.ok = FALSE,
  .var.name = deparse(substitute(x))
) {
  if (is.null(x) && null.ok) {
    return(invisible(TRUE))
  }

  if (is.null(x) && !null.ok) {
    stop(sprintf("Argument '%s' cannot be NULL", .var.name), call. = FALSE)
  }

  if (!is.character(x)) {
    stop(
      sprintf(
        "Argument '%s' must be a character string, got %s",
        .var.name,
        class(x)[1]
      ),
      call. = FALSE
    )
  }

  if (length(x) != 1) {
    stop(
      sprintf(
        "Argument '%s' must be a single string, got length %d",
        .var.name,
        length(x)
      ),
      call. = FALSE
    )
  }

  if (is.na(x)) {
    stop(sprintf("Argument '%s' cannot be NA", .var.name), call. = FALSE)
  }

  return(invisible(TRUE))
}

#' @keywords internal
assert_flag <- function(
  x,
  null.ok = FALSE,
  .var.name = deparse(substitute(x))
) {
  if (is.null(x) && null.ok) {
    return(invisible(TRUE))
  }

  if (is.null(x) && !null.ok) {
    stop(sprintf("Argument '%s' cannot be NULL", .var.name), call. = FALSE)
  }

  if (!is.logical(x)) {
    stop(
      sprintf(
        "Argument '%s' must be logical (TRUE/FALSE), got %s",
        .var.name,
        class(x)[1]
      ),
      call. = FALSE
    )
  }

  if (length(x) != 1) {
    stop(
      sprintf(
        "Argument '%s' must be a single logical value, got length %d",
        .var.name,
        length(x)
      ),
      call. = FALSE
    )
  }

  if (is.na(x)) {
    stop(sprintf("Argument '%s' cannot be NA", .var.name), call. = FALSE)
  }

  return(invisible(TRUE))
}

#' @keywords internal
assert_choice <- function(
  x,
  choices,
  null.ok = FALSE,
  .var.name = deparse(substitute(x))
) {
  if (is.null(x) && null.ok) {
    return(invisible(TRUE))
  }

  # Check if it's a string first
  assert_string(x, null.ok = null.ok, .var.name = .var.name)

  if (!x %in% choices) {
    stop(
      sprintf(
        "Argument '%s' must be one of: %s. Got: %s",
        .var.name,
        paste(choices, collapse = ", "),
        x
      ),
      call. = FALSE
    )
  }

  return(invisible(TRUE))
}

#' @keywords internal
assert_dependency <- function(
  package,
  .var.name = deparse(substitute(package))
) {
  assert_string(package, .var.name = .var.name)

  if (!requireNamespace(package, quietly = TRUE)) {
    stop(
      sprintf(
        "Package '%s' is required but not installed. Please install it with: install.packages('%s')",
        package,
        package
      ),
      call. = FALSE
    )
  }

  return(invisible(TRUE))
}
