## This class provides logging functionality (Stata's log and cmdlog commands).
## R's sink() doesn't quite do what we want - a) it doesn't let us distinguish
## between command and output result streams, but we want to handle these
## separately, and b) it can only have one sink at the top of the stack at any
## given time.

#FIXME should normalize paths

Logger <-
R6::R6Class("Logger",
    public=list(
        #currently a no-op
        initialize=function(...) {},

        has_sink=function(filename, type=NULL)
        {
            raiseifnot(is.null(type) || type %in% c("log", "cmdlog"),
                       msg="Invalid log type")

            if(type == "log")
            {
                return(filename %in% names(private$.logs))
            } else if(type == "cmdlog")
            {
                return(filename %in% names(private$.logs))
            } else
            {
                return(filename %in% names(private$.logs) ||
                           filename %in% names(private$.cmdlogs))
            }
        },

        sink_type=function(filename)
        {
            raiseifnot(self$has_sink(filename),
                       msg="No such logging sink")

            if(filename %in% names(private$.logs))
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

            ret <-
            tryCatch(
                {
                    con <- file(filename, open="wb")
                },

                error=function(e) e
            )

            raiseif(inherits(ret, "error"),
                    msg="Could not open logging sink " %p% filename)

            if(type == "log")
            {
                private$.logs[[filename]] = con
            } else
            {
                private$.cmdlogs[[filename]] = con
            }

            if(header)
            {
                msg <- paste0(rep('-', 80), collapse="") %p% '\n'
                msg <- msg %p% ifelse(type == 'log', 'log: ', 'cmdlog: ')
                msg <- msg %p% filename %p% '\n'
                msg <- msg %p% 'log type: text\n' #SMCL isn't supported
                msg <- msg %p% 'opened on: ' %p% date() %p% '\n'
                msg <- msg %p% '\n'

                cat(msg, file=con, sep="")
            }

            return(invisible(NULL))
        },

        deregister_sink=function(filename)
        {
            raiseifnot(self$has_sink(filename),
                       msg="No such logging sink")

            type <- self$sink_type(filename)

            if(type == "log")
            {
                close(private$.logs[[filename]])
                private$.logs[[filename]] <- NULL
            } else
            {
                close(private$.cmdlogs[[filename]])
                private$.cmdlogs[[filename]] <- NULL
            }

            return(invisible(NULL))
        },

        deregister_all_sinks=function(type=NULL)
        {
            raiseifnot(is.null(type) || type %in% c("log", "cmdlog"),
                       msg="Invalid log type")

            if(type == "log")
            {
                for(con in names(private$.logs))
                {
                    self$deregister_sink(con)
                }
            } else if(type == "cmdlog")
            {
                for(con in names(private$.cmdlogs))
                {
                    self$deregister_sink(con)
                }
            } else
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

            return(invisible(NULL))
        }

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
