# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

The ado package is an R-based interpreter for a dialect of Stata's ado language. It uses a traditional compiler pipeline: Flex lexer → Bison parser → AST → semantic analysis → R code generation → execution.

## Build and Development Commands

```r
# Load package for development (without full build)
devtools::load_all()

# Full build and install
devtools::install()

# Run all tests
devtools::test()

# Run R CMD CHECK (comprehensive validation)
devtools::check()

# Generate documentation from roxygen comments
devtools::document()

# Code coverage
covr::package_coverage()
```

## Running Individual Tests

```r
# Run a specific test file
testthat::test_file("tests/testthat/test-parse_accept.R")

# Run tests matching a pattern
testthat::test_file("tests/testthat/test-codegen.R", filter = "gen")
```

## Architecture

### Interpreter Pipeline
1. **Lexer** (`src/parser/ado.fl`) - Flex-based tokenizer with integrated macro expansion
2. **Parser** (`src/parser/ado.ypp`) - Bison grammar producing AST
3. **Semantic Analyzer** (`R/check.R`) - S3 `verifynode.*` methods validate AST nodes
4. **Code Generator** (`R/codegen.R`) - S3 `codegen.*` methods emit R code
5. **Execution** - Generated R code runs against interpreter context

### Core R6 Classes
- **AdoInterpreter** (`R/ado_interpreter.R`) - Main interpreter state: dataset, symbol tables, logging
- **Dataset** (`R/dataset.R`) - Wraps data.table with Stata-like semantics
- **SymbolTable** (`R/symbol_table.R`) - Key-value store for macros and results (r/e/c-class)
- **Logger** (`R/logger.R`) - Output/input capture

### Command Implementation
Commands are functions in `cmd_*.R` files with signature `ado_cmd_<name>(context, ...)`. The context provides access to interpreter state.

Key command files:
- `cmd_data.R` - gen, egen, collapse, keep, drop
- `cmd_load_save.R` - use, save, insheet, sysuse
- `cmd_loop.R` - foreach, forvalues
- `cmd_stats.R` - regression, summary statistics

### Public API Entry Point
`R/ado_frontend.R` exports the `ado()` function which creates an AdoInterpreter and runs code.

## Key Patterns

### Adding a New Command
1. Add handler function to appropriate `R/cmd_*.R` file
2. Register in AdoInterpreter's symbol table
3. Add parsing rules to `src/parser/ado.ypp` if new syntax needed
4. Add tests

### Parser/Lexer Changes
1. Edit `src/parser/ado.ypp` (grammar) or `src/parser/ado.fl` (lexer)
2. Run `./configure` to regenerate C++ files
3. Never manually edit generated files (`lex.yy.cpp`, `ado.tab.cpp`)

## Test Structure

Tests in `tests/testthat/`:
- `test-parse_accept.R` / `test-parse_reject.R` - Lexer/parser tests
- `test-semantic_accept.R` / `test-semantic_reject.R` - Semantic analysis tests
- `test-codegen.R` - Code generation tests
- `test-add_command.R` - Custom command registration
- `test-dataset.R` - Dataset class tests
- `test-cpp.R` - C++ unit tests

Test helpers in `helper-functions.R`:
- `parse_accept(str)` - Returns 1 if string parses successfully
- `ado_parse(str)` - Returns AST from string
- `analyze(str)` - Runs semantic analysis
- `expect_parse_accept/reject`, `expect_semantic_accept/reject` - Test assertions

## R Integration Mechanisms

1. **Embedded R blocks** - `{{{ R code }}}` executes R directly
2. **Custom commands** - R functions registered via `add_command()` can be used as ado commands

## Dependencies

- **Rcpp** - R/C++ interface
- **R6** - OOP classes
- **data.table** - Efficient data manipulation
- **readstata13** - Stata file I/O
- **C++11**, **Flex**, **Bison** - Build requirements
