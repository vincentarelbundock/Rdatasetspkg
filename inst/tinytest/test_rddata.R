# Test rdata function with known dataset
expect_silent(data <- rddata("iris", "datasets"))
expect_true(is.data.frame(data))
expect_true(nrow(data) > 0)
expect_true(ncol(data) > 0)

# Test automatic package detection
expect_silent(data2 <- rddata("iris"))
expect_true(is.data.frame(data2))
expect_equal(nrow(data), nrow(data2))

# Test error for nonexistent dataset
expect_error(rddata("nonexistent_dataset_xyz"), pattern = "not found")

# Test error for nonexistent package + dataset combination
expect_error(rddata("nonexistent_dataset", "datasets"), pattern = "not found in package")

# Test error for nonexistent package
expect_error(rddata("iris", "nonexistent_package"), pattern = "Package .* not found in Rdatasets")

# Test assertion errors
expect_error(rddata(123), pattern = "must be a character string")
expect_error(rddata("iris", 123), pattern = "must be a character string")
