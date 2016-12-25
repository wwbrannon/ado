## Preliminaries
AC_PREREQ(2.50)

AC_INIT(ado, 0.1.0.9000)

AC_LANG(C++)
AC_REQUIRE_CPP

## Make sure we have a minimum G++ version
AC_PROG_CXX
if test "${GXX}" = yes; then
    gxx_version=`${CXX} -v 2>&1 | grep "^.*g.. version" | \\
               sed -e 's/^.*g.. version *//'`
    case ${gxx_version} in
    1.*|2.*|3.0)
         AC_MSG_WARN([Only g++ >= 4.0 is usable with ado.])
         AC_MSG_ERROR([Please use a newer compiler.])   
    ;;
    esac
fi

## Make sure we have R and find R_HOME
AC_DEFUN(AC_PROG_R, [AC_CHECK_PROG(R,R,yes)])
AC_PROG_R

: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
    AC_MSG_ERROR([Could not determine R_HOME.])   
fi

## Set the default versions of toolchain variables
CXX1X=`${R_HOME}/bin/R CMD config CXX1X`
CXX1XSTD=`${R_HOME}/bin/R CMD config CXX1XSTD`
CXX1XPICFLAGS=`${R_HOME}/bin/R CMD config CXX1XPICFLAGS`
CXX1XFLAGS=`"${R_HOME}/bin/R" CMD config CXX1XFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`
MAKE=`"${R_HOME}/bin/R" CMD config MAKE`

## Append the R and Rcpp include directories
AC_DEFUN(AC_PROG_RSCRIPT, [AC_CHECK_PROG(RSCRIPT,Rscript,yes)])
AC_PROG_RSCRIPT
if test x"${RSCRIPT}" == x"yes" ; then
     r_include=`${R_HOME}/bin/Rscript -e 'cat(Sys.getenv("R_INCLUDE_DIR"))'`
     AC_SUBST([CPPFLAGS],["${CPPFLAGS} -I$r_include"])
     
     rcpp_cxxflags=`${R_HOME}/bin/Rscript -e 'Rcpp:::CxxFlags()'`
     AC_SUBST([CXX1XFLAGS],["${CXX1XFLAGS} $rcpp_cxxflags"])
else
    echo "
  Your installation does not appear to have Rscript installed.

  Please make sure that you have a working and complete R installation.
"
    exit 1
fi

## Set output variables and build makefiles
AC_SUBST(R_HOME)
AC_SUBST(MAKE)
AC_SUBST(CPPFLAGS)
AC_SUBST(CXX1X)
AC_SUBST(CXX1XSTD)
AC_SUBST(CXX1XFLAGS)
AC_SUBST(CXX1XPICFLAGS)

AC_OUTPUT(src/Makevars)
AC_OUTPUT(src/parser/Makefile)

echo "Completed configuration and ready to build."

