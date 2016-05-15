#Define an R6 class to encapsulate low-level access to the dataset.
#Rather than making every command-implementing function use data.table
#or dplyr directly, this class takes care of the details.

Dataset <-
R6::R6Class("Dataset",
        public=list(
            initialize=function(...)
            {
                
            },
            
            #Set the dataset column names
            setnames=function(names)
            {
            },
            
            #Save the data we currently have loaded in either the new or
            #the old Stata formats
            save=function(path, replace=FALSE, emptyok=TRUE)
            {
            },
            saveold=function(path, replace=FALSE)
            {
            },
            
            #Drop the current dataset
            clear=function()
            {
            },
            
            #Methods to load in data from different sources
            use=function(path)
            {
            },
            use_dataframe=function(df)
            {
            },
            use_url=function(url)
            {
            },
            use_csv=function(filename, header=TRUE, sep=',')
            {
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
                
            }
        ),
        private=list(
        ),
        active=list(
            #Return a 2-element numeric vector of (nrows, ncols)
            dim=function()
            {
            },
            
            #Return the current dataset column names
            names=function()
            {
            },
            
            #The underlying data.table, coerced to a data.frame
            as_data_frame=function()
            {
            },
            
            #The current Stata dataset label
            data_label=function()
            {
            }
        )
)