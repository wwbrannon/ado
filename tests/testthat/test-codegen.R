context("The code generator produces the correct R expression on valid input")

test_that("Literals generate correctly", {
  # ado_number
  expect_codegen_succeeds("disp 123\n")
  expect_codegen_succeeds("disp 3.14159\n")
  expect_codegen_succeeds("disp .\n")

  # ado_string_literal
  expect_codegen_succeeds('disp "hello"\n')
  expect_codegen_succeeds('disp `"nested "quotes""\'\n')

  # ado_ident
  expect_codegen_succeeds("disp var1\n")
  expect_codegen_succeeds("disp _myvar\n")

  # ado_format_spec
  expect_codegen_succeeds("disp %10.2f\n")
})

test_that("Datetime literals generate correctly", {
  skip("datetime codegen not implemented yet")
  expect_codegen_succeeds("disp 01jan2020\n")
})

test_that("Loops generate correctly", {
  # ado_foreach
  expect_codegen_succeeds("foreach i in 1 2 3 {
    disp `i'
  }")
  expect_codegen_succeeds("foreach i of varlist x y z {
    disp `i'
  }")

  # ado_forvalues
  expect_codegen_succeeds("forvalues i = 1/10 {
    disp `i'
  }")
  expect_codegen_succeeds("forvalues i = 1(2)20 {
    disp `i'
  }")
})

test_that("Commands generate correctly", {
  # ado_general_cmd
  expect_codegen_succeeds("display 123\n")
  expect_codegen_succeeds("gen x = 5\n")

  # ado_compound_cmd
  expect_codegen_succeeds("disp 1; disp 2\n")

  # ado_if_cmd
  expect_codegen_succeeds('if 1 {
    disp "true"
  }')

  # ado_modifier_cmd
  expect_codegen_succeeds("quietly summarize x\n")

  # ado_embedded_code
  expect_codegen_succeeds('{{{
    x <- 1 + 1
  }}}')
})

test_that("Command clauses generate correctly", {
  # ado_if_clause
  expect_codegen_succeeds("list if x > 5\n")

  # ado_in_clause
  expect_codegen_succeeds("list in 1/10\n")

  # ado_using_clause
  expect_codegen_succeeds('use using "data.dta"\n')

  # ado_option and ado_option_list
  expect_codegen_succeeds("list, noobs\n")
  expect_codegen_succeeds("summarize x, detail\n")
})

test_that("Expression lists generate correctly", {
  # ado_expression_list
  expect_codegen_succeeds("list x y z\n")

  # ado_argument_expression_list
  expect_codegen_succeeds("disp max(1, 2, 3)\n")
})

test_that("Expressions generate correctly", {
  # Arithmetic expressions
  expect_codegen_succeeds("disp 1 + 2\n")
  expect_codegen_succeeds("disp x * y + z\n")
  expect_codegen_succeeds("gen result = a / b\n")

  # Power expressions
  expect_codegen_succeeds("disp 2^8\n")
  expect_codegen_succeeds("gen y = x^2\n")

  # Unary expressions
  expect_codegen_succeeds("disp -x\n")
  expect_codegen_succeeds("disp +5\n")

  # Logical expressions
  expect_codegen_succeeds("disp 1 & 0\n")
  expect_codegen_succeeds("disp x | y\n")

  # Relational expressions
  expect_codegen_succeeds("list if x > 5\n")
  expect_codegen_succeeds("list if x == y\n")

  # Equality expressions
  expect_codegen_succeeds("gen flag = x == y\n")

  # Postfix expressions
  expect_codegen_succeeds("disp sqrt(16)\n")
  expect_codegen_succeeds("disp x[5]\n")

  # Factor expressions
  expect_codegen_succeeds("regress y i.group\n")
  expect_codegen_succeeds("regress y c.x\n")

  # Cross expressions
  expect_codegen_succeeds("regress y i.group#c.x\n")
  expect_codegen_succeeds("regress y i.group##c.x\n")
})

test_that("Type expressions generate correctly", {
  expect_codegen_succeeds("gen byte x = 1\n")
  expect_codegen_succeeds("gen int count = _n\n")
  expect_codegen_succeeds("gen str20 name = \"test\"\n")
  expect_codegen_succeeds("gen double price = 9.99\n")
})

test_that("Complex combined constructs generate correctly", {
  # Commands with multiple clauses
  expect_codegen_succeeds("list x y if x > 5 in 1/10, noobs\n")

  # Nested loops
  expect_codegen_succeeds("foreach i in 1 2 3 {
    forvalues j = 1/5 {
      disp `i' `j'
    }
  }")

  # Complex expressions
  expect_codegen_succeeds("gen result = (x + y) * z / (a - b)^2\n")
  expect_codegen_succeeds("list if (x > 5 & y < 10) | (z == 0)\n")
})

test_that("Weight clauses generate correctly", {
  skip("weight clause codegen not implemented yet")
  expect_codegen_succeeds("regress y x [fw=wt]\n")
})
