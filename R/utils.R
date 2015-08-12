every <-
function(vec)
{
    len <- length(which(vec))

    if(is.na(len) || len != length(vec))
        return(FALSE)
    else
        return(TRUE)
}

deep_eval <-
function(expr, envir=parent.frame(),
         enclos=if(is.list(envir) || is.pairlist(envir))
                    parent.frame()
                else
                    baseenv(),
         print.results=TRUE)
{
    raiseifnot(is.expression(expr))

    ret <- list()
    for(chld in expr)
    {
        if(is.expression(chld))
            ret[[length(ret)+1]] <- deep_eval(chld, envir=envir, enclos=enclos)
        else
            ret[[length(ret)+1]] <- eval(chld, envir=envir, enclos=enclos)

        if(print.results)
            print(ret[[length(ret)]])
    }

    ret
}

`%is%` <-
function(x, y)
every(y %in% class(x))

#Reverse a vector of strings
rev_string <-
function(str)
{
    pts <- lapply(strsplit(str, NULL), rev)
    pts <- lapply(pts, function(x) paste0(x, collapse=''))

    simplify2array(pts)
}

raiseCondition <-
function(msg, cls="BadCommandException")
{
    cond <- simpleCondition(msg)
    class(cond) <- c(class(cond), cls)
    signalCondition(cond)

    invisible(NULL)
}

raiseifnot <-
function(expr, cls="BadCommandException", msg=errmsg)
{
    #Construct a message
    ch <- deparse(substitute(expr))
    if (length(ch) > 1L)
        ch <- paste(ch[1L], "....")
    errmsg <- sprintf("%s is not TRUE", ch)

    #Check and raise a condition if it fails
    if (length(expr) == 0 || !is.logical(expr) || is.na(expr) || !expr)
      raiseCondition(msg, cls)

    invisible(NULL)
}

#We're reading from the console one line at a time, so we have to handle
#the /// construct in this function as well as in the parser
read_interactive <-
function()
{
    res = ""
    while(TRUE)
    {
        inpt <- readline(". ")

        if(length(inpt) == 0) #at EOF
            raiseCondition("End of file", "ExitRequestedException")

        if(substring(rev_string(inpt), 1, 3) == "///")
        {
            res <- paste(res, inpt, sep="\n")
            next;
        }

        #we got a line that doesn't continue onto the next line
        res <- paste(res, inpt, sep="\n")

        #the grammar requires a newline or semicolon as a statement
        #terminator, so add a few in case we didn't get one at EOF
        res <- paste0(res, "\n\n\n")

        break
    }

    res
}

#Functions for validating parts of general and special commands
valid_cmd_part <-
function(name)
{
  name %in% c("verb", "varlist", "expression_list",
              "if_clause", "in_clause", "weight_clause",
              "using_clause", "option_list", "expression")
}

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
      if(!children[[n]] %is% "rstata_expression_list")
        return(FALSE)

      types <- vapply(children[[n]]$children,
                      function(x) x %is% "rstata_ident" ||
                                  x %is% "rstata_label_expression" ||
                                  x %is% "rstata_factor_expression" ||
                                  x %is% "rstata_cross_expression",
                      TRUE)
      if(length(which(types)) != length(types))
        return(FALSE)
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
      if(!(children[[n]] %is% "rstata_expression"))
        return(FALSE)
    }
  }

  return(TRUE)
}

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

valid_format_spec <-
function(fmt)
{
  if(length(grep("%-?[0-9]+s", fmt)) > 0)
    return(TRUE)

  if(length(grep("%-?0?[1-9][0-9]+\\.[0-9]+[efg]c?", fmt)) > 0)
    return(TRUE)

  if(length(grep("%-?t[Ccdwmqh][A-Za-z_]*", fmt)) > 0)
    return(TRUE)

  return(FALSE)
}

#Functions for generating code
function_for_ado_operator <-
function(name)
{
  #Arithmetic expressions
  if(name %in% c("^", "-", "+", "*", "/", "+", "-"))
    return(as.symbol(name))

  #Logical, relational and other expressions
  if(name %in% c("==", "&", "|", "!", ">", "<", ">=", "<="))
    return(as.symbol(name))

  if(name == "()")
    return(as.symbol("do.call"))

  if(name == "=")
    return(as.symbol("<-"))

  if(name == "[]")
    return(as.symbol("["))

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
}

#For use with a function's list of its acceptable Stata options,
#or with the names attribute of the dataset
unabbreviateName <-
function(name, choices, cls="error")
{
  matched <- charmatch(name, choices)
  raiseifnot(length(matched) == 1, cls=cls)

  choices[matched]
}

#For unabbreviating command names against the list of all the
#rstata_* command-implementing functions
unabbreviateCommand <-
function(name, cls="error")
{
  funcs <- ls(envir=parent.env(environment()))
  funcs <- funcs[grep("^rstata_cmd_", funcs)]

  unabbreviateName(name, funcs, cls=cls)
}

#Those commands which take a varlist and interpret it as an R formula
#can call this function to convert it to one
varlist_to_formula <-
function(varlist, dv=TRUE)
{

}
