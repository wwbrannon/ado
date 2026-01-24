context("Utility Functions")

# ============================================================================
# Infix Operators
# ============================================================================

test_that("%is% checks class membership correctly", {
  `%is%` <- ado:::`%is%`

  x <- data.frame(a = 1)
  expect_true(x %is% "data.frame")
  expect_true(x %is% c("data.frame"))
  expect_false(x %is% "matrix")

  # Multiple classes
  y <- structure(list(), class = c("foo", "bar"))
  expect_true(y %is% c("foo", "bar"))
  expect_true(y %is% "foo")
  expect_false(y %is% c("foo", "baz"))
})

test_that("%p% concatenates strings", {
  `%p%` <- ado:::`%p%`

  expect_equal("hello" %p% "world", "helloworld")
  expect_equal("a" %p% "b" %p% "c", "abc")
  expect_equal("test" %p% 123, "test123")
  expect_equal("" %p% "x", "x")
})

test_that("%not_in% checks non-membership", {
  `%not_in%` <- ado:::`%not_in%`

  expect_true(5 %not_in% c(1, 2, 3))
  expect_false(2 %not_in% c(1, 2, 3))
  expect_true("x" %not_in% c("a", "b", "c"))
  expect_false("a" %not_in% c("a", "b", "c"))

  # Empty vector
  expect_true(1 %not_in% numeric(0))
})

test_that("%xor% performs logical XOR", {
  `%xor%` <- ado:::`%xor%`

  expect_true(TRUE %xor% FALSE)
  expect_true(FALSE %xor% TRUE)
  expect_false(TRUE %xor% TRUE)
  expect_false(FALSE %xor% FALSE)

  # Vectorized
  expect_equal(c(TRUE, FALSE) %xor% c(FALSE, FALSE), c(TRUE, FALSE))
})

test_that("%|% performs bitwise OR", {
  `%|%` <- ado:::`%|%`

  expect_equal(1 %|% 2, 3)
  expect_equal(4 %|% 8, 12)
  expect_equal(0 %|% 5, 5)
  expect_equal(7 %|% 7, 7)

  # Used for flag combinations (as in debug flags)
  expect_equal(32 %|% 64, 96)
})

test_that("%&% performs bitwise AND", {
  `%&%` <- ado:::`%&%`

  expect_equal(3 %&% 1, 1)
  expect_equal(7 %&% 3, 3)
  expect_equal(5 %&% 1, 1)
  expect_equal(8 %&% 4, 0)

  # Masking flags
  expect_equal(96 %&% 32, 32)
  expect_equal(96 %&% 64, 64)
})

# ============================================================================
# Option Handling
# ============================================================================

test_that("validateOpts validates and unabbreviates options", {
  # Create mock option list matching AST structure
  opts <- list(
    list(name = "det", args = NULL),
    list(name = "noc", args = NULL)
  )
  valid <- c("detail", "noconst", "robust")

  result <- ado:::validateOpts(opts, valid)
  expect_equal(as.character(result[[1]]$name), "detail")
  expect_equal(as.character(result[[2]]$name), "noconst")
})

test_that("validateOpts rejects duplicate options", {
  opts <- list(
    list(name = "detail", args = NULL),
    list(name = "detail", args = NULL)
  )
  valid <- c("detail", "noconst")

  expect_condition(
    ado:::validateOpts(opts, valid),
    class = "AdoException"
  )
})

test_that("validateOpts handles empty option list", {
  result <- ado:::validateOpts(list(), c("detail", "noconst"))
  expect_equal(result, list())
})

test_that("validateOpts rejects invalid options", {
  opts <- list(list(name = "invalid", args = NULL))
  valid <- c("detail", "noconst")

  expect_condition(
    ado:::validateOpts(opts, valid),
    class = "AdoException"
  )
})

test_that("hasOption checks for option presence", {
  opts <- list(
    list(name = "detail", args = NULL),
    list(name = "noconst", args = NULL)
  )

  expect_true(ado:::hasOption(opts, "detail"))
  expect_true(ado:::hasOption(opts, "noconst"))
  expect_false(ado:::hasOption(opts, "robust"))
})

test_that("hasOption handles empty option list", {
  expect_false(ado:::hasOption(list(), "detail"))
})

test_that("optionArgs retrieves option arguments", {
  opts <- list(
    list(name = "by", args = list("group1", "group2")),
    list(name = "detail", args = NULL)
  )

  expect_equal(ado:::optionArgs(opts, "by"), list("group1", "group2"))
  expect_null(ado:::optionArgs(opts, "detail"))
})

test_that("optionArgs raises error for missing option", {
  opts <- list(list(name = "detail", args = NULL))

  expect_condition(
    ado:::optionArgs(opts, "missing"),
    class = "AdoException"
  )
})

# ============================================================================
# General Utilities
# ============================================================================

test_that("temporary_name generates valid names", {
  # Basic generation
  nm <- ado:::temporary_name(len = 10)
  expect_equal(nchar(nm), 10)
  expect_true(grepl("^[A-Za-z][A-Za-z0-9]*$", nm))

  # Custom length
  nm5 <- ado:::temporary_name(len = 5)
  expect_equal(nchar(nm5), 5)

  # Minimum length
  nm1 <- ado:::temporary_name(len = 1)
  expect_equal(nchar(nm1), 1)
  expect_true(grepl("^[A-Za-z]$", nm1))
})

test_that("temporary_name avoids collisions", {
  `%not_in%` <- ado:::`%not_in%`

  existing <- c("abc123", "def456", "xyz789")
  nm <- ado:::temporary_name(lst = existing, len = 6)

  expect_equal(nchar(nm), 6)
  expect_true(nm %not_in% existing)
})

test_that("temporary_name rejects invalid length", {
  expect_condition(
    ado:::temporary_name(len = 0),
    class = "AdoException"
  )

  expect_condition(
    ado:::temporary_name(len = -5),
    class = "AdoException"
  )
})

test_that("char_count counts character occurrences", {
  result <- ado:::char_count(c("hello", "world"))

  expect_equal(length(result), 2)
  expect_true(is.list(result))

  # Check "hello" - result is a named integer vector
  expect_equal(unname(result[[1]]["h"]), 1)
  expect_equal(unname(result[[1]]["e"]), 1)
  expect_equal(unname(result[[1]]["l"]), 2)
  expect_equal(unname(result[[1]]["o"]), 1)

  # Characters not present should be 0
  expect_equal(unname(result[[1]]["w"]), 0)
})

test_that("char_count handles empty strings", {
  result <- ado:::char_count("")
  expect_equal(length(result), 1)
})

test_that("flatten recursively flattens nested lists", {
  # Simple nesting
  nested <- list(1, list(2, 3), 4)
  expect_equal(ado:::flatten(nested), list(1, 2, 3, 4))

  # Deep nesting
  deep <- list(1, list(2, list(3, list(4, 5))))
  expect_equal(ado:::flatten(deep), list(1, 2, 3, 4, 5))

  # Already flat
  flat <- list(1, 2, 3)
  expect_equal(ado:::flatten(flat), list(1, 2, 3))

  # Mixed types - flatten preserves structure
  mixed <- list("a", list(1, list("b", 2)))
  result <- ado:::flatten(mixed)
  expect_equal(length(result), 4)
  expect_equal(result[[1]], "a")
  # Note: flatten may coerce types due to c() behavior
  expect_true(result[[2]] == 1)  # Use loose equality
  expect_equal(result[[3]], "b")
  expect_true(result[[4]] == 2)
})

test_that("rev_string reverses strings", {
  expect_equal(ado:::rev_string("hello"), "olleh")
  expect_equal(ado:::rev_string("abc"), "cba")
  expect_equal(ado:::rev_string("a"), "a")
  expect_equal(ado:::rev_string(""), "")

  # Vectorized
  expect_equal(ado:::rev_string(c("ab", "cd")), c("ba", "dc"))
})

test_that("valid_data_type recognizes Stata types", {
  # Numeric types
  expect_true(ado:::valid_data_type("byte"))
  expect_true(ado:::valid_data_type("int"))
  expect_true(ado:::valid_data_type("long"))
  expect_true(ado:::valid_data_type("float"))
  expect_true(ado:::valid_data_type("double"))

  # String types
  expect_true(ado:::valid_data_type("str"))
  expect_true(ado:::valid_data_type("strL"))
  expect_true(ado:::valid_data_type("str1"))
  expect_true(ado:::valid_data_type("str244"))

  # Invalid types
  expect_false(ado:::valid_data_type("str0"))
  expect_false(ado:::valid_data_type("string"))
  expect_false(ado:::valid_data_type("integer"))
  expect_false(ado:::valid_data_type("varchar"))
})

test_that("unabbreviateName expands abbreviated names", {
  choices <- c("detail", "verbose", "debug", "default")

  expect_equal(ado:::unabbreviateName("det", choices), "detail")
  expect_equal(ado:::unabbreviateName("verb", choices), "verbose")
  expect_equal(ado:::unabbreviateName("deb", choices), "debug")

  # Full names work
  expect_equal(ado:::unabbreviateName("detail", choices), "detail")
})

test_that("unabbreviateName rejects ambiguous abbreviations", {
  choices <- c("detail", "debug", "default")

  # "de" is ambiguous (could be detail, debug, or default)
  expect_condition(
    ado:::unabbreviateName("de", choices),
    class = "AdoException"
  )
})

test_that("unabbreviateName rejects non-matching names", {
  choices <- c("detail", "verbose")

  expect_condition(
    ado:::unabbreviateName("invalid", choices),
    class = "AdoException"
  )
})

test_that("expression_list_to_formula converts expression lists", {
  # With dependent variable
  expr_list <- list("mpg", "wt", "hp")
  formula <- ado:::expression_list_to_formula(expr_list, dv = TRUE)

  expect_s3_class(formula, "formula")
  expect_equal(as.character(formula)[2], "mpg")
  expect_match(as.character(formula)[3], "wt.*hp")

  # Without dependent variable - creates formula with empty LHS (~ rhs)
  expr_list_no_dv <- list("wt", "hp")
  formula_no_dv <- ado:::expression_list_to_formula(expr_list_no_dv, dv = FALSE)

  expect_s3_class(formula_no_dv, "formula")
  # The formula structure is: ~ wt + hp, so element [2] is the RHS
  expect_match(as.character(formula_no_dv)[2], "wt.*hp")
})

# ============================================================================
# Condition Handling
# ============================================================================

test_that("raiseCondition signals conditions", {
  expect_condition(
    ado:::raiseCondition("test message"),
    class = "AdoException"
  )

  expect_condition(
    ado:::raiseCondition("test", cls = "CustomException"),
    class = "CustomException"
  )

  # Should also have AdoException class
  cond <- tryCatch(
    ado:::raiseCondition("test", cls = "CustomException"),
    condition = function(c) c
  )
  expect_true("AdoException" %in% class(cond))
  expect_true("CustomException" %in% class(cond))
})

test_that("raiseif raises condition when expression is TRUE", {
  # Should raise
  expect_condition(
    ado:::raiseif(TRUE, msg = "test"),
    class = "AdoException"
  )

  expect_condition(
    ado:::raiseif(1 > 0, msg = "positive"),
    class = "AdoException"
  )

  # Should NOT raise
  expect_silent(ado:::raiseif(FALSE, msg = "test"))
  expect_silent(ado:::raiseif(1 < 0, msg = "test"))
})

test_that("raiseif handles edge cases", {
  # Empty logical should raise
  expect_condition(
    ado:::raiseif(logical(0), msg = "empty"),
    class = "AdoException"
  )

  # NA should raise
  expect_condition(
    ado:::raiseif(NA, msg = "na"),
    class = "AdoException"
  )

  # Non-logical should raise
  expect_condition(
    ado:::raiseif("not logical", msg = "type"),
    class = "AdoException"
  )
})

test_that("raiseif generates default message from expression", {
  cond <- tryCatch(
    ado:::raiseif(TRUE),
    condition = function(c) c
  )

  expect_match(conditionMessage(cond), "TRUE.*is not TRUE")
})

test_that("raiseifnot raises condition when expression is FALSE", {
  # Should raise
  expect_condition(
    ado:::raiseifnot(FALSE, msg = "test"),
    class = "AdoException"
  )

  expect_condition(
    ado:::raiseifnot(1 < 0, msg = "negative"),
    class = "AdoException"
  )

  # Should NOT raise
  expect_silent(ado:::raiseifnot(TRUE, msg = "test"))
  expect_silent(ado:::raiseifnot(1 > 0, msg = "test"))
})

test_that("raiseifnot accepts custom exception class", {
  expect_condition(
    ado:::raiseifnot(FALSE, cls = "ValidationError", msg = "invalid"),
    class = "ValidationError"
  )

  # Should also be AdoException
  cond <- tryCatch(
    ado:::raiseifnot(FALSE, cls = "ValidationError", msg = "invalid"),
    condition = function(c) c
  )
  expect_true("AdoException" %in% class(cond))
})

# ============================================================================
# read_input tests (basic coverage)
# ============================================================================

test_that("read_input reads from text connection", {
  # Basic single line
  con <- textConnection("hello world\n")
  result <- ado:::read_input(con)
  expect_equal(result, "hello world\n")
  close(con)

  # Multiple lines joined with newline
  con <- textConnection("line1\nline2\n")
  result <- ado:::read_input(con)
  expect_match(result, "line1.*line2")
  close(con)
})

test_that("read_input handles empty input", {
  con <- textConnection("")
  result <- ado:::read_input(con)
  expect_equal(result, character(0))
  close(con)
})

test_that("read_input adds newline if missing", {
  con <- textConnection("no newline")
  result <- ado:::read_input(con)
  expect_match(result, "\\n$")
  close(con)
})

# ============================================================================
# Integration tests
# ============================================================================

test_that("infix operators can be chained", {
  `%p%` <- ado:::`%p%`
  `%|%` <- ado:::`%|%`
  `%&%` <- ado:::`%&%`

  # Practical example from the codebase
  result <- "hello" %p% " " %p% "world"
  expect_equal(result, "hello world")

  # Bitwise operations for flags
  flags <- 32 %|% 64 %|% 128
  expect_equal(flags, 224)
  expect_equal(flags %&% 32, 32)
  expect_equal(flags %&% 64, 64)
})

test_that("option handling workflow works end-to-end", {
  # Simulate option processing
  raw_opts <- list(
    list(name = "det", args = NULL),
    list(name = "noc", args = list("const")),
    list(name = "rob", args = NULL)
  )
  valid <- c("detail", "noconst", "robust", "level")

  # Validate and expand
  validated <- ado:::validateOpts(raw_opts, valid)

  # Check presence
  expect_true(ado:::hasOption(validated, "detail"))
  expect_true(ado:::hasOption(validated, "noconst"))
  expect_false(ado:::hasOption(validated, "level"))

  # Get arguments
  expect_equal(ado:::optionArgs(validated, "noconst"), list("const"))
  expect_null(ado:::optionArgs(validated, "robust"))
})

test_that("utilities work with temporary name generation", {
  `%not_in%` <- ado:::`%not_in%`

  # Generate multiple temporary names avoiding collisions
  existing <- character(0)
  for (i in 1:10) {
    nm <- ado:::temporary_name(lst = existing, len = 8)
    expect_true(nm %not_in% existing)
    existing <- c(existing, nm)
  }

  expect_equal(length(unique(existing)), 10)
})
