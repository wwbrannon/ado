ado_cmd_insheet <-
function(using_clause, varlist=NULL, option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #validate the options given against the valid list, raising a condition if
    #they fail to validate, and return the unabbreviated options
    valid_opts <- c("tab", "comma", "delimiter", "clear", "case", "names", "nonames")
    option_list <- validateOpts(option_list, valid_opts)

    raiseifnot(hasOption(option_list, "clear") || context$dta$dim[1] == 0,
               msg="No; data in memory would be lost")

    header <- hasOption(option_list, "nonames")

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
        a <- optionArgs(option_list, "delimiter")
        raiseifnot(length(a) == 1, msg="Too many delimiters")
        raiseifnot(nchar(a[[1]]) == 1, msg="Bad delimiter")

        delim <- a[[1]]
    } else
        delim <- NULL

    #Actually read the thing in
    context$dta$use_csv(filename=filename, header=header, sep=delim)

    if(!hasOption(option_list, "case"))
        context$dta$setnames(tolower(context$dta$names))

    if(!is.null(varlist))
        context$dta$drop_columns(varlist)

    #As is common in return values from these command functions,
    #this is an S3 class so it can pretty-print
    return(structure(context$dta$dim, class="ado_cmd_insheet"))
}

ado_cmd_save <-
function(expression=NULL, option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #Handle options
    valid_opts <- c("replace", "emptyok")
    option_list <- validateOpts(option_list, valid_opts)
    repl <- hasOption(option_list, "replace")
    emptyok <- hasOption(option_list, "emptyok")

    #Handle the path we got or perhaps didn't get
    if(is.null(expression))
    {
        pth <- ado_func_c("filename")
    } else
    {
        raiseifnot(length(expression) == 1, msg="Too many filenames given to save")
        pth <- expression[[1]]

        #If the path we've been given doesn't have an extension in the sense of
        #tools::file_ext, append ".dta"
        if(tools::file_ext(pth) == "")
            pth <- pth %p% ".dta"
    }

    context$dta$save(pth, replace=repl, emptyok=emptyok)

    return(structure(pth, class="ado_cmd_save"))
}

ado_cmd_saveold <-
function(expression=NULL, option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    #Handle options
    valid_opts <- c("replace")
    option_list <- validateOpts(option_list, valid_opts)
    repl <- hasOption(option_list, "replace")

    #Handle the path we got or perhaps didn't get
    if(is.null(expression))
        pth <- ado_func_c("filename")
    else
    {
        raiseifnot(length(expression) == 1, msg="Too many filenames given to save")
        pth <- expression[[1]]

        #If the path we've been given doesn't have an extension in the sense of
        #tools::file_ext, append ".dta"
        if(tools::file_ext(pth) == "")
            pth <- pth %p% ".dta"
    }

    context$dta$saveold(pth, replace=repl)

    return(structure(pth, class="ado_cmd_save"))
}

ado_cmd_use <-
function(expression, option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("clear")
    option_list <- validateOpts(option_list, valid_opts)

    raiseifnot(hasOption(option_list, "clear") || context$dta$dim[1] == 0,
               msg="No; data in memory would be lost")

    #We only support the load-the-whole-dataset form of this command,
    #because the underlying dta-reading packages don't provide Stata's
    #ability to filter the file as it's read in
    pth <- expression[[1]]

    #If the path we've been given doesn't have an extension in the sense of
    #tools::file_ext, append ".dta"
    if(tools::file_ext(pth) == "")
        pth <- pth %p% ".dta"

    #Load the dataset
    context$dta$use(pth)

    if(length(context$dta$data_label) == 0 || context$dta$data_label == "")
        return(structure("Data loaded", class="ado_cmd_use"))
    else
        return(structure(context$dta$data_label, class="ado_cmd_use"))
}

#This is a bit different from the Stata version of sysuse:
#    o) The datasets are different; these are the R datasets package's datasets
#    o) The argument isn't a filename, it's a string coercible to a symbol
#       exported from the datasets pacakge
#    o) correspondingly there is no logic about a ".dta" extension
ado_cmd_sysuse <-
function(expression, option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("clear")
    option_list <- validateOpts(option_list, valid_opts)

    if(is.symbol(expression[[1]]))
    {
        raiseifnot(as.character(expression[[1]]) == "dir",
                   msg="Unrecognized subcommand to sysuse")

        datasets <- ls(as.environment("package:datasets"))
        return(structure(datasets, class="ado_cmd_sysuse"))
    }
    else
    {
        raiseifnot(hasOption(option_list, "clear") || context$dta$dim[1] == 0,
                   msg="No; data in memory would be lost")

        df <- get(expression[[1]], envir=as.environment("package:datasets"))
        context$dta$use_dataframe(df)

        if(length(context$dta$data_label) == 0 || context$dta$data_label == "")
            return(structure("Data loaded", class="ado_cmd_use"))
        else
            return(structure(context$dta$data_label, class="ado_cmd_use"))
    }
}

ado_cmd_webuse <-
function(expression_list, option_list=NULL, context=NULL, return.match.call=FALSE)
{
    if(return.match.call)
        return(match.call())

    valid_opts <- c("clear")
    option_list <- validateOpts(option_list, valid_opts)

    default_url <- ado_func_c("default_webuse_url")
    webuse_url <- context$setting_value("webuse_url")

    raiseifnot(hasOption(option_list, "clear") || context$dta$dim[1] == 0,
               msg="No; data in memory would be lost")

    if(is.symbol(expression_list[[1]]))
    {
        if(as.character(expression_list[[1]]) == "query")
        {
            return(cat(webuse_url))
        }
        else if(as.character(expression_list[[1]]) == "set")
        {
            if(length(expression_list) == 1)
                context$setting_set("webuse_url", default_url)
            else if(length(expression_list) == 2)
                context$setting_set("webuse_url", as.character(expression_list[[2]]))
            else
                raiseCondition("Incorrect use of webuse set: too many arguments")

            return(invisible(NULL))
        }
        else
            raiseCondition("Unrecognized subcommand to webuse")
    }
    else
    {
        raiseifnot(length(expression_list) == 1, msg="Too many arguments to webuse")

        #Put together the actual URL we should fetch from
        pth <- expression_list[[1]]
        if(tools::file_ext(pth) == "")
            pth <- pth %p% ".dta"

        url_base <- context$setting_value("webuse_url")
        url <- url_base %p% pth

        #Pass off fetching and loading to the Dataset object (and specifically
        #data.table's fread() method)
        context$dta$use_url(url)

        if(length(context$dta$data_label) == 0 || context$dta$data_label == "")
            return(structure("Data loaded", class="ado_cmd_use"))
        else
            return(structure(context$dta$data_label, class="ado_cmd_use"))
    }
}
