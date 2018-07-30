ado_cmd_cd <-
function(expression=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    if(is.null(expression))
        return(ado_cmd_pwd(return.match.call=return.match.call))
    else
    {
        raiseifnot(length(expression) == 1, msg="Too many arguments to cd/chdir")

        setwd(expression[[1]])
        return(cat(expression[[1]]))
    }
}

ado_cmd_pwd <-
function(return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    return(cat(getwd()))
}

ado_cmd_rm <-
function(expression, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    raiseifnot(length(expression) == 1, msg="Too many arguments to rm/erase")

    file.remove(expression[[1]])

    return(invisible(NULL))
}

ado_cmd_mkdir <-
function(expression, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    valid_opts <- c("public")
    option_list <- validateOpts(option_list, valid_opts)

    raiseifnot(length(expression) == 1, msg="Too many arguments to mkdir")

    if(hasOption(option_list, "public"))
        dir.create(expression[[1]], mode="0755")
    else
        dir.create(expression[[1]])

    return(invisible(NULL))
}

ado_cmd_ls <-
function(expression=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    valid_opts <- c("wide")
    option_list <- validateOpts(option_list, valid_opts)

    if(is.null(expression))
        fspec <- ""
    else
        fspec <- expression[[1]]

    if(hasOption(option_list, "wide"))
        return(system("ls -F -C " %p% fspec, intern=TRUE))
    else
        return(system("ls -F -l " %p% fspec, intern=TRUE))
}

ado_cmd_cp <-
function(expression_list=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    valid_opts <- c("public", "replace", "recursive")
    option_list <- validateOpts(option_list, valid_opts)

    raiseifnot(length(expression_list) == 2,
               msg="Need one source file and one destination file for cp/copy")

    if(hasOption(option_list, "replace"))
        overwrite <- TRUE
    else
        overwrite <- FALSE

    if(hasOption(option_list, "recursive"))
        recursive <- TRUE
    else
        recursive <- FALSE

    #Actually do the copy
    file.copy(from=expression_list[[1]], to=expression_list[[2]],
              overwrite=overwrite, recursive=recursive)

    #Update destination permissions if requested
    if(hasOption(option_list, "public"))
    {
        if(utils::file_test("-d", expression_list[[2]]))
            Sys.chmod(expression_list[[2]], mode="0755")
        else
            Sys.chmod(expression_list[[2]], mode="0644")
    }

    return(invisible(NULL))
}

ado_cmd_cat <-
function(expression, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())

    valid_opts <- c("showtabs", "starbang", "lines")
    option_list <- validateOpts(option_list, valid_opts)

    raiseifnot(length(expression) == 1, msg="Too many arguments to cat/type")

    #Read in the file - it's your own fault if you specify a file
    #that's too big to handle
    lines <- readLines(expression[[1]])

    #Check this first to avoid processing showtabs/starbang requests
    #for lines we're not going to print
    if(hasOption(option_list, "lines"))
    {
        n <- optionArgs(option_list, "lines")
        lines <- lines[seq_len(n)]
    }

    if(hasOption(option_list, "showtabs"))
        lines <- lapply(lines, function(x) gsub('\t', '<T>', x, fixed=TRUE))

    if(hasOption(option_list, "starbang"))
        lines <- Filter(function(x) substring(x, 0, 2) == "*!", lines)

    return(cat(Reduce(function(x, y) paste0(x, y, collapse='\n'), lines)))
}

### Aliases for other commands
ado_cmd_chdir <- ado_cmd_cd
ado_cmd_copy  <- ado_cmd_cp
ado_cmd_dir   <- ado_cmd_ls
ado_cmd_erase <- ado_cmd_rm
ado_cmd_rmdir <- ado_cmd_rm
ado_cmd_type  <- ado_cmd_cat
