AC_PREREQ(2.50)

AC_INIT(ado, 0.1.0.9000)

AC_LANG(C++)
AC_REQUIRE_CPP

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

AC_DEFUN(AC_PROG_R, [AC_CHECK_PROG(R,R,yes)])
AC_PROG_R

: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
    AC_MSG_ERROR([Could not determine R_HOME.])   
fi
CXX=`${R_HOME}/bin/R CMD config CXX`
CXXFLAGS=`"${R_HOME}/bin/R" CMD config CXXFLAGS`

AC_SUBST(CXXFLAGS)
AC_SUBST(LDFLAGS)
AC_OUTPUT(src/Makevars)
echo "Completed configuration and ready to build."

