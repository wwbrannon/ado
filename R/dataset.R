#Define an R6 class to encapsulate low-level access to the dataset.
#Rather than making every command-implementing function use data.table
#or dplyr directly, this class takes care of the details.
Dataset <-
R6Class("Dataset",
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
            }
        )
)
