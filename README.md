statashell
==========

A Stata-like shell for R, implemented as a loadable package. It's intended to serve as training wheels for Stata users who'd like to switch or need to use R, but don't know much about R or programming in general.

An example of the intended usage:
    
    user@host:~$ R -q
    > require(statashell)
    > statashell("data")
    . insheet using "/home/user/data.csv"
    . count
      48473
    . bysort address: egen hh_rep = seq()
    . drop if hh_rep != 1
    . count
      37845

    ...

    . logit treat age gender countyname // a Stata comment
        <output>
    . ^D
    > summary(data)
    #after statashell, there's a data frame with changes made in Stata code
