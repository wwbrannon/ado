context("The semantic analyzer accepts valid input")

test_that("Literals are accepted", {
  # ado_number
  expect_semantic_accept("disp 123\n")
  expect_semantic_accept("disp 123.456\n")
  expect_semantic_accept("disp .\n")
  expect_semantic_accept("disp 0x1f\n")
  expect_semantic_accept("disp 077\n")

  # ado_string_literal
  expect_semantic_accept('disp "hello"\n')
  expect_semantic_accept('disp ""\n')
  expect_semantic_accept('disp `"nested "quotes" here"\'\n')

  # ado_ident
  expect_semantic_accept("disp var1\n")
  expect_semantic_accept("disp _var\n")
  expect_semantic_accept("disp var_name_123\n")

  # ado_datetime
  expect_semantic_accept("disp 01jan2020\n")
  expect_semantic_accept("disp 15dec2025 12:30:45\n")

  # ado_format_spec
  expect_semantic_accept("disp %10.2f\n")
  expect_semantic_accept("disp %-12s\n")
  expect_semantic_accept("disp %21x\n")
  expect_semantic_accept("disp %tcDDmonCCYY\n")
})

test_that("Loops are accepted", {
  # ado_foreach
  expect_semantic_accept("foreach i of varlist x y z {
    disp `i'
  }")
  expect_semantic_accept("foreach i in 1 2 3 {
    disp `i'
  }")

  # ado_forvalues
  expect_semantic_accept("forvalues i = 1/10 {
    disp `i'
  }")
  expect_semantic_accept("forvalues j = 1(2)20 {
    disp `j'
  }")
})

test_that("Command clauses are accepted", {
  # ado_if_clause
  expect_semantic_accept("list if x > 5\n")
  expect_semantic_accept("drop if missing(y)\n")

  # ado_in_clause
  expect_semantic_accept("list in 1/10\n")
  expect_semantic_accept("list in 5\n")
  expect_semantic_accept("list in -10/-1\n")

  # ado_using_clause
  expect_semantic_accept('use using "data.dta"\n')
  expect_semantic_accept('save using "output.dta"\n')

  # ado_weight_clause
  expect_semantic_accept("regress y x [fw=wt]\n")
  expect_semantic_accept("summarize var [aw=weight]\n")

  # ado_option and ado_option_list
  expect_semantic_accept("list, noobs\n")
  expect_semantic_accept("summarize x, detail\n")
  expect_semantic_accept("regress y x, robust noconstant\n")
})

test_that("Commands are accepted", {
  # ado_general_cmd
  expect_semantic_accept("display 123\n")
  expect_semantic_accept("gen newvar = x + y\n")
  expect_semantic_accept("drop var1 var2\n")

  # ado_compound_cmd (multiple commands)
  expect_semantic_accept("disp 1; disp 2; disp 3\n")

  # ado_if_cmd
  expect_semantic_accept('if 1 {
    disp "true"
  }')
  expect_semantic_accept('if x > 0 {
    disp "positive"
  } else {
    disp "non-positive"
  }')

  # ado_modifier_cmd
  expect_semantic_accept("quietly summarize x\n")
  expect_semantic_accept("noisily gen y = x^2\n")

  # ado_embedded_code
  expect_semantic_accept('{{{
    print("R code here")
  }}}')
})

test_that("Expression lists are accepted", {
  # ado_expression_list
  expect_semantic_accept("list x y z\n")
  expect_semantic_accept("drop var1 var2 var3\n")

  # ado_argument_expression_list
  expect_semantic_accept("disp sqrt(16)\n")
  expect_semantic_accept("disp max(x, y, z)\n")
})

test_that("Expressions are accepted", {
  # Arithmetic expressions
  expect_semantic_accept("disp 1 + 2\n")
  expect_semantic_accept("disp x * y + z\n")
  expect_semantic_accept("gen result = (a + b) / c\n")

  # Logical expressions
  expect_semantic_accept("disp 1 & 0\n")
  expect_semantic_accept("disp x | y\n")
  expect_semantic_accept("list if !missing(x)\n")

  # Relational expressions
  expect_semantic_accept("list if x > 5\n")
  expect_semantic_accept("list if x >= 5 & x < 10\n")
  expect_semantic_accept("gen flag = x == y\n")

  # Factor expressions
  expect_semantic_accept("regress y i.group\n")
  expect_semantic_accept("regress y i.group#c.x\n")
  expect_semantic_accept("regress y i.group##c.x\n")

  # Postfix expressions (function calls, indexing)
  expect_semantic_accept("disp sqrt(16)\n")
  expect_semantic_accept("disp x[5]\n")
  expect_semantic_accept("disp func(a, b, c)\n")

  # Power expressions
  expect_semantic_accept("gen y = x^2\n")
  expect_semantic_accept("disp 2^8\n")

  # Unary expressions
  expect_semantic_accept("disp -x\n")
  expect_semantic_accept("disp +5\n")
})

test_that("Type expressions are accepted", {
  expect_semantic_accept("gen byte newvar = 1\n")
  expect_semantic_accept("gen int count = _n\n")
  expect_semantic_accept("gen long bignum = 100000\n")
  expect_semantic_accept("gen float price = 9.99\n")
  expect_semantic_accept("gen double precise = 1.234567890\n")
  expect_semantic_accept("gen str20 name = \"test\"\n")
  expect_semantic_accept("gen strL text = \"long text\"\n")
})

test_that("Complex combined constructs are accepted", {
  # Commands with multiple clauses
  expect_semantic_accept("list x y if x > 5 in 1/10, noobs\n")
  expect_semantic_accept("regress y x1 x2 if group == 1 [fw=wt], robust\n")

  # Nested loops
  expect_semantic_accept("foreach i in 1 2 3 {
    forvalues j = 1/5 {
      disp `i' `j'
    }
  }")

  # Complex expressions
  expect_semantic_accept("gen complex = (x + y) * z / (a - b)^2\n")
  expect_semantic_accept("list if (x > 5 & y < 10) | (z == 0)\n")
})

