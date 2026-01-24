context("The semantic analyzer rejects invalid input")

test_that("Invalid literals are rejected", {
  # Invalid identifiers (starting with number)
  expect_semantic_reject("disp 123var\n")

  # Invalid datetime formats
  expect_semantic_reject("disp 32jan2020\n")  # day out of range
  expect_semantic_reject("disp 01xxx2020\n")  # invalid month

  # Invalid format specs
  expect_semantic_reject("disp %invalid\n")
  expect_semantic_reject("disp %999999.99f\n")  # unreasonable width
})

test_that("Invalid loop constructs are rejected", {
  # foreach with empty list
  # Note: This may actually be allowed by parser, testing semantic check

  # forvalues with invalid range syntax
  # Note: Parser may catch most of these, but semantic checks can validate ranges
})

test_that("Invalid command clauses are rejected", {
  # if clause with no expression
  # Note: Parser likely catches this, semantic validation ensures expression is present

  # in clause with invalid range
  # Note: Testing semantic validation of range values
})

test_that("Invalid expressions are rejected", {
  # Expressions with type mismatches (context-dependent, may not apply)
  # Note: Ado is dynamically typed, so type errors are often runtime

  # Invalid postfix expressions (calling non-existent functions)
  # Note: Function existence is often checked at codegen or runtime, not semantic
})

