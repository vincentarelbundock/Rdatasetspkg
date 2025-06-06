% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rdsearch.R
\name{rdsearch}
\alias{rdsearch}
\title{Search Available Datasets}
\usage{
rdsearch(
  pattern,
  field = NULL,
  fixed = FALSE,
  perl = FALSE,
  ignore.case = FALSE
)
}
\arguments{
\item{pattern}{String. Search pattern. Can be a regular expression or literal string depending on the \code{fixed} argument.}

\item{field}{String. Which field to search in. One of "package", "dataset", "title". If NULL (default), searches in all three fields.}

\item{fixed}{logical. If \code{TRUE}, \code{pattern} is a string to be
    matched as is.  Overrides all conflicting arguments.}

\item{perl}{logical.  Should Perl-compatible regexps be used?}

\item{ignore.case}{logical. if \code{FALSE}, the pattern matching is \emph{case
      sensitive} and if \code{TRUE}, case is ignored during matching.}
}
\value{
A data frame containing matching datasets with the following columns:
\itemize{
\item \code{Package}: Character. The name of the R package that contains the dataset
\item \code{Dataset}: Character. The name of the dataset
\item \code{Title}: Character. A descriptive title for the dataset
\item \code{Rows}: Integer. Number of rows in the dataset
\item \code{Cols}: Integer. Number of columns in the dataset
\item \code{n_binary}: Integer. Number of binary variables in the dataset
\item \code{n_character}: Integer. Number of character variables in the dataset
\item \code{n_factor}: Integer. Number of factor variables in the dataset
\item \code{n_logical}: Integer. Number of logical variables in the dataset
\item \code{n_numeric}: Integer. Number of numeric variables in the dataset
\item \code{CSV}: Character. URL to download the dataset in CSV format
\item \code{Doc}: Character. URL to the dataset's documentation
}
}
\description{
Search available datasets from the Rdatasets archive by regular expression.
}
\section{Global Options}{

The following global options control package behavior:
\itemize{
\item \code{Rdatasets_cache}: Logical
\itemize{
\item Whether to cache downloaded data and index for faster subsequent access. Default: \code{TRUE}. Please keep this option TRUE as it makes repeated access faster and avoids overloading the Rdatasets server. Only set to FALSE if local memory is severely limited.
\item Ex: `options(Rdatasets_cache = TRUE)``
}
\item \code{Rdatasets_class}: String
\itemize{
\item Output class of the returned data. One of "data.frame" (default), "tibble", or "data.table". Default: \code{"data.frame"}. Requires the respective packages to be installed for "tibble" or "data.table" formats.
\item Ex: \code{options(Rdatasets_class = "tibble")}
}
\item \code{Rdataset_path}: String.
\itemize{
\item Base URL for the Rdatasets archive. Default: \code{"https://vincentarelbundock.github.io/Rdatasets/"}. Advanced users can set this to use a different mirror or local copy.
\item Ex: \code{options(Rdataset_path = "https://vincentarelbundock.github.io/Rdatasets/")}
}
}
}

\examples{
# Search all fields (default behavior)
rdsearch("iris")

# Case-insensitive search
rdsearch("(?i)titanic")

# Search only in package names
rdsearch("datasets", field = "package")

# Search only in dataset names
rdsearch("iris", field = "dataset")

# Search only in titles
rdsearch("Edgar Anderson", field = "title")
}
