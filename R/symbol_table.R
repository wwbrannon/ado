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
            return(sym %in% private$all_symbols())
        },

        symbol_value = function(sym)
        {
            return(get(sym, envir=private$env))
        },

        set_symbol = function(sym, val)
        {
            assign(sym, val, envir=private$env)
        },

        set_symbols_from_list = function(lst)
        {
            list2env(x=lst, envir=private$env)
        }
    ),

    private = list(
        env = NULL
    )
)
