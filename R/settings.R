#' @keywords internal
Rdatasets_settings <- new.env()

#' @keywords internal
settings_cache <- function(setti) {
  out <- list()
  for (s in setti) {
    out[[s]] <- settings_get(s)
  }
  return(out)
}

#' @keywords internal
settings_restore <- function(cache) {
  for (n in names(cache)) {
    settings_set(n, cache[[n]])
  }
}

#' @keywords internal
settings_init <- function(settings = NULL) {
  settings_rm()

  default_settings <- list(
    Rdatasets_safefun_return1 = FALSE
  )

  if (!is.null(settings)) {
    settings <- c(settings, default_settings)
  }

  for (i in seq_along(settings)) {
    settings_set(names(settings)[i], settings[[i]])
  }
}

#' @keywords internal
settings_get <- function(name) {
  if (name %in% names(Rdatasets_settings)) {
    get(name, envir = Rdatasets_settings)
  } else {
    NULL
  }
}

#' @keywords internal
settings_set <- function(name, value) {
  assign(name, value = value, envir = Rdatasets_settings)
}

#' @keywords internal
settings_rm <- function(name = NULL) {
  if (is.null(name)) {
    rm(list = names(Rdatasets_settings), envir = Rdatasets_settings)
  } else if ("name" %in% names(Rdatasets_settings)) {
    rm(list = name, envir = Rdatasets_settings)
  }
}

#' @keywords internal
settings_equal <- function(name, comparison) {
  k <- settings_get(name)
  if (!is.null(k) && length(comparison) == 1 && k == comparison) {
    out <- TRUE
  } else if (!is.null(k) && length(comparison) > 1 && k %in% comparison) {
    out <- TRUE
  } else {
    out <- FALSE
  }
  return(out)
}
