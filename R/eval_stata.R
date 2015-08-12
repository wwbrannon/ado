# we want to eval these almost entirely for their side effects
eval_stata <-
function(expr_list, envir = parent.frame(),
         enclos = if(is.list(envir) || is.pairlist(envir))
                     parent.frame() else baseenv())
{
    for(i in seq_len(length(expr_list) - 1))
        eval(expr_list[[i]], envir, enclos);

    invisible(eval(expr_list[[length(expr_list)]], envir, enclos))
}

