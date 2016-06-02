.datatable.aware <- TRUE

.onLoad <-
function(libname, pkgname)
{
    #This environment has to exist at package scope before rstata() runs
    pkg_env <- parent.env(environment())
    if("rstata_env" %not_in% ls(envir=pkg_env))
    {
        assign("rstata_env", new.env(parent=baseenv()), envir=pkg_env)
    }
}

.onDetach <-
function(libpath)
{
    #Written defensively so as not to throw an error if
    #for whatever reason .onAttach fails and this env
    #doesn't exist
    pkg_env <- as.environment("package:" %p% pkgname)
    if("rstata_env" %in% ls(envir=pkg_env))
    {
        finalize()
    }
}

#Do the same thing on unload as on detach
.onUnload <- .onDetach

#More pkg-wide initialization stuff. This function's principal job is to set
#up the rstata_env package-wide holding environment. It's called on package
#load and again each time rstata() runs. The rstata_env environment holds
#several things: the dataset, the macro substitution symbol tables, a lookup
#table (as an environment) for settings, and the (e,r,c)-class value tables
#(which are also environments).
initialize <-
function()
{
    #We want it in a known-good state before initializing
    finalize()
    
    #===================================================
    #Set up the dataset object
    assign("rstata_dta", Dataset$new(), envir=rstata_env)
    
    #===================================================
    #Create environments to represent Stata's "e-class" and "r-class" objects
    #for stored results
    assign("rstata_rclass_env", new.env(parent=emptyenv()), envir=rstata_env)
    assign("rstata_eclass_env", new.env(parent=emptyenv()), envir=rstata_env)
    
    #===================================================
    #Another env for c-class objects that's not the only place c-class values
    #are looked up. Still need to set certain values here.
    cc_env <- new.env(parent=emptyenv())
    
    #Mathematical constants
    assign("pi", pi, envir=cc_env)
    assign("e", exp(1), envir=cc_env)
    
    #Letters
    assign("alpha", paste0(letters, collapse=" "), envir=cc_env)
    assign("ALPHA", paste0(LETTERS, collapse=" "), envir=cc_env)

    #Months - the Stata docs imply these aren't localized, but they should be
    assign("Mons", paste0(format(ISOdate(2000, 1:12, 1), "%b"), collapse=" "),
           envir=cc_env)
    assign("Months", paste0(format(ISOdate(2000, 1:12, 1), "%B"), collapse=" "),
           envir=cc_env)

    #Weekdays
    Wdays <- weekdays(seq(as.Date("2013-06-03"), by=1, len=7), abbreviate=TRUE)
    Wdays <- paste0(Wdays, collapse=" ")
    
    Weekdays <- weekdays(seq(as.Date("2013-06-03"), by=1, len=7))
    Weekdays <- paste0(Weekdays, collapse=" ")
    
    assign("Wdays", Wdays, envir=cc_env)
    assign("Weekdays", Weekdays, envir=cc_env)

    #URLs for webuse
    assign('default_webuse_url', 'http://www.stata-press.com/data/r13/', envir=cc_env)
    
    assign("rstata_cclass_env", cc_env, envir=rstata_env)
    
    #===================================================
    #Create the settings cache and macro symbol table
    assign("rstata_macro_env", new.env(parent=emptyenv()), envir=rstata_env)
    
    s_env <- new.env(parent=emptyenv())
    assign("webuse_url", 'http://www.stata-press.com/data/r13/', envir=s_env)
    assign("rstata_settings_env", s_env, envir=rstata_env)
    
    return(invisible(NULL))
}

#If initialize is the ctor for rstata_env, this is the dtor. The main
#reason it's important to tear this stuff down is so that the dataset
#object doesn't sit around consuming huge amounts of memory. It's an
#error to call this function without having first called initialize().
finalize <-
function()
{
    #Make extra sure this possibly huge object gets garbage-collected
    if("rstata_dta" %in% ls(envir=rstata_env))
    {
        dt <- get("rstata_dta", envir=rstata_env)
        dt$clear()
    }
    
    rm(list=ls(envir=rstata_env), envir=rstata_env)
    
    return(invisible(NULL))
}
