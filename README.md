
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Rdatasets package for `R`

The [Rdatasets Archive](https://vincentarelbundock.github.io/Rdatasets/)
is a language-agnostic website that hosts thousands of datasets in CSV
format. These datasets can be freely downloaded from the website (with
documentation), or from any data analysis environment.

The present page describes a package for `R` that provides a simple
interface to search, download, and view documentation for datasets
stored in both CSV and Parquet formats.

## Installation

You can install the development version of Rdatasets from
[GitHub](https://github.com/vincentarelbundock/Rdatasetspkg) with:

``` r
remotes::install_github("vincentarelbundock/Rdatasets")

# optional dependency: faster downloads and less bandwidth
install.packages("nanoparquet")
```

## `rsearch()` Search for datasets

Use `rsearch()` to find datasets by name, package, or title:

``` r
library(Rdatasets)
library(tinytable)

# Search all fields (default behavior)
rsearch(pattern = "iris") |> head()
#>       Package Dataset                      Title Rows Cols n_binary n_character n_factor n_logical n_numeric                                                                   CSV                                                                    Doc
#> 1010 datasets    iris Edgar Anderson's Iris Data  150    5        0           0        1         0         4  https://vincentarelbundock.github.io/Rdatasets/csv/datasets/iris.csv  https://vincentarelbundock.github.io/Rdatasets/doc/datasets/iris.html
#> 1011 datasets   iris3 Edgar Anderson's Iris Data   50   12        0           0        0         0        12 https://vincentarelbundock.github.io/Rdatasets/csv/datasets/iris3.csv https://vincentarelbundock.github.io/Rdatasets/doc/datasets/iris3.html

# Case-insensitive search for datasets about the Titanic
rsearch(pattern = "(?i)TITANIC", perl = TRUE)[, 1:4]
#>         Package         Dataset                                 Title Rows
#> 698     carData TitanicSurvival Survival of Passengers on the Titanic 1309
#> 769  causaldata         titanic  Data from the sinking of the Titanic 2201
#> 803       COUNT         titanic                               titanic 1316
#> 804       COUNT      titanicgrp                            titanicgrp   12
#> 1057   datasets         Titanic Survival of passengers on the Titanic   32
#> 2918  Stat2Data         Titanic             Passengers on the Titanic 1313
#> 3274        vcd       Lifeboats              Lifeboats on the Titanic   18
#> 3330   vcdExtra        Titanicp             Passengers on the Titanic 1309

# Search only in package names
rsearch(pattern = "ggplot2movies", field = "package") 
#>            Package Dataset                                             Title  Rows Cols n_binary n_character n_factor n_logical n_numeric                                                                         CSV                                                                          Doc
#> 1659 ggplot2movies  movies Movie information and user ratings from IMDB.com. 58788   24        7           2        0         0        22 https://vincentarelbundock.github.io/Rdatasets/csv/ggplot2movies/movies.csv https://vincentarelbundock.github.io/Rdatasets/doc/ggplot2movies/movies.html

# Search only in dataset names
rsearch(pattern = "iris", field = "dataset")
#>       Package Dataset                      Title Rows Cols n_binary n_character n_factor n_logical n_numeric                                                                   CSV                                                                    Doc
#> 1010 datasets    iris Edgar Anderson's Iris Data  150    5        0           0        1         0         4  https://vincentarelbundock.github.io/Rdatasets/csv/datasets/iris.csv  https://vincentarelbundock.github.io/Rdatasets/doc/datasets/iris.html
#> 1011 datasets   iris3 Edgar Anderson's Iris Data   50   12        0           0        0         0        12 https://vincentarelbundock.github.io/Rdatasets/csv/datasets/iris3.csv https://vincentarelbundock.github.io/Rdatasets/doc/datasets/iris3.html

# Returns no rows
rsearch(pattern = "bad_name", field = "dataset") 
#>  [1] Package     Dataset     Title       Rows        Cols        n_binary    n_character n_factor    n_logical   n_numeric   CSV         Doc        
#> <0 rows> (or 0-length row.names)

# Search only in titles
rsearch(pattern = "Edgar Anderson", field = "title")
#>       Package Dataset                      Title Rows Cols n_binary n_character n_factor n_logical n_numeric                                                                   CSV                                                                    Doc
#> 1010 datasets    iris Edgar Anderson's Iris Data  150    5        0           0        1         0         4  https://vincentarelbundock.github.io/Rdatasets/csv/datasets/iris.csv  https://vincentarelbundock.github.io/Rdatasets/doc/datasets/iris.html
#> 1011 datasets   iris3 Edgar Anderson's Iris Data   50   12        0           0        0         0        12 https://vincentarelbundock.github.io/Rdatasets/csv/datasets/iris3.csv https://vincentarelbundock.github.io/Rdatasets/doc/datasets/iris3.html
```

## `rdata()` Download datasets

Use `rdata()` to download and load datasets:

``` r
# Download the famous André-Michel Guerry dataset
guerry <- rdata("Guerry")
head(guerry, 3)
#>   rownames dept Region Department Crime_pers Crime_prop Literacy Donations Infants Suicides MainCity Wealth Commerce Clergy Crime_parents Infanticide Donation_clergy Lottery Desertion Instruction Prostitutes Distance Area Pop1831
#> 1        1    1      E        Ain      28870      15890       37      5098   33120    35039    2:Med     73       58     11            71          60              69      41        55          46          13  218.372 5762  346.03
#> 2        2    2      N      Aisne      26226       5521       51      8901   14572    12831    2:Med     22       10     82             4          82              36      38        82          24         327   65.945 7369  513.00
#> 3        3    3      C     Allier      26747       7925       13     10973   17044   114121    2:Med     61       66     68            46          42              76      66        16          85          34  161.927 7340  298.26

# Download the Titanic data from a specific package
titanic <- rdata("Titanic", "Stat2Data")
head(titanic, 3)
#>   rownames                                Name PClass Age    Sex Survived SexCode
#> 1        1        Allen, Miss Elisabeth Walton    1st  29 female        1       1
#> 2        2         Allison, Miss Helen Loraine    1st   2 female        0       1
#> 3        3 Allison, Mr Hudson Joshua Creighton    1st  30   male        0       0
```

## `rindex()` Browse the full dataset index

Use `rindex()` to get the complete list of available datasets:

``` r
idx <- rindex()
cat("Total datasets available:", nrow(idx), "\n")
#> Total datasets available: 3451

cat("Number of packages:", length(unique(idx$Package)), "\n")
#> Number of packages: 100

tail(idx, 10)
#>         Package Dataset   Title Rows Cols n_binary n_character n_factor n_logical n_numeric                                                                       CSV                                                                        Doc
#> 3442 wooldridge twoyear twoyear 6763   23       15           0        0         0        23 https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/twoyear.csv https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/twoyear.html
#> 3443 wooldridge   volat   volat  558   17        0           0        0         0        17   https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/volat.csv   https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/volat.html
#> 3444 wooldridge   vote1   vote1  173   10        1           1        0         0         9   https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/vote1.csv   https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/vote1.html
#> 3445 wooldridge   vote2   vote2  186   26        5           1        0         0        25   https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/vote2.csv   https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/vote2.html
#> 3446 wooldridge voucher voucher  990   19       13           0        0         0        19 https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/voucher.csv https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/voucher.html
#> 3447 wooldridge   wage1   wage1  526   24       16           0        0         0        24   https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/wage1.csv   https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/wage1.html
#> 3448 wooldridge   wage2   wage2  935   17        4           0        0         0        17   https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/wage2.csv   https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/wage2.html
#> 3449 wooldridge wagepan wagepan 4360   44       37           0        0         0        44 https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/wagepan.csv https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/wagepan.html
#> 3450 wooldridge wageprc wageprc  286   20        0           0        0         0        20 https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/wageprc.csv https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/wageprc.html
#> 3451 wooldridge    wine    wine   21    5        0           1        0         0         4    https://vincentarelbundock.github.io/Rdatasets/csv/wooldridge/wine.csv    https://vincentarelbundock.github.io/Rdatasets/doc/wooldridge/wine.html
```

## `rdocs()` View dataset documentation

Use `rdocs()` to open dataset documentation in your browser:

``` r
# Open documentation for the iris dataset
rdocs("iris", "datasets")

# Automatic package detection works here too
rdocs("mtcars")
```

## Performance Features

- **Caching**: All functions cache results by default to speed up
  repeated access and reduce server load
- **Parquet support**: When `nanoparquet` is installed, datasets are
  downloaded in Parquet format (faster, smaller)
- **CSV fallback**: Automatically falls back to CSV format when
  `nanoparquet` is not available

You can disable caching behavior:

``` r
options(Rdatasets_cache = FALSE)
```

**Note**: Please keep caching enabled (TRUE) as it makes repeated access
faster and avoids overloading the Rdatasets server.

## Output Formats

The package supports three output formats that can be set globally:

``` r
# Default: data.frame (no additional dependencies)
options(Rdatasets_cache = FALSE)
options(Rdatasets_class = "data.frame")
rdata("iris") |> class()
#> [1] "data.frame"

# Tibble format (requires tibble package)
options(Rdatasets_class = "tibble")
rdata("iris")
#> # A tibble: 150 × 6
#>    rownames Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>       <int>        <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#>  1        1          5.1         3.5          1.4         0.2 setosa 
#>  2        2          4.9         3            1.4         0.2 setosa 
#>  3        3          4.7         3.2          1.3         0.2 setosa 
#>  4        4          4.6         3.1          1.5         0.2 setosa 
#>  5        5          5           3.6          1.4         0.2 setosa 
#>  6        6          5.4         3.9          1.7         0.4 setosa 
#>  7        7          4.6         3.4          1.4         0.3 setosa 
#>  8        8          5           3.4          1.5         0.2 setosa 
#>  9        9          4.4         2.9          1.4         0.2 setosa 
#> 10       10          4.9         3.1          1.5         0.1 setosa 
#> # ℹ 140 more rows

# data.table format (requires data.table package)
options(Rdatasets_class = "data.table")
rdata("iris")
#>      rownames Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#>         <int>        <num>       <num>        <num>       <num>    <char>
#>   1:        1          5.1         3.5          1.4         0.2    setosa
#>   2:        2          4.9         3.0          1.4         0.2    setosa
#>   3:        3          4.7         3.2          1.3         0.2    setosa
#>   4:        4          4.6         3.1          1.5         0.2    setosa
#>   5:        5          5.0         3.6          1.4         0.2    setosa
#>  ---                                                                     
#> 146:      146          6.7         3.0          5.2         2.3 virginica
#> 147:      147          6.3         2.5          5.0         1.9 virginica
#> 148:      148          6.5         3.0          5.2         2.0 virginica
#> 149:      149          6.2         3.4          5.4         2.3 virginica
#> 150:      150          5.9         3.0          5.1         1.8 virginica

options(Rdatasets_cache = TRUE)
options(Rdatasets_class = "data.frame")
```

The format setting applies to all functions that return data (`rdata()`,
`rindex()`, `rsearch()`).
