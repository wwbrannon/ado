print.ado_cmd_insheet <-
function(x)
{
    cat(paste0("(", x[2], " vars, ", x[1], " obs)"), "\n")
}

print.ado_cmd_save <-
function(x)
{
    cat(paste0("file ", x, " saved"), "\n")
}

print.ado_cmd_use <-
function(x)
{
    cat(paste0("(", x, ")"), "\n")
}

print.ado_cmd_sysuse <-
function(x)
{
    NextMethod()
}

print.ado_cmd_about <-
function(x)
{
    NextMethod()
}

print.ado_cmd_display <-
function(x)
{
    if(length(x) == 0)
    {
        cat(" ")
    } else if(is.na(x))
    {
        cat(".")
    } else
    {
        cat(x)
    }
}

print.ado_cmd_creturn <-
function(x)
{
    cat("System Values: \n\n")
    
    for(nm in names(x))
    {
        cat("c(" %p% nm %p% "):    " %p% x[[nm]] %p% "\n")
    }
}

print.ado_cmd_return <-
function(x)
{
    cat("r()-class values: \n\n")
    
    for(nm in names(x))
    {
        cat("r(" %p% nm %p% "):    " %p% x[[nm]] %p% "\n")
    }
}

print.ado_cmd_ereturn <-
function(x)
{
    cat("e()-class values: \n\n")
    
    for(nm in names(x))
    {
        cat("e(" %p% nm %p% "):    " %p% x[[nm]] %p% "\n")
    }
}

print.ado_cmd_sample <-
function(x)
{
    cat("(" %p% as.character(x) %p% " observations deleted)")
}

print.ado_cmd_query <-
function(x)
{
    cat("Setting Values: \n\n")
    
    for(nm in names(x))
    {
        cat("set " %p% nm %p% ":    " %p% x[[nm]] %p% "\n")
    }
}
