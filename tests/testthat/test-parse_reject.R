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

test_that("Invalid type constructors fail to parse", {
    expect_parse_reject("gen foo byte = 1\n")
    expect_parse_reject("gen foo byte\n")
    expect_parse_reject("gen byte(byte var2 var3) byte baz\n")
    expect_parse_reject("gen var1(byte var2 var3) byte baz\n")
    expect_parse_reject("gen foo = int 1\n")
    expect_parse_reject("gen foo int\n")
    expect_parse_reject("gen (int var1 var2 var3) byte baz\n")
    expect_parse_reject("gen (var1 var2 var3) long int baz\n")
    expect_parse_reject("gen doble foo = 1\n")
    expect_parse_reject("gen (var1 var2 var3 double) long baz\n")
    expect_parse_reject("gen foo = 1 strL\n")
    expect_parse_reject("gen foo strL\n")
    expect_parse_reject("gen strL(var1 strL var2 var3) int baz\n")
    expect_parse_reject("gen var1 strL var2 var3) int baz\n")
    expect_parse_reject("gen str(var1 strL var2 var3) int baz\n")
    expect_parse_reject("gen var1 str var2 var3) int baz\n")
    expect_parse_reject("gen str987(var1 strL var2 var3) int baz\n")
    expect_parse_reject("gen var1 str987 var2 var3) int baz\n")
})

test_that("Invalid factor expressions and factorial operators fail to parse", {
    expect_parse_reject("logit y c..var1\n")
    expect_parse_reject("logit y i..var1\n")
    expect_parse_reject("logit y bn.bn.myvar\n")
    expect_parse_reject("logit y ib.(freq).zazz\n")
    expect_parse_reject("logit y b./(last).quux\n")
    expect_parse_reject("logit y ib(ib(first)).baz\n")
    expect_parse_reject("logit y b3...foo\n")
    expect_parse_reject("logit y ibib3.var\n")
    expect_parse_reject("logit y b(###4).foo\n")
    expect_parse_reject("logit y ib(#5#ib.).var\n")
    expect_parse_reject("logit y #i3#.treat\n")
    expect_parse_reject("logit y i(3 ib.8 5 7).var\n")
    expect_parse_reject("logit y i(i.b.0 1).var\n")
    expect_parse_reject("logit y i(4.b/2).var\n")
    expect_parse_reject("logit y io(#3).var\n")
    expect_parse_reject("logit y o(3 ## 8).var\n")
})

test_that("Invalid relational and equality expressions fail to parse", {
    expect_parse_reject("gen foo == var == var1\n")
    expect_parse_reject("gen foo != var = 4\n")
    expect_parse_reject("disp var1 == > var2\n")
    expect_parse_reject("disp var1 >== var2\n")
    expect_parse_reject("disp var1 -< var2\n")
})

test_that("Invalid logical expressions fail to parse", {
    expect_parse_reject("disp var2 || var1\n")
    expect_parse_reject("disp var2 && var1\n")
    expect_parse_reject("gen foo = var1 >< var2 | var1 | > var3\n")
    expect_parse_reject("gen foo = var1 << var2 & var1 => var3\n")
    expect_parse_reject("gen foo = (!var1 < var2 !& var1 > var3)\n")
})

test_that("Invalid assignment expressions fail to parse", {
    expect_parse_reject("gen foo == var\n")
    expect_parse_reject("gen foo = 1 = 3\n")
    expect_parse_reject("gen foo = 1 = var + 3.4\n")
    expect_parse_reject('gen = foo = "string"\n')
    expect_parse_reject('gen foo =() seq()\n')
    expect_parse_reject("gen foo =[2] seq[3]\n")
    expect_parse_reject("gen foo = var4 = (var1 < var2 | var1 > var3)\n")
})

test_that("Invalid long comments fail to parse", {
    expect_parse_reject("this is a long comment */ disp foo\n")
    expect_parse_reject("/* this is a long comment disp foo\n")
    expect_parse_reject("/* /* */ this is a long comment disp foo\n")
    expect_parse_reject("/* /* */ this is a long comment */ disp foo\n")
    expect_parse_reject("disp foo /* not /* */displayed */\n")
})

test_that("Invalid compound command blocks fail to parse", {
    expect_parse_reject("display 1+1; }\n")
    expect_parse_reject("{ display 1+1;\n")
})

test_that("Invalid general commands with no expression_list fail to parse", {
    expect_parse_reject("1\n")
    expect_parse_reject('"foo"\n')
})

test_that("Invalid general commands with an expression_list fail to parse", {
    expect_parse_reject("1 foo = 1\n")
    expect_parse_reject("'tab' support treat\n")
    expect_parse_reject("`\"gen\"' byte foo = 10\n")
})

test_that("Invalid general commands with an option list fail to parse", {
    expect_parse_reject("1, clear\n")
    expect_parse_reject("'count', opt\n")
    expect_parse_reject("'i am a bad command', opt(arg) opt2(arg1) opt3(arg233) opt4\n")
    expect_parse_reject("cmd, opt((arg) opt2(arg1) opt3(arg233) opt4\n")
    expect_parse_reject("cmd, opt((arg) opt2(arg1) opt3+(arg233) opt4\n")
})

test_that("Invalid general commands with an expression list and an if clause fail to parse", {
    expect_parse_reject("logit y x1 x2 x3 if if treat != 3\n")
    expect_parse_reject("drop if when hhid > 9999\n")
    expect_parse_reject("gen y = 1 if income <> 50000\n")
    expect_parse_reject("replace income = 0 if replace income <= 50000\n")
})

test_that("Invalid general commands with an expression list and an in clause fail to parse", {
    expect_parse_reject("gen y = 1 in 34 / L / F / 34\n")
    expect_parse_reject("gen y = 1 in l34\n")
    expect_parse_reject("gen y = 1 in llllll\n")
    expect_parse_reject("replace income = 0 in F / -24 / F\n")
})

test_that("Invalid general commands with an expression list and a weight clause fail to parse", {
    expect_parse_reject("tab support treat [pweight==weight]\n")
    expect_parse_reject("reg y x1 x2 x3 [aweight!=weight]\n")
    expect_parse_reject("logit z y1 y2##y10 y3 [iweight == wgt]\n")
})

test_that("Invalid general commands with an expression list and a using clause fail to parse", {
    expect_parse_reject('insheet using 1 2 "myfile.csv"\n')
    expect_parse_reject('insheet using "foo" "myfile.csv", comma clear\n')
    expect_parse_reject('save using\n')
    expect_parse_reject('save using 34 "foobar.dta", replace\n')
})

test_that("Invalid general commands with an expression list and an option list fail to parse", {
    expect_parse_reject("mlogit y x1 x2 x3, , b(0)\n")
    expect_parse_reject("reg voted treat, i.race, cluster(hhid)\n")
    expect_parse_reject("mlogit voted treat i.race, cluster((hhid) b(1)\n")
    expect_parse_reject("egen v = std(var1 + var2), m,issing\n")
})

test_that("Invalid embedded code blocks fail to parse", {
    expect_parse_reject('{{{
        y <- as.call(list(as.symbol("foobar"), 1, 2, 3, "abc"));
        print(y);
    }}\n')
    expect_parse_reject('{{
        y <- as.call(list(as.symbol("foobar"), 1, 2, 3, "abc"));
        print(y);
    }}}\n')
    expect_parse_reject('{{{{{{ print(1); }}}}}}\n')
})

test_that("Invalid use of the merge command fails to parse", {
    expect_parse_reject('merge 1m id using "final.dta"\n')
    expect_parse_reject('merge id using "final.dta"\n')
    expect_parse_reject('merge m:n id using "final.dta"\n')
    expect_parse_reject('merge m:7 id using "final.dta"\n')
    expect_parse_reject('merge 1 id firstname lastname using "final.dta"\n')
    expect_parse_reject('merge using "final.dta", gen(foo)\n')
})

test_that("Invalid use of the xi command fails to parse", {
    expect_parse_reject('xi\n')
    expect_parse_reject('xi, opt\n')
})

test_that("Invalid use of the ivregress command fails to parse", {
    expect_parse_reject('ivregress y x1 x2 x3 (contact = treat)\n')
    expect_parse_reject('ivregress 2foo y x1 x2 x3 (contact = treat) if treat != 4, cluster(household)\n')
    expect_parse_reject('ivregress 2foo y x1 x2 x3 if treat != 4, cluster(household)\n')
})

test_that("Invalid use of the gsort command fails to parse", {
    expect_parse_reject('gsort\n')
    expect_parse_reject('gsort +hhid --phone_score, mfirst\n')
    expect_parse_reject('gsort =hhid --phone_score, mfirst\n')
})

test_that("Invalid use of the collapse command fails to parse", {
    expect_parse_reject('collapse\n')
    expect_parse_reject('collapse (mean) (mean) support voteprop\n')
    expect_parse_reject('collapse (mean) (mean) support voteprop, by(foo)\n')
})

test_that("Invalid use of the lrtest command fails to parse", {
    expect_parse_reject('lrtest () A\n')
    expect_parse_reject('lrtest . ()\n')
})

test_that("Invalid use of the anova command fails to parse", {
    expect_parse_reject('anova i.x\n')
    expect_parse_reject('anova\n')
    expect_parse_reject('anova y i.x||c.z\n')
    expect_parse_reject('anova y i.xc.z /\n')
    expect_parse_reject('anova y i.x|c.z |/, option(val)\n')
})

test_that("Invalid use of the recode command fails to parse", {
    expect_parse_reject('recode treat (2 3 1)\n')
    expect_parse_reject('recode treat1 treat2 (2 3 = 1) (4/5/ = 9)\n')
})

test_that("Invalid prefix commands fail to parse with a general command", {
    expect_parse_reject('by state: foo: tab foo bar\n')
    expect_parse_reject('qui by: state: tab foo bar\n')
    expect_parse_reject('qui cap: by state: tab foo bar\n')
    expect_parse_reject('qui: by state: cap tab foo bar\n')
})

test_that("Invalid prefix commands fail to parse with a special command", {
    expect_parse_reject('by: state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_reject('noisily: by state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_reject('qui: cap bysort state: ivregress 2sls y x1 x2 x3 (contact = treat)\n')
    expect_parse_reject('noisily by / state: cap ivregress 2sls y x1 x2 x3 (contact = treat)\n')
})

test_that("Invalid if statements fail to parse", {
    expect_parse_reject('if if 1 {
        di "foo"
    }\n')

    expect_parse_reject('if 1 {}\n')
})

test_that("Invalid forvalues loops fail to parse", {
    expect_parse_reject("forvalues i 45 / 98 {
        gen var`i' = `i'
    }\n")

    expect_parse_reject("forvalues i = 45 / 98 {
        gen var`i' = `i'
    \n")

    expect_parse_reject("fervalues i = 45 / 98 {
        gen var`i' = `i'
    }\n")

    expect_parse_reject("forvalues i = 45 / / 98 {
        gen var`i' = `i'
    }\n")

    expect_parse_reject("forvalues i i = 45 / 98 {
        gen var`i' = `i'
    }\n")

    expect_parse_reject("forvalues i = 45/2/98 {
        gen var`i' = `i'
    }\n")

    expect_parse_reject("forvalues i = 45 :2: 98 {
        gen var`i' = `i'
    }\n")

    expect_parse_reject("forvalues i = i 45 2 to 98 {
        gen var`i' = `i'
    }\n")
})

test_that("Invalid foreach loops fail to parse", {
    expect_parse_reject("foreach i 1 2 3 4 5 6 {
        disp `i'
    }\n")

    expect_parse_reject("foreach i of 1 2 3 4 5 6 {
        disp `i'
    \n")

    expect_parse_reject("foreach i of 1 2 3 4 5 6
        disp `i'
    }\n")

    expect_parse_reject("foreach i of 1 2 3 of 4 5 6 {
        disp `i'
    }\n")

    expect_parse_reject("forech i of 1 2 3 4 5 6 {
        disp `i'
    }\n")

    expect_parse_reject("foreach i bar baz foo quux {
        disp `i'
    }\n")
})

