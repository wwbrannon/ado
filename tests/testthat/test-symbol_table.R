context("SymbolTable class unit tests")

test_that("initialization works", {
  # Empty initialization
  st <- ado:::SymbolTable$new()
  expect_s3_class(st, "SymbolTable")
  expect_s3_class(st, "R6")
  expect_length(st$all_symbols(), 0)
  expect_length(st$all_values(), 0)

  # Pre-populated initialization with existing environment
  env <- new.env()
  env$x <- 10
  env$y <- "test"
  st2 <- ado:::SymbolTable$new(env = env)
  expect_equal(sort(st2$all_symbols()), c("x", "y"))
  expect_equal(st2$symbol_value("x"), 10)
  expect_equal(st2$symbol_value("y"), "test")
})

test_that("set_symbol and symbol_value work", {
  st <- ado:::SymbolTable$new()

  # Set new symbol
  st$set_symbol("var1", 42)
  expect_equal(st$symbol_value("var1"), 42)

  # Overwrite existing symbol
  st$set_symbol("var1", 100)
  expect_equal(st$symbol_value("var1"), 100)

  # Set various types
  st$set_symbol("str", "hello")
  st$set_symbol("vec", c(1, 2, 3))
  st$set_symbol("lst", list(a = 1, b = 2))

  expect_equal(st$symbol_value("str"), "hello")
  expect_equal(st$symbol_value("vec"), c(1, 2, 3))
  expect_equal(st$symbol_value("lst"), list(a = 1, b = 2))
})

test_that("symbol_value returns NULL for undefined symbol", {
  st <- ado:::SymbolTable$new()

  # NOTE: raiseCondition() uses signalCondition() not stop(), so it returns NULL
  # rather than throwing an error. This is the current implementation behavior.
  result <- st$symbol_value("nonexistent")
  expect_null(result)
})

test_that("symbol_defined works", {
  st <- ado:::SymbolTable$new()

  # Undefined symbol returns FALSE
  expect_false(st$symbol_defined("var1"))

  # Defined symbol returns TRUE
  st$set_symbol("var1", 10)
  expect_true(st$symbol_defined("var1"))

  # Multiple symbols
  st$set_symbol("var2", 20)
  expect_true(st$symbol_defined("var1"))
  expect_true(st$symbol_defined("var2"))
  expect_false(st$symbol_defined("var3"))
})

test_that("unset_symbol works", {
  st <- ado:::SymbolTable$new()

  # Set and unset existing symbol
  st$set_symbol("var1", 100)
  expect_true(st$symbol_defined("var1"))

  st$unset_symbol("var1")
  expect_false(st$symbol_defined("var1"))

  # Unset non-existent symbol (may produce warning from rm())
  # This is expected R behavior - rm() warns about non-existent objects
  expect_warning(st$unset_symbol("nonexistent"))
})

test_that("all_symbols and all_values work", {
  st <- ado:::SymbolTable$new()

  # Empty table
  expect_length(st$all_symbols(), 0)
  expect_length(st$all_values(), 0)

  # Populated table
  st$set_symbol("x", 10)
  st$set_symbol("y", 20)
  st$set_symbol("z", 30)

  symbols <- st$all_symbols()
  expect_length(symbols, 3)
  expect_true(all(c("x", "y", "z") %in% symbols))

  values <- st$all_values()
  expect_length(values, 3)
  expect_equal(values$x, 10)
  expect_equal(values$y, 20)
  expect_equal(values$z, 30)

  # Match lengths
  expect_equal(length(st$all_symbols()), length(st$all_values()))
})

test_that("set_symbols_from_list works", {
  st <- ado:::SymbolTable$new()

  # Bulk set from named list
  lst <- list(a = 1, b = 2, c = 3)
  st$set_symbols_from_list(lst)

  expect_true(st$symbol_defined("a"))
  expect_true(st$symbol_defined("b"))
  expect_true(st$symbol_defined("c"))
  expect_equal(st$symbol_value("a"), 1)
  expect_equal(st$symbol_value("b"), 2)
  expect_equal(st$symbol_value("c"), 3)

  # Overwrite existing symbols
  lst2 <- list(a = 100, d = 4)
  st$set_symbols_from_list(lst2)

  expect_equal(st$symbol_value("a"), 100)
  expect_equal(st$symbol_value("d"), 4)
  expect_true(st$symbol_defined("b"))  # b should still exist
})

test_that("symbol_values_from_list works", {
  st <- ado:::SymbolTable$new()

  # Set up some symbols
  st$set_symbol("x", 10)
  st$set_symbol("y", 20)
  st$set_symbol("z", 30)

  # Get multiple values
  result <- st$symbol_values_from_list(c("x", "y"))
  expect_length(result, 2)
  expect_equal(result$x, 10)
  expect_equal(result$y, 20)

  # Get all values
  result2 <- st$symbol_values_from_list(c("x", "y", "z"))
  expect_length(result2, 3)
  expect_equal(result2$x, 10)
  expect_equal(result2$y, 20)
  expect_equal(result2$z, 30)
})

test_that("symbol_values_from_list returns NULL when any symbol undefined", {
  st <- ado:::SymbolTable$new()
  st$set_symbol("x", 10)

  # NOTE: mget() throws an error for undefined symbols, which is caught by
  # tryCatch and causes raiseCondition() to be called. Since raiseCondition
  # uses signalCondition() not stop(), the function returns NULL.
  result <- st$symbol_values_from_list(c("x", "nonexistent"))
  expect_null(result)
})

test_that("symbol_values_from_list accepts character vectors", {
  st <- ado:::SymbolTable$new()
  st$set_symbol("x", 10)
  st$set_symbol("y", 20)

  # Character vector (most common usage)
  result <- st$symbol_values_from_list(c("x", "y"))
  expect_equal(result$x, 10)
  expect_equal(result$y, 20)
})

test_that("symbol_values_from_list list input has implementation bug", {
  # NOTE: There is a bug in SymbolTable$symbol_values_from_list at line 98:
  # vapply uses logical(0) instead of logical(1), causing an error when
  # passed a list. This test documents the current (broken) behavior.

  st <- ado:::SymbolTable$new()
  st$set_symbol("x", 10)

  # List input currently fails due to vapply bug
  expect_error(
    st$symbol_values_from_list(list("x", "y"))
  )
})

test_that("environment sharing works", {
  # Two SymbolTables sharing the same environment
  env <- new.env()
  st1 <- ado:::SymbolTable$new(env = env)
  st2 <- ado:::SymbolTable$new(env = env)

  # Set via st1
  st1$set_symbol("shared", 42)

  # Should be visible via st2
  expect_true(st2$symbol_defined("shared"))
  expect_equal(st2$symbol_value("shared"), 42)

  # Modify via st2
  st2$set_symbol("shared", 100)

  # Should be updated in st1
  expect_equal(st1$symbol_value("shared"), 100)
})

test_that("independent environments work", {
  # Two SymbolTables with independent environments
  st1 <- ado:::SymbolTable$new()
  st2 <- ado:::SymbolTable$new()

  # Set in st1
  st1$set_symbol("var1", 42)

  # Should not be visible in st2
  expect_false(st2$symbol_defined("var1"))
  expect_null(st2$symbol_value("var1"))
})

test_that("special characters in symbol names work", {
  st <- ado:::SymbolTable$new()

  # Underscores
  st$set_symbol("var_name", 10)
  expect_equal(st$symbol_value("var_name"), 10)

  # Dots
  st$set_symbol("var.name", 20)
  expect_equal(st$symbol_value("var.name"), 20)

  # Numbers (but not as first character in R)
  st$set_symbol("var2", 30)
  expect_equal(st$symbol_value("var2"), 30)
})

test_that("empty symbol table operations work", {
  st <- ado:::SymbolTable$new()

  # all_symbols on empty table
  expect_length(st$all_symbols(), 0)
  expect_equal(st$all_symbols(), character(0))

  # all_values on empty table
  expect_length(st$all_values(), 0)
  expect_equal(st$all_values(), list())

  # symbol_defined on empty table
  expect_false(st$symbol_defined("anything"))

  # symbol_values_from_list with empty list
  result <- st$symbol_values_from_list(character(0))
  expect_length(result, 0)
})

test_that("large symbol table works", {
  st <- ado:::SymbolTable$new()

  # Set many symbols
  for (i in 1:100) {
    st$set_symbol(paste0("var", i), i * 10)
  }

  # Verify count
  expect_equal(length(st$all_symbols()), 100)

  # Verify some values
  expect_equal(st$symbol_value("var1"), 10)
  expect_equal(st$symbol_value("var50"), 500)
  expect_equal(st$symbol_value("var100"), 1000)

  # Unset some
  st$unset_symbol("var50")
  expect_false(st$symbol_defined("var50"))
  expect_equal(length(st$all_symbols()), 99)
})

test_that("NULL values can be stored", {
  st <- ado:::SymbolTable$new()

  # Set NULL value
  st$set_symbol("null_var", NULL)

  expect_true(st$symbol_defined("null_var"))
  expect_null(st$symbol_value("null_var"))
})

test_that("complex data structures can be stored", {
  st <- ado:::SymbolTable$new()

  # Data frame
  df <- data.frame(x = 1:3, y = 4:6)
  st$set_symbol("df_var", df)
  expect_equal(st$symbol_value("df_var"), df)

  # Matrix
  mat <- matrix(1:9, nrow = 3)
  st$set_symbol("mat_var", mat)
  expect_equal(st$symbol_value("mat_var"), mat)

  # Function
  fn <- function(x) x + 1
  st$set_symbol("fn_var", fn)
  expect_equal(st$symbol_value("fn_var")(10), 11)

  # Nested list
  nested <- list(a = list(b = list(c = 42)))
  st$set_symbol("nested_var", nested)
  expect_equal(st$symbol_value("nested_var"), nested)
})