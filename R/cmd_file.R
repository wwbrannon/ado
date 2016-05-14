rstata_cmd_cd <-
function(expression=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    if(is.null(expression))
        return(rstata_cmd_pwd(return.match.call=return.match.call))
    else
    {
        raiseifnot(length(expression) == 1, msg="Too many arguments to cd/chdir")
        
        setwd(expression[[1]])
        return(cat(expression[[1]]))
    }
}

rstata_cmd_pwd <-
function(return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    return(cat(getwd()))
}

rstata_cmd_rm <-
function(expression, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    raiseifnot(length(expression) == 1, msg="Too many arguments to rm/erase")
    
    file.remove(expression[[1]])
    
    return(invisible(NULL))
}

rstata_cmd_mkdir <-
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

rstata_cmd_ls <-
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
        return(system("ls -F -C " %p% fspec))
    else
        return(system("ls -F -l " %p% fspec))
}

rstata_cmd_cp <-
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
        if(file_test("-d", expression_list[[2]]))
            Sys.chmod(expression_list[[2]], mode="0755")
        else
            Sys.chmod(expression_list[[2]], mode="0644")
    }
    
    return(invisible(NULL))
}

rstata_cmd_cat <-
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

    return(cat(Reduce(paste0, lines)))
}

rstata_cmd_insheet <-
function(using_clause, varlist=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    dt <- get("rstata_dta", envir=rstata_env)
    
    #validate the options given against the valid list, raising a condition if
    #they fail to validate, and return the unabbreviated options
    valid_opts <- c("tab", "comma", "delimiter", "clear", "case", "names", "nonames")
    option_list <- validateOpts(option_list, valid_opts)
    
    raiseifnot(hasOption(option_list, "clear") || dt$dim[1] == 0,
               msg="No; data in memory would be lost")
    
    if(hasOption(option_list, "nonames"))
        header <- FALSE
    else
        header <- TRUE
    
    #not for the first time, this is questionable behavior we're implementing
    #because Stata does it
    ext <- tools::file_ext(using_clause)
    if(ext == "")
        filename <- paste0(using_clause, ".raw")
    else
        filename <- using_clause
    
    if(hasOption(option_list, "comma"))
        delim <- ","
    else if(hasOption(option_list, "tab"))
        delim <- "\t"
    else if(hasOption(option_list, "delimiter"))
    {
        args <- optionArgs(option_list, "delimiter")
        raiseifnot(length(args) == 1, msg="Too many delimiters")
        raiseifnot(nchar(args[[1]]) == 1, msg="Bad delimiter")
        
        delim <- args[[1]]
    } else
    {
        #We have to guess the delimiter, which is only worth doing
        #because Stata does. First, let's check the extension.
        if(ext == "csv")
            delim <- ","
        if(ext %in% c("tsv", "txt"))
            delim <- "\t"
        else
        {
            #As a last resort, read in the first five lines and see if there's
            #a character that appears the same number of times in all three lines.
            con = file(filename, "r")
            cnt <- char_count(readLines(con, n=5, warn=FALSE))
            
            nm <- Reduce(intersect, lapply(cnt, names))
            if(length(nm) == 0)
                raiseCondition("Cannot determine delimiter character",
                               cls="EvalErrorException")
            cands <-
                vapply(nm, function(x)
                {
                    length(unique(lapply(cnt, function(y) y[x])))
                }, integer(1))
            
            if(length(which(cands == 1)) == 1)
                delim <- names(cands)[which(cands == 1)]
            else
                raiseCondition("Cannot determine delimiter character",
                               cls="EvalErrorException")
            
            close(con)
        }
    }
    
    #Actually read the thing in
    dt$read_csv(filename=filename, header=header, sep=delim)
    
    if(!hasOption(option_list, "case"))
        dt$names <- tolower(dt$names)
    
    #As is common in return values from these command functions,
    #this is an S3 class so it can pretty-print
    structure(dt$dim(), class="rstata_cmd_insheet")
}

rstata_cmd_use <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, using_clause=NULL,
         option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_save <-
function(expression=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    valid_opts <- c("")
}

rstata_cmd_saveold <-
function(expression=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}


### Aliases for other commands
rstata_cmd_chdir <- rstata_cmd_cd
rstata_cmd_copy  <- rstata_cmd_cp
rstata_cmd_dir   <- rstata_cmd_ls
rstata_cmd_erase <- rstata_cmd_rm
rstata_cmd_rmdir <- rstata_cmd_rm
rstata_cmd_type  <- rstata_cmd_cat