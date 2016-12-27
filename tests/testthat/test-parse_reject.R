context("The parser rejects invalid input")

# NB: newlines or semicolons at the end of test cases are there
# because the grammar requires a statement terminator for commands
# other than those to the macro processor (foreach, forvalues, if)

test_that("Statements without terminators fail to parse", {
    expect_parse_reject("disp .")
    expect_parse_reject("disp seq(foo bar baz)")
    expect_parse_reject("gen double(var1 var2 var3) long baz")
    expect_parse_reject("mlogit voted treat i.race, cluster(hhid) b(1)")
    expect_parse_reject('by state: tab foo bar')
    expect_parse_reject('tempfile foobar')
    expect_parse_reject('collapse (mean) support voteprop (first) state, by(track)')
})

test_that("Invalid numeric literals fail to parse", {
    expect_parse_reject("disp 0.02.34\n")
    expect_parse_reject("disp 033-E31\n")
})

test_that("Invalid datetime literals fail to parse", {
    expect_parse_reject("disp jan072006\n")
    expect_parse_reject("disp jan199508\n")
    expect_parse_reject("disp 12:45:12.09 07jan2006 12:45:12.09\n")
    expect_parse_reject("disp 03:12:34 08jan1995\n")
})

test_that("Invalid string expressions, with double and compound double quotes, fail to parse", {
    expect_parse_reject('disp this is a string"\n')
    expect_parse_reject('disp "this is a string\n')
    expect_parse_reject('disp "this is a \\nstring \\\\\" with escapes"\n')
})

test_that("Invalid postfix expressions fail to parse", {
    expect_parse_reject("disp seq(\n")
    expect_parse_reject("disp seq1,2,3)\n")
    expect_parse_reject("disp seq(1,2,3\n")
    expect_parse_reject("disp seq)1, 2, 3(\n")
    expect_parse_reject("disp var(1 2 3\n")
    expect_parse_reject("disp seq(foo(), bar, baz\n")
    expect_parse_reject("disp seq(foo()\n")
    expect_parse_reject("disp var[36\n")
    expect_parse_reject("disp var36]\n")
    expect_parse_reject("disp var-1]\n")
    expect_parse_reject("disp var[-1\n")
    expect_parse_reject("disp var3+4 - 8*5]\n")
    expect_parse_reject("disp var[3+4 - 8*5\n")
})

test_that("Invalid format specifiers fail to parse", {
    expect_parse_reject("disp 1%0.0f\n")
    expect_parse_reject("disp tcDDm%onCCYY_HH:MM:SS.ss\n")
    expect_parse_reject("disp %9.2f%c\n")
    expect_parse_reject("disp %21%%x\n")
    expect_parse_reject("disp %10.%0g\n")
    expect_parse_reject("disp -9%.0gc\n")
})

test_that("Invalid arithmetic expressions fail to parse", {
    expect_parse_reject("disp 23 97 - \n")
    expect_parse_reject("disp / 3.4 / 10\n")
    expect_parse_reject("disp * 43 * 78.5\n")
    expect_parse_reject("disp 43 ^^ 2.0\n")
    expect_parse_reject("disp ((123 + 987) / 4^2\n")
    expect_parse_reject("disp (123 + 987) / 4^2)\n")
    expect_parse_reject("disp (1343 - 966.01 + 67 ^) 2 - 2 / 3\n")
    expect_parse_reject("disp (12 + 87 * (76 - 4)) (^) 2 - (34 / (43 + 98)) ^ 0.5\n")
})

# test_that("Invalid type constructors fail to parse", {
#     expect_parse_reject("gen byte foo = 1\n")
#     expect_parse_reject("gen byte foo\n")
#     expect_parse_reject("gen byte(var1 var2 var3) byte baz\n")
#     expect_parse_reject("gen int foo = 1\n")
#     expect_parse_reject("gen int foo\n")
#     expect_parse_reject("gen int(var1 var2 var3) byte baz\n")
#     expect_parse_reject("gen long foo = 1\n")
#     expect_parse_reject("gen long foo\n")
#     expect_parse_reject("gen long(var1 var2 var3) int baz\n")
#     expect_parse_reject("gen double foo = 1\n")
#     expect_parse_reject("gen double foo\n")
#     expect_parse_reject("gen double(var1 var2 var3) long baz\n")
#     expect_parse_reject("gen strL foo = 1\n")
#     expect_parse_reject("gen strL foo\n")
#     expect_parse_reject("gen strL(var1 var2 var3) int baz\n")
#     expect_parse_reject("gen str foo = 1\n")
#     expect_parse_reject("gen str foo\n")
#     expect_parse_reject("gen str(var1 var2 var3)\n")
#     expect_parse_reject("gen str987 foo = 1\n")
#     expect_parse_reject("gen str987 foo\n")
#     expect_parse_reject("gen str987(var1 var2 var3)\n")
# })
#
# test_that("Invalid factor expressions and factorial operators fail to parse", {
#     expect_parse_reject("logit y c.var1\n")
#     expect_parse_reject("logit y i.var1\n")
#     expect_parse_reject("logit y bn.myvar\n")
#     expect_parse_reject("logit y ibn.var3\n")
#     expect_parse_reject("logit y ib(freq).zazz\n")
#     expect_parse_reject("logit y b(last).quux\n")
#     expect_parse_reject("logit y ib(first).baz\n")
#     expect_parse_reject("logit y b3.foo\n")
#     expect_parse_reject("logit y ib3.var\n")
#     expect_parse_reject("logit y b(#4).foo\n")
#     expect_parse_reject("logit y ib(#5).var\n")
#     expect_parse_reject("logit y i3.treat\n")
#     expect_parse_reject("logit y i(3).var\n")
#     expect_parse_reject("logit y i(3 8).var\n")
#     expect_parse_reject("logit y i(3 8 5 7).var\n")
#     expect_parse_reject("logit y i(3    8     5    7).var\n")
#     expect_parse_reject("logit y i(0 1).var\n")
#     expect_parse_reject("logit y i(4 / 3).var2\n")
#     expect_parse_reject("logit y i(4/2).var\n")
#     expect_parse_reject("logit y io4.var\n")
#     expect_parse_reject("logit y o4.var\n")
#     expect_parse_reject("logit y io(3).var\n")
#     expect_parse_reject("logit y o(3 8).var\n")
#     expect_parse_reject("logit y io(0 1).var\n")
#     expect_parse_reject("logit y o(4 / 3).var2\n")
#     expect_parse_reject("logit y io(4/2).var\n")
#     expect_parse_reject("logit y bn.myvar c.var2#i.var4\n")
#     expect_parse_reject("logit y ibn.var3 i.var2##c.var2\n")
#     expect_parse_reject("logit y i(0 1).var var2#var4\n")
#     expect_parse_reject("logit y i(4 / 3).var2 var##var1\n")
# })
#
# test_that("Invalid relational and equality expressions fail to parse", {
#     expect_parse_reject("gen foo = var == var1\n")
#     expect_parse_reject("gen foo = var != var1\n")
#     expect_parse_reject("gen foo = var == var1 == var2\n")
#     expect_parse_reject("gen foo = (var == var1 == var2)\n")
#     expect_parse_reject("gen foo = 3 != var\n")
#     expect_parse_reject("gen foo = var != 3\n")
#     expect_parse_reject("gen foo = (var != 3)\n")
#     expect_parse_reject("disp var1 > var2\n")
#     expect_parse_reject("disp var1 >= var2\n")
#     expect_parse_reject("disp var1 < var2\n")
#     expect_parse_reject("disp var1 <= var2\n")
#     expect_parse_reject("disp (var1 / 2) > var2\n")
#     expect_parse_reject("disp (var1 / 2 + 3) > var2\n")
#     expect_parse_reject("disp (var1 == 3) > var2\n")
#     expect_parse_reject("disp (var1 == 3) <= var2\n")
# })
#
# test_that("Invalid logical expressions fail to parse", {
#     expect_parse_reject("disp var2 | var1\n")
#     expect_parse_reject("disp var2 & var1\n")
#     expect_parse_reject("gen foo = var1 < var2 | var1 > var3\n")
#     expect_parse_reject("gen foo = (var1 < var2 | var1 > var3)\n")
#     expect_parse_reject("gen foo = var1 < var2 & var1 > var3\n")
#     expect_parse_reject("gen foo = (var1 < var2 & var1 > var3)\n")
# })
#
# test_that("Invalid assignment expressions fail to parse", {
#     expect_parse_reject("gen foo = var\n")
#     expect_parse_reject("gen foo = 1\n")
#     expect_parse_reject("gen foo = 1 + 3.4\n")
#     expect_parse_reject('gen foo = "string"\n')
#     expect_parse_reject('gen foo = "`string"\'\n')
#     expect_parse_reject('gen foo = seq()\n')
#     expect_parse_reject("gen foo = seq[3]\n")
#     expect_parse_reject("gen foo = 3 > 4\n")
#     expect_parse_reject("gen foo = -var\n")
#     expect_parse_reject("gen foo = (3 != var)\n")
#     expect_parse_reject("gen foo = 3 != var\n")
#     expect_parse_reject("gen foo = var1 < var2 | var1 > var3\n")
#     expect_parse_reject("gen foo = (var1 < var2 | var1 > var3)\n")
# })
#
# test_that("Invalid long comments fail to parse", {
#     expect_parse_reject("/* this is a long comment */ disp foo\n")
#     expect_parse_reject("disp /* not displayed */ foo\n")
#     expect_parse_reject("disp foo /* not displayed */\n")
#     expect_parse_reject("disp 1+3 - 5 ^ /* oh look a comment */ 3\n")
#     expect_parse_reject("disp 1+3 - 5 ^ /* oh look
#                   a
#                   multiline
#                   comment */ 3\n")
#     expect_parse_reject("disp /* this comment is terminated */ foo\n")
# })
#
# test_that("Invalid short comments fail to parse", {
#     expect_parse_reject('disp "short comments parse" // at EOF')
#     expect_parse_reject('disp "short comments parse" // and at EOL with a newline\n')
#     expect_parse_reject('disp "short comments parse" // and with a semicolon;')
#     expect_parse_reject('disp "short comments parse"\n// on a new line\n')
#     expect_parse_reject('//short comments parse at the top of the script
#                   disp "short comments parse"
#                   // and again here\n')
# })
#
# test_that("Invalid uses of both statement delimiters fail to parse", {
#     #All of these statements appear elsewhere with a newline and are accepted
#     expect_parse_reject('collapse (mean) support voteprop;')
#     expect_parse_reject('collapse (mean) support voteprop (first) state;')
#     expect_parse_reject('qui cap gen foo = 1;')
#     expect_parse_reject('local foo = 1+1;')
#     expect_parse_reject('recode treat1 treat2 (2 3 = 1) (4 5 = 9);')
#     expect_parse_reject('recode treat1 treat2 (2 3 = 1) (4/5 = 9);')
# })
#
# test_that("Invalid compound command blocks fail to parse", {
#     expect_parse_reject("{ display 1+1; }\n")
#     expect_parse_reject("{
#         local name=1+1;
#         disp 45;
#         qui sum foo;
#     }\n")
# })
#
# test_that("Invalid general commands with no expression_list fail to parse", {
#     expect_parse_reject("exit\n")
#     expect_parse_reject("clear\n")
# })
#
# test_that("Invalid general commands with an expression_list fail to parse", {
#     expect_parse_reject("gen foo = 1\n")
#     expect_parse_reject("tab support treat\n")
#     expect_parse_reject("gen byte foo = 10\n")
#     expect_parse_reject("disp \"I'm a string\"\n")
#     expect_parse_reject("logit y x1 x2##i.x3 x4 c.x5#x6\n")
# })
#
# test_that("Invalid general commands with an option list fail to parse", {
#     expect_parse_reject("exit, clear\n")
#     expect_parse_reject("count, opt\n")
#     expect_parse_reject("cmd, opt(arg) opt2(arg1) opt3(arg233) opt4\n")
# })
#
# test_that("Invalid general commands with an if clause and an option list fail to parse", {
#     expect_parse_reject("drop if in_universe == 0, force\n")
#     expect_parse_reject("keep if good == 1, force\n")
#     expect_parse_reject("cmd if good_case + 1, opt opt2(val)\n")
# })
#
# test_that("Invalid general commands with an expression list and an if clause fail to parse", {
#     expect_parse_reject("logit y x1 x2 x3 if treat != 3\n")
#     expect_parse_reject("drop if hhid > 9999\n")
#     expect_parse_reject("gen y = 1 if income > 50000\n"
#     expect_parse_reject("replace income = 0 if income <= 50000\n")
# })
#
# test_that("Invalid general commands with an expression list and an in clause fail to parse", {
#     expect_parse_reject("logit y x1 x2 x3 in 3 / 4\n")
#     expect_parse_reject("drop in -5 / 6\n")
#     expect_parse_reject("gen y = 1 in 34 / L\n")
#     expect_parse_reject("gen y = 1 in F / 34\n")
#     expect_parse_reject("gen y = 1 in 34\n")
#     expect_parse_reject("gen y = 1 in l\n")
#     expect_parse_reject("replace income = 0 in -24 / F\n")
# })
#
# test_that("Invalid general commands with an expression list and a weight clause fail to parse", {
#     expect_parse_reject("tab support treat [pweight=weight]\n")
#     expect_parse_reject("reg y x1 x2 x3 [aweight=weight]\n")
#     expect_parse_reject("logit z y1 y2##y10 y3 [iweight = wgt]\n")
#     expect_parse_reject("mlogit z y2 y3 c.y5#y9 [aweight = wgt]\n")
# })
#
# test_that("Invalid general commands with an expression list and a using clause fail to parse", {
#     expect_parse_reject('insheet using "myfile.csv"\n')
#     expect_parse_reject('insheet using "myfile.csv", comma clear\n')
#     expect_parse_reject('save using "foobar.dta"\n')
#     expect_parse_reject('save using "foobar.dta", replace\n')
# })
#
# test_that("Invalid general commands with an expression list and an option list fail to parse", {
#     expect_parse_reject("mlogit y x1 x2 x3, b(0)\n")
#     expect_parse_reject("reg voted treat i.race, cluster(hhid)\n")
#     expect_parse_reject("mlogit voted treat i.race, cluster(hhid) b(1)\n")
#     expect_parse_reject("egen v = std(var1 + var2), missing\n")
#     expect_parse_reject("egen v = mode(var3), minmode\n")
# })
#
# test_that("Invalid embedded code blocks fail to parse", {
#     expect_parse_reject('{{{
#         y <- as.call(list(as.symbol("foobar"), 1, 2, 3, "abc"));
#         print(y);
#     }}}\n')
#
#     expect_parse_reject('{{{ print(1); }}}\n')
#     expect_parse_reject('{{{ }}}\n')
# })
#
# test_that("Invalid use of the merge command fails to parse", {
#     expect_parse_reject('merge 1:m id using "final.dta"\n')
#     expect_parse_reject('merge 1:1 id using "final.dta"\n')
#     expect_parse_reject('merge m:1 id using "final.dta"\n')
#     expect_parse_reject('merge m:m id using "final.dta"\n')
#     expect_parse_reject('merge m:1 id firstname lastname using "final.dta"\n')
#     expect_parse_reject('merge m:m id lastname using "final.dta", gen(foo)\n')
# })
#
# test_that("Invalid use of the xi command fails to parse", {
#     expect_parse_reject('xi var1\n')
#     expect_parse_reject('xi var1 var2\n')
#     expect_parse_reject('xi var1 var2, opt\n')
#     expect_parse_reject('xi var1 var2, opt opt2(param)\n')
# })
#
# test_that("Invalid use of the ivregress command fails to parse", {
#     expect_parse_reject('ivregress 2sls y x1 x2 x3 (contact = treat)\n')
#     expect_parse_reject('ivregress 2sls y x1 x2 x3 (contact = treat) if treat != 4, cluster(household)\n')
# })
#
# test_that("Invalid use of the gsort command fails to parse", {
#     expect_parse_reject('gsort +hhid -phone_score\n')
#     expect_parse_reject('gsort +hhid -phone_score, mfirst\n')
# })
#
# test_that("Invalid use of the collapse command fails to parse", {
#     expect_parse_reject('collapse support voteprop\n')
#     expect_parse_reject('collapse support voteprop, by(track)\n')
#     expect_parse_reject('collapse support voteprop id=id\n')
#     expect_parse_reject('collapse support voteprop id=id, by(track)\n')
#     expect_parse_reject('collapse (mean) support voteprop\n')
#     expect_parse_reject('collapse (mean) support voteprop (first) state\n')
#     expect_parse_reject('collapse (mean) support voteprop (first) state id=id\n')
#     expect_parse_reject('collapse (mean) support voteprop (first) state, by(track)\n')
#     expect_parse_reject('collapse (mean) support voteprop (first) state id=id, by(track)\n')
# })
#
# test_that("Invalid use of the lrtest command fails to parse", {
#     expect_parse_reject('lrtest A (B C)\n')
#     expect_parse_reject('lrtest . (B C)\n')
# })
#
# test_that("Invalid use of the anova command fails to parse", {
#     expect_parse_reject('anova y i.x\n')
#     expect_parse_reject('anova y i.x#z\n')
#     expect_parse_reject('anova y i.x##c.z\n')
#     expect_parse_reject('anova y i.x|c.z\n')
#     expect_parse_reject('anova y i.x|c.z /\n')
#     expect_parse_reject('anova y i.x|c.z /, option(val)\n')
# })
#
# test_that("Invalid use of the recode command fails to parse", {
#     expect_parse_reject('recode treat (2 3 = 1)\n')
#     expect_parse_reject('recode treat1 treat2 (2 3 = 1) (4 5 = 9)\n')
#     expect_parse_reject('recode treat1 treat2 (2 3 = 1) (4/5 = 9)\n')
#     expect_parse_reject('recode treat1 treat2 (2 . = 1) (4/5 = 9)\n')
#     expect_parse_reject('recode treat1 treat2 (2 . = 1) (4/5 = 9)\n')
#     expect_parse_reject('recode treat1 treat2 (missing = 1) (4/5 = 9)\n')
#     expect_parse_reject('recode treat1 treat2 (missing = 1) (4/5 = 9), gen(newvar)\n')
# })
#
# test_that("Invalid prefix commands fail to parse with a general command", {
#     expect_parse_reject('quietly gen foobar = 1\n')
#     expect_parse_reject('qui gen foobar = 1\n')
#     expect_parse_reject('qui cap gen foo = 1\n')
#     expect_parse_reject('by state: tab foo bar\n')
#     expect_parse_reject('qui by state: tab foo bar\n')
#     expect_parse_reject('qui cap by state: tab foo bar\n')
#     expect_parse_reject('qui by state: cap tab foo bar\n')
# })
#
# test_that("Invalid prefix commands fail to parse with a special command", {
#     expect_parse_reject('quietly ivregress 2sls y x1 x2 x3 (contact = treat)\n')
#     expect_parse_reject('qui ivregress 2sls y x1 x2 x3 (contact = treat)\n')
#     expect_parse_reject('qui cap ivregress 2sls y x1 x2 x3 (contact = treat)\n')
#     expect_parse_reject('by state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
#     expect_parse_reject('noisily by state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
#     expect_parse_reject('qui cap bysort state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
#     expect_parse_reject('noisily by state: cap ivregress 2sls y x1 x2 x3 (contact = treat)\n')
# })
#
# test_that("Invalid macro manipulation commands fail to parse", {
#     expect_parse_reject('local foo "bar"\n')
#     expect_parse_reject('local mac\n')
#     expect_parse_reject('local foo = 1+1\n')
#     expect_parse_reject('tempfile foobar\n')
#     expect_parse_reject('macro drop\n')
#     expect_parse_reject('macro dir\n')
# })
#
# test_that("Invalid if statements fail to parse", {
#     expect_parse_reject('if 1 {
#         di "foo"
#     }\n')
#
#     expect_parse_reject("if `foo' + 3 >= 7 {
#         disp \"it worked\"
#     }\n")
# })
#
# test_that("Invalid forvalues loops fail to parse", {
#     expect_parse_reject("forvalues i = 45 / 98 {
#         gen var`i' = `i'
#     }\n")
#
#     expect_parse_reject("forvalues i = 45 / 98 { // this is a short comment that the scanner should remove from the input
#         gen var`i' = `i'
#     }\n")
#
#     expect_parse_reject("forvalues i = 45 / 98 { /* this is a long comment that the scanner should remove from the input */
#         gen var`i' = `i'
#     }\n")
#
#     expect_parse_reject("forvalues i = 45(2)98 {
#         gen var`i' = `i'
#     }\n")
#
#     expect_parse_reject("forvalues i = 45 2: 98 {
#         gen var`i' = `i'
#     }\n")
#
#     expect_parse_reject("forvalues i = 45 2 to 98 {
#         gen var`i' = `i'
#     }\n")
# })
#
# test_that("Invalid foreach loops fail to parse", {
#     expect_parse_reject("foreach i of 1 2 3 4 5 6 {
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of 1 2 3 4 5 6 { // this is a short comment that the scanner should remove from the input
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of 1 2 3 4 5 6 { /* this is a long comment that the scanner should remove from the input */
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of bar baz foo quux {
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of bar baz foo quux {
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of local nums {
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of global nums {
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of varlist bar baz foo quux {
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of newlist bar baz foo quux {
#         disp `i'
#     }\n")
#
#     expect_parse_reject("foreach i of numlist 1 2 3 4 {
#         disp `i'
#     }\n")
# })
#
