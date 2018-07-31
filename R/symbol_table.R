#FIXME error handling for symboltable

SymbolTable <-
R6::R6Class("SymbolTable",
    public = list(
        initialize = function()
        {
            private$env <- new.env(hash=TRUE, parent=emptyenv())
        },

        all_symbols = function()
        {
            return(ls(private$env))
        },

        all_values = function()
        {
            return(as.list(private$env))
        },

        symbol_defined = function(sym)
        {
            return(sym %in% self$all_symbols())
        },

        symbol_value = function(sym)
        {
            return(get(sym, envir=private$env))
        },

        set_symbol = function(sym, val)
        {
            assign(sym, val, envir=private$env)

            return(invisible(NULL))
        },

        unset_symbol = function(sym)
        {
            rm(sym, envir=private$env)

            return(invisible(NULL))
        },

        set_symbols_from_list = function(lst)
        {
            list2env(x=lst, envir=private$env)

            return(invisible(NULL))
        },

        symbol_values_from_list = function(lst)
        {
            if(is.list(lst))
            {
                good <- vapply(lst, function(x) is.character(x) || is.symbol(x),
                               logical(0))
                raiseifnot(all(good), msg="Bad symbol names")

                lst <- as.character(lst)
            }

            return(mget(lst, envir=private$env))
        }

    ),

    private = list(
        env = NULL
    )
)
