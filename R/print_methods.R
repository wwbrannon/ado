print.rstata_cmd_insheet <-
function(x)
{
    cat(paste0("(", x[2], " vars, ", x[1], " obs)"), "\n")
}
