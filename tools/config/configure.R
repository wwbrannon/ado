options(configure.auto = FALSE)

cxxflags <- c(read_r_config("CXXFLAGS")$CXXFLAGS,
              read_r_config("CXXPICFLAGS")$CXXPICFLAGS,
              capture.output(Rcpp:::CxxFlags()))

cppflags <- c(read_r_config("CPPFLAGS")$CPPFLAGS,
              paste0('-I', Sys.getenv("R_INCLUDE_DIR", unset="")))

define(STDVER = "CXX11")
define(CPPFLAGS = paste0(cppflags, collapse=' '))
define(CXXFLAGS = paste0(cxxflags, collapse=' '))

switch(.Platform$OS.type,
       unix = configure_file("src/Makevars.in", "src/Makevars"),
       windows = configure_file("src/Makevars.in", "src/Makevars.win"))
