every <-
function(vec)
{
    len <- length(which(vec))

    if(is.na(len) || len != length(vec))
        return(FALSE)
    else
        return(TRUE)
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
function(cls, msg)
{
    cond <- simpleError(msg)
    class(cond) <- c(class(cond), cls)
    signalCondition(cond)

    invisible(NULL)
}

raiseifnot <-
function(expr, cls="bad_command", msg=errmsg)
{
    #Construct a message
    ch <- deparse(substitute(expr))
    if (length(ch) > 1L) 
        ch <- paste(ch[1L], "....")
    errmsg <- sprintf("%s is not TRUE", ch)
    
    #Check and raise a condition if it fails
    if (!(is.logical(expr) && !is.na(expr) && expr))
        raiseCondition(cls, msg)
    
    invisible(NULL)
}

#We're reading from the console, so we have to handle the /// construct
#in this function as well as in the parser.
read_interactive <-
function()
{
    res = ""
    while(TRUE)
    {
        inpt <- readline(". ")
        
        if(length(inpt) == 0) #at EOF
            raiseCondition("exit", "end of file")
        
        if(substring(rev_string(inpt), 1, 3) == "///")
        {
            res <- paste(res, inpt, sep="\n")
            next;
        }
        
        #we got a non-continuing line
        res <- paste(res, inpt, sep="\n")
        break
    }

    res
}

#Functions for validating parts of general and special commands
valid_cmd_part <-
function(name)
{
  name %in% c("main_cmd", "next_modifier", "verb", "varlist",
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
