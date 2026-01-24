// A Bison parser, made by GNU Bison 3.8.2.

// Skeleton interface for Bison LALR(1) parsers in C++

// Copyright (C) 2002-2015, 2018-2021 Free Software Foundation, Inc.

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// As a special exception, you may create a larger work that contains
// part or all of the Bison parser skeleton and distribute that work
// under terms of your choice, so long as that work isn't itself a
// parser generator using the skeleton or a modified version thereof
// as a parser skeleton.  Alternatively, if you modify or redistribute
// the parser skeleton itself, you may (at your option) remove this
// special exception, which will cause the skeleton and the resulting
// Bison output files to be licensed under the GNU General Public
// License without this special exception.

// This special exception was added by the Free Software Foundation in
// version 2.2 of Bison.


/**
 ** \file ado.tab.hpp
 ** Define the yy::parser class.
 */

// C++ LALR(1) parser skeleton written by Akim Demaille.

// DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
// especially those whose name start with YY_ or yy_.  They are
// private implementation details that can be changed or removed.

#ifndef YY_YY_ADO_TAB_HPP_INCLUDED
# define YY_YY_ADO_TAB_HPP_INCLUDED
// "%code requires" blocks.
#line 13 "ado.ypp"

#include "Ado.hpp"
typedef void* yyscan_t;

#define YY_DECL int yylex(yy::AdoParser::semantic_type* yylval_param, \
                          yy::AdoParser::location_type* llocp,        \
                          ParseDriver& driver, yyscan_t yyscanner)      

#define R_ACTION(node) driver.wrap_cmd_action(node);
#define RETURN_AST(node) driver.set_ast(node);

#line 61 "ado.tab.hpp"


# include <cstdlib> // std::abort
# include <iostream>
# include <stdexcept>
# include <string>
# include <vector>

#if defined __cplusplus
# define YY_CPLUSPLUS __cplusplus
#else
# define YY_CPLUSPLUS 199711L
#endif

// Support move semantics when possible.
#if 201103L <= YY_CPLUSPLUS
# define YY_MOVE           std::move
# define YY_MOVE_OR_COPY   move
# define YY_MOVE_REF(Type) Type&&
# define YY_RVREF(Type)    Type&&
# define YY_COPY(Type)     Type
#else
# define YY_MOVE
# define YY_MOVE_OR_COPY   copy
# define YY_MOVE_REF(Type) Type&
# define YY_RVREF(Type)    const Type&
# define YY_COPY(Type)     const Type&
#endif

// Support noexcept when possible.
#if 201103L <= YY_CPLUSPLUS
# define YY_NOEXCEPT noexcept
# define YY_NOTHROW
#else
# define YY_NOEXCEPT
# define YY_NOTHROW throw ()
#endif

// Support constexpr when possible.
#if 201703 <= YY_CPLUSPLUS
# define YY_CONSTEXPR constexpr
#else
# define YY_CONSTEXPR
#endif
# include "location.hh"


#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YY_USE(E) ((void) (E))
#else
# define YY_USE(E) /* empty */
#endif

/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
#if defined __GNUC__ && ! defined __ICC && 406 <= __GNUC__ * 100 + __GNUC_MINOR__
# if __GNUC__ * 100 + __GNUC_MINOR__ < 407
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")
# else
#  define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                           \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# endif
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif

namespace yy {
#line 196 "ado.tab.hpp"




  /// A Bison parser.
  class  AdoParser 
  {
  public:
#ifdef YYSTYPE
# ifdef __GNUC__
#  pragma GCC message "bison: do not #define YYSTYPE in C++, use %define api.value.type"
# endif
    typedef YYSTYPE value_type;
#else
    /// Symbol semantic values.
    union value_type
    {
#line 29 "ado.ypp"

    std::string   *str;
    ExprNode      *node;

#line 219 "ado.tab.hpp"

    };
#endif
    /// Backward compatibility (Bison 3.8).
    typedef value_type semantic_type;

    /// Symbol locations.
    typedef location location_type;

    /// Syntax errors thrown from user actions.
    struct syntax_error : std::runtime_error
    {
      syntax_error (const location_type& l, const std::string& m)
        : std::runtime_error (m)
        , location (l)
      {}

      syntax_error (const syntax_error& s)
        : std::runtime_error (s.what ())
        , location (s.location)
      {}

      ~syntax_error () YY_NOEXCEPT YY_NOTHROW;

      location_type location;
    };

    /// Token kinds.
    struct token
    {
      enum token_kind_type
      {
        TOK_YYEMPTY = -2,
    TOK_END = 0,                   // "end of file"
    TOK_YYerror = 256,             // error
    TOK_YYUNDEF = 257,             // "invalid token"
    TOK_RELATIONAL = 258,          // RELATIONAL
    TOK_PLUS = 259,                // "+"
    TOK_MINUS = 260,               // "-"
    TOK_EXPONENT = 261,            // EXPONENT
    TOK_LPAREN = 262,              // "("
    TOK_NEWLINE = 263,             // NEWLINE
    TOK_SEMICOLON = 264,           // ";"
    TOK_RPAREN = 265,              // ")"
    TOK_COMMA = 266,               // ","
    TOK_LBRACE = 267,              // "{"
    TOK_RBRACE = 268,              // "}"
    TOK_LBRACKET = 269,            // "["
    TOK_RBRACKET = 270,            // "]"
    TOK_COLON = 271,               // ":"
    TOK_ASSIGN = 272,              // "="
    TOK_LT_OP = 273,               // "<"
    TOK_GT_OP = 274,               // ">"
    TOK_NEG_OP = 275,              // "!"
    TOK_STAR = 276,                // "*"
    TOK_SLASH = 277,               // "/"
    TOK_CARET = 278,               // "^"
    TOK_GE_OP = 279,               // ">="
    TOK_LE_OP = 280,               // "<="
    TOK_EQ_OP = 281,               // "=="
    TOK_NE_OP = 282,               // "!="
    TOK_OR_OP = 283,               // "|"
    TOK_AND_OP = 284,              // "&"
    TOK_FACT_CROSS = 285,          // "##"
    TOK_CROSS = 286,               // "#"
    TOK_NUMBER = 287,              // NUMBER
    TOK_IDENT = 288,               // IDENT
    TOK_STRING_LITERAL = 289,      // STRING_LITERAL
    TOK_DATE = 290,                // DATE
    TOK_DATETIME = 291,            // DATETIME
    TOK_PERIOD = 292,              // "."
    TOK_BYTE = 293,                // BYTE
    TOK_INT = 294,                 // INT
    TOK_LONG = 295,                // LONG
    TOK_FLOAT = 296,               // FLOAT
    TOK_DOUBLE = 297,              // DOUBLE
    TOK_STRING_TYPE_SPEC = 298,    // STRING_TYPE_SPEC
    TOK_STRING_FORMAT = 299,       // STRING_FORMAT
    TOK_DATETIME_FORMAT = 300,     // DATETIME_FORMAT
    TOK_NUMBER_FORMAT = 301,       // NUMBER_FORMAT
    TOK_EMBEDDED_CODE = 302,       // EMBEDDED_CODE
    TOK_BY = 303,                  // BY
    TOK_XI = 304,                  // XI
    TOK_BYSORT = 305,              // BYSORT
    TOK_QUIETLY = 306,             // QUIETLY
    TOK_CAPTURE = 307,             // CAPTURE
    TOK_NOISILY = 308,             // NOISILY
    TOK_MERGE = 309,               // MERGE
    TOK_COLLAPSE = 310,            // COLLAPSE
    TOK_IVREGRESS = 311,           // IVREGRESS
    TOK_RECODE = 312,              // RECODE
    TOK_GSORT = 313,               // GSORT
    TOK_LRTEST = 314,              // LRTEST
    TOK_ANOVA = 315,               // ANOVA
    TOK_TSLS = 316,                // TSLS
    TOK_USING = 317,               // USING
    TOK_IF = 318,                  // IF
    TOK_IN = 319,                  // IN
    TOK_WEIGHT_SPEC = 320,         // WEIGHT_SPEC
    TOK_MERGE_SPEC = 321,          // MERGE_SPEC
    TOK_CONT_OPERATOR = 322,       // CONT_OPERATOR
    TOK_IND_OPERATOR = 323,        // IND_OPERATOR
    TOK_BASE_OPERATOR = 324,       // BASE_OPERATOR
    TOK_OMIT_OPERATOR = 325,       // OMIT_OPERATOR
    TOK_FOREACH = 326,             // FOREACH
    TOK_FORVALUES = 327,           // FORVALUES
    TOK_LOCAL = 328,               // LOCAL
    TOK_GLOBAL = 329,              // GLOBAL
    TOK_VARLIST = 330,             // VARLIST
    TOK_NEWLIST = 331,             // NEWLIST
    TOK_NUMLIST = 332,             // NUMLIST
    TOK_TO = 333,                  // TO
    TOK_OF = 334                   // OF
      };
      /// Backward compatibility alias (Bison 3.6).
      typedef token_kind_type yytokentype;
    };

    /// Token kind, as returned by yylex.
    typedef token::token_kind_type token_kind_type;

    /// Backward compatibility alias (Bison 3.6).
    typedef token_kind_type token_type;

    /// Symbol kinds.
    struct symbol_kind
    {
      enum symbol_kind_type
      {
        YYNTOKENS = 80, ///< Number of tokens.
        S_YYEMPTY = -2,
        S_YYEOF = 0,                             // "end of file"
        S_YYerror = 1,                           // error
        S_YYUNDEF = 2,                           // "invalid token"
        S_RELATIONAL = 3,                        // RELATIONAL
        S_PLUS = 4,                              // "+"
        S_MINUS = 5,                             // "-"
        S_EXPONENT = 6,                          // EXPONENT
        S_LPAREN = 7,                            // "("
        S_NEWLINE = 8,                           // NEWLINE
        S_SEMICOLON = 9,                         // ";"
        S_RPAREN = 10,                           // ")"
        S_COMMA = 11,                            // ","
        S_LBRACE = 12,                           // "{"
        S_RBRACE = 13,                           // "}"
        S_LBRACKET = 14,                         // "["
        S_RBRACKET = 15,                         // "]"
        S_COLON = 16,                            // ":"
        S_ASSIGN = 17,                           // "="
        S_LT_OP = 18,                            // "<"
        S_GT_OP = 19,                            // ">"
        S_NEG_OP = 20,                           // "!"
        S_STAR = 21,                             // "*"
        S_SLASH = 22,                            // "/"
        S_CARET = 23,                            // "^"
        S_GE_OP = 24,                            // ">="
        S_LE_OP = 25,                            // "<="
        S_EQ_OP = 26,                            // "=="
        S_NE_OP = 27,                            // "!="
        S_OR_OP = 28,                            // "|"
        S_AND_OP = 29,                           // "&"
        S_FACT_CROSS = 30,                       // "##"
        S_CROSS = 31,                            // "#"
        S_NUMBER = 32,                           // NUMBER
        S_IDENT = 33,                            // IDENT
        S_STRING_LITERAL = 34,                   // STRING_LITERAL
        S_DATE = 35,                             // DATE
        S_DATETIME = 36,                         // DATETIME
        S_PERIOD = 37,                           // "."
        S_BYTE = 38,                             // BYTE
        S_INT = 39,                              // INT
        S_LONG = 40,                             // LONG
        S_FLOAT = 41,                            // FLOAT
        S_DOUBLE = 42,                           // DOUBLE
        S_STRING_TYPE_SPEC = 43,                 // STRING_TYPE_SPEC
        S_STRING_FORMAT = 44,                    // STRING_FORMAT
        S_DATETIME_FORMAT = 45,                  // DATETIME_FORMAT
        S_NUMBER_FORMAT = 46,                    // NUMBER_FORMAT
        S_EMBEDDED_CODE = 47,                    // EMBEDDED_CODE
        S_BY = 48,                               // BY
        S_XI = 49,                               // XI
        S_BYSORT = 50,                           // BYSORT
        S_QUIETLY = 51,                          // QUIETLY
        S_CAPTURE = 52,                          // CAPTURE
        S_NOISILY = 53,                          // NOISILY
        S_MERGE = 54,                            // MERGE
        S_COLLAPSE = 55,                         // COLLAPSE
        S_IVREGRESS = 56,                        // IVREGRESS
        S_RECODE = 57,                           // RECODE
        S_GSORT = 58,                            // GSORT
        S_LRTEST = 59,                           // LRTEST
        S_ANOVA = 60,                            // ANOVA
        S_TSLS = 61,                             // TSLS
        S_USING = 62,                            // USING
        S_IF = 63,                               // IF
        S_IN = 64,                               // IN
        S_WEIGHT_SPEC = 65,                      // WEIGHT_SPEC
        S_MERGE_SPEC = 66,                       // MERGE_SPEC
        S_CONT_OPERATOR = 67,                    // CONT_OPERATOR
        S_IND_OPERATOR = 68,                     // IND_OPERATOR
        S_BASE_OPERATOR = 69,                    // BASE_OPERATOR
        S_OMIT_OPERATOR = 70,                    // OMIT_OPERATOR
        S_FOREACH = 71,                          // FOREACH
        S_FORVALUES = 72,                        // FORVALUES
        S_LOCAL = 73,                            // LOCAL
        S_GLOBAL = 74,                           // GLOBAL
        S_VARLIST = 75,                          // VARLIST
        S_NEWLIST = 76,                          // NEWLIST
        S_NUMLIST = 77,                          // NUMLIST
        S_TO = 78,                               // TO
        S_OF = 79,                               // OF
        S_YYACCEPT = 80,                         // $accept
        S_translation_unit = 81,                 // translation_unit
        S_external_statement = 82,               // external_statement
        S_foreach_cmd = 83,                      // foreach_cmd
        S_forvalues_cmd = 84,                    // forvalues_cmd
        S_foreach_sep = 85,                      // foreach_sep
        S_if_cmd = 86,                           // if_cmd
        S_compound_cmd = 87,                     // compound_cmd
        S_cmds = 88,                             // cmds
        S_cmd = 89,                              // cmd
        S_cmd_sep = 90,                          // cmd_sep
        S_modifier_cmd = 91,                     // modifier_cmd
        S_long_modifier_cmd = 92,                // long_modifier_cmd
        S_modifier_cmd_list = 93,                // modifier_cmd_list
        S_nonmodifier_cmd = 94,                  // nonmodifier_cmd
        S_varlist = 95,                          // varlist
        S_number_or_missing = 96,                // number_or_missing
        S_numlist = 97,                          // numlist
        S_collapse_spec_base = 98,               // collapse_spec_base
        S_collapse_spec_base_list = 99,          // collapse_spec_base_list
        S_collapse_spec = 100,                   // collapse_spec
        S_collapse_list = 101,                   // collapse_list
        S_recode_rule = 102,                     // recode_rule
        S_recode_rule_list = 103,                // recode_rule_list
        S_gsort_var = 104,                       // gsort_var
        S_gsort_varlist = 105,                   // gsort_varlist
        S_modelspec = 106,                       // modelspec
        S_modelspec_list = 107,                  // modelspec_list
        S_anova_nest_expression = 108,           // anova_nest_expression
        S_anova_error_expression = 109,          // anova_error_expression
        S_anova_term_list = 110,                 // anova_term_list
        S_type_operator = 111,                   // type_operator
        S_assignment_operator = 112,             // assignment_operator
        S_unary_operator = 113,                  // unary_operator
        S_unary_factor_operator = 114,           // unary_factor_operator
        S_power_operator = 115,                  // power_operator
        S_multiplication_operator = 116,         // multiplication_operator
        S_additive_operator = 117,               // additive_operator
        S_relational_operator = 118,             // relational_operator
        S_equality_operator = 119,               // equality_operator
        S_logical_operator = 120,                // logical_operator
        S_cross_operator = 121,                  // cross_operator
        S_format_spec = 122,                     // format_spec
        S_literal_expression = 123,              // literal_expression
        S_primary_expression = 124,              // primary_expression
        S_unary_factor_expression = 125,         // unary_factor_expression
        S_cross_expression = 126,                // cross_expression
        S_postfix_expression = 127,              // postfix_expression
        S_power_expression = 128,                // power_expression
        S_unary_expression = 129,                // unary_expression
        S_multiplication_expression = 130,       // multiplication_expression
        S_additive_expression = 131,             // additive_expression
        S_relational_expression = 132,           // relational_expression
        S_equality_expression = 133,             // equality_expression
        S_logical_expression = 134,              // logical_expression
        S_expression = 135,                      // expression
        S_expression_list = 136,                 // expression_list
        S_argument_expression_list = 137,        // argument_expression_list
        S_option_list = 138,                     // option_list
        S_options = 139,                         // options
        S_option = 140,                          // option
        S_option_ident = 141,                    // option_ident
        S_weight_clause = 142,                   // weight_clause
        S_if_clause = 143,                       // if_clause
        S_in_clause = 144,                       // in_clause
        S_using_clause = 145                     // using_clause
      };
    };

    /// (Internal) symbol kind.
    typedef symbol_kind::symbol_kind_type symbol_kind_type;

    /// The number of tokens.
    static const symbol_kind_type YYNTOKENS = symbol_kind::YYNTOKENS;

    /// A complete symbol.
    ///
    /// Expects its Base type to provide access to the symbol kind
    /// via kind ().
    ///
    /// Provide access to semantic value and location.
    template <typename Base>
    struct basic_symbol : Base
    {
      /// Alias to Base.
      typedef Base super_type;

      /// Default constructor.
      basic_symbol () YY_NOEXCEPT
        : value ()
        , location ()
      {}

#if 201103L <= YY_CPLUSPLUS
      /// Move constructor.
      basic_symbol (basic_symbol&& that)
        : Base (std::move (that))
        , value (std::move (that.value))
        , location (std::move (that.location))
      {}
#endif

      /// Copy constructor.
      basic_symbol (const basic_symbol& that);
      /// Constructor for valueless symbols.
      basic_symbol (typename Base::kind_type t,
                    YY_MOVE_REF (location_type) l);

      /// Constructor for symbols with semantic value.
      basic_symbol (typename Base::kind_type t,
                    YY_RVREF (value_type) v,
                    YY_RVREF (location_type) l);

      /// Destroy the symbol.
      ~basic_symbol ()
      {
        clear ();
      }



      /// Destroy contents, and record that is empty.
      void clear () YY_NOEXCEPT
      {
        Base::clear ();
      }

      /// The user-facing name of this symbol.
      std::string name () const YY_NOEXCEPT
      {
        return  AdoParser ::symbol_name (this->kind ());
      }

      /// Backward compatibility (Bison 3.6).
      symbol_kind_type type_get () const YY_NOEXCEPT;

      /// Whether empty.
      bool empty () const YY_NOEXCEPT;

      /// Destructive move, \a s is emptied into this.
      void move (basic_symbol& s);

      /// The semantic value.
      value_type value;

      /// The location.
      location_type location;

    private:
#if YY_CPLUSPLUS < 201103L
      /// Assignment operator.
      basic_symbol& operator= (const basic_symbol& that);
#endif
    };

    /// Type access provider for token (enum) based symbols.
    struct by_kind
    {
      /// The symbol kind as needed by the constructor.
      typedef token_kind_type kind_type;

      /// Default constructor.
      by_kind () YY_NOEXCEPT;

#if 201103L <= YY_CPLUSPLUS
      /// Move constructor.
      by_kind (by_kind&& that) YY_NOEXCEPT;
#endif

      /// Copy constructor.
      by_kind (const by_kind& that) YY_NOEXCEPT;

      /// Constructor from (external) token numbers.
      by_kind (kind_type t) YY_NOEXCEPT;



      /// Record that this symbol is empty.
      void clear () YY_NOEXCEPT;

      /// Steal the symbol kind from \a that.
      void move (by_kind& that);

      /// The (internal) type number (corresponding to \a type).
      /// \a empty when empty.
      symbol_kind_type kind () const YY_NOEXCEPT;

      /// Backward compatibility (Bison 3.6).
      symbol_kind_type type_get () const YY_NOEXCEPT;

      /// The symbol kind.
      /// \a S_YYEMPTY when empty.
      symbol_kind_type kind_;
    };

    /// Backward compatibility for a private implementation detail (Bison 3.6).
    typedef by_kind by_type;

    /// "External" symbols: returned by the scanner.
    struct symbol_type : basic_symbol<by_kind>
    {};

    /// Build a parser object.
     AdoParser  (ParseDriver& driver_yyarg, yyscan_t yyscanner_yyarg);
    virtual ~ AdoParser  ();

#if 201103L <= YY_CPLUSPLUS
    /// Non copyable.
     AdoParser  (const  AdoParser &) = delete;
    /// Non copyable.
     AdoParser & operator= (const  AdoParser &) = delete;
#endif

    /// Parse.  An alias for parse ().
    /// \returns  0 iff parsing succeeded.
    int operator() ();

    /// Parse.
    /// \returns  0 iff parsing succeeded.
    virtual int parse ();

#if YYDEBUG
    /// The current debugging stream.
    std::ostream& debug_stream () const YY_ATTRIBUTE_PURE;
    /// Set the current debugging stream.
    void set_debug_stream (std::ostream &);

    /// Type for debugging levels.
    typedef int debug_level_type;
    /// The current debugging level.
    debug_level_type debug_level () const YY_ATTRIBUTE_PURE;
    /// Set the current debugging level.
    void set_debug_level (debug_level_type l);
#endif

    /// Report a syntax error.
    /// \param loc    where the syntax error is found.
    /// \param msg    a description of the syntax error.
    virtual void error (const location_type& loc, const std::string& msg);

    /// Report a syntax error.
    void error (const syntax_error& err);

    /// The user-facing name of the symbol whose (internal) number is
    /// YYSYMBOL.  No bounds checking.
    static std::string symbol_name (symbol_kind_type yysymbol);



    class context
    {
    public:
      context (const  AdoParser & yyparser, const symbol_type& yyla);
      const symbol_type& lookahead () const YY_NOEXCEPT { return yyla_; }
      symbol_kind_type token () const YY_NOEXCEPT { return yyla_.kind (); }
      const location_type& location () const YY_NOEXCEPT { return yyla_.location; }

      /// Put in YYARG at most YYARGN of the expected tokens, and return the
      /// number of tokens stored in YYARG.  If YYARG is null, return the
      /// number of expected tokens (guaranteed to be less than YYNTOKENS).
      int expected_tokens (symbol_kind_type yyarg[], int yyargn) const;

    private:
      const  AdoParser & yyparser_;
      const symbol_type& yyla_;
    };

  private:
#if YY_CPLUSPLUS < 201103L
    /// Non copyable.
     AdoParser  (const  AdoParser &);
    /// Non copyable.
     AdoParser & operator= (const  AdoParser &);
#endif


    /// Stored state numbers (used for stacks).
    typedef short state_type;

    /// The arguments of the error message.
    int yy_syntax_error_arguments_ (const context& yyctx,
                                    symbol_kind_type yyarg[], int yyargn) const;

    /// Generate an error message.
    /// \param yyctx     the context in which the error occurred.
    virtual std::string yysyntax_error_ (const context& yyctx) const;
    /// Compute post-reduction state.
    /// \param yystate   the current state
    /// \param yysym     the nonterminal to push on the stack
    static state_type yy_lr_goto_state_ (state_type yystate, int yysym);

    /// Whether the given \c yypact_ value indicates a defaulted state.
    /// \param yyvalue   the value to check
    static bool yy_pact_value_is_default_ (int yyvalue) YY_NOEXCEPT;

    /// Whether the given \c yytable_ value indicates a syntax error.
    /// \param yyvalue   the value to check
    static bool yy_table_value_is_error_ (int yyvalue) YY_NOEXCEPT;

    static const short yypact_ninf_;
    static const signed char yytable_ninf_;

    /// Convert a scanner token kind \a t to a symbol kind.
    /// In theory \a t should be a token_kind_type, but character literals
    /// are valid, yet not members of the token_kind_type enum.
    static symbol_kind_type yytranslate_ (int t) YY_NOEXCEPT;

    /// Convert the symbol name \a n to a form suitable for a diagnostic.
    static std::string yytnamerr_ (const char *yystr);

    /// For a symbol, its name in clear.
    static const char* const yytname_[];


    // Tables.
    // YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
    // STATE-NUM.
    static const short yypact_[];

    // YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
    // Performed when YYTABLE does not specify something else to do.  Zero
    // means the default is an error.
    static const unsigned char yydefact_[];

    // YYPGOTO[NTERM-NUM].
    static const short yypgoto_[];

    // YYDEFGOTO[NTERM-NUM].
    static const unsigned char yydefgoto_[];

    // YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
    // positive, shift that token.  If negative, reduce the rule whose
    // number is the opposite.  If YYTABLE_NINF, syntax error.
    static const short yytable_[];

    static const short yycheck_[];

    // YYSTOS[STATE-NUM] -- The symbol kind of the accessing symbol of
    // state STATE-NUM.
    static const unsigned char yystos_[];

    // YYR1[RULE-NUM] -- Symbol kind of the left-hand side of rule RULE-NUM.
    static const unsigned char yyr1_[];

    // YYR2[RULE-NUM] -- Number of symbols on the right-hand side of rule RULE-NUM.
    static const signed char yyr2_[];


#if YYDEBUG
    // YYRLINE[YYN] -- Source line where rule number YYN was defined.
    static const short yyrline_[];
    /// Report on the debug stream that the rule \a r is going to be reduced.
    virtual void yy_reduce_print_ (int r) const;
    /// Print the state stack on the debug stream.
    virtual void yy_stack_print_ () const;

    /// Debugging level.
    int yydebug_;
    /// Debug stream.
    std::ostream* yycdebug_;

    /// \brief Display a symbol kind, value and location.
    /// \param yyo    The output stream.
    /// \param yysym  The symbol.
    template <typename Base>
    void yy_print_ (std::ostream& yyo, const basic_symbol<Base>& yysym) const;
#endif

    /// \brief Reclaim the memory associated to a symbol.
    /// \param yymsg     Why this token is reclaimed.
    ///                  If null, print nothing.
    /// \param yysym     The symbol.
    template <typename Base>
    void yy_destroy_ (const char* yymsg, basic_symbol<Base>& yysym) const;

  private:
    /// Type access provider for state based symbols.
    struct by_state
    {
      /// Default constructor.
      by_state () YY_NOEXCEPT;

      /// The symbol kind as needed by the constructor.
      typedef state_type kind_type;

      /// Constructor.
      by_state (kind_type s) YY_NOEXCEPT;

      /// Copy constructor.
      by_state (const by_state& that) YY_NOEXCEPT;

      /// Record that this symbol is empty.
      void clear () YY_NOEXCEPT;

      /// Steal the symbol kind from \a that.
      void move (by_state& that);

      /// The symbol kind (corresponding to \a state).
      /// \a symbol_kind::S_YYEMPTY when empty.
      symbol_kind_type kind () const YY_NOEXCEPT;

      /// The state number used to denote an empty symbol.
      /// We use the initial state, as it does not have a value.
      enum { empty_state = 0 };

      /// The state.
      /// \a empty when empty.
      state_type state;
    };

    /// "Internal" symbol: element of the stack.
    struct stack_symbol_type : basic_symbol<by_state>
    {
      /// Superclass.
      typedef basic_symbol<by_state> super_type;
      /// Construct an empty symbol.
      stack_symbol_type ();
      /// Move or copy construction.
      stack_symbol_type (YY_RVREF (stack_symbol_type) that);
      /// Steal the contents from \a sym to build this.
      stack_symbol_type (state_type s, YY_MOVE_REF (symbol_type) sym);
#if YY_CPLUSPLUS < 201103L
      /// Assignment, needed by push_back by some old implementations.
      /// Moves the contents of that.
      stack_symbol_type& operator= (stack_symbol_type& that);

      /// Assignment, needed by push_back by other implementations.
      /// Needed by some other old implementations.
      stack_symbol_type& operator= (const stack_symbol_type& that);
#endif
    };

    /// A stack with random access from its top.
    template <typename T, typename S = std::vector<T> >
    class stack
    {
    public:
      // Hide our reversed order.
      typedef typename S::iterator iterator;
      typedef typename S::const_iterator const_iterator;
      typedef typename S::size_type size_type;
      typedef typename std::ptrdiff_t index_type;

      stack (size_type n = 200) YY_NOEXCEPT
        : seq_ (n)
      {}

#if 201103L <= YY_CPLUSPLUS
      /// Non copyable.
      stack (const stack&) = delete;
      /// Non copyable.
      stack& operator= (const stack&) = delete;
#endif

      /// Random access.
      ///
      /// Index 0 returns the topmost element.
      const T&
      operator[] (index_type i) const
      {
        return seq_[size_type (size () - 1 - i)];
      }

      /// Random access.
      ///
      /// Index 0 returns the topmost element.
      T&
      operator[] (index_type i)
      {
        return seq_[size_type (size () - 1 - i)];
      }

      /// Steal the contents of \a t.
      ///
      /// Close to move-semantics.
      void
      push (YY_MOVE_REF (T) t)
      {
        seq_.push_back (T ());
        operator[] (0).move (t);
      }

      /// Pop elements from the stack.
      void
      pop (std::ptrdiff_t n = 1) YY_NOEXCEPT
      {
        for (; 0 < n; --n)
          seq_.pop_back ();
      }

      /// Pop all elements from the stack.
      void
      clear () YY_NOEXCEPT
      {
        seq_.clear ();
      }

      /// Number of elements on the stack.
      index_type
      size () const YY_NOEXCEPT
      {
        return index_type (seq_.size ());
      }

      /// Iterator on top of the stack (going downwards).
      const_iterator
      begin () const YY_NOEXCEPT
      {
        return seq_.begin ();
      }

      /// Bottom of the stack.
      const_iterator
      end () const YY_NOEXCEPT
      {
        return seq_.end ();
      }

      /// Present a slice of the top of a stack.
      class slice
      {
      public:
        slice (const stack& stack, index_type range) YY_NOEXCEPT
          : stack_ (stack)
          , range_ (range)
        {}

        const T&
        operator[] (index_type i) const
        {
          return stack_[range_ - i];
        }

      private:
        const stack& stack_;
        index_type range_;
      };

    private:
#if YY_CPLUSPLUS < 201103L
      /// Non copyable.
      stack (const stack&);
      /// Non copyable.
      stack& operator= (const stack&);
#endif
      /// The wrapped container.
      S seq_;
    };


    /// Stack type.
    typedef stack<stack_symbol_type> stack_type;

    /// The stack.
    stack_type yystack_;

    /// Push a new state on the stack.
    /// \param m    a debug message to display
    ///             if null, no trace is output.
    /// \param sym  the symbol
    /// \warning the contents of \a s.value is stolen.
    void yypush_ (const char* m, YY_MOVE_REF (stack_symbol_type) sym);

    /// Push a new look ahead token on the state on the stack.
    /// \param m    a debug message to display
    ///             if null, no trace is output.
    /// \param s    the state
    /// \param sym  the symbol (for its value and location).
    /// \warning the contents of \a sym.value is stolen.
    void yypush_ (const char* m, state_type s, YY_MOVE_REF (symbol_type) sym);

    /// Pop \a n symbols from the stack.
    void yypop_ (int n = 1) YY_NOEXCEPT;

    /// Constants.
    enum
    {
      yylast_ = 793,     ///< Last index in yytable_.
      yynnts_ = 66,  ///< Number of nonterminal symbols.
      yyfinal_ = 112 ///< Termination state number.
    };


    // User arguments.
    ParseDriver& driver;
    yyscan_t yyscanner;

  };


} // yy
#line 1022 "ado.tab.hpp"




#endif // !YY_YY_ADO_TAB_HPP_INCLUDED
