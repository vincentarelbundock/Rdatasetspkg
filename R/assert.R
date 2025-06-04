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

#' @keywords internal
check_available_data <- function(dataset, package = NULL) {
  assert_string(dataset)
  assert_string(package, null.ok = TRUE)
  
  # If package is NULL, try to find exact match in Rdatasets
  if (is.null(package)) {
    matches <- rdsearch(paste0("^", dataset, "$"))
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
        "Dataset '%s' not found. Please specify the package name, or use rdsearch('...') to search available datasets",
        dataset
      )
      stop(msg, call. = FALSE)
    }
  } else {
    # If both package and dataset are provided, validate they exist together
    idx <- rdindex()
    match_exists <- any(idx$Package == package & idx$Dataset == dataset)
    if (!match_exists) {
      # Check if package exists
      package_exists <- any(idx$Package == package)
      if (!package_exists) {
        msg <- sprintf(
          "Package '%s' not found in Rdatasets. Use rdsearch() to find available packages and datasets",
          package
        )
      } else {
        # Package exists but dataset doesn't
        available_datasets <- idx$Dataset[idx$Package == package]
        msg <- sprintf(
          "Dataset '%s' not found in package '%s'. Available datasets in this package: %s",
          dataset,
          package,
          paste(available_datasets, collapse = ", ")
        )
      }
      stop(msg, call. = FALSE)
    }
  }
  
  return(list(package = package, dataset = dataset))
}
