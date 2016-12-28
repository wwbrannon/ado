#include <Rcpp.h>

// The idea here is from Winston Chang.
// See https://gist.github.com/wch/3280369#file-unlockenvironment-r

// These macros are taken from R 3.3's main/envir.c. They're very stable over
// time, so there shouldn't be much risk of breakage in R-devel.
// See https://github.com/wch/r-source/blob/R-3-3-branch/src/main/envir.c#L106
#define FRAME_LOCK_MASK (1<<14)
#define FRAME_IS_LOCKED(e) (ENVFLAGS(e) & FRAME_LOCK_MASK)
#define UNLOCK_FRAME(e) SET_ENVFLAGS(e, ENVFLAGS(e) & (~ FRAME_LOCK_MASK))

// [[Rcpp::export]]
bool
unlockEnvironment(Rcpp::Environment env)
{
    UNLOCK_FRAME(env);
    return FRAME_IS_LOCKED(env) == 0;
}

