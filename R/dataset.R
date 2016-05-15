#Define an R6 class to encapsulate low-level access to the dataset.
#Rather than making every command-implementing function use data.table
#or dplyr directly, this class takes care of the details.

Dataset <-
R6::R6Class("Dataset",
    public=list(
        #No-op at the moment
        initialize=function(...) {},
        
        #Set the dataset column names
        setnames=function(names)
        {
            raiseifnot(length(names) == ncol(private$dt),
                       msg="Incorrect number of column names to setnames")
            
            setnames(private$dt, names)
        },
        
        #Save the data we currently have loaded in either the new or
        #the old Stata formats
        save=function(path, replace=FALSE, emptyok=TRUE)
        {
            if(!replace && file.exists(path))
                raiseCondition("Cannot save dataset; file exists")
            
            if(!emptyok && self$dim[1] == 0)
                raiseCondition("Cannot save; dataset is empty and emptyok not specified")
            
            readstata13::save.dta13(private$dt, path, data.label=self$data_label)
            
            return(invisible(TRUE))
        },
        saveold=function(path, replace=FALSE)
        {
            if(!replace && file.exists(path))
                raiseCondition("Cannot save dataset; file exists")
            
            readstata13::stata_pre13_save(private$dt, path)
            
            return(invisible(TRUE))
        },
        
        #Drop the current dataset
        clear=function()
        {
            private$dt <- NULL #the old table is garbage collected
        },
        
        #Methods to load in data from different sources
        use=function(path, ...)
        {
            self$clear()
            
            read_args <- list(...)
            read_args$file <- path
            
            df <- do.call(readstata13::read.dta13, read_args)
            attrs <- attributes(df)
            
            #This is duplicated from use_dataframe because calling that fn would
            #copy the data.frame. It could be one of R's not-quite-macros with
            #substitute, but it's tricky to fit that into the structure of this
            #class. Pass-by-reference semantics are nice sometimes...
            private$dt <- data.table::data.table(df)
            private$append_attributes(attrs)
            
            return(invisible(TRUE))
        },
        use_dataframe=function(df)
        {
            self$clear()
            
            attrs <- attributes(df)
            
            private$dt <- data.table::data.table(df)
            private$append_attributes(attrs)
            
            return(invisible(TRUE))
        },
        use_url=function(url)
        {
            return(self$use(url)) #read.dta13 handles URLs too
        },
        use_csv=function(filename, header=TRUE, sep=',', ...)
        {
            read_args <- list(...)
            read_args$header <- header
            
            #We need to figure out the separator if it wasn't given
            if(is.null(sep))
            {
                ext <- tools::file_ext(filename)
                
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
            
            #We've set delim or thrown an exception
            read_args$sep <- delim
            
            #Actually read in the data. There are no attributes worth
            #preserving on a read-in CSV.
            private <- data.table::data.table(do.call(read.csv, read_args))
    
            return(invisible(TRUE))
        }
    ),
    private = list(
        dt = data.table::data.table(), #a null data.table makes names and dim work
        append_attributes = function(attrs)
        {
            #read.dta13 creates a lot of attributes with information about the
            #original Stata file. We need to keep them, but the data.table ctor
            #strips them off. Because private$dt won't be copied and in the
            #process lose its attributes, it suffices to do this once when this
            #particular Stata dataset is loaded.
            
            to_set <- setdiff(names(attrs), names(attributes(private$dt)))
            to_set <- attrs[to_set]
            
            for(nm in names(to_set))
                attr(private$dt, nm) <- to_set[nm]
            
            return(invisible(TRUE))
        }
    ),
    active = list(
        #Return a 2-element numeric vector of (nrows, ncols)
        dim = function() base::dim(private$dt),
    
        #Return the current dataset column names
        names = function() base::names(private$dt),
        
        #May be changed in the future, but a data.table is a data.frame
        as_data_frame = function() private$dt,
    
        #The current Stata dataset label
        data_label=function() attr(private$dt, "datalabel")
    )
)