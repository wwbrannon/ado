#' rstata: An implementation of Stata's ado language in R.
#'
#' The rstata package provides an R-based interpreter for a dialect of Stata's
#' ado language. Loops, macros, data manipulation commands and statistics commands
#' are all supported, as are multiple ways to embed R code and use R for writing
#' ado- language commands.
#'
#' See the package vignettes for an introduction to the provided
#' ado-language functionality.
#'
#' @section Interface:
#' The only entry point from R is the ado() function, which interprets ado code.
#' Command input can be read interactively (from the R prompt), from a file or
#' from a string. The various types of global state that Stata maintains (settings,
#' macros, the dataset, etc) are all kept in internal package data structures that
#' do not persist across calls to the ado() function.
#'
#' @section Disclaimer:
#' This package is not in any way affiliated with or endorsed by StataCorp.
#'
#' @docType package
#' @name rstata
NULL
