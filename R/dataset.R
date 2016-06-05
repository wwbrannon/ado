#Define an R6 class to encapsulate low-level access to the dataset.
#Rather than making every command-implementing function use data.table
#or dplyr directly, this class takes care of the details.

#FIXME - need to make sure column names are unique

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
            
            data.table::setnames(private$dt, names)
            
            private$.changed <- TRUE
            
            return(invisible(TRUE))
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
            
            private$.changed <- FALSE
            private$.filename <- path
            private$.filedate <- date()
            
            return(invisible(TRUE))
        },
        
        saveold=function(path, replace=FALSE)
        {
            if(!replace && file.exists(path))
                raiseCondition("Cannot save dataset; file exists")
            
            foreign::write.dta(private$dt, path)
            
            private$.changed <- FALSE
            private$.filename <- path
            private$.filedate <- date()
            
            return(invisible(TRUE))
        },
        
        #Drop the current dataset
        clear=function()
        {
            private$dt <- NULL #the old table is garbage-collected
            private$dt <- data.table::data.table()
            
            private$.changed <- NULL
            private$.filename <- NULL
            private$.filedate <- NULL
            
            return(invisible(NULL))
        },
        
        #Methods to load in data from different sources
        use=function(path, ...)
        {
            self$clear()
            
            read_args <- list(...)
            read_args$file <- path
            
            df <- tryCatch(do.call(readstata13::read.dta13, read_args),
                           message=function(c) c)
            if(inherits(df, "condition")) #something went wrong
            {
                #Re-raise this in a way our further-up layers will catch
                raiseCondition(df$message)
            }
            else
            {
                attrs <- attributes(df)
                
                #This is duplicated from use_dataframe because calling that fn would
                #copy the data.frame. It could be one of R's not-quite-macros with
                #substitute, but it's tricky to fit that into the structure of this
                #class. Pass-by-reference semantics are nice sometimes...
                private$dt <- data.table::data.table(df)
                private$append_attributes(attrs)
                
                private$.changed <- FALSE
                private$.filename <- NULL
                private$.filedate <- NULL
                
                return(invisible(TRUE))
            }
        },
        
        use_dataframe=function(df)
        {
            self$clear()
            
            attrs <- attributes(df)
            
            private$dt <- data.table::data.table(df)
            private$append_attributes(attrs)
            
            private$.changed <- FALSE
            private$.filename <- NULL
            private$.filedate <- NULL
            
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
            read_args$file <- filename
            
            #We need to figure out the separator if it wasn't given
            if(is.null(sep))
            {
                ext <- tools::file_ext(filename)
                #We have to guess the delimiter, which is only worth doing
                #because Stata does. First, let's check the extension.
                if(ext == "csv")
                {
                    delim <- ","
                } else if(ext %in% c("tsv", "txt"))
                {
                    delim <- "\t"
                }
                else
                {
                    #As a last resort, read in the first five lines and see if there's
                    #a character that appears the same number of times in all five lines.
                    rows <- readLines(filename, n=5, warn=FALSE)
                    cnt <- char_count(rows)
                    
                    nm <- Reduce(intersect, lapply(cnt, names))
                    if(length(nm) == 0)
                    {
                        raiseCondition("Cannot determine delimiter character",
                                       cls="EvalErrorException")
                    }
                    
                    cands <- vapply(nm, function(x)
                        {
                            length(unique(lapply(cnt, function(y) y[x])))
                        }, integer(1))
                    
                    if(length(which(cands == 1)) == 1)
                    {
                        delim <- names(cands)[which(cands == 1)]
                    } else
                    {
                        raiseCondition("Cannot determine delimiter character",
                                       cls="EvalErrorException")
                    }
                }
            }
            
            #We've set delim or thrown an exception
            read_args$sep <- delim
            
            #Actually read in the data. There are no attributes worth
            #preserving on a read-in CSV.
            private$dt <- data.table::data.table(do.call(read.csv, read_args))
    
            private$.changed <- FALSE
            private$.filename <- NULL
            private$.filedate <- NULL
            
            return(invisible(TRUE))
        },
        
        preserve = function(memory=FALSE)
        {
            #Default to preserving to disk
            if(memory)
            {
                private$preserve_cpy <- copy(private$dt)
            } else
            {
                private$preserve_file <- tempfile()
                dput(private$dt, file=private$preserve_file)
            }
            
            return(invisible(TRUE))
        },
        
        restore = function(cancel=FALSE)
        {
            if(cancel)
            {
                if(!is.null(private$preserve_cpy))
                {
                    #The garbage collector destroys the object
                    private$preserve_cpy <- NULL
                } else if(!is.null(private$preserve_file))
                {
                    unlink(private$preserve_file)
                    private$preserve_file <- NULL
                } else
                {
                    raiseCondition("Cannot cancel preserve: no preserve set up")
                }
            } else
            {
                if(!is.null(private$preserve_cpy))
                {
                    #The garbage collector will tear down both dt and preserve_cpy
                    #once we set the refs to NULL, which frees up memory
                    
                    private$dt <- NULL
                    private$dt <- private$preserve_cpy
                    
                    private$preserve_cpy <- NULL
                } else if(!is.null(private$preserve_file))
                {
                    #Load the serialized object back in
                    private$dt <- NULL
                    private$dt <- dget(private$preserve_file)
                    
                    #Unlink the copy on disk to free up space
                    unlink(private$preserve_file)
                    private$preserve_file <- NULL
                } else
                {
                    raiseCondition("Cannot restore: no preserve set up")
                }
            }
        },
        
        drop_columns = function(cols)
        {
            for(col in cols)
            {
                if(col %not_in% names(private$dt))
                {
                    raiseCondition("Column does not exist")
                }
                
                col <- as.symbol(col)
                private$dt[, eval(col) := NULL]
            }
            
            private$.changed <- TRUE
            return(invisible(TRUE))
        },
        
        head = function(n=5)
        {
            return(utils::head(private$dt, n))
        },
        
        iloc = function(row_indexer, col_indexer)
        {
            return(private$dt[row_indexer, col_indexer, with=FALSE])
        },
        
        subset = function(subset, select, ...)
        {
            args <- c(x=private$dt, subset=subset, select=select, list(...))
            return(do.call(subset, args))
        },
        
        in_clause_to_row_numbers = function(in_clause)
        {
            #Update bounds if they're given as f/F or l/L, and translate
            #negative row numbers to positive ones
            for(n in names(in_clause))
            {
                if(in_clause[[n]] == as.symbol("f") || in_clause[[n]] == as.symbol("F"))
                {
                    in_clause[[n]] <- 1
                }
                
                if(in_clause[[n]] == as.symbol("l") || in_clause[[n]] == as.symbol("L"))
                {
                    in_clause[[n]] <- self$dim[1]
                }
                
                #Handle negative bounds: -n becomes (n-1) rows before the end of the
                #dataset. If self$dim[1] == 100, -1 => 100 + 1 -1 == 100, the last
                #indexable row.
                if(in_clause[[n]] < 0)
                {
                    in_clause[[n]] <- self$dim[1] + 1 + in_clause[[n]]
                }
            }
            
            #Raise if the bounds are bad
            raiseifnot(in_clause$lower <= in_clause$upper,
                       msg="In clause: start row occurs after end row")
            raiseifnot(in_clause$upper <= self$dim[1],
                       msg="In clause: end row exceeds dataset length")
            raiseifnot(in_clause$lower >= 1,
                       msg="In clause: start row too low")
            
            return(c(in_clause$lower, in_clause$upper))
        },
        
        setcolorder = function(cols)
        {
            setcolorder(private$dt, cols)
        },
        
        drop_rows = function(rows)
        {
            #FIXME
            
            private$.changed <- TRUE
            return(invisible(TRUE))
        },
        
        rows_where = function(expr)
        {
            #FIXME
        },
        
        sort = function(cols, rows=NULL, asc=replicate(length(cols), TRUE),
                        row_number=NULL, na.last=TRUE, stable=FALSE)
        {
            #FIXME
            
            private$.changed <- TRUE
            return(invisible(TRUE))
        }
    ),
    private = list(
        dt = data.table::data.table(), #a null data.table makes names and dim work
        preserve_cpy = NULL,
        preserve_file = NULL,
        
        .changed = NULL,
        .filename = NULL,
        .filedate = NULL,
        
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
                attr(private$dt, nm) <- to_set[[nm]]
            
            return(invisible(TRUE))
        }
    ),
    active = list(
        #Return a 2-element numeric vector of (nrows, ncols)
        dim = function() base::dim(private$dt),
        
        nrow = function() base::nrow(private$dt),
        ncol = function() base::ncol(private$dt),
    
        #Return the current dataset column names
        names = function() base::names(private$dt),
        
        #May be changed in the future, but a data.table is a data.frame
        as_data_frame = function() private$dt,
    
        #The current Stata dataset label
        data_label = function() attr(private$dt, "datalabel"),
        
        #Has the dataset been modified since it was loaded?
        changed = function() private$.changed, #FIXME - preserve/restore?
        
        #What filename did we last save to?
        filename = function() private$.filename,
        
        #When did we last save?
        filedate = function() private$.filedate,
        
        #Column data types
        dtypes = function() vapply(private$dt, function(x)
        {
            if(is.factor(x))
            {
                return("factor")
            } else
            {
                return(mode(x))
            }
        }, character(1))
    )
)
