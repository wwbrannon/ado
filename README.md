<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Build Status](https://img.shields.io/travis/wwbrannon/ado.svg?style=flat)](https://travis-ci.org/wwbrannon/ado)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/wwbrannon/ado?branch=master&svg=true)](https://ci.appveyor.com/project/wwbrannon/ado)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/ado)](https://cran.r-project.org/package=ado)
[![Downloads](https://cranlogs.r-pkg.org/badges/ado)](https://cran.r-project.org/package=ado)
[![Coverage Status](https://img.shields.io/codecov/c/github/wwbrannon/ado/master.svg)](https://codecov.io/github/wwbrannon/ado?branch=master)
[![License](https://img.shields.io/:license-mit-blue.svg?style=flat)](https://wwbrannon.mit-license.org/)

# ado

The ado package provides an R-based interpreter for Stata's ado language. It's still under development and isn't yet suitable for day-to-day use. When it's completed, the language it supports will be close to but not exactly like Stata, in much the same way that R is descended from but not identical to S. This package is not in any way affiliated with or endorsed by StataCorp.

The target functionality, only some of which is currently completed, covers several areas:

* Stata macros and loops: Support for Stata's macros, and for foreach and forvalues loops. Macros and loops are tightly coupled in Stata, because loops are directives to the macro processor rather than the interpreter (i.e., loop over values and repeatedly macro-expand and execute text, rather than loop over values and repeatedly execute already parsed text).
* Ways of interfacing with R: The ado code this package understands can integrate with R code in two ways: a) R can be used to write new ado-language commands, which can be used alongside the built-in ones; b) syntax for embedding R inline into ado code and allowing it to operate on ado data structures.
* Data manipulation commands: The most important of Stata's many data manipulation commands - collapse, gen and egen, drop and keep, and many more.
* Statistics commands: A selection of the most important and most easily implemented statistics commands. Hypothesis tests, regression and a few other items will be supported.
* Misc and system commands: Some miscellaneous commands including logging, ways to work with the operating system, and commands for managing files.
* Graphics: A few fairly thin wrappers around base R's graphics, for making histograms, scatterplots and the like.

See sections below for more detail on functionality that's already complete or nearly so.

## Parsing and frontend
The interpreter's frontend is mostly complete. The parser and lexer, semantic analyzer and code generator (which generates R code) are functional and accept nearly the final language we want to support. There are still a few minor bugs, and the differences from Stata are poorly documented.

## Macros and loops
Support for macros and loops is complete, and touches many parts of the interpreter architecture. Macro support in particular is tightly integrated into the lexer, because it turns out that it has to be to reproduce Stata's behavior.

## R interface
Both targeted ways of integrating with R are already supported:

* Text between `{{{` and `}}}` is understood to be R code, and is executed as such without using the ado parser and code generator. The exact environment that this code executes in, and how the ado dataset is visible to it, is still TBD.
* There's a mechanism for defining and registering R functions that follow a particular (at the moment, entirely undocumented) calling convention as ado commands. Commands registered this way can be used just like ones built into the package.

## Logging and misc
Stata's logging features are mostly supported. The log and cmdlog commands exist and work as expected, allowing output, input or both to be captured and redirected to files in a much simpler way than with `sink()`.

File manipulation commands are ready and working, though possibly not on Windows.

## Installation
There's no CRAN version yet, so install the dev version from github:
```
install.packages("devtools")
devtools::install_github("wwbrannon/ado")
```
