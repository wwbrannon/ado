print.rstata_cmd_insheet <-
function(x)
{
    cat(paste0("(", x[2], " vars, ", x[1], " obs)"), "\n")
}

print.rstata_cmd_save <-
function(x)
{
    cat(paste0("file ", x, " saved"), "\n")
}

print.rstata_cmd_use <-
function(x)
{
    cat(paste0("(", x, ")"), "\n")
}

print.rstata_cmd_sysuse <-
function(x)
{
    NextMethod()
}

print.rstata_cmd_about <-
function(x)
{
    NextMethod()
}

print.rstata_cmd_display <-
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

print.rstata_cmd_creturn <-
function(x)
{
    cat("System Values: \n\n")
    
    for(nm in names(x))
    {
        cat("c(" %p% nm %p% "):    " %p% x[[nm]] %p% "\n")
    }
}
