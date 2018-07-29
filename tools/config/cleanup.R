# Clean up files generated during configuration here.
# Use 'remove_file()' to remove files generated during configuration.

remove_file("src/Makevars")
remove_file("src/Makevars.win")
remove_file("src/parser/build")

sapply(list.files(path='src/', pattern='\\.o$', recursive=TRUE), remove_file)
sapply(list.files(path='src/', pattern='\\.a$', recursive=TRUE), remove_file)
sapply(list.files(path='src/', pattern='\\.so$', recursive=TRUE), remove_file)
sapply(list.files(path='src/', pattern='\\~$', recursive=TRUE), remove_file)

