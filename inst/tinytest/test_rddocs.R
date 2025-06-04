# Test rdocs function error handling
# Note: We can't easily test the actual viewer functionality in automated tests
# so we focus on error handling and input validation

# Test assertion errors
expect_error(rddocs(123), pattern = "must be a character string")
expect_error(rddocs("iris", 123), pattern = "must be a character string")

# Test error for nonexistent dataset
expect_error(rddocs("nonexistent_dataset_xyz"), pattern = "not found")

# Test error for nonexistent package + dataset combination
expect_error(rddocs("nonexistent_dataset", "datasets"), pattern = "not found in package")

# Test error for nonexistent package
expect_error(rddocs("iris", "nonexistent_package"), pattern = "Package .* not found in Rdatasets")

# Test that function accepts valid inputs without error up to the point of opening docs
# We can't test the actual doc opening in an automated test environment
# but we can test input validation and dataset lookup
