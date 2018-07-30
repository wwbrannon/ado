#Functions that implement the two types of loops we support
ado_foreach <-
function(macro_name, text, varlist=NULL, numlist=NULL,
         local_macro_source=NULL, global_macro_source=NULL, context=NULL)
{
    #Sanity-check that we got sensible input
    cnt <- vapply(c(varlist, numlist, local_macro_source, global_macro_source),
                  function(x) !is.null(x), logical(1))
    raiseifnot(length(which(cnt)) == 1, msg="Bad body statement for foreach loop")

    #Get the debug level from the global settings environment
    debug_level <- context$settings$symbol_value("debug_level")

    #In case the text block doesn't end in a statement terminator, let's add one
    text <- paste0(text, "\n")

    #Loop over the values we should bind this macro to
    if(!is.null(varlist))
        vals <- varlist
    if(!is.null(numlist))
        vals <- numlist
    if(!is.null(global_macro_source))
    {
        src <- context$macro_syms$symbol_value(global_macro_source)
        vals <- strsplit(src, " |\t")
    }
    if(!is.null(local_macro_source))
    {
        nm <- paste0("_", local_macro_source)
        src <- context$macro_syms$symbol_value(nm)
        vals <- strsplit(src, " |\t")
    }

    #And now let's loop
    for(val in vals)
    {
        #Set the macro value
        ado_cmd_local(list(substitute(macro_name), as.character(val)))

        #And re-parse the text block
        ret <-
        tryCatch(
        {
            lc <- function(msg) context$logger$log_command(msg)
            do_parse_with_callbacks(text=text,
                                    cmd_action=process_cmd,
                                    macro_value_accessor=macro_value_accessor,
                                    log_command=lc, debug_level=debug_level,
                                    echo=0)
        },
        error=function(c) c)

        if(inherits(ret, "error"))
        {
            if(inherits(ret, "BreakException"))
            {
                break
            } else if(inherits(ret, "ContinueException"))
            {
                next
            } else
            {
                signalCondition(ret) #pass it on up
            }
        }
    }
}

ado_forvalues <-
function(macro_name, text, upper, lower,
         increment=NULL, increment_t=NULL, context=NULL)
{
    #Sanity-check that we got sensible input
    raiseifnot(!is.null(upper) && !is.null(lower) &&
               is.numeric(upper) && is.numeric(lower),
               msg="Bad range for forvalues command")
    if(!is.null(increment) || !is.null(increment_t))
        raiseifnot(xor(is.null(increment), is.null(increment_t)),
                   msg="Bad range for forvalues command")
    if(!is.null(increment))
        raiseifnot(is.numeric(increment), msg="Bad range for forvalues command")
    if(!is.null(increment_t))
        raiseifnot(is.numeric(increment_t), msg="Bad range for forvalues command")

    #Get the debug level from the global settings environment
    debug_level <- context$settings$symbol_value("debug_level")

    #In case the text block doesn't end in a statement terminator, let's add one
    text <- paste0(text, "\n")

    #Generate the sequence we should be looping over
    if(is.null(increment) && is.null(increment_t))
    {
        inc <- 1
    } else if(!is.null(increment))
    {
        inc <- increment
    } else if(!is.null(increment_t))
    {
        inc <- increment_t - lower
    }

    ret <-
    tryCatch(
    {
        vals <- seq.int(lower, upper, inc)
    },
    error=function(c) c)

    if(inherits(ret, "error"))
    {
        raiseCondition("Bad values for foreach limits / increment")
    }

    #And now let's loop
    for(val in vals)
    {
        #Set the macro value
        ado_cmd_local(list(substitute(macro_name), as.character(val)))

        #And re-parse the text block
        ret <-
        tryCatch(
        {
            lc <- function(msg) context$logger$log_command(msg)
            do_parse_with_callbacks(text=text,
                                    cmd_action=process_cmd,
                                    macro_value_accessor=macro_value_accessor,
                                    log_command=lc, debug_level=debug_level,
                                    echo=0)
        },
        error=function(c) c)

        if(inherits(ret, "error"))
        {
            if(inherits(ret, "BreakException"))
            {
                break
            } else if(inherits(ret, "ContinueException"))
            {
                next
            } else
            {
                signalCondition(ret) #pass it on up
            }
        }
    }
}

