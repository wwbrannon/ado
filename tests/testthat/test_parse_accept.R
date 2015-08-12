context("The parser accepts all and only valid input")

#The expectation functions we're going to use here
expect_accept <- function(str) eval(bquote(expect_equal(parse_accept(.(str)), 1)))
expect_reject <- function(str) eval(bquote(expect_equal(parse_accept(.(str)), 0)))

test_that("Numeric literals parse", {
    expect_accept("disp 1")
    expect_accept("disp -11")
    expect_accept("disp 0xdeadbeef")
    expect_accept("disp ")
})

test_that("Arithmetic expressions parse", {
    #FIXME
})

test_that("Datetime literals parse", {
    #FIXME
})
    
test_that("String expressions, with double and compound double quotes, parse", {
    #FIXME
})

test_that("Factor expressions and factorial operators parse", {
    #FIXME
})

test_that("Type constructors parse", {
    #FIXME
})

test_that("Postfix expressions parse", {
    #FIXME
})

test_that("Relational and equality expressions parse", {
    #FIXME
})

test_that("Logical expressions parse", {
    #FIXME
})

test_that("Assignment expressions parse", {
    #FIXME
})

test_that("Short comments parse", {
    expect_accept('disp "short comments parse" // at EOF')
    expect_accept('disp "short comments parse" // and at EOL with a newline\n')
    expect_accept('disp "short comments parse" // and with a semicolon;')
    expect_accept('disp "short comments parse"\n// on a new line\n')
    expect_accept('//short comments parse at the top of the script
                  disp "short comments parse"
                  // and again here\n')
})

test_that("Long comments parse", {
    #FIXME
})

test_that("Both statement delimiters parse", {
    #All of these statements appear elsewhere with a newline and are accepted
    expect_accept('collapse (mean) support voteprop;')
    expect_accept('collapse (mean) support voteprop (first) state;')
    expect_reject('qui gen foobar = 1')
    expect_accept('qui cap gen foo = 1;')
    expect_accept('local foo = 1+1;')
    expect_reject('tempfile foobar')
    expect_accept('recode treat1 treat2 (2 3 = 1) (4 5 = 9);')
    expect_accept('recode treat1 treat2 (2 3 = 1) (4/5 = 9);')
})

test_that("Compound command blocks parse", {
    expect_reject("{ }\n")
    expect_accept("{ display 1+1; }\n")
    expect_accept("{
        local name=1+1;
        disp 45;
        qui sum foo;
    }\n")
})

test_that("General commands with no expression_list parse", {
    expect_accept("exit\n")
    expect_accept("clear\n")
})

test_that("General commands with an expression_list parse", {
    expect_accept("gen foo = 1\n")
    expect_accept("tab support treat\n")
    expect_accept("gen byte foo = 10\n")
    expect_accept("disp \"I'm a string\"\n")
    expect_accept("logit y x1 x2##i.x3 x4 c.x5#x6")
})

test_that("General commands with an option list parse", {
    expect_accept("exit, clear\n")
    expect_accept("count, opt\n")
    expect_accept("cmd, opt(arg) opt2(arg1) opt3(arg233) opt4\n")
})

test_that("General commands with an if clause and an option list parse", {
    expect_accept("drop if in_universe == 0, force\n")
    expect_accept("keep if good == 1, force\n")
    expect_accept("cmd if good_case + 1, opt opt2(val)\n")
})

test_that("General commands with an expression list and an if clause parse", {
    expect_accept("logit y x1 x2 x3 if treat != 3\n")
    expect_accept("drop if hhid > 9999\n")
    expect_accept("gen y = 1 if income > 50000\n")
    expect_accept("replace income = 0 if income <= 50000")
})

test_that("General commands with an expression list and an in clause parse", {
    expect_accept("logit y x1 x2 x3 in 3 / 4\n")
    expect_accept("drop in -5 / 6\n")
    expect_accept("gen y = 1 in 34 / L\n")
    expect_accept("replace income = 0 in -24 / F\n")
})

test_that("General commands with an expression list and a weight clause parse", {
    expect_accept("tab support treat [pweight=weight]\n")
    expect_accept("reg y x1 x2 x3 [aweight=weight]\n")
    expect_accept("logit z y1 y2##y10 y3 [iweight = wgt]")
    expect_accept("mlogit z y2 y3 c.y5#y9 [aweight = wgt]\n")
})

test_that("General commands with an expression list and a using clause parse", {
    expect_accept('insheet using "myfile.csv"\n')
    expect_accept('insheet using "myfile.csv", comma clear\n')
    expect_accept('save using "foobar.dta"\n')
    expect_accept('save using "foobar.dta", replace\n')
})

test_that("General commands with an expression list and an option list parse", {
    expect_accept("mlogit y x1 x2 x3, b(0)\n")
    expect_accept("reg voted treat i.race, cluster(hhid)\n")
    expect_accept("mlogit voted treat i.race, cluster(hhid) b(1)\n")
    expect_accept("egen v = std(var1 + var2), missing\n")
    expect_accept("egen v = mode(var3), minmode")
})

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

