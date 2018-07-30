ado_cmd_clear <-
function(expression=NULL, return.match.call=FALSE)
{
    if(return.match.call)
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
        dt <- get("ado_dta", envir=ado_env)
        dt$clear()
    }

    if(drop_results)
    {
        ado_cmd_return(expression=as.call(list(as.symbol("clear"))))
        ado_cmd_ereturn(expression=as.call(list(as.symbol("clear"))))
    }

    return(invisible(NULL))
}

ado_cmd_head <-
function(option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("n")
    option_list <- validateOpts(option_list, valid_opts)

    n <- 5
    if(hasOption(option_list, "n"))
    {
        pn <- optionArgs(option_list, "n")
        raiseif(length(pn) < 1, msg="Must provide a number of lines")
        raiseif(length(pn) > 1, msg="Too many values to option n")

        n <- pn[[1]]
    }

    dt <- get("ado_dta", envir=ado_env)
    if(dt$dim[1] == 0)
    {
        return(invisible(NULL))
    } else
    {
        return(ado_cmd_list(in_clause=list(upper=n, lower=1)))
    }
}

ado_cmd_list <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both in clause and if clause at once")

    dt <- get("ado_dta", envir=ado_env)

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

    if(dt$dim[1] == 0)
    {
        return(invisible(NULL))
    } else
    {
        return(dt$iloc(rows, cols))
    }
}

ado_cmd_drop <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #Only certain combinations of these arguments are valid
    raiseif(is.null(varlist) && is.null(if_clause) && is.null(in_clause),
            msg="Must specify what to drop")
    raiseif(!is.null(varlist) && (!is.null(if_clause) || !is.null(in_clause)),
            msg="Cannot drop both columns and rows at once")
    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both an in clause and an if clause at once")

    dt <- get("ado_dta", envir=ado_env)
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

ado_cmd_keep <-
function(varlist=NULL, if_clause=NULL, in_clause=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #Only certain combinations of these arguments are valid
    raiseif(is.null(varlist) && is.null(if_clause) && is.null(in_clause),
            msg="Must specify what to keep")
    raiseif(!is.null(varlist) && (!is.null(if_clause) || !is.null(in_clause)),
            msg="Cannot keep both columns and rows at once")
    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both an in clause and an if clause at once")

    dt <- get("ado_dta", envir=ado_env)
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

ado_cmd_count <-
function(if_clause=NULL, in_clause=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot give both an if clause and an in clause at once")

    dt <- get("ado_dta", envir=ado_env)

    #We don't need to do any expensive copying here, fortunately
    if(!is.null(if_clause))
    {
        rows <- dt$rows_where(if_clause)
        return(length(rows))
    } else if(!is.null(in_clause))
    {
        rn <- dt$in_clause_to_row_numbers(in_clause)
        return(rn[2] - rn[1] + 1)
    } else
    {
        return(dt$dim[1])
    }
}

ado_cmd_gsort <-
function(expression_list, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("generate", "mfirst")
    option_list <- validateOpts(option_list, valid_opts)

    na.last <- !hasOption(option_list, "mfirst")

    rn <- NULL
    if(hasOption(option_list, "generate"))
    {
        rn <- optionArgs(option_list, "generate")
    }

    dt <- get("ado_dta", envir=ado_env)

    #These are unevaluated calls to ado_func_ functions, so they
    #need to be evaluated before being used.
    proc <- lapply(expression_list, eval)
    cols <- lapply(proc, function(x) x$col)
    ords <- lapply(proc, function(x) x$asc)

    dt$sort(cols, asc=ords, row_number=rn, na.last=na.last)

    return(invisible(TRUE))
}

ado_cmd_sort <-
function(varlist, in_clause=NULL, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("stable")
    option_list <- validateOpts(option_list, valid_opts)
    stable <- hasOption(option_list, "stable")

    dt <- get("ado_dta", envir=ado_env)

    rows <- NULL
    if(!is.null(in_clause))
    {
        rn <- dt$in_clause_to_row_numbers(in_clause)
        rows <- seq.int(rn[1], rn[2])
    }

    dt$sort(varlist, rows=rows, stable=stable)

    return(invisible(TRUE))
}

ado_cmd_lookfor <-
function(expression_list, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    dt <- get("ado_dta", envir=ado_env)

    ind <- numeric(0)
    for(expr in expression_list)
    {
        re <- ".*" %p% as.character(expr) %p% ".*"
        ind <- c(ind, grep(re, dt$names))
    }

    df <- data.frame(variable_name=dt$names[ind],
                     storage_type=dt$dtypes[ind],
                     row.names=NULL)

    return(df)
}

ado_cmd_rename <-
function(expression_list, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    raiseifnot(length(expression_list) == 2,
               msg="Incorrect number of arguments")

    dt <- get("ado_dta", envir=ado_env)
    expression_list <- lapply(expression_list, as.character)

    nm <- dt$names
    ind <- which(nm == expression_list[[1]])
    nm[ind] <- expression_list[[2]]

    dt$setnames(nm)

    return(invisible(TRUE))
}

ado_cmd_isid <-
function(varlist, using_clause=NULL, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("sort", "missok")
    option_list <- validateOpts(option_list, valid_opts)
    sort <- hasOption(option_list, "sort")
    missok <- hasOption(option_list, "missok")

    varlist <- vapply(varlist, as.character, character(1))

    #In typical inconsistent Stata fashion, the using clause here says to do
    #something that doesn't involve the main dataset, so if needed, we'll set
    #up a temporary dataset instead
    if(!is.null(using_clause))
    {
        dt <- Dataset$new()

        if(tools::file_ext(using_clause) == "")
            using_clause <- using_clause %p% ".dta"

        dt$use(using_clause)
    } else
    {
        dt <- get("ado_dta", envir=ado_env)
    }

    if(!missok)
    {
        func <- function(x) length(which(is.na(dt$as_data_frame[, x])))
        missings <- vapply(varlist, func, numeric(1))

        raiseif(sum(missings) > 0,
                msg="Missing values in id variables and missok not specified")
    }

    if(sort)
    {
        dt$sort(varlist)
    }

    n <- data.table::uniqueN(dt$as_data_frame, by=varlist)
    raiseif(n < dt$dim[1],
            msg="Variables do not uniquely identify observations")

    return(invisible(TRUE))
}

ado_cmd_sample <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both if clause and in clause at once")

    valid_opts <- c("count", "by")
    option_list <- validateOpts(option_list, valid_opts)
    count <- hasOption(option_list, "count")
    if(hasOption(option_list, "by"))
    {
        byvars <- optionArgs(option_list, "by")
        byvars <- vapply(byvars, as.character, character(1))
    } else
    {
        byvars <- NULL
    }

    dt <- get("ado_dta", envir=ado_env)
    if(!is.null(in_clause))
    {
        rn <- dt$in_clause_to_row_numbers(in_clause)
        rows <- seq.int(rn[1], rn[2])
    } else if(!is.null(if_clause))
    {
        rows <- dt$rows_where(if_clause)
    } else
    {
        rows <- seq.int(1, dt$dim[1])
    }

    if(count)
    {
        cnt <- min(as.numeric(expression), length(rows))
    } else
    {
        cnt <- ceiling(as.numeric(expression) * length(rows))
    }

    raiseifnot(!is.na(cnt) && cnt >= 1 && cnt <= length(rows),
               msg="Bad count or proportion of rows to sample")

    if(is.null(byvars))
    {
        samp <- sample(rows, cnt)
    } else
    {
        idx <- dt$iloc(rows, byvars)

        samp <- c(tapply(rows, idx, function(x) sample(x, cnt), simplify=TRUE))
        samp <- samp[which(!is.na(samp))]
    }

    to_drop <- setdiff(rows, samp)
    dt$drop_rows(to_drop)
    return(structure(length(to_drop), class="ado_cmd_sample"))
}

ado_cmd_order <-
function(varlist, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("first", "last", "before", "after", "alphabetic", "sequential")
    option_list <- validateOpts(option_list, valid_opts)

    alphabetic <- hasOption(option_list, "alphabetic")
    sequential <- hasOption(option_list, "sequential")
    raiseif(alphabetic && sequential,
            msg="Cannot specify both alphabetic and sequential at once")

    first <- hasOption(option_list, "first")
    last <- hasOption(option_list, "last")
    before <- hasOption(option_list, "before")
    after <- hasOption(option_list, "after")

    n <- sum(first, last, before, after)
    raiseif(n > 1, msg="Cannot specify more than one position for re-ordered variables")
    if(n == 0)
    {
        first <- TRUE
    }

    if(before)
    {
        varname <- optionArgs(option_list, "before")
        raiseif(length(varname) > 1,
                msg="Too many variables specified")
        varname <- as.character(varname[[1]])
    } else if(after)
    {
        varname <- optionArgs(option_list, "after")
        raiseif(length(varname) > 1,
                msg="Too many variables specified")
        varname <- as.character(varname[[1]])
    } else
    {
        varname <- NULL
    }

    varlist <- vapply(varlist, as.character, character(1))
    dt <- get("ado_dta", envir=ado_env)
    nm <- dt$names

    raiseifnot(every(varlist %in% nm),
               msg="Not all variable names specified exist in the dataset")
    raiseifnot(length(varlist) == length(unique(varlist)),
               msg="Some variable names specified more than once")

    if(alphabetic)
    {
        varlist <- sort(varlist)
    } else if(sequential)
    {
        varlist <- varlist #FIXME
    }

    if(first)
    {
        tmp <- setdiff(nm, varlist)
        nm <- c(varlist, tmp)
    } else if(last)
    {
        tmp <- setdiff(nm, varlist)
        nm <- c(tmp, varlist)
    } else if(before)
    {
        #Setdiff, despite being a set operation, preserves the actual order
        #of elements in the vector that is its first argument in the return
        #value, so we can simplify this a bit.
        tmp <- setdiff(nm, varlist)
        ind <- which(tmp == varname)

        if(ind > 1)
        {
            pre <- tmp[seq.int(1, ind - 1)]
        } else
        {
            pre <- c()
        }

        if(ind < length(tmp))
        {
            post <- tmp[seq.int(ind + 1, length(tmp))]
        } else
        {
            post <- c()
        }

        nm <- c(pre, varlist, varname, post)
    } else if(after)
    {
        tmp <- setdiff(nm, varlist)
        ind <- which(tmp == varname)

        if(ind > 1)
        {
            pre <- tmp[seq.int(1, ind - 1)]
        } else
        {
            pre <- c()
        }

        if(ind < length(tmp))
        {
            post <- tmp[seq.int(ind + 1, length(tmp))]
        } else
        {
            post <- c()
        }

        nm <- c(pre, varname, varlist, post)
    }

    dt$setcolorder(nm)
    return(invisible(TRUE))
}

# =============================================================================

ado_cmd_compare <-
function(varlist, if_clause=NULL, in_clause=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    raiseifnot(length(varlist) == 2,
               msg="Incorrect number of arguments")

    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both if and in clause at once")

    dt <- get("ado_dta", envir=ado_env)

    if(!is.null(in_clause))
    {
        rn <- dt$in_clause_to_row_numbers(in_clause)
        rows <- seq.int(rn[1], rn[2])
    } else if(!is.null(if_clause))
    {
        rows <- dt$rows_where(if_clause)
    } else
    {
        rows <- seq.int(1, dt$dim[1])
    }

    v1 <- dt$iloc(rows, as.character(varlist[[1]]))
    v2 <- dt$iloc(rows, as.character(varlist[[2]]))

    ret <- list()

    #Always get the relative patterns of missings

    #If both are n
}

ado_cmd_duplicates <-
function(varlist, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    raiseifnot(length(varlist) >= 1,
               msg="Must specify subcommand")

    raiseif(!is.null(if_clause) && !is.null(in_clause),
            msg="Cannot specify both if clause and in clause at once")

    valid_opts <- c("generate", "force")
    option_list <- validateOpts(option_list, valid_opts)
    gen <- hasOption(option_list, "generate")
    fr <- hasOption(option_list, "force")

    dt <- get("ado_dta", envir=ado_env)

    if(length(varlist) == 1)
    {
        varlist <- dt$names
    } else
    {
        varlist <- varlist[2:length(varlist)]
    }

    if(!is.null(in_clause))
    {
        rn <- dt$in_clause_to_row_numbers(in_clause)
        rows <- seq.int(rn[1], rn[2])
    } else if(!is.null(if_clause))
    {
        rows <- dt$rows_where(if_clause)
    } else
    {
        rows <- seq.int(dt$dim[1], dt$dim[2])
    }

    subcommands <- c("tag", "report", "list", "examples", "drop")
    subcommand <- as.character(varlist[[1]])
    subcommand <- unabbreviateName(subcommand, subcommands, msg="Invalid subcommand")

    if(subcommand == "tag")
    {
        raiseifnot(gen, msg="The generate option is required")
        nm <- optionArgs(option_list, "generate")[[1]]


    } else if(subcommand == "report")
    {

    } else if(subcommand == "list")
    {

    } else if(subcommand == "examples")
    {

    } else if(subcommand == "drop")
    {

    } else
    {
        raiseCondition("Unrecognized subcommand")
    }
}

ado_cmd_append <-
function(expression_list=NULL, using_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_merge <-
function(varlist, using_clause, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_split <-
function(varlist, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("generate", "parse", "limit", "notrim",
                    "destring", "ignore", "force", "percent")
    option_list <- validateOpts(option_list, valid_opts)

}

ado_cmd_codebook <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL,
         option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_collapse <-
function(expression_list, if_clause=NULL, in_clause=NULL, weight_clause=NULL,
         option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_describe <-
function(expression_list=NULL, using_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_expand <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_recode <-
function(expression_list, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

#FIXME - need to revise grammar to allow e.g. "reshape long"
ado_cmd_reshape <-
function(expression_list=NULL, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_separate <-
function(expression, option_list, if_clause=NULL, in_clause=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

# =============================================================================

ado_cmd_recast <-
function(expression, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("force")
    option_list <- validateOpts(option_list, valid_opts)

}

rstata_cmd_egen <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

rstata_cmd_generate <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

# =============================================================================
ado_cmd_tostring <-
function(varlist, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_destring <-
function(varlist=NULL, option_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_decode <-
function(expression, if_clause=NULL, in_clause=NULL, option_list,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_egen <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_encode <-
function(expression, if_clause=NULL, in_clause=NULL, option_list,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_format <-
function(expression_list=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_replace <-
function(expression, if_clause=NULL, in_clause=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_generate <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_label <-
function(expression_list, using_clause=NULL, option_list=NULL,
         return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())
}

ado_cmd_flist <- ado_cmd_list

