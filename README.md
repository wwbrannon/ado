statashell
==========

A Stata-like shell for R. It's intended to serve as training wheels for Stata users who'd like to switch, but don't know much about R or programming in general.

An example of the intended usage:
    user@host:~$ R -q
    > require(statashell)
    > statashell()
    . insheet using "/home/jrandomuser/data.csv"
    . bysort address: egen hh_id = seq()
    
    ...

    . logit treat age gender countyname
        <output>
    . ^D
    > head(data) #showing changes made in Stata shell

