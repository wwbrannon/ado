rstata_cmd_clear <-
function(expression=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    if(is.null(expression))
    {
        drop_data <- TRUE
        drop_results <- FALSE
    } else if(as.character(expression[[1]]) == "all")
    {
        drop_data <- TRUE
        drop_results <- TRUE
    } else if(as.character(expression[[1]]) == "results")
    {
        drop_data <- FALSE
        drop_results <- TRUE
    } else
    {
        raiseCondition("Bad subcommand to clear")
    }
    
    if(drop_data)
    {
        dt <- get("rstata_dta", envir=rstata_env)
        dt$clear()
    }
    
    if(drop_results)
    {
        rstata_cmd_return(expression_list=list(as.symbol("clear")))
        rstata_cmd_ereturn(expression_list=list(as.symbol("clear")))
    }
    
    return(invisible(NULL))    
}

rstata_cmd_head <-
function(option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    valid_opts <- c("n")
    option_list <- validateOpts(option_list, valid_opts)
    
    n <- 5
    if(hasOption(option_list, "n"))
    {
        n <- optionArgs(option_list, "n")
    }
    
    return(rstata_cmd_list(in_clause=list(upper=n, lower=1)))
}

rstata_cmd_list <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both in clause and if clause at once")
    
    dt <- get("rstata_dta", envir=rstata_env)
    
    cols <- varlist
    if(is.null(cols))
    {
        cols <- dt$names
    }
    
    if(!is.null(if_clause))
    {
        rows <- dt$rows_where(if_clause)
    } else if(!is.null(in_clause))
    {
        rn <- dt$in_clause_to_row_numbers(in_clause)
        rows <- seq.int(rn[1], rn[2])
    } else
    {
        rows <- seq.int(1, dt$dim[1])
    }
    
    return(dt$iloc(rows, cols))
}

rstata_cmd_drop <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    #Only certain combinations of these arguments are valid
    raiseif(is.null(varlist) && is.null(if_clause) && is.null(in_clause),
            msg="Must specify what to drop")
    raiseif(!is.null(varlist) && (!is.null(if_clause) || !is.null(in_clause)),
            msg="Cannot drop both columns and rows at once")
    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both an in clause and an if clause at once")
    
    dt <- get("rstata_dta", envir=rstata_env)
    varlist <- lapply(varlist, as.character)
    
    #One Stata syntax: we're dropping columns
    if(!is.null(varlist))
    {
        dt$drop_columns(varlist)
    }
    
    #We're dropping rows but keeping all columns
    if(!is.null(if_clause))
    {
        rows <- dt$rows_where(if_clause)
        dt$drop_rows(rows)
    }
    
    if(!is.null(in_clause))
    {
        rn <- dt$in_clause_to_row_numbers(in_clause)
        dt$drop_rows(seq.int(rn[1], rn[2]))
    }
    
    return(invisible(NULL))
}

rstata_cmd_keep <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    #Only certain combinations of these arguments are valid
    raiseif(is.null(varlist) && is.null(if_clause) && is.null(in_clause),
            msg="Must specify what to keep")
    raiseif(!is.null(varlist) && (!is.null(if_clause) || !is.null(in_clause)),
            msg="Cannot keep both columns and rows at once")
    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both an in clause and an if clause at once")
    
    dt <- get("rstata_dta", envir=rstata_env)
    varlist <- lapply(varlist, as.character)
    
    #One Stata syntax: we're dropping columns
    if(!is.null(varlist))
    {
        cols <- setdiff(dt$names, varlist)
        dt$drop_columns(cols)
    }
    
    #We're dropping rows but keeping all columns
    if(!is.null(if_clause))
    {
        all_rows = seq.int(dt$dim[1], dt$dim[2])
        rows <- dt$rows_where(if_clause)
        
        dt$drop_rows(setdiff(all_rows, rows))
    }
    
    if(!is.null(in_clause))
    {
        rn <- dt$in_clause_to_row_numbers(in_clause)
        
        all_rows = seq.int(dt$dim[1], dt$dim[2])
        rows <- seq.int(rn[1], rn[2])
        
        dt$drop_rows(setdiff(all_rows, rows))
    }
    
    return(invisible(NULL))
}

rstata_cmd_append <-
function(using_clause, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_codebook <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_collapse <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_compare <-
function(expression_list, if_clause=NULL, in_clause=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_count <-
function(if_clause=NULL, in_clause=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    dt <- get("rstata_dta", envir=rstata_env)
    return(dt$dim[1])
}

rstata_cmd_decode <-
function(expression, if_clause=NULL, in_clause=NULL, option_list,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_describe <-
function(expression_list=NULL, using_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_destring <-
function(expression_list=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_duplicates <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_egen <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_encode <-
function(expression, if_clause=NULL, in_clause=NULL, option_list,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_expand <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_flist <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_format <-
function(expression_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_generate <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_gsort <-
function(expression_list, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_isid <-
function(varlist, using_clause=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_label <-
function(expression_list, using_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_lookfor <-
function(expression_list, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_merge <-
function(varlist, using_clause, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_order <-
function(expression_list, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_recast <-
function(expression, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_recode <-
function(expression_list, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_rename <-
function(expression_list, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_reshape <-
function(expression_list=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_sample <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_separate <-
function(expression, option_list, if_clause=NULL, in_clause=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_sort <-
function(expression, in_clause=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_split <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_tostring <-
function(expression_list, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_xtile <-
function(expression, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}
