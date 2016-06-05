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

#Like any(), but check if _all_ elements of the argument are TRUE
every <-
function(vec)
{
    len <- length(which(vec))

    if(is.na(len) || len != length(vec))
        return(FALSE)
    else
        return(TRUE)
}

#Some useful infix operators
`%is%` <- function(x, y) every(y %in% class(x))
`%p%` <- function(x, y) paste0(x, y)
`%not_in%` <- function(x, y) (!(x %in% y))
`%xor%` <- function(x, y) xor(x, y)

#As in C, for handling bitwise ops on flags
`%|%` <- function(x, y) bitwOr(x, y)
`%&%` <- function(x, y) bitwAnd(x, y)

#Recursive evaluation of the sort of expression object that the parser builds.
#This function both evaluates the exps and prints the results.
deep_eval <-
function(expr, envir=parent.frame(),
         enclos=if(is.list(envir) || is.pairlist(envir))
                    parent.frame()
                else
                    baseenv(),
         print.results=TRUE)
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

            if(print.results && tmp$visible)
                print(tmp$value)
        }
    }

    ret
}

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

#Read a line from the console in interactive use, printing a prompt, and
#handling Stata's /// construct (which we have to do here as well as in
#the parser because it extends the line this function should read).
read_interactive <-
function()
{
    res = ""
    
    repeat
    {
        inpt <- readline(". ")

        #We're reading from the console one line at a time, so we have to handle
        #the /// construct in this function as well as in the parser
        if(substring(rev_string(inpt), 1, 3) == "///")
        {
            res <- paste(res, inpt, sep="\n")
            next;
        }

        #we got a line that doesn't continue onto the next line
        res <- paste(res, inpt, sep="\n")

        #Our ado grammar requires a newline or semicolon as a statement
        #terminator, so add one in case we didn't get one at EOF
        res <- paste0(res, "\n")

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
      if(!children[[n]] %is% "rstata_if_clause")
        return(FALSE)
    }

    if(n == "in_clause")
    {
      if(!children[[n]] %is% "rstata_in_clause")
        return(FALSE)
    }

    if(n == "weight_clause")
    {
      if(!children[[n]] %is% "rstata_weight_clause")
        return(FALSE)
    }

    if(n == "using_clause")
    {
      if(!children[[n]] %is% "rstata_using_clause")
        return(FALSE)
    }

    if(n == "option_list")
    {
      if(!children[[n]] %is% "rstata_option_list")
        return(FALSE)
    }

    if(n == "varlist")
    {
      if(!(children[[n]] %is% "rstata_expression_list"))
          return(FALSE)

      if(children[[n]]$children[[1]] %is% "rstata_type_expression")
      {
          type_exp <- children[[n]]$children[[1]]
          types <- vapply(type_exp$children[[1]]$children,
                          function(x) x %is% "rstata_ident",
                          TRUE)

          if(length(which(types)) != length(types))
              return(FALSE)
          else
              return(TRUE)
      } else
      {
          types <- vapply(children[[n]]$children,
                          function(x) x %is% "rstata_ident" ||
                              x %is% "rstata_factor_expression" ||
                              x %is% "rstata_cross_expression",
                          TRUE)

          if(length(which(types)) != length(types))
              return(FALSE)
          else
              return(TRUE)
      }
    }

    if(n == "expression_list")
    {
        if(!children[[n]] %is% "rstata_expression_list")
            return(FALSE)

        types <- vapply(children[[n]]$children,
                        function(x) x %is% "rstata_expression" ||
                                    x %is% "rstata_literal",
                        TRUE)

        if(length(which(types)) != length(types))
            return(FALSE)
    }
    if(n == "expression")
    {
        if(!children[[n]] %is% "rstata_expression_list")
            return(FALSE)

        types <- vapply(children[[n]]$children,
                        function(x) x %is% "rstata_expression" ||
                            x %is% "rstata_literal",
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

  if(valid_data_type(name))
    return(as.symbol(name))

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
#rstata_* command-implementing functions.
unabbreviateCommand <-
function(name, cls="error", msg=NULL)
{
  funcs <- ls(envir=parent.env(environment()))
  funcs <- funcs[grep("^rstata_cmd_", funcs)]

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
    form <- as.formula(y %p% " ~ " %p% paste0(st, collapse="+"))
    
    return(form)
}

#Take a format specifier string and transform it to an R list that encodes
#the format, setting the appropriate S3 class.
expand_format_spec <-
function(fmt)
{
    #FIXME
}
