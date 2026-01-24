context("End-to-end script tests")

test_that("local macro assignment and display works", {
  run_e2e_test("test_local_macro")
})

test_that("global macro assignment and display works", {
  run_e2e_test("test_global_macro")
})

test_that("display formats work correctly", {
  run_e2e_test("test_display_formats")
})

test_that("macro expansion in various contexts works", {
  run_e2e_test("test_macro_expansion")
})

test_that("sequential state building works", {
  run_e2e_test("test_sequential_state")
})

test_that("run_ado_script works with inline script", {
  tmp <- tempfile(fileext = ".do")
  writeLines('local y = 2 * 3', tmp)
  on.exit(unlink(tmp))

  result <- run_ado_script(tmp)
  expect_equal(result$macros[["_y"]], "6")
})

test_that("string literal assignment to macros works (FIXED!)", {
  # Tests the fix for string literal assignment - type keywords like 'str'
  # are now allowed as identifiers in expressions

  tmp <- tempfile(fileext = ".do")
  writeLines('local str = "world"\ndisplay "`str\'"', tmp)
  on.exit(unlink(tmp))

  result <- run_ado_script(tmp)
  expect_equal(result$macros[["_str"]], "world")
  expect_equal(result$output, "world")
})
