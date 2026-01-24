context("Dataset objects behave as expected")

test_that("Dataset initialization works", {
  # Empty initialization
  ds <- ado:::Dataset$new()
  expect_equal(ds$nrow, 0)
  expect_equal(ds$ncol, 0)
  expect_equal(ds$dim, c(0, 0))

  # Initialize with data.frame
  df <- data.frame(x = 1:10, y = 11:20)
  ds <- ado:::Dataset$new(df)
  expect_equal(ds$nrow, 10)
  expect_equal(ds$ncol, 2)
  expect_equal(ds$names, c("x", "y"))
})

test_that("Dataset loading works", {
  # use_dataframe
  df <- data.frame(a = 1:5, b = letters[1:5], stringsAsFactors = FALSE)
  ds <- ado:::Dataset$new()
  ds$use_dataframe(df)
  expect_equal(ds$nrow, 5)
  expect_equal(ds$ncol, 2)
  expect_equal(ds$names, c("a", "b"))

  # Clear
  ds$clear()
  expect_equal(ds$nrow, 0)
  expect_equal(ds$ncol, 0)
})

test_that("Dataset manipulation works", {
  df <- data.frame(x = 1:10, y = 11:20, z = 21:30)
  ds <- ado:::Dataset$new(df)

  # setnames
  ds$setnames(c("a", "b", "c"))
  expect_equal(ds$names, c("a", "b", "c"))

  # drop_columns
  ds$drop_columns("c")
  expect_equal(ds$ncol, 2)
  expect_equal(ds$names, c("a", "b"))

  # drop_rows
  ds$drop_rows(1:5)
  expect_equal(ds$nrow, 5)
})

test_that("Dataset access works", {
  df <- data.frame(x = 1:10, y = 11:20)
  ds <- ado:::Dataset$new(df)

  # Active bindings
  expect_equal(ds$dim, c(10, 2))
  expect_equal(ds$nrow, 10)
  expect_equal(ds$ncol, 2)
  expect_equal(ds$names, c("x", "y"))

  # as_data_frame
  result <- ds$as_data_frame
  expect_s3_class(result, "data.table")
  expect_equal(nrow(result), 10)

  # dtypes
  types <- ds$dtypes
  expect_equal(length(types), 2)
  expect_true(all(types %in% c("numeric", "integer", "double")))

  # head
  head_result <- ds$head(3)
  expect_equal(nrow(head_result), 3)
})

test_that("Dataset preserve/restore works", {
  df <- data.frame(x = 1:5, y = 6:10)
  ds <- ado:::Dataset$new(df)

  # Preserve
  ds$preserve()

  # Modify dataset
  ds$drop_rows(1:2)
  expect_equal(ds$nrow, 3)

  # Restore
  ds$restore()
  expect_equal(ds$nrow, 5)
  expect_equal(ds$ncol, 2)
})

test_that("Dataset sorting works", {
  skip("sort() method not implemented yet (FIXME)")
  df <- data.frame(x = c(3, 1, 2), y = c(30, 10, 20))
  ds <- ado:::Dataset$new(df)

  # Sort by x ascending
  ds$sort(c("x"))
  result <- ds$as_data_frame
  expect_equal(result$x, c(1, 2, 3))
  expect_equal(result$y, c(10, 20, 30))

  # Sort by x descending
  df2 <- data.frame(x = c(3, 1, 2), y = c(30, 10, 20))
  ds2 <- ado:::Dataset$new(df2)
  ds2$sort(c("x"), asc = FALSE)
  result2 <- ds2$as_data_frame
  expect_equal(result2$x, c(3, 2, 1))
})

test_that("Dataset in_clause_to_row_numbers works", {
  df <- data.frame(x = 1:10)
  ds <- ado:::Dataset$new(df)

  # Single row
  rows <- ds$in_clause_to_row_numbers(list(lower = 5, upper = 5))
  expect_equal(rows, c(5, 5))

  # Range
  rows <- ds$in_clause_to_row_numbers(list(lower = 2, upper = 5))
  expect_equal(rows, c(2, 5))

  # Negative indices (from end)
  rows <- ds$in_clause_to_row_numbers(list(lower = -3, upper = -1))
  expect_equal(rows, c(8, 10))
})

test_that("Dataset subset works", {
  df <- data.frame(x = 1:10, y = 11:20, z = 21:30)
  ds <- ado:::Dataset$new(df)

  # Subset rows and columns
  result <- ds$subset(subset = 1:5, select = c("x", "y"))
  expect_equal(nrow(result), 5)
  expect_equal(ncol(result), 2)
  expect_equal(names(result), c("x", "y"))
})

test_that("Dataset set_obs works", {
  skip("set_obs() method not implemented yet (FIXME)")
  ds <- ado:::Dataset$new()

  # Set observations on empty dataset
  ds$set_obs(10)
  expect_equal(ds$nrow, 10)
  expect_equal(ds$ncol, 0)

  # Increase observations
  df <- data.frame(x = 1:5)
  ds <- ado:::Dataset$new(df)
  ds$set_obs(10)
  expect_equal(ds$nrow, 10)

  # Decrease observations
  ds$set_obs(3)
  expect_equal(ds$nrow, 3)
})

