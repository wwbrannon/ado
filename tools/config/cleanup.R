# Clean up files generated during configuration here.
# Use 'remove_file()' to remove files generated during configuration.

remove_pattern <-
function(path, pattern)
{
    lst <- list.files(path=path, pattern=pattern, full.names=TRUE,
                      recursive=TRUE)

    sapply(lst, remove_file)
}

remove_file("src/Makevars")
remove_file("src/Makevars.win")
remove_file("src/parser/build")

remove_pattern(path='src', pattern='\\.o$')
remove_pattern(path='src', pattern='\\.a$')
remove_pattern(path='src', pattern='\\.so$')
remove_pattern(path='src', pattern='\\~$')

