rstata_cmd_append <-
function(using_clause, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_clear <-
function(expression=NULL, return.match.call=NULL)
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
function(expression_list, if_clause=NULL, in_clause=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_count <-
function(if_clause=NULL, in_clause=NULL, by_dta=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    
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

rstata_cmd_dir <-
function(expression=NULL, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_drop <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, by_dta=NULL,
         return.match.call=NULL)
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
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL, by_dta=NULL,
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

rstata_cmd_erase <-
function(expression, return.match.call=NULL)
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
         by_dta=NULL, return.match.call=NULL)
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
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL, by_dta=NULL,
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

rstata_cmd_insheet <-
function(using_clause, varlist=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
    
    valid_opts <- c("tab", "comma", "delimiter", "clear", "case", "names", "nonames")
    raiseifnot(validateOpts(option_list, valid_opts))
    
    raiseifnot(hasOption(option_list, "clear") || dataset_dim()[1] == 0,
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
    
    #actually read the thing in
    op <- bquote(rstata_dta <- utils::read.csv(.(filename), header=.(header),
                                               sep=.(delim)))
    eval(op, envir=rstata_env)
    
    if(!hasOption(option_list, "case"))
    {
        op <- quote(names(rstata_dta) <- tolower(names(rstata_dta)))
        eval(op, envir=rstata_env)
    }
    
    structure(dataset_dim(), class="rstata_dataset_dim")
}

rstata_cmd_isid <-
function(expression_list, using_clause=NULL, option_list=NULL, return.match.call=NULL)
{
    if(!is.null(return.match.call) && return.match.call)
        return(match.call())
}

rstata_cmd_keep <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, by_dta=NULL,
         return.match.call=NULL)
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

rstata_cmd_list <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, option_list=NULL,
         by_dta=NULL, return.match.call=NULL)
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

rstata_cmd_ls <-
function(expression, option_list=NULL, return.match.call=NULL)
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

rstata_cmd_mkdir <-
function(expression, option_list=NULL, return.match.call=NULL)
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

rstata_cmd_rm <-
function(expression, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_rmdir <-
function(expression, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_sample <-
function(expression, if_clause=NULL, in_clause=NULL, option_list=NULL, by_dta=NULL,
         return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_save <-
function(expression=NULL, option_list=NULL, return.match.call=NULL)
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

rstata_cmd_type <-
function(expression, option_list=NULL, return.match.call=NULL)
{
  if(!is.null(return.match.call) && return.match.call)
    return(match.call())
}

rstata_cmd_use <-
function(expression_list=NULL, if_clause=NULL, in_clause=NULL, using_clause=NULL,
         option_list=NULL, return.match.call=NULL)
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

