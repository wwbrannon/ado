context("Parser accepts all and only valid input")

#The expectation functions we're going to use here
expect_accept <- function(str) eval(bquote(expect_equal(parse_accept(.(str)), 1)))
expect_reject <- function(str) eval(bquote(expect_equal(parse_accept(.(str)), 0)))

#What do we need to test? Both valid and invalid input for
#these categories of commands/expressions:
#   (*) special commands
#   (*) loops
#   (*) embedded code blocks
#   (*) prefix commands with special commands
#   (*) prefix commands with general commands
#   expressions, via e.g. the generate command
#   general commands
#   macros, all three varieties
#   comments
#   compound command blocks
#   statement delimiters
#   command parts
#       using clause
#       weight clause
#       if clause
#       in clause
#       option lists
#       expression lists
#It's important to provide both valid and invalid input to see
#if invalid input is correctly rejected.

test_that("Embedded code blocks parse", {
    expect_accept('{{{
        y <- as.call(list(as.symbol("foobar"), 1, 2, 3, "abc"));
        print(y);
    }}}\n')

    expect_reject('{{{
        y <- as.call(list(as.symbol("foobar"), 1, 2, 3, "abc"));
        print(y);
    ')

    expect_accept('{{{ print(1); }}}\n')
    expect_accept('{{{ }}}\n')
})

test_that("The merge command parses", {
    expect_accept('merge 1:m id using "final.dta"\n')
    expect_accept('merge 1:1 id using "final.dta"\n')
    expect_accept('merge m:1 id using "final.dta"\n')
    expect_accept('merge m:m id using "final.dta"\n')
    expect_accept('merge m:1 id firstname lastname using "final.dta"\n')
    expect_accept('merge m:m id lastname using "final.dta", gen(foo)\n')
})

test_that("The xi command parses", {
    expect_accept('xi var1\n')
    expect_accept('xi var1 var2\n')
    expect_accept('xi var1 var2, opt\n')
    expect_accept('xi var1 var2, opt opt2(param)\n')
})

test_that("The ivregress command parses", {
    expect_accept('ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_accept('ivregress 2sls y x1 x2 x3 (contact = treat) if treat != 4, cluster(household)\n')
})

test_that("The gsort command parses", {
    expect_accept('gsort +hhid -phone_score\n')
    expect_accept('gsort +hhid -phone_score, mfirst\n')
})

test_that("The collapse command parses", {
    expect_accept('collapse support voteprop\n')
    expect_accept('collapse support voteprop, by(track)\n')
    expect_accept('collapse support voteprop id=id\n')
    expect_accept('collapse support voteprop id=id, by(track)\n')
    expect_accept('collapse (mean) support voteprop\n')
    expect_accept('collapse (mean) support voteprop (first) state\n')
    expect_accept('collapse (mean) support voteprop (first) state id=id\n')
    expect_accept('collapse (mean) support voteprop (first) state, by(track)\n')
    expect_accept('collapse (mean) support voteprop (first) state id=id, by(track)\n')
})

test_that("The lrtest command parses", {
    expect_accept('lrtest A (B C)\n')
    expect_accept('lrtest . (B C)\n')
    expect_reject('lrtest A (B .)\n')
})

test_that("The anova command parses", {
    expect_accept('anova y i.x\n')
    expect_accept('anova y i.x#z\n')
    expect_accept('anova y i.x##c.z\n')
    expect_accept('anova y i.x|c.z\n')
    expect_accept('anova y i.x|c.z /\n')
    expect_accept('anova y i.x|c.z /, option(val)\n')
})

test_that("The recode command parses", {
    expect_accept('recode treat (2 3 = 1)\n')
    expect_accept('recode treat1 treat2 (2 3 = 1) (4 5 = 9)\n')
    expect_accept('recode treat1 treat2 (2 3 = 1) (4/5 = 9)\n')
    expect_accept('recode treat1 treat2 (2 . = 1) (4/5 = 9)\n')
    expect_accept('recode treat1 treat2 (2 . = 1) (4/5 = 9)\n')
    expect_accept('recode treat1 treat2 (missing = 1) (4/5 = 9)\n')
    expect_accept('recode treat1 treat2 (missing = 1) (4/5 = 9), gen(newvar)\n')
})

test_that("Prefix commands parse with a general command", {
    expect_accept('quietly gen foobar = 1\n')
    expect_accept('qui gen foobar = 1\n')
    expect_accept('qui cap gen foo = 1\n')
    expect_accept('by state: tab foo bar\n')
    expect_accept('qui by state: tab foo bar\n')
    expect_accept('qui cap by state: tab foo bar\n')
    expect_accept('qui by state: cap tab foo bar\n')
})

test_that("Prefix commands parse with a special command", {
    expect_accept('quietly ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_accept('qui ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_accept('qui cap ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_accept('by state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_accept('noisily by state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_accept('qui cap bysort state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_accept('noisily by state: cap ivregress 2sls y x1 x2 x3 (contact = treat)\n')
})

test_that("Macro manipulation commands parse", {
    expect_accept('local foo "bar"\n')
    expect_accept('local mac\n')
    expect_accept('local foo = 1+1\n')
    expect_accept('tempfile foobar\n')
    expect_accept('macro drop\n')
    expect_accept('macro dir\n')
})

test_that("Deeply nested expressions parse", {
    expect_accept('gen foo = -(1 + ((98/4^2) - (8.3+1)))\n')
    expect_accept('disp 87+.98-96/23^7\n')
    expect_accept('logit y score##i.state\n')
})

test_that("If statements parse", {
    expect_accept('if 1 {
        di "foo"
    }\n')

    expect_accept("if `foo' + 3 >= 7 {
        disp \"it worked\"
    }\n")
})

test_that("Forvalues loops parse", {
    expect_accept("forvalues i = 45 / 98 {
        gen var`i' = `i'
    }\n")

    expect_accept("forvalues i = 45(2)98 {
        gen var`i' = `i'
    }\n")

    expect_accept("forvalues i = 45 2: 98 {
        gen var`i' = `i'
    }\n")

    expect_accept("forvalues i = 45 2 to 98 {
        gen var`i' = `i'
    }\n")
})

test_that("Foreach loops parse", {
    expect_accept("foreach i of 1 2 3 4 5 6 {
        disp `i'
    }\n")

    expect_accept("foreach i of bar baz foo quux {
        disp `i'
    }\n")

    expect_accept("foreach i of bar baz foo quux {
        disp `i'
    }\n")

    expect_accept("foreach i of local nums {
        disp `i'
    }\n")

    expect_accept("foreach i of global nums {
        disp `i'
    }\n")

    expect_accept("foreach i of varlist bar baz foo quux {
        disp `i'
    }\n")

    expect_accept("foreach i of newlist bar baz foo quux {
        disp `i'
    }\n")

    expect_accept("foreach i of numlist 1 2 3 4 {
        disp `i'
    }\n")
})

