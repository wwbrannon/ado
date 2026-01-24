# Grammar Design Notes

## Shift/Reduce Conflicts

### Type Keywords as Identifiers (12 conflicts)

**Status**: Intentional and correctly resolved

**Background**: Type keywords (`byte`, `int`, `long`, `float`, `double`, `str`, `strL`) serve dual purposes:
1. **Type specifiers**: `gen byte x = 1`, `byte(expression)`
2. **Identifiers**: `local byte = 5`, `anova y byte`

**Conflict Details**:

When the parser encounters a type keyword followed by `IDENT` or `(`, it faces a shift/reduce conflict:

```
Input: BYTE IDENT
Conflict:
  - SHIFT: Continue reading to form type specification (BYTE IDENT → primary_expression)
  - REDUCE: Reduce BYTE to literal_expression immediately
```

**Resolution**: Bison's default behavior is to **SHIFT**, which is correct for our needs.

**Grammar Rules Involved**:

1. In `literal_expression`:
   ```yacc
   literal_expression:
       ...
     | BYTE     /* Can be used as identifier */
     | INT      /* Can be used as identifier */
     ...
   ```

2. In `primary_expression`:
   ```yacc
   primary_expression:
       ...
     | BYTE IDENT               /* Type specification: gen byte x */
     | BYTE "(" expression_list ")"   /* Type conversion: byte(x) */
     ...
   ```

**Conflict Breakdown**:
- 6 type keywords (BYTE, INT, LONG, FLOAT, DOUBLE, STRING_TYPE_SPEC)
- 2 contexts per keyword (followed by IDENT or followed by "(")
- Total: 12 shift/reduce conflicts

**Test Coverage**: See `tests/testthat/test-e2e.R` for test cases verifying:
- Type keywords as type specifiers work: `gen byte x = 1`
- Type keywords as identifiers work: `local str = "world"`
- Type keywords in expressions work: `anova y byte`

**Why Not Use Precedence Declarations?**

Precedence declarations (`%prec`) were attempted but caused "useless rule" warnings, indicating they interfered with the grammar in unexpected ways. Since Bison's default shift behavior is correct, explicit documentation is clearer and safer than precedence manipulation.

**For Future Grammar Developers**:

1. **DO NOT** try to eliminate these conflicts by restricting where type keywords can appear
2. **DO NOT** use precedence declarations to "silence" the warnings
3. **DO** verify that `make parser` reports exactly 12 shift/reduce conflicts
4. **DO** ensure tests in `test-e2e.R` pass, especially the string literal assignment test
5. **DO** add test cases when introducing new type keywords

**Historical Note**:

This design replaces the previous `type_operator` non-terminal approach, which created reduce/reduce conflicts. The current approach:
- Eliminated the intermediate `type_operator` non-terminal
- Inlined type tokens directly in both `literal_expression` and `primary_expression`
- Trades 12 reduce/reduce conflicts for 12 shift/reduce conflicts
- Results in clearer, more predictable parser behavior

**References**:
- Original bug fix: R/cmd_macro.R (comments at top)
- Implementation: src/parser/ado.ypp (literal_expression and primary_expression rules)
- Tests: tests/testthat/test-e2e.R (test_local_macro fixture)
