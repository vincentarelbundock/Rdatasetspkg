# Test rsearch function
expect_silent(results <- rsearch(pattern = "iris"))
expect_true(is.data.frame(results))
expect_true(nrow(results) >= 1)
expect_true("iris" %in% results$Dataset)

# Test case-insensitive search
expect_silent(results2 <- rsearch(pattern = "(?i)IRIS", perl = TRUE))
expect_true(nrow(results2) >= 1)

# Test search by package
expect_silent(results3 <- rsearch(pattern = "datasets"))
expect_true(nrow(results3) > 0)

# Test field-specific searches
expect_silent(pkg_results <- rsearch(pattern = "datasets", field = "package"))
expect_true(all(grepl("datasets", pkg_results$Package)))

expect_silent(dataset_results <- rsearch(pattern = "iris", field = "dataset"))
expect_true("iris" %in% dataset_results$Dataset)

expect_silent(title_results <- rsearch(pattern = "Edgar Anderson", field = "title"))
expect_true(nrow(title_results) >= 1)

# Test empty search results
expect_silent(empty <- rsearch(pattern = "nonexistent_xyz_123"))
expect_true(is.data.frame(empty))
expect_equal(nrow(empty), 0)

# Test fixed search (literal string)
expect_silent(fixed_results <- rsearch(pattern = "iris", fixed = TRUE))
expect_true("iris" %in% fixed_results$Dataset)

# Test perl regex
expect_silent(perl_results <- rsearch(pattern = "(?i)iris", perl = TRUE))
expect_true(nrow(perl_results) >= 1)

# Test assertion errors
expect_error(rsearch(pattern = 123), pattern = "must be a character string")
expect_error(rsearch(pattern = "iris", field = "invalid"), pattern = "must be one of")
expect_error(rsearch(pattern = "iris", fixed = "invalid"), pattern = "must be logical")
expect_error(rsearch(pattern = "iris", perl = "invalid"), pattern = "must be logical")
