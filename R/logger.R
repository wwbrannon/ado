## This class provides logging functionality (Stata's log and cmdlog commands).
## R's sink() doesn't quite do what we want - a) it doesn't let us distinguish
## between command and output result streams, but we want to handle these
## separately, and b) it can only have one sink at the top of the stack at any
## given time.

Logger <-
R6::R6Class("Logger",
    public=list(
        #currently a no-op
        initialize=function(...) {},

        has_sink=function(filename, type=NULL)
        {
            raiseifnot(is.null(type) || type %in% c("log", "cmdlog"),
                       msg="Invalid log type")

            pth <- normalizePath(filename)

            if(is.null(type))
            {
                return(pth %in% names(private$.logs) ||
                       pth %in% names(private$.cmdlogs))
            } else if(type == "log")
            {
                return(pth %in% names(private$.logs))
            } else
            {
                return(pth %in% names(private$.cmdlogs))
            }
        },

        sink_type=function(filename)
        {
            raiseifnot(self$has_sink(filename),
                       msg="No such logging sink")

            pth <- normalizePath(filename)

            if(pth %in% names(private$.logs))
            {
                return("log")
            } else
            {
                return("cmdlog")
            }
        },

        register_sink=function(filename, type="log", header=TRUE)
        {
            raiseif(type %not_in% c("log", "cmdlog"),
                    msg="Invalid logging type")

            raiseif(self$has_log(filename),
                    msg="Log already exists")

            pth <- normalizePath(filename)

            ret <-
            tryCatch(
                {
                    con <- file(pth, open="wb")
                },

                error=function(e) e
            )

            raiseif(inherits(ret, "error"),
                    msg="Could not open logging sink " %p% pth)

            if(type == "log")
            {
                private$.logs[[pth]] = con
            } else
            {
                private$.cmdlogs[[pth]] = con
            }

            if(header)
            {
                msg <- paste0(rep('-', 80), collapse="") %p% '\n'
                msg <- msg %p% ifelse(type == 'log', 'log: ', 'cmdlog: ')
                msg <- msg %p% pth %p% '\n'
                msg <- msg %p% 'log type: text\n' #SMCL isn't supported
                msg <- msg %p% 'opened on: ' %p% date() %p% '\n'
                msg <- msg %p% '\n'

                cat(msg, file=con, sep="")
            }

            return(invisible(NULL))
        },

        deregister_sink=function(filename)
        {
            type <- self$sink_type(filename)
            pth <- normalizePath(filename)

            if(type == "log")
            {
                close(private$.logs[[pth]])
                private$.logs[[pth]] <- NULL
            } else
            {
                close(private$.cmdlogs[[pth]])
                private$.cmdlogs[[pth]] <- NULL
            }

            return(invisible(NULL))
        },

        deregister_all_sinks=function(type=NULL)
        {
            raiseifnot(is.null(type) || type %in% c("log", "cmdlog"),
                       msg="Invalid log type")

            if(is.null(type))
            {
                for(con in names(private$.logs))
                {
                    self$deregister_sink(con)
                }

                for(con in names(private$.cmdlogs))
                {
                    self$deregister_sink(con)
                }
            }
            } else if(type == "log")
            {
                for(con in names(private$.logs))
                {
                    self$deregister_sink(con)
                }
            } else
            {
                for(con in names(private$.cmdlogs))
                {
                    self$deregister_sink(con)
                }
            }

            return(invisible(NULL))
        },

        log_command=function(msg)
        {
            if(settingIsSet("echo") &&
               getSettingValue("echo"))
            {
                cat(msg, sep="")
            }

            if(self$enabled)
            {
                for(con in private$.logs)
                {
                    cat(msg, file=con, sep="", append=TRUE)
                }

                for(con in private$.cmdlogs)
                {
                    cat(msg, file=con, sep="", append=TRUE)
                }
            }

            return(invisible(NULL))
        },

        log_result=function(msg)
        {
            if(settingIsSet("print_results") &&
               getSettingValue("print_results"))
            {
                cat(msg, sep="")
                cat("\n")
            }

            if(self$enabled)
            {
                for(con in private$.logs)
                {
                    cat(msg, file=con, sep="", append=TRUE)
                    cat("\n")
                }
            }

            return(invisible(NULL))
        }
    ),

    private = list(
        #The log and command log sink lists. These aren't stacks or queues;
        #really they're hash tables: we just need to be able to a) get a
        #connection given its name, and b) loop over all currently
        #registered connections.
        .logs = list(),
        .cmdlogs = list(),
        .use_log = TRUE,
        .use_cmdlog = TRUE
    ),

    active = list(
        log_sinks = function() names(private$.logs),
        cmdlog_sinks = function() names(private$.cmdlog_sinks),

        log_enabled = function(value)
        {
            if(missing(value))
            {
                return(private$.use_log)
            } else
            {
                private$.use_log <- as.logical(value)
            }
        },

        cmdlog_enabled = function(value)
        {
            if(missing(value))
            {
                return(private$.use_cmdlog)
            } else
            {
                private$.use_cmdlog <- as.logical(value)
            }
        }
    )
)
