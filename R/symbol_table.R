SymbolTable <-
R6::R6Class("SymbolTable",
    public = list(
        env = NULL,

        initialize = function(parent=emptyenv())
        {
            self$env <- new.env(hash=TRUE, parent=parent)
        },

        ##
        ## Getters
        ##

        all_symbols = function()
        {
            ret <- tryCatch(ls(self$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(ret)
        },

        all_values = function()
        {
            ret <- tryCatch(as.list(self$env), error=identity)

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
            ret <- tryCatch(get(sym, envir=self$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(ret)
        },

        ##
        ## Setters
        ##

        set_symbol = function(sym, val)
        {
            ret <- tryCatch(assign(sym, val, envir=self$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(invisible(ret))
        },

        unset_symbol = function(sym)
        {
            ret <- tryCatch(rm(sym, envir=self$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(invisible(ret))
        },

        set_symbols_from_list = function(lst)
        {
            ret <- tryCatch(list2env(x=lst, envir=self$env), error=identity)

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

            ret <- tryCatch(mget(lst, envir=self$env), error=identity)

            if(inherits(ret, "error"))
                raiseCondition("Error in symbol table access")
            else
                return(ret)
        }
    )
)
