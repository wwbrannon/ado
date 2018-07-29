if(!('Rcpp' %in% rownames(installed.packages())))
    stop("Your installation does not have Rcpp installed; aborting")

Rcpp:::compilerCheck(minVersion="4.6.0") # FIXME?

define(STDVER = "CXX11")

cxxflags <- c(read_r_config("CXXFLAGS")$CXXFLAGS,
              read_r_config("CXXPICFLAGS")$CXXPICFLAGS,
              capture.output(Rcpp:::CxxFlags()))

cppflags <- c(read_r_config("CPPFLAGS")$CPPFLAGS,
              paste0('-I', Sys.getenv("R_INCLUDE_DIR", unset="")))

define(CPPFLAGS = paste0(cppflags, collapse=' '))
define(CXXFLAGS = paste0(cxxflags, collapse=' '))

configure_file("src/Makevars.in", "src/Makevars")
configure_file("src/Makevars.in", "src/Makevars.win")
configure_file("src/parser/Makefile.in", "src/parser/Makefile")
