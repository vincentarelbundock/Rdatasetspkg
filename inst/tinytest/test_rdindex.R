# Test rdindex function
expect_silent(idx <- rdindex())
expect_true(is.data.frame(idx))
expect_true("Package" %in% colnames(idx))
expect_true("Dataset" %in% colnames(idx))
expect_true("Title" %in% colnames(idx))
expect_true(nrow(idx) > 0)

# Test that index contains expected datasets
expect_true("iris" %in% idx$Dataset)
expect_true("datasets" %in% idx$Package)
