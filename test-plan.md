# Test Suite Expansion Plan for ado Package

## Current State Summary

**Well-tested:**
- Parser acceptance/rejection (~76 test blocks in `test-parse_accept.R` and `test-parse_reject.R`)
- C++ ExprNode unit tests (8 Catch2 tests in `src/test-ExprNode.cpp`)
- One user command test (`test-add_command.R`)

**Empty stubs (infrastructure ready):**
- `test-semantic_accept.R` / `test-semantic_reject.R` - only context declarations
- `test-codegen.R` - only context declaration
- `test-dataset.R` - only context declaration

**No tests:**
- R6 classes: AdoInterpreter, SymbolTable, Logger
- 131+ command implementations
- Utility functions (utils.R, fmt.R)
- End-to-end Stata comparison tests

---

## Phase 1: Fill Empty Test Stubs

### 1.1 Semantic Analysis Tests

**Files:** `test-semantic_accept.R`, `test-semantic_reject.R`

**Infrastructure:** Already exists in `helper-functions.R`:
- `analyze(str)` - runs semantic analysis, returns 1/0
- `expect_semantic_accept(str)` / `expect_semantic_reject(str)`

**Test categories based on `R/check.R` verifynode methods:**

| Category | Methods to Test |
|----------|-----------------|
| Literals | `ado_literal`, `ado_ident`, `ado_number`, `ado_string_literal`, `ado_datetime`, `ado_format_spec` |
| Loops | `ado_loop`, `ado_foreach`, `ado_forvalues` |
| Command Parts | `ado_if_clause`, `ado_in_clause`, `ado_using_clause`, `ado_weight_clause`, `ado_option_list`, `ado_option` |
| Commands | `ado_compound_cmd`, `ado_if_cmd`, `ado_modifier_cmd_list`, `ado_embedded_code`, `ado_cmd`, `ado_modifier_cmd`, `ado_general_cmd` |
| Expression Lists | `ado_expression_list`, `ado_argument_expression_list` |
| Expressions | `ado_expression`, `ado_type_expression`, factor/cross expressions, arithmetic, logical, relational, assignment, postfix |

**Acceptance tests:** Valid syntax for each node type, edge cases, combined constructs
**Rejection tests:** Wrong children count, missing data members, invalid values, type mismatches

### 1.2 Code Generation Tests

**File:** `test-codegen.R`

**New helper needed in `helper-functions.R`:**
```r
codegen_test <- function(str) {
  ast <- ado_parse(str)
  if (is.null(ast)) return(NULL)
  obj <- AdoInterpreter$new()
  codegen(ast, context = obj)
}
```

**Test categories based on `R/codegen.R` methods:**
- Loops: `codegen.ado_foreach`, `codegen.ado_forvalues`
- Commands: `codegen.ado_compound_cmd`, `codegen.ado_if_cmd`, `codegen.ado_embedded_code`, `codegen.ado_general_cmd`, `codegen.ado_modifier_cmd`
- Command parts: if/in/using/weight clauses, options
- Expression lists and expressions
- Literals: ident, number, string, datetime, format_spec

### 1.3 Dataset Tests

**File:** `test-dataset.R`

**Test categories based on `R/dataset.R`:**

| Category | Methods |
|----------|---------|
| Initialization | `$new()`, `$new(df)` |
| Loading | `use()`, `use_dataframe()`, `use_csv()` |
| Saving | `save()`, `saveold()` |
| Manipulation | `setnames()`, `clear()`, `drop_columns()`, `drop_rows()` |
| Access | `dim`, `nrow`, `ncol`, `names`, `as_data_frame`, `dtypes` active bindings |
| Selection | `head()`, `iloc()`, `subset()`, `in_clause_to_row_numbers()` |
| Preserve/Restore | `preserve()`, `restore()` |
| Sorting | `sort()` with various specs |

---

## Phase 2: R6 Class Unit Tests

### 2.1 New file: `test-ado_interpreter.R`

**Test categories:**
- Initialization (default, with data.frame)
- Symbol table accessors: `eclass_*`, `rclass_*`, `cclass_*`, `macro_*`, `setting_*` (28+ methods)
- c-class special behavior (varying values like `current_date`, `N`, `k`)
- User command management: `usercmd_set/unset/value/defined`
- Command lookup: `cmd_all`, `cmd_names_all`, `cmd_unabbreviate`
- Logging integration: `log_*` methods
- Debug flags: active bindings
- Main entry: `interpret()`, `cmd_action()`, `deep_eval()`, `macro_accessor()`

### 2.2 New file: `test-symbol_table.R`

**Test categories:**
- Initialization
- Symbol operations: `all_symbols`, `all_values`, `symbol_defined`, `symbol_value`, `set_symbol`, `unset_symbol`, `set_symbols_from_list`

### 2.3 New file: `test-logger.R`

**Test categories:**
- Sink management: `has_sink`, `sink_type`, `register_sink`, `deregister_sink`
- Logging: `log_command`, `log_result`
- Enable/disable: `log_enabled`, `cmdlog_enabled`

---

## Phase 3: Command Implementation Tests

### Test Organization

Create files by command category:
- `test-cmd_data.R` - gen, egen, replace, drop, keep, collapse, merge (38 commands)
- `test-cmd_stats.R` - regress, glm, logit, ttest (42 commands, mostly stubs)
- `test-cmd_general.R` - quit, do, display, sleep (20 commands)
- `test-cmd_load_save.R` - use, save, insheet, sysuse (6 commands)
- `test-cmd_loop.R` - foreach, forvalues
- `test-cmd_macro.R` - local, global, macro (4 commands)

### New helper functions for `helper-functions.R`:

```r
# Run ado code with test data, return results
with_test_data <- function(df, code) {
  obj <- AdoInterpreter$new(df = df)
  result <- capture.output(obj$interpret(textConnection(code), echo = 0))
  list(
    data = obj$dta$as_data_frame,
    output = result,
    rclass = obj$rclass_all(),
    eclass = obj$eclass_all()
  )
}

# Assert command executes without error
expect_cmd_succeeds <- function(code, df = NULL) {
  expect_silent({
    obj <- AdoInterpreter$new(df = df)
    obj$interpret(textConnection(code), echo = 0)
  })
}

# Assert command produces expected dataset
expect_data_equals <- function(code, df_input, df_expected) {
  result <- with_test_data(df_input, code)
  expect_equal(as.data.frame(result$data), as.data.frame(df_expected))
}
```

### Priority Commands (fully implemented, test first):

**Data:** clear, head, list, drop, keep, count, describe, gen, replace, rename, recode, collapse
**Load/Save:** use, save, insheet, sysuse
**General:** display, quit, do, preserve, restore
**Loops:** foreach, forvalues
**Macros:** local, global, tempfile

---

## Phase 4: Utility Function Tests

### New file: `test-utils.R`

**Test categories based on `R/utils.R`:**
- Infix operators: `%is%`, `%p%`, `%not_in%`, `%xor%`, `%|%`, `%&%`
- Option handling: `validateOpts`, `hasOption`, `optionArgs`
- Utilities: `temporary_name`, `char_count`, `flatten`, `rev_string`, `valid_data_type`, `unabbreviateName`, `expression_list_to_formula`
- Conditions: `raiseCondition`, `raiseif`, `raiseifnot`

---

## Phase 5: End-to-End Testing Infrastructure

### Fixture-Based Approach (for CI without Stata)

**Directory structure:**
```
tests/testthat/fixtures/e2e/
  test_gen_basic/
    input.do           # Ado code to run
    input_data.csv     # Optional input data
    expected.csv       # Expected output data
    expected_macros.json   # Expected macro state
```

### New helper functions:

```r
load_e2e_fixture <- function(name) {
  base <- file.path("fixtures/e2e", name)
  list(
    code = readLines(file.path(base, "input.do")),
    input_data = if (file.exists(file.path(base, "input_data.csv")))
      read.csv(file.path(base, "input_data.csv")) else NULL,
    expected_data = if (file.exists(file.path(base, "expected.csv")))
      read.csv(file.path(base, "expected.csv")) else NULL,
    expected_macros = if (file.exists(file.path(base, "expected_macros.json")))
      jsonlite::fromJSON(file.path(base, "expected_macros.json")) else NULL
  )
}

run_e2e_test <- function(fixture_name) {
  fixture <- load_e2e_fixture(fixture_name)
  result <- with_test_data(fixture$input_data, paste(fixture$code, collapse = "\n"))

  if (!is.null(fixture$expected_data)) {
    expect_equal(as.data.frame(result$data), fixture$expected_data, tolerance = 1e-6)
  }
  if (!is.null(fixture$expected_macros)) {
    for (name in names(fixture$expected_macros)) {
      expect_equal(result$macros[[name]], fixture$expected_macros[[name]])
    }
  }
}
```

### Fixture Generation Workflow

**Approach: Manual specification based on Stata documentation**

1. Write `.do` files with test cases
2. Manually specify expected results based on Stata documentation and known behavior
3. Save as fixtures (committed to repo)
4. CI tests run against fixtures without needing Stata

This approach avoids requiring a Stata installation while still ensuring correctness through careful reference to Stata's documented behavior.

### Priority E2E Test Cases

```stata
// gen_basic.do
clear
set obs 10
gen x = _n
gen y = x^2

// collapse_mean.do
use input_data
collapse (mean) value, by(group)

// forvalues_basic.do
forvalues i = 1/5 {
    gen var`i' = `i'
}

// local_macro.do
local x = 1 + 1
display "`x'"
```

---

## Implementation Priority

| Priority | Phase | Est. Tests | Rationale |
|----------|-------|------------|-----------|
| 1 | 1.1 Semantic Tests | ~80 | Catches invalid programs that parse OK |
| 2 | 1.2 Codegen Tests | ~40 | Ensures correct R code generation |
| 3 | 1.3 Dataset Tests | ~50 | Core data structure for everything |
| 4 | 2.1 AdoInterpreter | ~60 | Main orchestration class |
| 5 | 3 Priority Commands | ~100 | User-facing functionality |
| 6 | 4 Utility Tests | ~30 | Shared helper code |
| 7 | 2.2-2.3 SymbolTable/Logger | ~30 | Simpler supporting classes |
| 8 | 5 E2E Tests | ~50 | Full pipeline confidence |

**Total estimated new tests: ~440**

---

## Files to Create/Modify

**Modify:**
- `tests/testthat/helper-functions.R` - Add new test helpers

**Fill existing stubs:**
- `tests/testthat/test-semantic_accept.R`
- `tests/testthat/test-semantic_reject.R`
- `tests/testthat/test-codegen.R`
- `tests/testthat/test-dataset.R`

**Create new:**
- `tests/testthat/test-ado_interpreter.R`
- `tests/testthat/test-symbol_table.R`
- `tests/testthat/test-logger.R`
- `tests/testthat/test-utils.R`
- `tests/testthat/test-cmd_data.R`
- `tests/testthat/test-cmd_stats.R`
- `tests/testthat/test-cmd_general.R`
- `tests/testthat/test-cmd_load_save.R`
- `tests/testthat/test-cmd_loop.R`
- `tests/testthat/test-cmd_macro.R`
- `tests/testthat/test-e2e.R`
- `tests/testthat/fixtures/e2e/` directory with test fixtures

---

## Verification

After implementation, verify with:
```r
devtools::test()              # Run all tests
covr::package_coverage()      # Check coverage
devtools::check()             # Full R CMD CHECK
```
