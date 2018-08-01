SymbolTable <-
R6::R6Class("SymbolTable",
    public = list(
        initialize = function()
        {
            private$env <- new.env(hash=TRUE, parent=emptyenv())
        },

        all_symbols = function()
        {
            ret <- tryCatch(ls(private$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(ret)
        },

        all_values = function()
        {
            ret <- tryCatch(as.list(private$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(ret)
        },

        symbol_defined = function(sym)
        {
            ret <- tryCatch(sym %in% self$all_symbols(), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(ret)
        },

        symbol_value = function(sym)
        {
            ret <- tryCatch(get(sym, envir=private$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(ret)
        },

        set_symbol = function(sym, val)
        {
            ret <- tryCatch(assign(sym, val, envir=private$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(invisible(ret))
        },

        unset_symbol = function(sym)
        {
            ret <- tryCatch(rm(sym, envir=private$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(invisible(ret))
        },

        set_symbols_from_list = function(lst)
        {
            ret <- tryCatch(list2env(x=lst, envir=private$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(invisible(ret))
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

            ret <- tryCatch(mget(lst, envir=private$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(ret)
        }

    ),

    private = list(
        env = NULL
    )
)

