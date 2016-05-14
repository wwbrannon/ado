#Define an R6 class to encapsulate low-level access to the dataset.
#Rather than making every command-implementing function use data.table
#or dplyr directly, this class takes care of the details.

#setnames
#names
#read_dta
#save
#saveold
#clear
#data_label
#use
#use_dataframe
#use_url

Dataset <-
R6::R6Class("Dataset",
        public=list(
            initialize=function(...)
            {
            },
            read_csv=function(filename, header=TRUE, sep=',')
            {
            }
        ),
        private=list(
            
        ),
        active=list(
            dim=function()
            {
            },
            names=function()
            {
            },
            underlying=function()
            {
            }
        )
)

# {
#     #We have to guess the delimiter, which is only worth doing
#     #because Stata does. First, let's check the extension.
#     if(ext == "csv")
#         delim <- ","
#     if(ext %in% c("tsv", "txt"))
#         delim <- "\t"
#     else
#     {
#         #As a last resort, read in the first five lines and see if there's
#         #a character that appears the same number of times in all three lines.
#         con = file(filename, "r")
#         cnt <- char_count(readLines(con, n=5, warn=FALSE))
#         
#         nm <- Reduce(intersect, lapply(cnt, names))
#         if(length(nm) == 0)
#             raiseCondition("Cannot determine delimiter character",
#                            cls="EvalErrorException")
#         cands <-
#             vapply(nm, function(x)
#             {
#                 length(unique(lapply(cnt, function(y) y[x])))
#             }, integer(1))
#         
#         if(length(which(cands == 1)) == 1)
#             delim <- names(cands)[which(cands == 1)]
#         else
#             raiseCondition("Cannot determine delimiter character",
#                            cls="EvalErrorException")
#         
#         close(con)
#     }
# }
