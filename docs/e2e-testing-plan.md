# Plan: End-to-End Script Testing Infrastructure

## Goal
Add support for running entire Stata/ado scripts as test cases, with a working proof-of-concept.

## Verification Approach

The infrastructure will support **three verification mechanisms**:

1. **Console Output** (`expected_output.txt`) - Compare captured stdout to expected text
2. **Macro State** (`expected_macros.json`) - Verify macro values after execution
3. **Dataset State** (`expected.csv`) - Compare final dataset to expected CSV

For the proof-of-concept, we'll use **console output and macro verification** since these rely on fully-implemented commands (`local`, `global`, `display`).

## Files to Modify

### 1. `tests/testthat/helper-functions.R`
Add three helper functions:

```r
run_ado_script(script_path, input_data = NULL)
```
- Runs a .do script file through the interpreter
- Returns list with: `data`, `output`, `rclass`, `eclass`, `macros`

```r
load_e2e_fixture(fixture_name)
```
- Loads fixture files from `fixtures/e2e/<name>/`
- Returns list with: `script_path`, `input_data`, `expected_data`, `expected_output`, `expected_macros`

```r
run_e2e_test(fixture_name, tolerance = 1e-6)
```
- Combines load + run + verify in one call
- Checks whichever expected files exist

### 2. `DESCRIPTION`
Add `jsonlite` to Suggests (for parsing expected_macros.json)

## Files to Create

### 3. `tests/testthat/fixtures/e2e/` (directory)
Create fixture directory structure.

### 4. `tests/testthat/fixtures/e2e/test_local_macro/input.do`
```stata
local x = 1 + 1
display "`x'"
```

### 5. `tests/testthat/fixtures/e2e/test_local_macro/expected_output.txt`
```
2
```

### 6. `tests/testthat/fixtures/e2e/test_local_macro/expected_macros.json`
```json
{
  "_x": "2"
}
```
Note: Local macros are stored with underscore prefix internally.

### 7. `tests/testthat/test-e2e.R`
```r
context("End-to-end script tests")

test_that("local macro assignment and display works", {
  run_e2e_test("test_local_macro")
})

test_that("run_ado_script works with inline script", {
  tmp <- tempfile(fileext = ".do")
  writeLines('local y = 2 * 3', tmp)
  on.exit(unlink(tmp))

  result <- run_ado_script(tmp)
  expect_equal(result$macros[["_y"]], "6")
})
```

## Implementation Order

1. Add `jsonlite` to DESCRIPTION Suggests
2. Add helper functions to `helper-functions.R`
3. Create fixture directory and files
4. Create `test-e2e.R`
5. Run tests to verify

## Verification

```r
devtools::test(filter = "e2e")
```

Expected: 2 passing tests demonstrating:
- Fixture-based script execution with output and macro verification
- Direct script execution with macro verification

## Future Extensions

Once proof-of-concept works:
- Add `test_global_macro/` fixture
- Add `test_display_formats/` fixture
- Add dataset verification tests when data commands are ready
- Add rclass/eclass verification for statistics commands
