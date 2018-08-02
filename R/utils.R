#Some useful infix operators
`%is%` <- function(x, y) all(y %in% class(x))
`%p%` <- function(x, y) paste0(x, y)
`%not_in%` <- function(x, y) (!(x %in% y))
`%xor%` <- function(x, y) xor(x, y)

#As in C, for handling bitwise ops on flags
`%|%` <- function(x, y) bitwOr(x, y)
`%&%` <- function(x, y) bitwAnd(x, y)

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

#Reverse a vector of strings
rev_string <-
function(str)
{
    pts <- lapply(strsplit(str, NULL), rev)
    pts <- lapply(pts, function(x) paste0(x, collapse=''))

    simplify2array(pts)
}

#The command processing callback catches certain types of conditions signaled
#in code that it calls, so we want to have a concise idiom for signaling those
#conditions. That way we can use them for exception handling.
raiseCondition <-
function(msg, cls="BadCommandException")
{
    cls <- unique(c("AdoException", cls))

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
#exception to the point where it's caught and handled.
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

#Wrap around charmatch but check that the match is unambiguous.
#For use with a function's list of its acceptable Stata options,
#or with the colnames of the dataset (i.e., with dataset variables).
unabbreviateName <-
function(name, choices, cls="EvalErrorException", msg=NULL)
{
  matched <- charmatch(name, choices)
  raiseifnot(length(matched) == 1 && matched != 0 && !is.na(matched),
             cls=cls, msg=msg)

  choices[matched]
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
