## Functions for parsing tests
parse_accept <-
function(str)
{
    # DEBUG_NO_PARSE_ERROR = 32, DEBUG_NO_CALLBACKS = 64
    debug_level <- bitwOr(32, 64)  # 96
    echo <- 0

    cls <- methods::getRefClass("ParseDriver")
    obj <- cls$new(str, emptyenv(), debug_level, echo)

    ret <- obj$parse()

    ifelse(ret == 0 && obj$error_seen == 0, 1, 0)
}

expect_parse_accept <-
function(str)
{
    eval(bquote(expect_equal(parse_accept(.(str)), 1)))
}

expect_parse_reject <-
function(str)
{
    eval(bquote(expect_equal(parse_accept(.(str)), 0)))
}

## Helper for testing raiseCondition() which signals but doesn't throw errors
expect_condition_signaled <-
function(expr, class = "AdoException")
{
  condition_signaled <- FALSE

  withCallingHandlers(
    expr,
    condition = function(c) {
      if (inherits(c, class)) {
        condition_signaled <<- TRUE
      }
    }
  )

  expect_true(condition_signaled,
              label = sprintf("Expected condition of class '%s' to be signaled", class))
}

## Functions for semantic analysis tests
ado_parse <-
function(str)
{
    # DEBUG_NO_PARSE_ERROR = 32, DEBUG_NO_CALLBACKS = 64
    debug_level <- bitwOr(32, 64)  # 96
    echo <- 0

    cls <- methods::getRefClass("ParseDriver")
    obj <- cls$new(str, emptyenv(), debug_level, echo)

    ret <- obj$parse()

    if(ret == 0 && obj$error_seen == 0)
        return(obj$get_ast())
    else
        return(NULL)
}

analyze <-
function(str)
{
  val <-
    tryCatch(
      {
        tr <- ado_parse(str)

        #we have to list "error" here explicitly because in the lower-level code,
        #the "error" class is added automatically to a caught C++ exception
        if(identical(tr, list()))
          ado:::raiseCondition("Bad command", cls=c("error", "BadCommandException"))

        ado:::check(tr)
      },
      error=identity)

  if(inherits(val, "EvalErrorException") ||
     inherits(val, "BadCommandException"))
  {
    return(0)
  } else
  {
    return(1)
  }
}

expect_semantic_accept <- function(str) eval(bquote(expect_equal(analyze(.(str)), 1)))
expect_semantic_reject <- function(str) eval(bquote(expect_equal(analyze(.(str)), 0)))

## Functions for code generation tests
codegen_test <-
function(str)
{
  ast <- ado_parse(str)
  if(is.null(ast))
    return(NULL)

  obj <- ado:::AdoInterpreter$new()
  tryCatch(
    ado:::codegen(ast, context = obj),
    error = function(e) NULL
  )
}

expect_codegen_succeeds <-
function(str)
{
  result <- codegen_test(str)
  eval(bquote(expect_true(!is.null(.(result)))))
}

expect_codegen_fails <-
function(str)
{
  result <- codegen_test(str)
  eval(bquote(expect_null(.(result))))
}

## Functions for end-to-end script tests

#' Run an ado script file and return results
#'
#' @param script_path Path to .do file
#' @param input_data Optional data.frame to load before running script
#' @return List with data, output, rclass, eclass, macros
run_ado_script <-
function(script_path, input_data = NULL)
{
  # Read the script
  script_content <- paste(readLines(script_path), collapse = "\n")

  # Create interpreter
  interp <- ado:::AdoInterpreter$new(df = input_data, echo = 0, print_results = 1)

  # Create text connection for the script
  con <- textConnection(script_content)
  on.exit(close(con))

  # Capture output
  output <- capture.output({
    tryCatch(
      interp$interpret(con),
      error = function(e) {
        stop("Script execution failed: ", e$message)
      }
    )
  })

  # Return results
  list(
    data = interp$dta$as_data_frame,
    output = trimws(paste(output, collapse = "\n"), which = "right"),
    rclass = interp$rclass_all(),
    eclass = interp$eclass_all(),
    macros = interp$macro_all()
  )
}

#' Load end-to-end test fixture
#'
#' @param fixture_name Name of fixture directory under fixtures/e2e/
#' @return List with script_path, input_data, expected_data, expected_output, expected_macros
load_e2e_fixture <-
function(fixture_name)
{
  fixture_dir <- file.path("fixtures", "e2e", fixture_name)

  if (!dir.exists(fixture_dir)) {
    stop("Fixture directory not found: ", fixture_dir)
  }

  result <- list()

  # Load script (required)
  script_path <- file.path(fixture_dir, "input.do")
  if (!file.exists(script_path)) {
    stop("input.do not found in fixture: ", fixture_name)
  }
  result$script_path <- script_path

  # Load input data (optional)
  input_csv <- file.path(fixture_dir, "input.csv")
  if (file.exists(input_csv)) {
    result$input_data <- read.csv(input_csv, stringsAsFactors = FALSE)
  } else {
    result$input_data <- NULL
  }

  # Load expected data (optional)
  expected_csv <- file.path(fixture_dir, "expected.csv")
  if (file.exists(expected_csv)) {
    result$expected_data <- read.csv(expected_csv, stringsAsFactors = FALSE)
  } else {
    result$expected_data <- NULL
  }

  # Load expected output (optional)
  expected_output <- file.path(fixture_dir, "expected_output.txt")
  if (file.exists(expected_output)) {
    result$expected_output <- paste(readLines(expected_output), collapse = "\n")
  } else {
    result$expected_output <- NULL
  }

  # Load expected macros (optional)
  expected_macros <- file.path(fixture_dir, "expected_macros.json")
  if (file.exists(expected_macros)) {
    result$expected_macros <- jsonlite::fromJSON(expected_macros)
  } else {
    result$expected_macros <- NULL
  }

  result
}

#' Run end-to-end test from fixture
#'
#' @param fixture_name Name of fixture directory
#' @param tolerance Numeric tolerance for data comparisons
run_e2e_test <-
function(fixture_name, tolerance = 1e-6)
{
  # Load fixture
  fixture <- load_e2e_fixture(fixture_name)

  # Run script
  result <- run_ado_script(fixture$script_path, fixture$input_data)

  # Verify output if expected
  if (!is.null(fixture$expected_output)) {
    expect_equal(result$output, fixture$expected_output,
                 label = paste0("Output for ", fixture_name))
  }

  # Verify macros if expected
  if (!is.null(fixture$expected_macros)) {
    for (name in names(fixture$expected_macros)) {
      expect_equal(result$macros[[name]], fixture$expected_macros[[name]],
                   label = paste0("Macro ", name, " for ", fixture_name))
    }
  }

  # Verify data if expected
  if (!is.null(fixture$expected_data)) {
    expect_equal(as.data.frame(result$data), fixture$expected_data,
                 tolerance = tolerance,
                 label = paste0("Data for ", fixture_name))
  }

  invisible(result)
}
