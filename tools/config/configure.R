if(!('Rcpp' %in% rownames(installed.packages())))
    stop("Your installation does not have Rcpp installed; aborting")

Rcpp:::compilerCheck(minVersion="4.6.0")

define(STDVER = "c++11")

define(CXX = read_r_config("CXX")$CXX)
define(MAKE = read_r_config("MAKE")$MAKE)

cxxflags <- c(read_r_config("CXXFLAGS")$CXXFLAGS,
              capture.output(Rcpp:::CxxFlags()))

cppflags <- c(read_r_config("CPPFLAGS")$CPPFLAGS,
              paste0('-I', Sys.getenv("R_INCLUDE_DIR", unset="")))

define(CPPFLAGS = paste0(cppflags, collapse=' '))
define(CXXFLAGS = paste0(cxxflags, collapse=' '))
define(CXXPICFLAGS = read_r_config("CXXPICFLAGS")$CXXPICFLAGS)

configure_file("src/Makevars.in", "src/Makevars")
configure_file("src/Makevars.in", "src/Makevars.win")
configure_file("src/parser/Makefile.in", "src/parser/Makefile")
