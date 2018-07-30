default_webuse_url <- 'https://www.stata-press.com/data/r15/'

test_parse <-
function(text, context=NULL, debug_level=0)
{
    lc <- function(msg) context$logger$log_command(msg)
    return(codegen(do_parse(text, log_command=lc, debug_level=debug_level)))
}

# Return the default c-class env values. This is not the
# only place c-class values are looked up (see ado_func_c),
# but we still need to set certain values here.
get_default_cclass_values <-
function()
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

        default_webuse_url = default_webuse_url,

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
}

get_varying_cclass_value <-
function(val, context=NULL)
{
    if(val == 'current_date')
    {
        return(Sys.Date())
    } else if(val == 'current_time')
    {
        return(Sys.time())
    } else if(val == 'mode')
    {
        if(interactive())
        {
            return("")
        } else
        {
            return("batch")
        }
    } else if(val == 'console')
    {
        if(.Platform$GUI == "unknown")
        {
            return("console")
        } else
        {
            return("")
        }
    } else if(val == 'hostname')
    {
        return(Sys.info()["nodename"])
    } else if(val == 'username')
    {
        return(Sys.info()["user"])
    } else if(val == 'tmpdir')
    {
        return(tempdir())
    } else if(val == 'pwd')
    {
        return(getwd())
    } else if(val == 'N')
    {
        return(context$dta$dim[1])
    } else if(val == 'k')
    {
        return(context$dta$dim[2])
    } else if(val == 'width')
    {
        return(utils::object.size(context$dta))
    } else if(val == 'changed')
    {
        return(context$dta$changed)
    } else if(val == 'filename')
    {
        return(context$dta$filename)
    } else if(val == 'filedate')
    {
        return(context$dta$filedate)
    } else if(val == 'memory')
    {
        #it's appalling that this is the recommended way to check mem usage
        mem <- gc()
        return( 1024 * (mem[1, "(Mb)"] + mem[2, "(Mb)"]) )
    } else if(val == 'niceness')
    {
        return(tools::psnice())
    } else if(val == 'rng')
    {
        return(paste0(RNGkind(), collapse=" "))
    } else if(val == 'rngstate')
    {
        return(paste0(.Random.seed, collapse=","))
    } else if(val == 'rc')
    {
        #FIXME - need to implement the machinery for commands to have
        #return codes; it's not clear what this should look like in an
        #implementation where control flow at a low level is based on
        #calls to signalCondition().
        return(0)
    } else
    {
        return(get(val, envir=env, inherits=FALSE))
    }
}

get_default_setting_values <-
function()
{
    return(list(
        webuse_url = default_webuse_url
    ))
}

### Option-list accessor methods

#Validate and unabbreviate the provided options against the list of valid
#options for the function calling this helper.
validateOpts <-
function(option_list, valid_opts)
{
    if(length(option_list) == 0)
        return(option_list)

    #Extract the option names as strings
    given <- vapply(option_list, function(x) as.character(x$name), character(1))

    #Unabbreviate each option. The unabbreviateName function will raise an
    #error condition if an option is invalid or ambiguous.
    given <- vapply(given, function(x) unabbreviateName(x, valid_opts), character(1))

    #The same option can't be given more than once
    raiseifnot(length(given) == length(unique(given)),
               msg="Option given more than once")

    #Update the names
    for(i in 1:length(given))
        option_list[[i]]$name <- given[i]

    option_list
}

#This function assumes that the option_list has already been validated and
#unabbreviated by the validateOpts function above.
hasOption <-
function(option_list, opt)
{
    nm <- vapply(option_list, function(v) as.character(v$name), character(1))
    opt %in% nm
}

#Get the arguments provided to the option named by opt.
#This function assumes that the option_list has already been validated and
#unabbreviated by the validateOpts function above.
optionArgs <-
function(option_list, opt)
{
    raiseifnot(hasOption(option_list, opt), msg="Option not provided")

    #extract the option names as strings
    nm <- vapply(option_list, function(v) as.character(v$name), character(1))

    ind <- which(nm == opt)
    if("args" %in% names(option_list[[ind]]))
        return(option_list[[ind]]$args)
    else
        return(NULL)
}

temporary_name <-
function(lst=NULL, len=10)
{
    raiseifnot(len >= 1, msg="temporary name length must be positive")

    flchars <- c(letters, LETTERS)
    fl <- sample(flchars, 1)

    chars <- c(letters, LETTERS, vapply(0:9, as.character, character(1)))
    oc <- sample(chars, len - 1)

    nm <- paste0(c(fl, oc), collapse="")

    if(!is.null(lst))
    {
        repeat
        {
            if(nm %not_in% lst)
            {
                break
            }

            nm <- paste0(sample(chars, len), collapse="")
        }
    }

    nm
}

#Returns a list of vectors, each with names the unique characters
#occurring in str, and values the number of times each apppears
char_count <-
function(strs)
{
    sp <- strsplit(strs, "", fixed=TRUE)

    uniqs <- unique(Reduce(c, sp))

    lapply(sp, function(y)
        vapply(uniqs,
               function(x) length(which(y == x)),
               integer(1))
    )
}

#Recursively flatten a possibly nested list
flatten <-
function(x)
{
    repeat
    {
        if(!any(vapply(x, is.list, logical(1))))
            return(x)

        x <- Reduce(c, x)
    }
}

#Some useful infix operators
`%is%` <- function(x, y) every(y %in% class(x))
`%p%` <- function(x, y) paste0(x, y)
`%not_in%` <- function(x, y) (!(x %in% y))
`%xor%` <- function(x, y) xor(x, y)

#As in C, for handling bitwise ops on flags
`%|%` <- function(x, y) bitwOr(x, y)
`%&%` <- function(x, y) bitwAnd(x, y)

#Reverse a vector of strings
rev_string <-
function(str)
{
    pts <- lapply(strsplit(str, NULL), rev)
    pts <- lapply(pts, function(x) paste0(x, collapse=''))

    simplify2array(pts)
}

#The process_cmd callback catches certain types of conditions signaled in
#code that it calls, so we want to have a concise idiom for signaling those
#conditions. That way we can use them for exception handling.
raiseCondition <-
function(msg, cls="BadCommandException")
{
    cond <- simpleCondition(msg)
    class(cond) <- c(class(cond), cls)
    signalCondition(cond)

    invisible(NULL)
}

raiseifnot <-
function(expr, cls="BadCommandException", msg=NULL)
{
    raiseif(!expr, cls=cls, msg=msg)
}

#Like stopifnot(), but rather than actually calling stop(), just throw an
#exception to the point in process_cmd where it's caught and handled.
raiseif <-
function(expr, cls="BadCommandException", msg=NULL)
{
    if(is.null(msg))
    {
      #Construct a message
      ch <- deparse(substitute(expr))
      if (length(ch) > 1L)
          ch <- paste(ch[1L], "....")
      errmsg <- sprintf("%s is not TRUE", ch)
    } else
    {
      errmsg <- msg
    }

    #Check and raise a condition if it fails
    if (length(expr) == 0 || !is.logical(expr) || is.na(expr) || expr)
      raiseCondition(errmsg, cls)

    invisible(NULL)
}

#Read a line from the console in interactive use, or from a connection,
#printing a prompt, and handling Stata's /// construct (which we have to
#do here as well as in the parser because it extends the line this function
#should read).
read_input <-
function(con=NULL)
{
    res = ""

    repeat
    {
        if(is.null(con) && interactive())
        {
            inpt <- readline(". ")
        } else if(!is.null(con))
        {
            inpt <- readLines(con, n=-1L, warn=FALSE)
            inpt <- Reduce(function(x, y) paste(x, y, sep="\n"), inpt)
        } else
        {
            stop("Cannot read without a connection in non-interactive mode")
        }

        #We've hit EOF
        if(length(inpt) == 0)
        {
            #An empty file or an incomplete "///" terminated line without anything
            #on the next line, either of which is a syntax error. Return it for
            #parsing and let the parser complain about the syntax error.
            if(nchar(res) > 0)
                break
            else
                return(character(0))
        }

        #Skip blank lines
        inpt <- trimws(inpt)
        if(inpt == "")
        {
            cat("\n")
            next;
        }

        #When we're reading one line at a time, we have to handle
        #the /// construct in this function as well as in the parser
        if(substring(rev_string(inpt), 1, 3) == "///")
        {
            res <- paste(res, inpt, sep="\n")
            next;
        }

        #We got a line that doesn't continue onto the next line
        if(nchar(res) > 0)
        {
            res <- paste(res, inpt, sep="\n")
        } else
        {
            res <- inpt
        }

        #Our ado grammar requires a newline or semicolon as a statement
        #terminator, so add one if we didn't get one or discarded it
        ch <- substr(res, nchar(res), nchar(res))
        if(ch %not_in% c("\n", ";"))
        {
            res <- paste0(res, "\n")
        }

        break
    }

    res
}

#Is the command part that the semantic analyzer has seen actually a valid
#part of a command object?
valid_cmd_part <-
function(name)
{
  name %in% c("verb", "varlist", "expression_list",
              "if_clause", "in_clause", "weight_clause",
              "using_clause", "option_list", "expression")
}

#Now that we know the command object has parts with the correct names,
#are the things within it that have those names of the correct S3 types?
#Are they well-formed?
correct_arg_types_for_cmd <-
function(children)
{
  ns <- setdiff(names(children), c("verb"))

  for(n in ns)
  {
    if(n == "if_clause")
    {
      if(!children[[n]] %is% "ado_if_clause")
        return(FALSE)
    }

    if(n == "in_clause")
    {
      if(!children[[n]] %is% "ado_in_clause")
        return(FALSE)
    }

    if(n == "weight_clause")
    {
      if(!children[[n]] %is% "ado_weight_clause")
        return(FALSE)
    }

    if(n == "using_clause")
    {
      if(!children[[n]] %is% "ado_using_clause")
        return(FALSE)
    }

    if(n == "option_list")
    {
      if(!children[[n]] %is% "ado_option_list")
        return(FALSE)
    }

    if(n == "varlist")
    {
      if(!(children[[n]] %is% "ado_expression_list"))
          return(FALSE)

      if(children[[n]]$children[[1]] %is% "ado_type_expression")
      {
          type_exp <- children[[n]]$children[[1]]
          types <- vapply(type_exp$children[[1]]$children,
                          function(x) x %is% "ado_ident",
                          TRUE)

          if(length(which(types)) != length(types))
              return(FALSE)
          else
              return(TRUE)
      } else
      {
          types <- vapply(children[[n]]$children,
                          function(x) x %is% "ado_ident" ||
                              x %is% "ado_factor_expression" ||
                              x %is% "ado_cross_expression",
                          TRUE)

          if(length(which(types)) != length(types))
              return(FALSE)
          else
              return(TRUE)
      }
    }

    if(n == "expression_list")
    {
        if(!children[[n]] %is% "ado_expression_list")
            return(FALSE)

        types <- vapply(children[[n]]$children,
                        function(x) x %is% "ado_expression" ||
                                    x %is% "ado_literal",
                        TRUE)

        if(length(which(types)) != length(types))
            return(FALSE)
    }
    if(n == "expression")
    {
        if(!children[[n]] %is% "ado_expression_list")
            return(FALSE)

        types <- vapply(children[[n]]$children,
                        function(x) x %is% "ado_expression" ||
                            x %is% "ado_literal",
                        TRUE)

        if(length(which(types)) != length(types))
            return(FALSE)

        if(length(children[[n]]$children) != 1)
            return(FALSE)
    }
  }

  return(TRUE)
}

#We have something that syntactically has to be a data type name.
#Is it a valid one?
valid_data_type <-
function(name)
{
  if(name %in% c("byte", "int", "long", "float", "double"))
    return(TRUE)

  if(name %in% c("str", "strL"))
    return(TRUE)

  if(length(grep("str[0-9]+", name)) > 0)
    if(name != "str0")
      return(TRUE)

  return(FALSE)
}

#Is this a valid format specifier?
valid_format_spec <-
function(fmt)
{
  #string formats
  if(length(grep("%[-~]?[0-9]+s", fmt)) > 0)
    return(TRUE)

  #datetime formats
  if(length(grep("%t[Ccdwmqh][A-Za-z\\.\\,\\:\\-\\_\\/\\\\\\+]*", fmt)) > 0)
    return(TRUE)

  #numeric formats
  if(length(grep("%-?[0-9]+\\.[0-9]+(g|f|e|gc|fc)", fmt)) > 0)
    return(TRUE)

  #special numeric formats
  if(length(grep("%21x|%16H|%16L|%8H|%8L", fmt)) > 0)
    return(TRUE)

  return(FALSE)
}

#Take the name of an ado-language operator, whether unary or binary, and return
#a symbol for the R function that implements that operator.
function_for_ado_operator <-
function(name)
{
  #Arithmetic expressions
  if(name %in% c("^", "-", "+", "*", "/", "+", "-"))
    return(as.symbol(name))

  #Logical, relational and other expressions
  if(name %in% c("&", "|", "!", ">", "<", ">=", "<="))
    return(as.symbol(name))

  if(name == "()")
    return(as.symbol("do.call"))

  if(name == "=")
    return(as.symbol("<-"))

  if(name == "[]")
    return(as.symbol("["))

  if(name == "==")
    return(as.symbol("%==%"))

  #Factor operators
  if(name == "c.")
    return(as.symbol("op_cont"))

  if(name == "i.")
    return(as.symbol("op_ind"))

  if(name == "o.")
    return(as.symbol("op_omit"))

  if(name == "ib.")
    return(as.symbol("op_base"))

  if(name == "##")
    return(as.symbol("%##%"))

  if(name == "#")
    return(as.symbol("%#%"))

  if(name == "%anova_nest%")
    return(as.symbol("%anova_nest%"))

  if(name == "%anova_error%")
    return(as.symbol("%anova_error%"))

  #Type constructors
  if(valid_data_type(name))
  {
      if(substr(name, 1, 3) == "str")
      {
          return(as.symbol('ado_type_str'))
      }
      else
      {
          return(as.symbol('ado_type_' %p% name))
      }
  }

  raiseCondition("Bad operator or function", cls="BadCommandException")
}

#Wrap around charmatch but check that the match is unambiguous.
#For use with a function's list of its acceptable Stata options,
#or with the colnames of the dataset (i.e., with dataset variables).
unabbreviateName <-
function(name, choices, cls="EvalErrorException", msg=NULL)
{
  matched <- charmatch(name, choices)
  raiseifnot(length(matched) == 1 && matched != 0 && !is.na(matched), cls=cls, msg=msg)

  choices[matched]
}

#For unabbreviating command names against the list of all the
#ado_* command-implementing functions.
unabbreviateCommand <-
function(name, cls="error", msg=NULL)
{
  funcs <- ls(envir=parent.env(environment()))
  funcs <- funcs[grep("^ado_cmd_", funcs)]

  unabbreviateName(name, funcs, cls=cls, msg=msg)
}

#FIXME - this doesn't handle large parts of stata formula syntax yet
#Those commands which take an exp list and interpret it as an R formula
#can call this function to convert it to one. If the dv flag is TRUE,
#the first element of varlist must be a symbol or character that becomes
#the LHS of the formula.
expression_list_to_formula <-
function(expression_list, dv=TRUE)
{
    if(dv)
    {
        y <- as.character(expression_list[[1]])
        expression_list <- expression_list[2:length(expression_list)]
    } else
    {
        y <- ""
    }

    st <- lapply(expression_list, as.character)
    form <- stats::as.formula(y %p% " ~ " %p% paste0(st, collapse="+"))

    return(form)
}

#Take a format specifier string and transform it to an R list that encodes
#the format, setting the appropriate S3 class.
expand_format_spec <-
function(fmt)
{
    #FIXME
}
