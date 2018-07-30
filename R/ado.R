### The core interpreter class and a frontend function

#FIXME should these context variables be nullable?
#Remove obsolete 'Setting' functions
#Remove last references to ado_env

#Flags you can bitwise OR to enable debugging features.
#It's important that these have the same numeric values as
#the macros in the C++ header file.
DEBUG_PARSE_TRACE <- 4
DEBUG_MATCH_CALL <- 8
DEBUG_VERBOSE_ERROR <- 16
DEBUG_NO_PARSE_ERROR <- 32

#' Interpret ado code interactively or from a file.
#'
#' An interpreter for a dialect of Stata's ado language. The ado dialect is
#' close to the one Stata provides; see the package vignettes for full details.
#'
#' @param dta If NULL, start with an empty dataset; if a data.frame, use a copy
#'            of the data.frame to initialize the dataset.
#' @param filename The path to an ado script to execute. At least one of filename
#'                 and string must be NULL.
#' @param string A length-1 character vector to read command input from. At least
#'                 one of filename and string must be NULL.
#' @param assign.back If TRUE, copy the final dataset state to a variable in the
#'                    caller's environment on function exit. The variable name is
#'                    the name (in the caller's environment) of the data.frame
#'                    passed as the dta argument, or if dta was NULL, the name "dta"
#'                    is used. The effect is to modify the passed data.frame, though
#'                    the old value will not necessarily be garbage-collected.
#' @param debug_level How verbose debug messages should be.
#' @param echo Whether to echo command input. Values 0, 1, and NULL are accepted;
#'             if NULL, echo only when running non-interactively.
#' @param print_results Whether to print command results. Values 0 or 1. The value
#'                      passed here becomes the ado setting "print_results".
#'
#' @return Invisible NULL.
#'
#' @export
#' @useDynLib ado, .registration = TRUE
#' @import Rcpp
ado <-
function(df = NULL, filename=NULL, string=NULL, assign.back=FALSE,
         debug_level = 0, print_results = 1, echo = NULL)
{
    ##
    ## Sanity checks
    ##

    # Make sure file and string aren't both set
    if(!is.null(filename) && !is.null(string))
        stop("Cannot specify both the filename and string arguments")

    # Mke sure we get one of filename and string if not in interactive mode
    if(!interactive() && is.null(filename) && is.null(string))
        stop("Must specify filename or string if not in interactive mode")

    ##
    ## Set up the object to read from
    ##

    if(interactive() && is.null(filename) && is.null(string))
    {
        con <- NULL
    } else if(is.null(filename) && is.null(string))
    {
        con <- stdin()
    } else if(!is.null(filename))
    {
        con <- file(filename, "rb")
        on.exit(close(con), add=TRUE)
    } else
    {
        # It's not important to close this type of connection because (as
        # in the R docs for textConnection) it's not really an OS resource.
        con <- textConnection(string)
    }

    ##
    ## Final setup
    ##

    #Should we echo input? Don't echo when interactive and reading from
    #stdin, because then the cmd text is already visible on the console.
    if(is.null(echo))
        echo <- as.numeric(!is.null(con))

    #Should we, on exit, put the final dataset back into the variable
    #we were given as if we had a pointer to it?
    if(is.null(df))
        varname <- "df"
    else
        varname <- deparse(substitute(df))

    on.exit(if(assign.back)
    {
        obj <- as.data.frame(dt$as_data_frame)
        assign(varname, obj, pos=parent.frame())
    })

    ##
    ## Run the interpreter
    ##

    obj <- AdoInterpreter$new(df=df, print_results=print_results,
                              debug_level=debug_level, echo=echo)
    obj$interpret(con)

    return(invisible((obj$dta$as_data_frame)))
}

AdoInterpreter <-
R6::R6Class("AdoInterpreter",
    public = list(
        # Several things here: the dataset, the macro substitution symbol
        # tables, a lookup table (as an environment) for settings, and the
        # (e,r,c)-class value symbol tables (which are also environments).

        logger = NULL,
        dta = NULL,
        rclass = NULL,
        cclass = NULL,
        eclass = NULL,
        settings = NULL,
        macro_syms = NULL,

        initialize = function(df = NULL, debug_level = 0, print_results = 1,
                              echo = NULL)
        {
            self$logger <- Logger$new()
            self$dta <- Dataset$new()

            self$rclass <- SymbolTable$new()
            self$eclass <- SymbolTable$new()
            self$macro_syms <- SymbolTable$new()

            self$cclass <- SymbolTable$new()
            self$cclass$set_symbols_from_list(get_default_cclass_values())

            self$settings <- SymbolTable$new()
            self$settings$set_symbols_from_list(get_default_setting_values())

            self$settings$set_symbol("echo", echo)
            self$settings$set_symbol("print_results", print_results)
            self$settings$set_symbol("debug_level", debug_level)

            if(!is.null(df))
                self$dta$use_dataframe(df)
        }

        finalize = function()
        {
            self$dta$clear()
            self$logger$deregister_all_sinks()
        },

        interpret = function(con = NULL)
        {
            debug_level <- self$settings$symbol_value("debug_level")
            echo <- self$settings$symbol_value("echo")

            while(TRUE)
            {
                val <-
                    tryCatch(
                        {
                            inpt <- read_input(con)

                            #We've hit EOF
                            if(length(inpt) == 0)
                            {
                                raiseCondition(msg="Exit requested",
                                               c("error", "ExitRequestedException"))
                            }

                            #Send the input to the bison parser, which, after reading
                            #each command, invokes the process_cmd callback
                            lc <- function(msg) self$logger$log_command(msg)
                            do_parse_with_callbacks(text=inpt, cmd_action=process_cmd,
                                                    macro_value_accessor=macro_value_accessor,
                                                    log_command=lc, debug_level=debug_level,
                                                    echo=echo)
                        },
                        error = function(c) c)

                if(inherits(val, "error"))
                {
                    if(inherits(val, "ExitRequestedException"))
                    {
                        break
                    } else if(inherits(val, "BadCommandException") ||
                              inherits(val, "EvalErrorException") ||
                              inherits(val, "ContinueException") ||
                              inherits(val, "BreakException"))
                    {
                        cat(paste0(val$message, "\n\n"))

                        next
                    } else
                    {
                        cat(paste0(val$message, "\n\n"))

                        break
                    }
                } else
                {
                    cat("\n")
                }
            }

            return(invisible(NULL))
        }
    ),

    private = list(
        # The main command-processing callback function for the parser
        process_cmd = function(ast, debug_level=0)
        {
            #Semantic analysis and code generation
            ret_p1 <-
                tryCatch(
                    {
                        check(ast, ifelse( (debug_level %&% DEBUG_VERBOSE_ERROR) != 0, 1, 0))

                        codegen(ast, context = self,
                                ifelse( (debug_level %&% DEBUG_MATCH_CALL) != 0, 1, 0))
                    },
                    error=function(c) c,
                    BadCommandException=function(c) c)

            #Raising conditions with custom classes through an intervening
            #C++ layer is quite tricky, so we're going to return ints and have
            #the C++ code re-raise the exceptions in a more controllable way
            if(inherits(ret_p1, "BadCommandException") || inherits(ret_p1, "error"))
            {
                return( list(1, ret_p1$message) )
            }

            #Evaluate the generated calls for their side effects and for printable objects
            ret_p2 <-
                tryCatch(
                    {
                        deep_eval(ret_p1, envir=parent.env(environment()), enclos=self)
                    },
                    error=function(c) c,
                    EvalErrorException=function(c) c,
                    BadCommandException=function(c) c,
                    ExitRequestedException=function(c) c,
                    ContinueException=function(c) c,
                    BreakException=function(c) c)

            if(inherits(ret_p2, "EvalErrorException") || inherits(ret_p2, "BadCommandException") ||
               inherits(ret_p2, "error"))
            {
                return( list(2, ret_p2$message) )
            }

            if(inherits(ret_p2, "ExitRequestedException"))
            {
                return( list(3, ret_p2$message) )
            }

            if(inherits(ret_p2, "ContinueException"))
            {
                return( list(4, ret_p2$message) )
            }

            if(inherits(ret_p2, "BreakException"))
            {
                return( list(5, ret_p2$message) )
            }

            return( list(0, "Success") );
        },

        #Recursive evaluation of the sort of expression object that the parser builds.
        #This function both evaluates the expressions and sends the results through
        #the logger.
        deep_eval <-
        function(expr, envir=parent.frame(),
                 enclos=if(is.list(envir) || is.pairlist(envir))
                     parent.frame()
                 else
                     baseenv())
        {
            ret <- list()
            for(chld in expr)
            {
                if(is.expression(chld))
                    ret[[length(ret)+1]] <- deep_eval(chld, envir=envir, enclos=enclos)
                else
                {
                    tmp <- suppressWarnings(withVisible(eval(chld, envir=envir, enclos=enclos)))
                    ret[[length(ret)+1]] <- tmp$value

                    if(tmp$visible)
                    {
                        self$logger$log_result(fmt(tmp$value))
                    }
                }
            }

            # Return this so that higher layers can check whether it's a condition,
            # but those layers don't print it. All printing of results happens
            # above.
            ret
        },

        #Callbacks: a macro value accessor that allows the lexer to retrieve macro values.
        macro_value_accessor = function(name)
        {
            #Implement the e() and r() stored results objects, and the c() system
            #values object. All of the regexes here are a little screwy: when the e(),
            #r(), or c() appears at the beginning of the macro text, everything after
            #the close paren is ignored. But this is actually Stata's behavior,
            #so we'll run with it.

            #The (e,r,c)-classes are ONLY recognized when at the start of a macro text.
            #The "_?" in the regexes matches them when used in either a local macro
            #(which the parser expands into a global with a prefixed "_") or a global.

            #One peculiarity of note: for the c-class values, we don't just
            #check the c-class environment. We also have to looks up certain
            #c-class values from other places, mainly Sys.* R functions and
            #other wrappers around system APIs. C-class values not resolved from
            #such lookups are looked for in the usual symbol table. E-class and
            #r-class values don't behave this way, and all values are stored in
            #the corresponding symbol tables.

            #the e() class
            m <- regexpr("^e_?\\((?<match>.*)\\)", name, perl=TRUE)
            start <- attr(m, "capture.start")
            len <- attr(m, "capture.length")
            if(start != -1)
            {
                txt <- substr(name, start, start + len - 1)
                val <- as.character(ado_func_e(txt))

                return(val)
            }

            #the r() class
            m <- regexpr("^_?r\\((?<match>.*)\\)", name, perl=TRUE)
            start <- attr(m, "capture.start")
            len <- attr(m, "capture.length")
            if(start != -1)
            {
                txt <- substr(name, start, start + len - 1)
                val <- as.character(ado_func_r(txt))

                return(val)
            }

            #the c() class
            m <- regexpr("^_?c\\((?<match>.*)\\)", name, perl=TRUE)
            start <- attr(m, "capture.start")
            len <- attr(m, "capture.length")
            if(start != -1)
            {
                txt <- substr(name, start, start + len - 1)
                val <- as.character(ado_func_c(txt))

                return(val)
            }

            #a normal macro
            if(!(self$macro_syms$symbol_defined(name)))
                return("")
            else
                return(self$macro_syms$symbol_value(name))
        }
    )
)
