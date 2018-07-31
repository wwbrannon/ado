#FIXME c-class accessors broken / bad
#FIXME rig up function_for_ado_operator and codegen to pass context pointer to all non-builtin functions
#FIXME error handling for symboltable

##
## The core interpreter class
##

#Flags you can bitwise OR to enable debugging features.
#It's necessary that these have the same numeric values as
#the macros in the C++ header file.
DEBUG_PARSE_TRACE <- 4
DEBUG_MATCH_CALL <- 8
DEBUG_VERBOSE_ERROR <- 16
DEBUG_NO_PARSE_ERROR <- 32

AdoInterpreter <-
R6::R6Class("AdoInterpreter",
    public = list(
        dta = NULL,

        ##
        ## ctor and dtor
        ##

        initialize = function(df = NULL, debug_level = 0, print_results = 1,
                              echo = NULL)
        {
            self$dta <- Dataset$new()

            private$logger <- Logger$new()

            private$rclass <- SymbolTable$new()
            private$eclass <- SymbolTable$new()
            private$macro_syms <- SymbolTable$new()

            private$cclass <- SymbolTable$new()
            private$cclass$set_symbols_from_list(private$cclass_value_defaults())

            private$settings <- SymbolTable$new()
            private$settings$set_symbols_from_list(private$setting_value_defaults())

            self$setting_set("echo", echo)
            self$setting_set("print_results", print_results)
            self$setting_set("debug_level", debug_level)

            if(!is.null(df))
                self$dta$use_dataframe(df)
        },

        finalize = function()
        {
            self$dta$clear()
            self$log_deregister_all_sinks()
        },

        ##
        ## The main entry point
        ##

        interpret = function(con = NULL, echo = NULL)
        {
            debug_level <- private$setting_value("debug_level")

            # Allow the echo setting to be overridden
            if(is.null(echo))
                echo <- private$setting_value("echo")

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
                            do_parse_with_callbacks(text=inpt, cmd_action=private$process_cmd,
                                                    macro_value_accessor=private$macro_value_accessor,
                                                    log_command=self$log_command, debug_level=debug_level,
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
        },

        ##
        ## Logging methods
        ##

        log_has_sink = function(filename, type = NULL)
        {
            return(private$logger$has_sink(filename = filename, type = type))
        },

        log_sink_type = function(filename)
        {
            return(private$logger$sink_type(filename = filename))
        },

        log_register_sink = function(filename, type="log", header = TRUE)
        {
            return(private$logger$register_sink(filename = filename, type = type,
                                                header = header))
        },

        log_deregister_sink = function(filename)
        {
            return(private$logger$deregister_sink(filename))
        },

        log_deregister_all_sinks = function(type = NULL)
        {
            return(private$logger$deregister_all_sinks(type = type))
        },

        log_command = function(msg, echo = NULL)
        {
            if(is.null(echo))
            {
                if(self$setting_defined("echo"))
                    echo <- self$setting_value("echo")
                else
                    echo <- FALSE
            }

            return(private$logger$log_command(msg = msg, echo = echo))
        },

        log_results = function(msg, print_results = NULL)
        {
            if(is.null(print_results))
            {
                if(self$setting_defined("print_results"))
                    print_results <- self$setting_value("print_results")
                else
                    print_results <- FALSE
            }

            return(private$logger$log_command(msg = msg, print_results = print_reslts))
        },

        log_sinks = function() private$logger$log_sinks,
        log_cmdlog_sinks = function() private$logger$cmdlog_sinks,

        log_is_enabled = function() private$logger$log_enabled,
        log_set_enabled = function(value) private$logger$log_enabled(value),

        log_cmdlog_is_enabled = function() private$logger$cmdlog_enabled,
        log_cmdlog_set_enabled = function(value) private$logger$cmdlog_enabled(value),

        ##
        ## e-class accessors
        ##

        eclass_all = function()
        {
            return(private$eclass$all_values())
        },

        eclass_names = function()
        {
            return(private$eclass$all_symbols())
        },

        eclass_set = function(sym, val)
        {
            return(private$eclass$set_symbol(sym, val))
        },

        eclass_unset = function(sym)
        {
            return(private$eclass$unset_symbol(sym))
        },

        eclass_value = function(sym)
        {
            return(private$eclass$symbol_value(sym))
        },

        eclass_defined = function(sym)
        {
            return(private$eclass$symbol_defined(sym))
        },

        eclass_query = function(val=NULL, enum=NULL)
        {
            raiseif(is.null(val) && is.null(enum),
                    msg="Must provide argument for e-class query")

            if(enum)
                return(self$eclass_names())
            else
                return(self$eclass_value(val))
        },

        ##
        ## r-class accessors
        ##

        rclass_all = function()
        {
            return(private$rclass$all_values())
        },

        rclass_names = function()
        {
            return(private$rclass$all_symbols())
        },

        rclass_set = function(sym, val)
        {
            return(private$rclass$set_symbol(sym, val))
        },

        rclass_unset = function(sym)
        {
            return(private$rclass$unset_symbol(sym))
        },

        rclass_value = function(sym)
        {
            return(private$rclass$symbol_value(sym))
        },

        rclass_defined = function(sym)
        {
            return(private$rclass$symbol_defined(sym))
        },

        rclass_query = function(val=NULL, enum=NULL)
        {
            raiseif(is.null(val) && is.null(enum),
                    msg="Must provide argument for r-class query")

            if(enum)
                return(self$rclass_names())
            else
                return(self$rclass_value(val))
        },

        ##
        ## c-class accessors
        ##

        cclass_all = function()
        {
            lst <- list()
            return(private$cclass$all_values())
        },

        cclass_names = function()
        {
            st <- private$cclass$all_symbols()
            se <- names(private$cclass_value_varying_quoted())

            return(c(st, se))
        },

        cclass_set = function(sym, val)
        {
            return(private$cclass$set_symbol(sym, val))
        },

        cclass_unset = function(sym)
        {
            return(private$cclass$unset_symbol(sym))
        },

        cclass_value = function(sym)
        {
            return(private$cclass$symbol_value(sym))
        },

        cclass_defined = function(sym)
        {
            return(private$cclass$symbol_defined(sym))
        },

        cclass_query = function(val=NULL, enum=NULL)
        {
            raiseif(is.null(val) && is.null(enum),
                    msg="Must provide argument for c-class query")

            if(enum)
                return(self$cclass_names())
            else
                return(self$cclass_value(val))
        },

        ##
        ## Macro accessors
        ##

        macro_all = function()
        {
            return(private$macro_syms$all_values())
        },

        macro_names = function()
        {
            return(private$macro$all_symbols())
        },

        macro_set = function(sym, val)
        {
            return(private$macro_syms$set_symbol(sym, val))
        },

        macro_unset = function(sym)
        {
            return(private$macro_syms$unset_symbol(sym))
        },

        macro_value = function(sym)
        {
            return(private$macro_syms$symbol_value(sym))
        },

        macro_defined = function(sym)
        {
            return(private$macro_syms$symbol_defined(sym))
        },

        ##
        ## Settings accessors
        ##

        setting_all = function()
        {
            return(private$settings$all_values())
        },

        setting_names = function()
        {
            return(private$settings$all_symbols())
        },

        setting_set = function(sym, val)
        {
            return(private$settings$set_symbol(sym, val))
        },

        setting_unset = function(sym)
        {
            return(private$settings$unset_symbol(sym))
        },

        setting_value = function(sym)
        {
            return(private$settings$symbol_value(sym))
        },

        setting_defined = function(sym)
        {
            return(private$settings$symbol_defined(sym))
        }
    ),

    active = list(
        debug_parse_trace = function()
        {
            debug_level <- self$setting_value("debug_level") # set in ctor
            return((debug_level %&% DEBUG_PARSE_TRACE) != 0)
        },

        debug_match_call = function()
        {
            debug_level <- self$setting_value("debug_level")
            return((debug_level %&% DEBUG_MATCH_CALL) != 0)
        },

        debug_verbose_error = function()
        {
            debug_level <- self$setting_value("debug_level")
            return((debug_level %&% DEBUG_VERBOSE_ERROR) != 0)
        },

        debug_no_parse_error = function()
        {
            debug_level <- self$setting_value("debug_level")
            return((debug_level %&% DEBUG_NO_PARSE_ERROR) != 0)
        }
    ),

    private = list(
        # Several things here: the macro substitution symbol
        # tables, a lookup table (as an environment) for settings, and the
        # (e,r,c)-class value symbol tables (which are also environments).

        logger = NULL,

        rclass = NULL,
        cclass = NULL,
        eclass = NULL,
        settings = NULL,
        macro_syms = NULL,

        default_webuse_url = function()
        {
            return('https://www.stata-press.com/data/r15/')
        },

        # Default settings (for, e.g., restoring to defaults)
        setting_value_defaults = function()
        {
            return(list(
                webuse_url = private$default_webuse_url()
            ))
        },

        # Return the default c-class env values
        cclass_value_defaults = function()
        {
            return(list(
                ##
                ## Mathematical constants
                ##

                pi = pi,
                e = exp(1),

                ##
                ## Letters
                ##

                alpha = paste0(letters, collapse=" "),
                ALPHA = paste0(LETTERS, collapse=" "),

                ##
                ## Weeks and months
                ## The Stata docs imply these aren't localized, but they should be.
                ##

                Wdays = paste0(weekdays(seq(as.Date("2013-06-03"), by=1, len=7),
                                        abbreviate=TRUE),
                               collapse=" "),

                Weekdays = paste0(weekdays(seq(as.Date("2013-06-03"), by=1, len=7)),
                                  collapse=" "),

                Mons = paste0(format(ISOdate(2000, 1:12, 1), "%b"), collapse=" "),
                Months = paste0(format(ISOdate(2000, 1:12, 1), "%B"), collapse=" "),

                ##
                ## URLs for webuse, also available in settings
                ##

                default_webuse_url = private$default_webuse_url(),

                ##
                ## OS or machine info that can't change during execution
                ##
                os = if(.Platform$OS.type == "windows") "Windows"
                        else if(Sys.info()["sysname"] == "Darwin") "MacOSX"
                        else "Unix",
                osdtl = Sys.info()["release"] %p% " " %p% Sys.info()["version"],
                bit = 8 * .Machine$sizeof.pointer, # e.g., 8 * 8 = 64-bit
                machine_type = utils::sessionInfo()$platform,
                byteorder = if(.Platform$endian == 'big') "hilo" else "lohi",
                processors = parallel::detectCores(),
                processors_mach = parallel::detectCores(),
                processors_max = parallel::detectCores(),

                dirsep = .Platform$file.sep,

                #Almost if not quite exactly right
                mindouble = -.Machine$double.xmax,

                maxdouble = .Machine$double.xmax,
                epsdouble = .Machine$double.eps,
                smallestdouble = .Machine$double.xmin,

                #R does have a 4-byte integer type, even though integers are
                #generally represented as doubles
                minlong = -2^31 + 1,

                maxlong = 2^31 - 1,

                #Almost if not quite exactly right
                minfloat = -.Machine$double.xmax,

                maxfloat = .Machine$double.xmax,
                epsfloat = .Machine$double.eps,

                ##
                ## Versions of R or ado, also can't change during execution
                ##

                rversion = R.version$version.string,
                ado_version = utils::packageVersion(utils::packageName()),

                ##
                ## Resource limits
                ##

                max_N_theory = 2^31 - 1,
                max_k_theory = 2^31 - 1,

                #This corresponds to a data.frame of 2^31 - 1 columns and 2^31 - 1 rows,
                #where each cell is a string of 2^31 - 1 bytes' length. There's a reason
                #this variable's name ends in "theory".
                max_width_theory = (2^31 - 1)^3,

                #As hardcoded into our lexer: see ado.fl's redefinition
                #of the C macro YYLMAX
                max_macrolen = 2^16,
                macrolen = 2^16,

                max_macro_namelen = 32, # Stata disallows long identifiers

                #The real limit is on the length of a single lexer token, which can
                #be no longer than 2^16 bytes. There's no limit on the length of
                #commands, provided they can be represented as R strings, and an R
                #string can be no longer than 2^31 - 1 bytes. Note that encountering
                #a single token longer than YYLMAX = 2^16 bytes will cause yylex() to
                #raise an R error condition rather than calling the C exit() function
                #on the R process.
                max_cmdlen = 2^31 - 1,

                cmdlen = 2^31 - 1,

                #The maximum length of the symbol type as of R 2.13.0
                namelen = 10000,

                #This is the limit on vector size hardcoded into R in various places;
                #the newer long vectors can be, of course, longer, but using them is
                #still difficult and we've made no effort to do so.
                maxvar = 2^31 - 1,

                maxstrvarlen = 2^31 - 1,

                #The str# and strL types as we implement them are the same
                maxstrlvarlen = 2^31 - 1
            ))
        },

        # These are the c-class values that may change during execution,
        # which means we can't set any default values for them; they have
        # to be looked up at query time
        cclass_value_varying_quoted = function()
        {
            return(list(
                current_date = quote(Sys.Date()),
                current_time = quote(Sys.time()),
                mode = quote(if(interactive()) "" else "batch"),
                console = quote(if(.Platform$GUI == "unknown") "console" else ""),
                hostname = quote(Sys.info()["nodename"]),
                username = quote(Sys.info()["user"]),
                tempdir = quote(tempdir()),
                tmpdir = quote(tempdir()),
                pwd = quote(getwd()),
                N = quote(self$dta$dim[1]),
                k = quote(self$dta$dim[2]),
                width = quote(utils::object.size(self$dta)),
                changed = quote(self$dta$changed),
                filename = quote(self$dta$filename),
                filedate = quote(self$dta$filedate),
                niceness = quote(tools::psnice()),
                rng = quote(paste0(RNGkind(), collapse=" ")),
                rngstate = quote(paste0(.Random.seed, collapse=",")),

                # it's appalling that triggering a garbage collection is the
                # recommended way to check mem usage
                memory = quote({mem <- gc(); 1024 * (mem[1, "(Mb)"] + mem[2, "(Mb)"])}),

                # FIXME - need to implement the machinery for commands to have
                # return codes; it's not clear what this should look like in an
                # implementation where control flow at a low level is based on
                # calls to signalCondition().
                rc = quote(0)
            ))
        },

        cclass_value_varying = function(val)
        {
            qtd <- private$cclass_value_varying_quoted()

            if(val %in% names(qtd))
                return(eval(qtd[[val]]))
            else
                raiseCondition("Bad c-class value")
        },

        # The main command-processing callback function for the parser
        process_cmd = function(ast, debug_level=0)
        {
            #Semantic analysis and code generation
            ret_p1 <-
                tryCatch(
                    {
                        check(ast, self$debug_parse_trace)
                        codegen(ast, context = self)
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
        deep_eval = function(expr, envir=parent.frame(),
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
                        self$log_result(fmt(tmp$value))
                    }
                }
            }

            # Return this so that higher layers can check whether it's a condition,
            # but those layers don't print it. All printing of results happens
            # above.
            ret
        },

        # A callback that allows the lexer to retrieve macro and
        # (e,r,c)-class values
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

                return(self$eclass_value(txt))
            }

            #the r() class
            m <- regexpr("^_?r\\((?<match>.*)\\)", name, perl=TRUE)
            start <- attr(m, "capture.start")
            len <- attr(m, "capture.length")
            if(start != -1)
            {
                txt <- substr(name, start, start + len - 1)

                return(self$rclass_value(txt))
            }

            #the c() class
            m <- regexpr("^_?c\\((?<match>.*)\\)", name, perl=TRUE)
            start <- attr(m, "capture.start")
            len <- attr(m, "capture.length")
            if(start != -1)
            {
                txt <- substr(name, start, start + len - 1)

                return(self$cclass_value(txt))
            }

            #a normal macro
            if(!(self$macro_defined(name)))
                return("")
            else
                return(self$macro_value(name))
        }
    )
)

