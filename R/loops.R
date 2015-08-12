#Functions that implement the two types of loops we support
rstata_foreach <-
function(macro_name, text, varlist=NULL, numlist=NULL,
         local_macro_source=NULL, global_macro_source=NULL)
{
    #Sanity-check that we got sensible input
    cnt <- vapply(c(varlist, numlist, local_macro_source, global_macro_source),
                  function(x) !is.null(x), logical(1))
    raiseifnot(length(which(cnt)) == 1, msg="Bad body statement for foreach loop")
    
    #Get the debug level from the global settings environment
    debug_level <- getSettingValue("debug_level")

    #In case the text block doesn't end in a statement terminator, let's add one
    text <- paste0(text, "\n")

    #Loop over the values we should bind this macro to
    if(!is.null(varlist))
        vals <- varlist
    if(!is.null(numlist))
        vals <- numlist 
    if(!is.null(global_macro_source))
    {
        src <- get(global_macro_source, envir=get("rstata_macro_env", envir=rstata_env))
        vals <- strsplit(src, " |\t")
    }
    if(!is.null(local_macro_source))
    {
        nm <- paste0("_", local_macro_source)
        src <- get(nm, envir=get("rstata_macro_env", envir=rstata_env))
        vals <- strsplit(src, " |\t")
    }
    
    #And now let's loop
    for(val in vals)
    {
        #Set the macro value
        rstata_cmd_local(list(substitute(macro_name), as.character(val)))
        
        #And re-parse the text block
        do_parse_with_callbacks(text=text,
                                cmd_action=process_cmd,
                                macro_value_accessor=macro_value_accessor,
                                debug_level=debug_level,
                                echo=0)
    }
}

rstata_forvalues <-
function(macro_name, text, upper, lower,
         increment=NULL, increment_t=NULL)
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
    debug_level <- getSettingValue("debug_level")

    #In case the text block doesn't end in a statement terminator, let's add one
    text <- paste0(text, "\n")

    #Generate the sequence we should be looping over
    if(is.null(increment) && is.null(increment_t))
    {
        vals <- seq.int(lower, upper, 1)
    } else if(!is.null(increment))
    {
        vals <- seq.int(lower, upper, increment)
    } else if(!is.null(increment_t))
    {
        vals <- seq.int(lower, upper, increment_t - lower)
    }

    #And now let's loop
    for(val in vals)
    {
        #Set the macro value
        rstata_cmd_local(list(substitute(macro_name), as.character(val)))

        #And re-parse the text block
        do_parse_with_callbacks(text=text,
                                cmd_action=process_cmd,
                                macro_value_accessor=macro_value_accessor,
                                debug_level=debug_level,
                                echo=0)
    }
}

