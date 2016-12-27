context("The parser accepts all and only valid input")

test_that("Numeric literals parse", {
    expect_parse_accept("disp .\n")
    expect_parse_accept("disp 0\n")
    expect_parse_accept("disp -10\n")
    expect_parse_accept("disp -10.0978\n")
    expect_parse_accept("disp 0.0234\n")
    expect_parse_accept("disp .0234\n")
    expect_parse_accept("disp 10.0978\n")
    expect_parse_accept("disp 0x0\n")
    expect_parse_accept("disp 0xadf\n")
    expect_parse_accept("disp 0x1482\n")
    expect_parse_accept("disp 0xdeadbeef\n")
    expect_parse_accept("disp 02453\n")
    expect_parse_accept("disp 00124\n")
    expect_parse_accept("disp 03.24E3\n")
    expect_parse_accept("disp 033E31\n")
})

test_that("Datetime literals parse", {
    expect_parse_accept("disp 07jan2006\n")
    expect_parse_accept("disp 08jan1995\n")
    expect_parse_accept("disp 14jul209\n")
    expect_parse_accept("disp 07jan2006 12:45:12.09\n")
    expect_parse_accept("disp 08jan1995 03:12:34\n")
    expect_parse_accept("disp 14jul209 21:45:02\n")
})

test_that("String expressions, with double and compound double quotes, parse", {
    expect_parse_accept('disp "this is a string"\n')
    expect_parse_accept('disp "this is a \\nstring \\\" with escapes"\n')
    expect_parse_accept('disp `"this is a \\nstring \\\" with escapes"\'\n')
    expect_parse_accept('disp `"this is a "nested" string"\'\n')
})

test_that("Postfix expressions parse", {
    expect_parse_accept("disp seq()\n")
    expect_parse_accept("disp seq(1,2,3)\n")
    expect_parse_accept("disp seq(1, 2, 3)\n")
    expect_parse_accept("disp var(1 2 3)\n")
    expect_parse_accept("disp seq(foo bar baz)\n")
    expect_parse_accept("disp func(foo, bar, baz)\n")
    expect_parse_accept("disp seq(foo(), bar, baz)\n")
    expect_parse_accept("disp val(foo() bar baz)\n")
    expect_parse_accept("disp var[36]\n")
    expect_parse_accept("disp var[-1]\n")
    expect_parse_accept("disp var[3+4 - 8*5]\n")
})

test_that("Format specifiers parse", {
    expect_parse_accept("disp %10.0f\n")
    expect_parse_accept("disp %-14s\n")
    expect_parse_accept("disp %05.0f\n")
    expect_parse_accept("disp %tcDDmonCCYY_HH:MM:SS.ss\n")
    expect_parse_accept("disp %9.2fc\n")
    expect_parse_accept("disp %21x\n")
    expect_parse_accept("disp %-12.2f\n")
    expect_parse_accept("disp %10.0g\n")
    expect_parse_accept("disp %9s\n")
    expect_parse_accept("disp %8s\n")
    expect_parse_accept("disp %10.7e\n")
    expect_parse_accept("disp %16L\n")
    expect_parse_accept("disp %9.2fc\n")
    expect_parse_accept("disp %-9.0gc\n")
})

test_that("Arithmetic expressions parse", {
    expect_parse_accept("disp 45+1\n")
    expect_parse_accept("disp 97-23\n")
    expect_parse_accept("disp 3.4 / 10\n")
    expect_parse_accept("disp 43 * 78.5\n")
    expect_parse_accept("disp 43 ^ 2.0\n")
    expect_parse_accept("disp 43 ^ 3\n")
    expect_parse_accept("disp (123 + 987) / 4^2\n")
    expect_parse_accept("disp (1343 - 966.01 + 67) ^ 2 - 2 / 3\n")
    expect_parse_accept("disp (12 + 87 * (76 - 4)) ^ 2 - (34 / (43 + 98)) ^ 0.5\n")
})

test_that("Type constructors parse", {
    expect_parse_accept("gen byte foo = 1\n")
    expect_parse_accept("gen byte foo\n")
    expect_parse_accept("gen byte(var1 var2 var3) byte baz\n")
    expect_parse_accept("gen int foo = 1\n")
    expect_parse_accept("gen int foo\n")
    expect_parse_accept("gen int(var1 var2 var3) byte baz\n")
    expect_parse_accept("gen long foo = 1\n")
    expect_parse_accept("gen long foo\n")
    expect_parse_accept("gen long(var1 var2 var3) int baz\n")
    expect_parse_accept("gen double foo = 1\n")
    expect_parse_accept("gen double foo\n")
    expect_parse_accept("gen double(var1 var2 var3) long baz\n")
    expect_parse_accept("gen strL foo = 1\n")
    expect_parse_accept("gen strL foo\n")
    expect_parse_accept("gen strL(var1 var2 var3) int baz\n")
    expect_parse_accept("gen str foo = 1\n")
    expect_parse_accept("gen str foo\n")
    expect_parse_accept("gen str(var1 var2 var3)\n")
    expect_parse_accept("gen str987 foo = 1\n")
    expect_parse_accept("gen str987 foo\n")
    expect_parse_accept("gen str987(var1 var2 var3)\n")
})

test_that("Factor expressions and factorial operators parse", {
    expect_parse_accept("logit y c.var1\n")
    expect_parse_accept("logit y i.var1\n")
    expect_parse_accept("logit y bn.myvar\n")
    expect_parse_accept("logit y ibn.var3\n")
    expect_parse_accept("logit y ib(freq).zazz\n")
    expect_parse_accept("logit y b(last).quux\n")
    expect_parse_accept("logit y ib(first).baz\n")
    expect_parse_accept("logit y b3.foo\n")
    expect_parse_accept("logit y ib3.var\n")
    expect_parse_accept("logit y b(#4).foo\n")
    expect_parse_accept("logit y ib(#5).var\n")
    expect_parse_accept("logit y i3.treat\n")
    expect_parse_accept("logit y i(3).var\n")
    expect_parse_accept("logit y i(3 8).var\n")
    expect_parse_accept("logit y i(3 8 5 7).var\n")
    expect_parse_accept("logit y i(3    8     5    7).var\n")
    expect_parse_accept("logit y i(0 1).var\n")
    expect_parse_accept("logit y i(4 / 3).var2\n")
    expect_parse_accept("logit y i(4/2).var\n")
    expect_parse_accept("logit y io4.var\n")
    expect_parse_accept("logit y o4.var\n")
    expect_parse_accept("logit y io(3).var\n")
    expect_parse_accept("logit y o(3 8).var\n")
    expect_parse_accept("logit y io(0 1).var\n")
    expect_parse_accept("logit y o(4 / 3).var2\n")
    expect_parse_accept("logit y io(4/2).var\n")
    expect_parse_accept("logit y bn.myvar c.var2#i.var4\n")
    expect_parse_accept("logit y ibn.var3 i.var2##c.var2\n")
    expect_parse_accept("logit y i(0 1).var var2#var4\n")
    expect_parse_accept("logit y i(4 / 3).var2 var##var1\n")
})

test_that("Relational and equality expressions parse", {
    expect_parse_accept("gen foo = var == var1\n")
    expect_parse_accept("gen foo = var != var1\n")
    expect_parse_accept("gen foo = var == var1 == var2\n")
    expect_parse_accept("gen foo = (var == var1 == var2)\n")
    expect_parse_accept("gen foo = 3 != var\n")
    expect_parse_accept("gen foo = var != 3\n")
    expect_parse_accept("gen foo = (var != 3)\n")
    expect_parse_accept("disp var1 > var2\n")
    expect_parse_accept("disp var1 >= var2\n")
    expect_parse_accept("disp var1 < var2\n")
    expect_parse_accept("disp var1 <= var2\n")
    expect_parse_accept("disp (var1 / 2) > var2\n")
    expect_parse_accept("disp (var1 / 2 + 3) > var2\n")
    expect_parse_accept("disp (var1 == 3) > var2\n")
    expect_parse_accept("disp (var1 == 3) <= var2\n")
})

test_that("Logical expressions parse", {
    expect_parse_accept("disp var2 | var1\n")
    expect_parse_accept("disp var2 & var1\n")
    expect_parse_accept("gen foo = var1 < var2 | var1 > var3\n")
    expect_parse_accept("gen foo = (var1 < var2 | var1 > var3)\n")
    expect_parse_accept("gen foo = var1 < var2 & var1 > var3\n")
    expect_parse_accept("gen foo = (var1 < var2 & var1 > var3)\n")
})

test_that("Assignment expressions parse", {
    expect_parse_accept("gen foo = var\n")
    expect_parse_accept("gen foo = 1\n")
    expect_parse_accept("gen foo = 1 + 3.4\n")
    expect_parse_accept('gen foo = "string"\n')
    expect_parse_accept('gen foo = "`string"\'\n')
    expect_parse_accept('gen foo = seq()\n')
    expect_parse_accept("gen foo = seq[3]\n")
    expect_parse_accept("gen foo = 3 > 4\n")
    expect_parse_accept("gen foo = -var\n")
    expect_parse_accept("gen foo = (3 != var)\n")
    expect_parse_accept("gen foo = 3 != var\n")
    expect_parse_accept("gen foo = var1 < var2 | var1 > var3\n")
    expect_parse_accept("gen foo = (var1 < var2 | var1 > var3)\n")
})

test_that("Long comments parse", {
    expect_parse_accept("/* this is a long comment */ disp foo\n")
    expect_parse_accept("disp /* not displayed */ foo\n")
    expect_parse_accept("disp foo /* not displayed */\n")
    expect_parse_accept("disp 1+3 - 5 ^ /* oh look a comment */ 3\n")
    expect_parse_accept("disp 1+3 - 5 ^ /* oh look
                  a
                  multiline
                  comment */ 3\n")
    expect_parse_accept("disp /* this comment is terminated */ foo\n")
})

test_that("Short comments parse", {
    expect_parse_accept('disp "short comments parse" // at EOF')
    expect_parse_accept('disp "short comments parse" // and at EOL with a newline\n')
    expect_parse_accept('disp "short comments parse" // and with a semicolon;')
    expect_parse_accept('disp "short comments parse"\n// on a new line\n')
    expect_parse_accept('//short comments parse at the top of the script
                  disp "short comments parse"
                  // and again here\n')
})

test_that("Both statement delimiters parse", {
    #All of these statements appear elsewhere with a newline and are accepted
    expect_parse_accept('collapse (mean) support voteprop;')
    expect_parse_accept('collapse (mean) support voteprop (first) state;')
    expect_parse_accept('qui cap gen foo = 1;')
    expect_parse_accept('local foo = 1+1;')
    expect_parse_accept('recode treat1 treat2 (2 3 = 1) (4 5 = 9);')
    expect_parse_accept('recode treat1 treat2 (2 3 = 1) (4/5 = 9);')
})

test_that("Compound command blocks parse", {
    expect_parse_accept("{ display 1+1; }\n")
    expect_parse_accept("{
        local name=1+1;
        disp 45;
        qui sum foo;
    }\n")
})

test_that("General commands with no expression_list parse", {
    expect_parse_accept("exit\n")
    expect_parse_accept("clear\n")
})

test_that("General commands with an expression_list parse", {
    expect_parse_accept("gen foo = 1\n")
    expect_parse_accept("tab support treat\n")
    expect_parse_accept("gen byte foo = 10\n")
    expect_parse_accept("disp \"I'm a string\"\n")
    expect_parse_accept("logit y x1 x2##i.x3 x4 c.x5#x6\n")
})

test_that("General commands with an option list parse", {
    expect_parse_accept("exit, clear\n")
    expect_parse_accept("count, opt\n")
    expect_parse_accept("cmd, opt(arg) opt2(arg1) opt3(arg233) opt4\n")
})

test_that("General commands with an if clause and an option list parse", {
    expect_parse_accept("drop if in_universe == 0, force\n")
    expect_parse_accept("keep if good == 1, force\n")
    expect_parse_accept("cmd if good_case + 1, opt opt2(val)\n")
})

test_that("General commands with an expression list and an if clause parse", {
    expect_parse_accept("logit y x1 x2 x3 if treat != 3\n")
    expect_parse_accept("drop if hhid > 9999\n")
    expect_parse_accept("gen y = 1 if income > 50000\n")
    expect_parse_accept("replace income = 0 if income <= 50000\n")
})

test_that("General commands with an expression list and an in clause parse", {
    expect_parse_accept("logit y x1 x2 x3 in 3 / 4\n")
    expect_parse_accept("drop in -5 / 6\n")
    expect_parse_accept("gen y = 1 in 34 / L\n")
    expect_parse_accept("gen y = 1 in F / 34\n")
    expect_parse_accept("gen y = 1 in 34\n")
    expect_parse_accept("gen y = 1 in l\n")
    expect_parse_accept("replace income = 0 in -24 / F\n")
})

test_that("General commands with an expression list and a weight clause parse", {
    expect_parse_accept("tab support treat [pweight=weight]\n")
    expect_parse_accept("reg y x1 x2 x3 [aweight=weight]\n")
    expect_parse_accept("logit z y1 y2##y10 y3 [iweight = wgt]\n")
    expect_parse_accept("mlogit z y2 y3 c.y5#y9 [aweight = wgt]\n")
})

test_that("General commands with an expression list and a using clause parse", {
    expect_parse_accept('insheet using "myfile.csv"\n')
    expect_parse_accept('insheet using "myfile.csv", comma clear\n')
    expect_parse_accept('save using "foobar.dta"\n')
    expect_parse_accept('save using "foobar.dta", replace\n')
})

test_that("General commands with an expression list and an option list parse", {
    expect_parse_accept("mlogit y x1 x2 x3, b(0)\n")
    expect_parse_accept("reg voted treat i.race, cluster(hhid)\n")
    expect_parse_accept("mlogit voted treat i.race, cluster(hhid) b(1)\n")
    expect_parse_accept("egen v = std(var1 + var2), missing\n")
    expect_parse_accept("egen v = mode(var3), minmode\n")
})

test_that("Embedded code blocks parse", {
    expect_parse_accept('{{{
        y <- as.call(list(as.symbol("foobar"), 1, 2, 3, "abc"));
        print(y);
    }}}\n')

    expect_parse_accept('{{{ print(1); }}}\n')
    expect_parse_accept('{{{ }}}\n')
})

test_that("The merge command parses", {
    expect_parse_accept('merge 1:m id using "final.dta"\n')
    expect_parse_accept('merge 1:1 id using "final.dta"\n')
    expect_parse_accept('merge m:1 id using "final.dta"\n')
    expect_parse_accept('merge m:m id using "final.dta"\n')
    expect_parse_accept('merge m:1 id firstname lastname using "final.dta"\n')
    expect_parse_accept('merge m:m id lastname using "final.dta", gen(foo)\n')
})

test_that("The xi command parses", {
    expect_parse_accept('xi var1\n')
    expect_parse_accept('xi var1 var2\n')
    expect_parse_accept('xi var1 var2, opt\n')
    expect_parse_accept('xi var1 var2, opt opt2(param)\n')
})

test_that("The ivregress command parses", {
    expect_parse_accept('ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_accept('ivregress 2sls y x1 x2 x3 (contact = treat) if treat != 4, cluster(household)\n')
})

test_that("The gsort command parses", {
    expect_parse_accept('gsort +hhid -phone_score\n')
    expect_parse_accept('gsort +hhid -phone_score, mfirst\n')
})

test_that("The collapse command parses", {
    expect_parse_accept('collapse support voteprop\n')
    expect_parse_accept('collapse support voteprop, by(track)\n')
    expect_parse_accept('collapse support voteprop id=id\n')
    expect_parse_accept('collapse support voteprop id=id, by(track)\n')
    expect_parse_accept('collapse (mean) support voteprop\n')
    expect_parse_accept('collapse (mean) support voteprop (first) state\n')
    expect_parse_accept('collapse (mean) support voteprop (first) state id=id\n')
    expect_parse_accept('collapse (mean) support voteprop (first) state, by(track)\n')
    expect_parse_accept('collapse (mean) support voteprop (first) state id=id, by(track)\n')
})

test_that("The lrtest command parses", {
    expect_parse_accept('lrtest A (B C)\n')
    expect_parse_accept('lrtest . (B C)\n')
})

test_that("The anova command parses", {
    expect_parse_accept('anova y i.x\n')
    expect_parse_accept('anova y i.x#z\n')
    expect_parse_accept('anova y i.x##c.z\n')
    expect_parse_accept('anova y i.x|c.z\n')
    expect_parse_accept('anova y i.x|c.z /\n')
    expect_parse_accept('anova y i.x|c.z /, option(val)\n')
})

test_that("The recode command parses", {
    expect_parse_accept('recode treat (2 3 = 1)\n')
    expect_parse_accept('recode treat1 treat2 (2 3 = 1) (4 5 = 9)\n')
    expect_parse_accept('recode treat1 treat2 (2 3 = 1) (4/5 = 9)\n')
    expect_parse_accept('recode treat1 treat2 (2 . = 1) (4/5 = 9)\n')
    expect_parse_accept('recode treat1 treat2 (2 . = 1) (4/5 = 9)\n')
    expect_parse_accept('recode treat1 treat2 (missing = 1) (4/5 = 9)\n')
    expect_parse_accept('recode treat1 treat2 (missing = 1) (4/5 = 9), gen(newvar)\n')
})

test_that("Prefix commands parse with a general command", {
    expect_parse_accept('quietly gen foobar = 1\n')
    expect_parse_accept('qui gen foobar = 1\n')
    expect_parse_accept('qui cap gen foo = 1\n')
    expect_parse_accept('by state: tab foo bar\n')
    expect_parse_accept('qui by state: tab foo bar\n')
    expect_parse_accept('qui cap by state: tab foo bar\n')
    expect_parse_accept('qui by state: cap tab foo bar\n')
})

test_that("Prefix commands parse with a special command", {
    expect_parse_accept('quietly ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_accept('qui ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_accept('qui cap ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_accept('by state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_accept('noisily by state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_accept('qui cap bysort state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_accept('noisily by state: cap ivregress 2sls y x1 x2 x3 (contact = treat)\n')
})

test_that("Macro manipulation commands parse", {
    expect_parse_accept('local foo "bar"\n')
    expect_parse_accept('local mac\n')
    expect_parse_accept('local foo = 1+1\n')
    expect_parse_accept('tempfile foobar\n')
    expect_parse_accept('macro drop\n')
    expect_parse_accept('macro dir\n')
})

test_that("If statements parse", {
    expect_parse_accept('if 1 {
        di "foo"
    }\n')

    expect_parse_accept("if `foo' + 3 >= 7 {
        disp \"it worked\"
    }\n")
})

test_that("Forvalues loops parse", {
    expect_parse_accept("forvalues i = 45 / 98 {
        gen var`i' = `i'
    }\n")

    expect_parse_accept("forvalues i = 45 / 98 { // this is a short comment that the scanner should remove from the input
        gen var`i' = `i'
    }\n")

    expect_parse_accept("forvalues i = 45 / 98 { /* this is a long comment that the scanner should remove from the input */
        gen var`i' = `i'
    }\n")

    expect_parse_accept("forvalues i = 45(2)98 {
        gen var`i' = `i'
    }\n")

    expect_parse_accept("forvalues i = 45 2: 98 {
        gen var`i' = `i'
    }\n")

    expect_parse_accept("forvalues i = 45 2 to 98 {
        gen var`i' = `i'
    }\n")
})

test_that("Foreach loops parse", {
    expect_parse_accept("foreach i of 1 2 3 4 5 6 {
        disp `i'
    }\n")

    expect_parse_accept("foreach i of 1 2 3 4 5 6 { // this is a short comment that the scanner should remove from the input
        disp `i'
    }\n")

    expect_parse_accept("foreach i of 1 2 3 4 5 6 { /* this is a long comment that the scanner should remove from the input */
        disp `i'
    }\n")

    expect_parse_accept("foreach i of bar baz foo quux {
        disp `i'
    }\n")

    expect_parse_accept("foreach i of bar baz foo quux {
        disp `i'
    }\n")

    expect_parse_accept("foreach i of local nums {
        disp `i'
    }\n")

    expect_parse_accept("foreach i of global nums {
        disp `i'
    }\n")

    expect_parse_accept("foreach i of varlist bar baz foo quux {
        disp `i'
    }\n")

    expect_parse_accept("foreach i of newlist bar baz foo quux {
        disp `i'
    }\n")

    expect_parse_accept("foreach i of numlist 1 2 3 4 {
        disp `i'
    }\n")
})

