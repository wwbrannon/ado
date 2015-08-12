#the REPL loop and environment-handling logic for statashell

statashell <-
function(data)
{
    while(TRUE)
    {
      line <- readline(". ")

      #AFAIK this has to be hard-coded
      if( line == "exit" || line == "quit" )
        return(invisible(1));
      
      expr <- parse(textConnection(line))
      val <- eval(expr, parent.frame())      
      cat(val)
    }
}
