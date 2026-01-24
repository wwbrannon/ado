// A Bison parser, made by GNU Bison 3.8.2.

// Skeleton implementation for Bison LALR(1) parsers in C++

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

// DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
// especially those whose name start with YY_ or yy_.  They are
// private implementation details that can be changed or removed.





#include "ado.tab.hpp"


// Unqualified %code blocks.
#line 32 "ado.ypp"

    #include <string>
    #include <Rcpp.h>

    YY_DECL;

    void
    yy::AdoParser::error(const location_type& l, const std::string& m)
    {
        driver.error(l.begin.line, l.begin.column, m);
    }

    #define R_ACTION(node) driver.wrap_cmd_action(node);
    #define RETURN_AST(node) driver.set_ast(node);

#line 62 "ado.tab.cpp"


#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> // FIXME: INFRINGES ON USER NAME SPACE.
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif


// Whether we are compiled with exception support.
#ifndef YY_EXCEPTIONS
# if defined __GNUC__ && !defined __EXCEPTIONS
#  define YY_EXCEPTIONS 0
# else
#  define YY_EXCEPTIONS 1
# endif
#endif

#define YYRHSLOC(Rhs, K) ((Rhs)[K].location)
/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

# ifndef YYLLOC_DEFAULT
#  define YYLLOC_DEFAULT(Current, Rhs, N)                               \
    do                                                                  \
      if (N)                                                            \
        {                                                               \
          (Current).begin  = YYRHSLOC (Rhs, 1).begin;                   \
          (Current).end    = YYRHSLOC (Rhs, N).end;                     \
        }                                                               \
      else                                                              \
        {                                                               \
          (Current).begin = (Current).end = YYRHSLOC (Rhs, 0).end;      \
        }                                                               \
    while (false)
# endif


// Enable debugging if requested.
#if YYDEBUG

// A pseudo ostream that takes yydebug_ into account.
# define YYCDEBUG if (yydebug_) (*yycdebug_)

# define YY_SYMBOL_PRINT(Title, Symbol)         \
  do {                                          \
    if (yydebug_)                               \
    {                                           \
      *yycdebug_ << Title << ' ';               \
      yy_print_ (*yycdebug_, Symbol);           \
      *yycdebug_ << '\n';                       \
    }                                           \
  } while (false)

# define YY_REDUCE_PRINT(Rule)          \
  do {                                  \
    if (yydebug_)                       \
      yy_reduce_print_ (Rule);          \
  } while (false)

# define YY_STACK_PRINT()               \
  do {                                  \
    if (yydebug_)                       \
      yy_stack_print_ ();                \
  } while (false)

#else // !YYDEBUG

# define YYCDEBUG if (false) std::cerr
# define YY_SYMBOL_PRINT(Title, Symbol)  YY_USE (Symbol)
# define YY_REDUCE_PRINT(Rule)           static_cast<void> (0)
# define YY_STACK_PRINT()                static_cast<void> (0)

#endif // !YYDEBUG

#define yyerrok         (yyerrstatus_ = 0)
#define yyclearin       (yyla.clear ())

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab
#define YYRECOVERING()  (!!yyerrstatus_)

namespace yy {
#line 154 "ado.tab.cpp"

  /// Build a parser object.
   AdoParser :: AdoParser  (ParseDriver& driver_yyarg, yyscan_t yyscanner_yyarg)
#if YYDEBUG
    : yydebug_ (false),
      yycdebug_ (&std::cerr),
#else
    :
#endif
      driver (driver_yyarg),
      yyscanner (yyscanner_yyarg)
  {}

   AdoParser ::~ AdoParser  ()
  {}

   AdoParser ::syntax_error::~syntax_error () YY_NOEXCEPT YY_NOTHROW
  {}

  /*---------.
  | symbol.  |
  `---------*/

  // basic_symbol.
  template <typename Base>
   AdoParser ::basic_symbol<Base>::basic_symbol (const basic_symbol& that)
    : Base (that)
    , value (that.value)
    , location (that.location)
  {}


  /// Constructor for valueless symbols.
  template <typename Base>
   AdoParser ::basic_symbol<Base>::basic_symbol (typename Base::kind_type t, YY_MOVE_REF (location_type) l)
    : Base (t)
    , value ()
    , location (l)
  {}

  template <typename Base>
   AdoParser ::basic_symbol<Base>::basic_symbol (typename Base::kind_type t, YY_RVREF (value_type) v, YY_RVREF (location_type) l)
    : Base (t)
    , value (YY_MOVE (v))
    , location (YY_MOVE (l))
  {}


  template <typename Base>
   AdoParser ::symbol_kind_type
   AdoParser ::basic_symbol<Base>::type_get () const YY_NOEXCEPT
  {
    return this->kind ();
  }


  template <typename Base>
  bool
   AdoParser ::basic_symbol<Base>::empty () const YY_NOEXCEPT
  {
    return this->kind () == symbol_kind::S_YYEMPTY;
  }

  template <typename Base>
  void
   AdoParser ::basic_symbol<Base>::move (basic_symbol& s)
  {
    super_type::move (s);
    value = YY_MOVE (s.value);
    location = YY_MOVE (s.location);
  }

  // by_kind.
   AdoParser ::by_kind::by_kind () YY_NOEXCEPT
    : kind_ (symbol_kind::S_YYEMPTY)
  {}

#if 201103L <= YY_CPLUSPLUS
   AdoParser ::by_kind::by_kind (by_kind&& that) YY_NOEXCEPT
    : kind_ (that.kind_)
  {
    that.clear ();
  }
#endif

   AdoParser ::by_kind::by_kind (const by_kind& that) YY_NOEXCEPT
    : kind_ (that.kind_)
  {}

   AdoParser ::by_kind::by_kind (token_kind_type t) YY_NOEXCEPT
    : kind_ (yytranslate_ (t))
  {}



  void
   AdoParser ::by_kind::clear () YY_NOEXCEPT
  {
    kind_ = symbol_kind::S_YYEMPTY;
  }

  void
   AdoParser ::by_kind::move (by_kind& that)
  {
    kind_ = that.kind_;
    that.clear ();
  }

   AdoParser ::symbol_kind_type
   AdoParser ::by_kind::kind () const YY_NOEXCEPT
  {
    return kind_;
  }


   AdoParser ::symbol_kind_type
   AdoParser ::by_kind::type_get () const YY_NOEXCEPT
  {
    return this->kind ();
  }



  // by_state.
   AdoParser ::by_state::by_state () YY_NOEXCEPT
    : state (empty_state)
  {}

   AdoParser ::by_state::by_state (const by_state& that) YY_NOEXCEPT
    : state (that.state)
  {}

  void
   AdoParser ::by_state::clear () YY_NOEXCEPT
  {
    state = empty_state;
  }

  void
   AdoParser ::by_state::move (by_state& that)
  {
    state = that.state;
    that.clear ();
  }

   AdoParser ::by_state::by_state (state_type s) YY_NOEXCEPT
    : state (s)
  {}

   AdoParser ::symbol_kind_type
   AdoParser ::by_state::kind () const YY_NOEXCEPT
  {
    if (state == empty_state)
      return symbol_kind::S_YYEMPTY;
    else
      return YY_CAST (symbol_kind_type, yystos_[+state]);
  }

   AdoParser ::stack_symbol_type::stack_symbol_type ()
  {}

   AdoParser ::stack_symbol_type::stack_symbol_type (YY_RVREF (stack_symbol_type) that)
    : super_type (YY_MOVE (that.state), YY_MOVE (that.value), YY_MOVE (that.location))
  {
#if 201103L <= YY_CPLUSPLUS
    // that is emptied.
    that.state = empty_state;
#endif
  }

   AdoParser ::stack_symbol_type::stack_symbol_type (state_type s, YY_MOVE_REF (symbol_type) that)
    : super_type (s, YY_MOVE (that.value), YY_MOVE (that.location))
  {
    // that is emptied.
    that.kind_ = symbol_kind::S_YYEMPTY;
  }

#if YY_CPLUSPLUS < 201103L
   AdoParser ::stack_symbol_type&
   AdoParser ::stack_symbol_type::operator= (const stack_symbol_type& that)
  {
    state = that.state;
    value = that.value;
    location = that.location;
    return *this;
  }

   AdoParser ::stack_symbol_type&
   AdoParser ::stack_symbol_type::operator= (stack_symbol_type& that)
  {
    state = that.state;
    value = that.value;
    location = that.location;
    // that is emptied.
    that.state = empty_state;
    return *this;
  }
#endif

  template <typename Base>
  void
   AdoParser ::yy_destroy_ (const char* yymsg, basic_symbol<Base>& yysym) const
  {
    if (yymsg)
      YY_SYMBOL_PRINT (yymsg, yysym);

    // User destructor.
    switch (yysym.kind ())
    {
      case symbol_kind::S_YYerror: // error
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 367 "ado.tab.cpp"
        break;

      case symbol_kind::S_PLUS: // "+"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 373 "ado.tab.cpp"
        break;

      case symbol_kind::S_MINUS: // "-"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 379 "ado.tab.cpp"
        break;

      case symbol_kind::S_NEWLINE: // NEWLINE
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 385 "ado.tab.cpp"
        break;

      case symbol_kind::S_SEMICOLON: // ";"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 391 "ado.tab.cpp"
        break;

      case symbol_kind::S_LT_OP: // "<"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 397 "ado.tab.cpp"
        break;

      case symbol_kind::S_GT_OP: // ">"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 403 "ado.tab.cpp"
        break;

      case symbol_kind::S_NEG_OP: // "!"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 409 "ado.tab.cpp"
        break;

      case symbol_kind::S_STAR: // "*"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 415 "ado.tab.cpp"
        break;

      case symbol_kind::S_SLASH: // "/"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 421 "ado.tab.cpp"
        break;

      case symbol_kind::S_CARET: // "^"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 427 "ado.tab.cpp"
        break;

      case symbol_kind::S_GE_OP: // ">="
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 433 "ado.tab.cpp"
        break;

      case symbol_kind::S_LE_OP: // "<="
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 439 "ado.tab.cpp"
        break;

      case symbol_kind::S_EQ_OP: // "=="
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 445 "ado.tab.cpp"
        break;

      case symbol_kind::S_NE_OP: // "!="
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 451 "ado.tab.cpp"
        break;

      case symbol_kind::S_OR_OP: // "|"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 457 "ado.tab.cpp"
        break;

      case symbol_kind::S_AND_OP: // "&"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 463 "ado.tab.cpp"
        break;

      case symbol_kind::S_FACT_CROSS: // "##"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 469 "ado.tab.cpp"
        break;

      case symbol_kind::S_CROSS: // "#"
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 475 "ado.tab.cpp"
        break;

      case symbol_kind::S_NUMBER: // NUMBER
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 481 "ado.tab.cpp"
        break;

      case symbol_kind::S_IDENT: // IDENT
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 487 "ado.tab.cpp"
        break;

      case symbol_kind::S_STRING_LITERAL: // STRING_LITERAL
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 493 "ado.tab.cpp"
        break;

      case symbol_kind::S_DATE: // DATE
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 499 "ado.tab.cpp"
        break;

      case symbol_kind::S_DATETIME: // DATETIME
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 505 "ado.tab.cpp"
        break;

      case symbol_kind::S_PERIOD: // "."
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 511 "ado.tab.cpp"
        break;

      case symbol_kind::S_BYTE: // BYTE
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 517 "ado.tab.cpp"
        break;

      case symbol_kind::S_INT: // INT
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 523 "ado.tab.cpp"
        break;

      case symbol_kind::S_LONG: // LONG
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 529 "ado.tab.cpp"
        break;

      case symbol_kind::S_FLOAT: // FLOAT
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 535 "ado.tab.cpp"
        break;

      case symbol_kind::S_DOUBLE: // DOUBLE
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 541 "ado.tab.cpp"
        break;

      case symbol_kind::S_STRING_TYPE_SPEC: // STRING_TYPE_SPEC
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 547 "ado.tab.cpp"
        break;

      case symbol_kind::S_STRING_FORMAT: // STRING_FORMAT
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 553 "ado.tab.cpp"
        break;

      case symbol_kind::S_DATETIME_FORMAT: // DATETIME_FORMAT
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 559 "ado.tab.cpp"
        break;

      case symbol_kind::S_NUMBER_FORMAT: // NUMBER_FORMAT
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 565 "ado.tab.cpp"
        break;

      case symbol_kind::S_EMBEDDED_CODE: // EMBEDDED_CODE
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 571 "ado.tab.cpp"
        break;

      case symbol_kind::S_BY: // BY
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 577 "ado.tab.cpp"
        break;

      case symbol_kind::S_XI: // XI
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 583 "ado.tab.cpp"
        break;

      case symbol_kind::S_BYSORT: // BYSORT
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 589 "ado.tab.cpp"
        break;

      case symbol_kind::S_QUIETLY: // QUIETLY
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 595 "ado.tab.cpp"
        break;

      case symbol_kind::S_CAPTURE: // CAPTURE
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 601 "ado.tab.cpp"
        break;

      case symbol_kind::S_NOISILY: // NOISILY
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 607 "ado.tab.cpp"
        break;

      case symbol_kind::S_MERGE: // MERGE
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 613 "ado.tab.cpp"
        break;

      case symbol_kind::S_COLLAPSE: // COLLAPSE
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 619 "ado.tab.cpp"
        break;

      case symbol_kind::S_IVREGRESS: // IVREGRESS
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 625 "ado.tab.cpp"
        break;

      case symbol_kind::S_RECODE: // RECODE
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 631 "ado.tab.cpp"
        break;

      case symbol_kind::S_GSORT: // GSORT
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 637 "ado.tab.cpp"
        break;

      case symbol_kind::S_LRTEST: // LRTEST
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 643 "ado.tab.cpp"
        break;

      case symbol_kind::S_ANOVA: // ANOVA
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 649 "ado.tab.cpp"
        break;

      case symbol_kind::S_TSLS: // TSLS
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 655 "ado.tab.cpp"
        break;

      case symbol_kind::S_WEIGHT_SPEC: // WEIGHT_SPEC
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 661 "ado.tab.cpp"
        break;

      case symbol_kind::S_MERGE_SPEC: // MERGE_SPEC
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 667 "ado.tab.cpp"
        break;

      case symbol_kind::S_CONT_OPERATOR: // CONT_OPERATOR
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 673 "ado.tab.cpp"
        break;

      case symbol_kind::S_IND_OPERATOR: // IND_OPERATOR
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 679 "ado.tab.cpp"
        break;

      case symbol_kind::S_BASE_OPERATOR: // BASE_OPERATOR
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 685 "ado.tab.cpp"
        break;

      case symbol_kind::S_OMIT_OPERATOR: // OMIT_OPERATOR
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 691 "ado.tab.cpp"
        break;

      case symbol_kind::S_FOREACH: // FOREACH
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 697 "ado.tab.cpp"
        break;

      case symbol_kind::S_FORVALUES: // FORVALUES
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 703 "ado.tab.cpp"
        break;

      case symbol_kind::S_translation_unit: // translation_unit
#line 158 "ado.ypp"
                    { }
#line 709 "ado.tab.cpp"
        break;

      case symbol_kind::S_external_statement: // external_statement
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 715 "ado.tab.cpp"
        break;

      case symbol_kind::S_foreach_cmd: // foreach_cmd
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 721 "ado.tab.cpp"
        break;

      case symbol_kind::S_forvalues_cmd: // forvalues_cmd
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 727 "ado.tab.cpp"
        break;

      case symbol_kind::S_if_cmd: // if_cmd
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 733 "ado.tab.cpp"
        break;

      case symbol_kind::S_compound_cmd: // compound_cmd
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 739 "ado.tab.cpp"
        break;

      case symbol_kind::S_cmds: // cmds
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 745 "ado.tab.cpp"
        break;

      case symbol_kind::S_cmd: // cmd
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 751 "ado.tab.cpp"
        break;

      case symbol_kind::S_cmd_sep: // cmd_sep
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 757 "ado.tab.cpp"
        break;

      case symbol_kind::S_modifier_cmd: // modifier_cmd
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 763 "ado.tab.cpp"
        break;

      case symbol_kind::S_long_modifier_cmd: // long_modifier_cmd
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 769 "ado.tab.cpp"
        break;

      case symbol_kind::S_modifier_cmd_list: // modifier_cmd_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 775 "ado.tab.cpp"
        break;

      case symbol_kind::S_nonmodifier_cmd: // nonmodifier_cmd
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 781 "ado.tab.cpp"
        break;

      case symbol_kind::S_varlist: // varlist
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 787 "ado.tab.cpp"
        break;

      case symbol_kind::S_number_or_missing: // number_or_missing
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 793 "ado.tab.cpp"
        break;

      case symbol_kind::S_numlist: // numlist
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 799 "ado.tab.cpp"
        break;

      case symbol_kind::S_collapse_spec_base: // collapse_spec_base
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 805 "ado.tab.cpp"
        break;

      case symbol_kind::S_collapse_spec_base_list: // collapse_spec_base_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 811 "ado.tab.cpp"
        break;

      case symbol_kind::S_collapse_spec: // collapse_spec
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 817 "ado.tab.cpp"
        break;

      case symbol_kind::S_collapse_list: // collapse_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 823 "ado.tab.cpp"
        break;

      case symbol_kind::S_recode_rule: // recode_rule
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 829 "ado.tab.cpp"
        break;

      case symbol_kind::S_recode_rule_list: // recode_rule_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 835 "ado.tab.cpp"
        break;

      case symbol_kind::S_gsort_var: // gsort_var
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 841 "ado.tab.cpp"
        break;

      case symbol_kind::S_gsort_varlist: // gsort_varlist
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 847 "ado.tab.cpp"
        break;

      case symbol_kind::S_modelspec: // modelspec
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 853 "ado.tab.cpp"
        break;

      case symbol_kind::S_modelspec_list: // modelspec_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 859 "ado.tab.cpp"
        break;

      case symbol_kind::S_anova_nest_expression: // anova_nest_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 865 "ado.tab.cpp"
        break;

      case symbol_kind::S_anova_error_expression: // anova_error_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 871 "ado.tab.cpp"
        break;

      case symbol_kind::S_anova_term_list: // anova_term_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 877 "ado.tab.cpp"
        break;

      case symbol_kind::S_unary_operator: // unary_operator
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 883 "ado.tab.cpp"
        break;

      case symbol_kind::S_unary_factor_operator: // unary_factor_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 889 "ado.tab.cpp"
        break;

      case symbol_kind::S_power_operator: // power_operator
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 895 "ado.tab.cpp"
        break;

      case symbol_kind::S_multiplication_operator: // multiplication_operator
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 901 "ado.tab.cpp"
        break;

      case symbol_kind::S_additive_operator: // additive_operator
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 907 "ado.tab.cpp"
        break;

      case symbol_kind::S_relational_operator: // relational_operator
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 913 "ado.tab.cpp"
        break;

      case symbol_kind::S_equality_operator: // equality_operator
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 919 "ado.tab.cpp"
        break;

      case symbol_kind::S_logical_operator: // logical_operator
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 925 "ado.tab.cpp"
        break;

      case symbol_kind::S_cross_operator: // cross_operator
#line 159 "ado.ypp"
                    { delete (yysym.value.str); }
#line 931 "ado.tab.cpp"
        break;

      case symbol_kind::S_format_spec: // format_spec
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 937 "ado.tab.cpp"
        break;

      case symbol_kind::S_literal_expression: // literal_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 943 "ado.tab.cpp"
        break;

      case symbol_kind::S_primary_expression: // primary_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 949 "ado.tab.cpp"
        break;

      case symbol_kind::S_unary_factor_expression: // unary_factor_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 955 "ado.tab.cpp"
        break;

      case symbol_kind::S_cross_expression: // cross_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 961 "ado.tab.cpp"
        break;

      case symbol_kind::S_postfix_expression: // postfix_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 967 "ado.tab.cpp"
        break;

      case symbol_kind::S_power_expression: // power_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 973 "ado.tab.cpp"
        break;

      case symbol_kind::S_unary_expression: // unary_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 979 "ado.tab.cpp"
        break;

      case symbol_kind::S_multiplication_expression: // multiplication_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 985 "ado.tab.cpp"
        break;

      case symbol_kind::S_additive_expression: // additive_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 991 "ado.tab.cpp"
        break;

      case symbol_kind::S_relational_expression: // relational_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 997 "ado.tab.cpp"
        break;

      case symbol_kind::S_equality_expression: // equality_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1003 "ado.tab.cpp"
        break;

      case symbol_kind::S_logical_expression: // logical_expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1009 "ado.tab.cpp"
        break;

      case symbol_kind::S_expression: // expression
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1015 "ado.tab.cpp"
        break;

      case symbol_kind::S_expression_list: // expression_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1021 "ado.tab.cpp"
        break;

      case symbol_kind::S_argument_expression_list: // argument_expression_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1027 "ado.tab.cpp"
        break;

      case symbol_kind::S_option_list: // option_list
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1033 "ado.tab.cpp"
        break;

      case symbol_kind::S_options: // options
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1039 "ado.tab.cpp"
        break;

      case symbol_kind::S_option: // option
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1045 "ado.tab.cpp"
        break;

      case symbol_kind::S_option_ident: // option_ident
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1051 "ado.tab.cpp"
        break;

      case symbol_kind::S_weight_clause: // weight_clause
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1057 "ado.tab.cpp"
        break;

      case symbol_kind::S_if_clause: // if_clause
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1063 "ado.tab.cpp"
        break;

      case symbol_kind::S_in_clause: // in_clause
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1069 "ado.tab.cpp"
        break;

      case symbol_kind::S_using_clause: // using_clause
#line 160 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1075 "ado.tab.cpp"
        break;

      default:
        break;
    }
  }

#if YYDEBUG
  template <typename Base>
  void
   AdoParser ::yy_print_ (std::ostream& yyo, const basic_symbol<Base>& yysym) const
  {
    std::ostream& yyoutput = yyo;
    YY_USE (yyoutput);
    if (yysym.empty ())
      yyo << "empty symbol";
    else
      {
        symbol_kind_type yykind = yysym.kind ();
        yyo << (yykind < YYNTOKENS ? "token" : "nterm")
            << ' ' << yysym.name () << " ("
            << yysym.location << ": ";
        YY_USE (yykind);
        yyo << ')';
      }
  }
#endif

  void
   AdoParser ::yypush_ (const char* m, YY_MOVE_REF (stack_symbol_type) sym)
  {
    if (m)
      YY_SYMBOL_PRINT (m, sym);
    yystack_.push (YY_MOVE (sym));
  }

  void
   AdoParser ::yypush_ (const char* m, state_type s, YY_MOVE_REF (symbol_type) sym)
  {
#if 201103L <= YY_CPLUSPLUS
    yypush_ (m, stack_symbol_type (s, std::move (sym)));
#else
    stack_symbol_type ss (s, sym);
    yypush_ (m, ss);
#endif
  }

  void
   AdoParser ::yypop_ (int n) YY_NOEXCEPT
  {
    yystack_.pop (n);
  }

#if YYDEBUG
  std::ostream&
   AdoParser ::debug_stream () const
  {
    return *yycdebug_;
  }

  void
   AdoParser ::set_debug_stream (std::ostream& o)
  {
    yycdebug_ = &o;
  }


   AdoParser ::debug_level_type
   AdoParser ::debug_level () const
  {
    return yydebug_;
  }

  void
   AdoParser ::set_debug_level (debug_level_type l)
  {
    yydebug_ = l;
  }
#endif // YYDEBUG

   AdoParser ::state_type
   AdoParser ::yy_lr_goto_state_ (state_type yystate, int yysym)
  {
    int yyr = yypgoto_[yysym - YYNTOKENS] + yystate;
    if (0 <= yyr && yyr <= yylast_ && yycheck_[yyr] == yystate)
      return yytable_[yyr];
    else
      return yydefgoto_[yysym - YYNTOKENS];
  }

  bool
   AdoParser ::yy_pact_value_is_default_ (int yyvalue) YY_NOEXCEPT
  {
    return yyvalue == yypact_ninf_;
  }

  bool
   AdoParser ::yy_table_value_is_error_ (int yyvalue) YY_NOEXCEPT
  {
    return yyvalue == yytable_ninf_;
  }

  int
   AdoParser ::operator() ()
  {
    return parse ();
  }

  int
   AdoParser ::parse ()
  {
    int yyn;
    /// Length of the RHS of the rule being reduced.
    int yylen = 0;

    // Error handling.
    int yynerrs_ = 0;
    int yyerrstatus_ = 0;

    /// The lookahead symbol.
    symbol_type yyla;

    /// The locations where the error started and ended.
    stack_symbol_type yyerror_range[3];

    /// The return value of parse ().
    int yyresult;

#if YY_EXCEPTIONS
    try
#endif // YY_EXCEPTIONS
      {
    YYCDEBUG << "Starting parse\n";


    /* Initialize the stack.  The initial state will be set in
       yynewstate, since the latter expects the semantical and the
       location values to have been already stored, initialize these
       stacks with a primary value.  */
    yystack_.clear ();
    yypush_ (YY_NULLPTR, 0, YY_MOVE (yyla));

  /*-----------------------------------------------.
  | yynewstate -- push a new symbol on the stack.  |
  `-----------------------------------------------*/
  yynewstate:
    YYCDEBUG << "Entering state " << int (yystack_[0].state) << '\n';
    YY_STACK_PRINT ();

    // Accept?
    if (yystack_[0].state == yyfinal_)
      YYACCEPT;

    goto yybackup;


  /*-----------.
  | yybackup.  |
  `-----------*/
  yybackup:
    // Try to take a decision without lookahead.
    yyn = yypact_[+yystack_[0].state];
    if (yy_pact_value_is_default_ (yyn))
      goto yydefault;

    // Read a lookahead token.
    if (yyla.empty ())
      {
        YYCDEBUG << "Reading a token\n";
#if YY_EXCEPTIONS
        try
#endif // YY_EXCEPTIONS
          {
            yyla.kind_ = yytranslate_ (yylex (&yyla.value, &yyla.location, driver, yyscanner));
          }
#if YY_EXCEPTIONS
        catch (const syntax_error& yyexc)
          {
            YYCDEBUG << "Caught exception: " << yyexc.what() << '\n';
            error (yyexc);
            goto yyerrlab1;
          }
#endif // YY_EXCEPTIONS
      }
    YY_SYMBOL_PRINT ("Next token is", yyla);

    if (yyla.kind () == symbol_kind::S_YYerror)
    {
      // The scanner already issued an error message, process directly
      // to error recovery.  But do not keep the error token as
      // lookahead, it is too special and may lead us to an endless
      // loop in error recovery. */
      yyla.kind_ = symbol_kind::S_YYUNDEF;
      goto yyerrlab1;
    }

    /* If the proper action on seeing token YYLA.TYPE is to reduce or
       to detect an error, take that action.  */
    yyn += yyla.kind ();
    if (yyn < 0 || yylast_ < yyn || yycheck_[yyn] != yyla.kind ())
      {
        goto yydefault;
      }

    // Reduce or error.
    yyn = yytable_[yyn];
    if (yyn <= 0)
      {
        if (yy_table_value_is_error_ (yyn))
          goto yyerrlab;
        yyn = -yyn;
        goto yyreduce;
      }

    // Count tokens shifted since error; after three, turn off error status.
    if (yyerrstatus_)
      --yyerrstatus_;

    // Shift the lookahead token.
    yypush_ ("Shifting", state_type (yyn), YY_MOVE (yyla));
    goto yynewstate;


  /*-----------------------------------------------------------.
  | yydefault -- do the default action for the current state.  |
  `-----------------------------------------------------------*/
  yydefault:
    yyn = yydefact_[+yystack_[0].state];
    if (yyn == 0)
      goto yyerrlab;
    goto yyreduce;


  /*-----------------------------.
  | yyreduce -- do a reduction.  |
  `-----------------------------*/
  yyreduce:
    yylen = yyr2_[yyn];
    {
      stack_symbol_type yylhs;
      yylhs.state = yy_lr_goto_state_ (yystack_[yylen].state, yyr1_[yyn]);
      /* If YYLEN is nonzero, implement the default value of the
         action: '$$ = $1'.  Otherwise, use the top of the stack.

         Otherwise, the following line sets YYLHS.VALUE to garbage.
         This behavior is undocumented and Bison users should not rely
         upon it.  */
      if (yylen)
        yylhs.value = yystack_[yylen - 1].value;
      else
        yylhs.value = yystack_[0].value;

      // Default location.
      {
        stack_type::slice range (yystack_, yylen);
        YYLLOC_DEFAULT (yylhs.location, range, yylen);
        yyerror_range[1].location = yylhs.location;
      }

      // Perform the reduction.
      YY_REDUCE_PRINT (yyn);
#if YY_EXCEPTIONS
      try
#endif // YY_EXCEPTIONS
        {
          switch (yyn)
            {
  case 2: // translation_unit: external_statement
#line 173 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_compound_cmd");
        node->appendChild((yystack_[0].value.node));
        RETURN_AST(node);

        if( !((yystack_[0].value.node)->isDummy()) )
        {
            R_ACTION(node);
        }

        (yylhs.value.node) = node;
    }
#line 1357 "ado.tab.cpp"
    break;

  case 3: // translation_unit: translation_unit external_statement
#line 186 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));

        if( !((yystack_[0].value.node)->isDummy()) )
        {
            ExprNode *node = new ExprNode("ado_compound_cmd");
            node->appendChild((yystack_[0].value.node));

            // FIXME? is this a memory leak?
            RETURN_AST(node);
            R_ACTION(node);
        } else
        {
            RETURN_AST((yystack_[1].value.node));
        }

        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1380 "ado.tab.cpp"
    break;

  case 4: // translation_unit: translation_unit error
#line 205 "ado.ypp"
    {
        (yystack_[0].value.node); // shut up, bison...

        // we shouldn't need to use set_ast here, because the earlier
        // production that created the translation_unit will have done
        // so already (unlike the one-statement error production below)
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1393 "ado.tab.cpp"
    break;

  case 5: // translation_unit: error
#line 214 "ado.ypp"
    {
        (yystack_[0].value.node); // shut up, bison...

        ExprNode *node = new ExprNode("ado_compound_cmd");

        RETURN_AST(node);
        (yylhs.value.node) = node;
    }
#line 1406 "ado.tab.cpp"
    break;

  case 6: // external_statement: cmd
#line 225 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1412 "ado.tab.cpp"
    break;

  case 7: // external_statement: compound_cmd
#line 226 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1418 "ado.tab.cpp"
    break;

  case 8: // external_statement: if_cmd
#line 227 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1424 "ado.tab.cpp"
    break;

  case 9: // external_statement: foreach_cmd
#line 228 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1430 "ado.tab.cpp"
    break;

  case 10: // external_statement: forvalues_cmd
#line 229 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1436 "ado.tab.cpp"
    break;

  case 11: // foreach_cmd: FOREACH IDENT foreach_sep varlist "{" STRING_LITERAL "}"
#line 244 "ado.ypp"
    {
        (yystack_[6].value.node)->appendChild("macro_name", (yystack_[5].value.node));
        (yystack_[6].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[6].value.node)->appendChild("varlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[6].value.node);
    }
#line 1448 "ado.tab.cpp"
    break;

  case 12: // foreach_cmd: FOREACH IDENT foreach_sep numlist "{" STRING_LITERAL "}"
#line 252 "ado.ypp"
    {
        (yystack_[6].value.node)->appendChild("macro_name", (yystack_[5].value.node));
        (yystack_[6].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[6].value.node)->appendChild("numlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[6].value.node);
    }
#line 1460 "ado.tab.cpp"
    break;

  case 13: // foreach_cmd: FOREACH IDENT foreach_sep LOCAL IDENT "{" STRING_LITERAL "}"
#line 260 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("local_macro_source", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1472 "ado.tab.cpp"
    break;

  case 14: // foreach_cmd: FOREACH IDENT foreach_sep GLOBAL IDENT "{" STRING_LITERAL "}"
#line 268 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("global_macro_source", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1484 "ado.tab.cpp"
    break;

  case 15: // foreach_cmd: FOREACH IDENT foreach_sep VARLIST varlist "{" STRING_LITERAL "}"
#line 276 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("varlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1496 "ado.tab.cpp"
    break;

  case 16: // foreach_cmd: FOREACH IDENT foreach_sep NEWLIST varlist "{" STRING_LITERAL "}"
#line 284 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("varlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1508 "ado.tab.cpp"
    break;

  case 17: // foreach_cmd: FOREACH IDENT foreach_sep NUMLIST numlist "{" STRING_LITERAL "}"
#line 292 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("numlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1520 "ado.tab.cpp"
    break;

  case 18: // forvalues_cmd: FORVALUES IDENT "=" NUMBER "(" NUMBER ")" NUMBER "{" STRING_LITERAL "}"
#line 303 "ado.ypp"
    {
        (yystack_[10].value.node)->appendChild("macro_name", (yystack_[9].value.node));
        (yystack_[10].value.node)->appendChild("text", (yystack_[1].value.node));

        (yystack_[10].value.node)->appendChild("upper", (yystack_[3].value.node));
        (yystack_[10].value.node)->appendChild("lower", (yystack_[7].value.node));
        (yystack_[10].value.node)->appendChild("increment", (yystack_[5].value.node));

        (yylhs.value.node) = (yystack_[10].value.node);
    }
#line 1535 "ado.tab.cpp"
    break;

  case 19: // forvalues_cmd: FORVALUES IDENT "=" NUMBER "/" NUMBER "{" STRING_LITERAL "}"
#line 314 "ado.ypp"
    {
        (yystack_[4].value.str); // shut up, bison...

        (yystack_[8].value.node)->appendChild("macro_name", (yystack_[7].value.node));
        (yystack_[8].value.node)->appendChild("text", (yystack_[1].value.node));

        (yystack_[8].value.node)->appendChild("upper", (yystack_[3].value.node));
        (yystack_[8].value.node)->appendChild("lower", (yystack_[5].value.node));
        // if "increment" and "increment_t" are both missing, assume increment = 1

        (yylhs.value.node) = (yystack_[8].value.node);
    }
#line 1552 "ado.tab.cpp"
    break;

  case 20: // forvalues_cmd: FORVALUES IDENT "=" NUMBER NUMBER ":" NUMBER "{" STRING_LITERAL "}"
#line 327 "ado.ypp"
    {
        (yystack_[9].value.node)->appendChild("macro_name", (yystack_[8].value.node));
        (yystack_[9].value.node)->appendChild("text", (yystack_[1].value.node));

        (yystack_[9].value.node)->appendChild("upper", (yystack_[3].value.node));
        (yystack_[9].value.node)->appendChild("lower", (yystack_[6].value.node));
        (yystack_[9].value.node)->appendChild("increment_t", (yystack_[5].value.node));

        (yylhs.value.node) = (yystack_[9].value.node);
    }
#line 1567 "ado.tab.cpp"
    break;

  case 21: // forvalues_cmd: FORVALUES IDENT "=" NUMBER NUMBER TO NUMBER "{" STRING_LITERAL "}"
#line 338 "ado.ypp"
    {
        (yystack_[9].value.node)->appendChild("macro_name", (yystack_[8].value.node));
        (yystack_[9].value.node)->appendChild("text", (yystack_[1].value.node));

        (yystack_[9].value.node)->appendChild("upper", (yystack_[3].value.node));
        (yystack_[9].value.node)->appendChild("lower", (yystack_[6].value.node));
        (yystack_[9].value.node)->appendChild("increment_t", (yystack_[5].value.node));

        (yylhs.value.node) = (yystack_[9].value.node);
    }
#line 1582 "ado.tab.cpp"
    break;

  case 24: // if_cmd: IF expression compound_cmd
#line 357 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_if_cmd");
        node->appendChild("expression", (yystack_[1].value.node));
        node->appendChild("compound_cmd", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1594 "ado.tab.cpp"
    break;

  case 25: // compound_cmd: "{" cmds "}"
#line 368 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1602 "ado.tab.cpp"
    break;

  case 26: // cmds: cmd
#line 375 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_compound_cmd");

        node->appendChild((yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1614 "ado.tab.cpp"
    break;

  case 27: // cmds: compound_cmd
#line 383 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[0].value.node);
    }
#line 1622 "ado.tab.cpp"
    break;

  case 28: // cmds: cmds cmd
#line 387 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));

        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1632 "ado.tab.cpp"
    break;

  case 29: // cmds: cmds compound_cmd
#line 393 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));

        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1642 "ado.tab.cpp"
    break;

  case 30: // cmd: cmd_sep
#line 401 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1648 "ado.tab.cpp"
    break;

  case 31: // cmd: EMBEDDED_CODE
#line 402 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1654 "ado.tab.cpp"
    break;

  case 32: // cmd: nonmodifier_cmd cmd_sep
#line 405 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1664 "ado.tab.cpp"
    break;

  case 33: // cmd: long_modifier_cmd ":" modifier_cmd_list compound_cmd cmd_sep
#line 411 "ado.ypp"
    {
        (yystack_[2].value.node)->prependChild((yystack_[4].value.node));
        (yystack_[2].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 1677 "ado.tab.cpp"
    break;

  case 34: // cmd: long_modifier_cmd ":" modifier_cmd_list nonmodifier_cmd cmd_sep
#line 420 "ado.ypp"
    {
        (yystack_[2].value.node)->prependChild((yystack_[4].value.node));
        (yystack_[2].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 1690 "ado.tab.cpp"
    break;

  case 35: // cmd: long_modifier_cmd ":" nonmodifier_cmd cmd_sep
#line 429 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_modifier_cmd_list");

        (yystack_[0].value.node); // suppressing a stupid bison warning

        node->appendChild((yystack_[3].value.node));
        node->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 1705 "ado.tab.cpp"
    break;

  case 36: // cmd: modifier_cmd_list nonmodifier_cmd cmd_sep
#line 440 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[2].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 1717 "ado.tab.cpp"
    break;

  case 37: // cmd: modifier_cmd_list ":" nonmodifier_cmd cmd_sep
#line 448 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[3].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[3].value.node);
    }
#line 1729 "ado.tab.cpp"
    break;

  case 38: // cmd: modifier_cmd_list compound_cmd cmd_sep
#line 456 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[2].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 1741 "ado.tab.cpp"
    break;

  case 39: // cmd: modifier_cmd_list ":" compound_cmd cmd_sep
#line 464 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[3].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[3].value.node);
    }
#line 1753 "ado.tab.cpp"
    break;

  case 40: // cmd: modifier_cmd_list long_modifier_cmd ":" nonmodifier_cmd cmd_sep
#line 472 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[4].value.node)->appendChild((yystack_[3].value.node));
        (yystack_[4].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[4].value.node);
    }
#line 1766 "ado.tab.cpp"
    break;

  case 41: // cmd: modifier_cmd_list long_modifier_cmd ":" compound_cmd cmd_sep
#line 481 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[4].value.node)->appendChild((yystack_[3].value.node));
        (yystack_[4].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[4].value.node);
    }
#line 1779 "ado.tab.cpp"
    break;

  case 42: // cmd: modifier_cmd_list long_modifier_cmd ":" modifier_cmd_list nonmodifier_cmd cmd_sep
#line 490 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[5].value.node)->appendChild((yystack_[4].value.node));
        (yystack_[5].value.node)->appendChild((yystack_[2].value.node));
        (yystack_[5].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[5].value.node);
    }
#line 1793 "ado.tab.cpp"
    break;

  case 43: // cmd: modifier_cmd_list long_modifier_cmd ":" modifier_cmd_list compound_cmd cmd_sep
#line 500 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[5].value.node)->appendChild((yystack_[4].value.node));
        (yystack_[5].value.node)->appendChild((yystack_[2].value.node));
        (yystack_[5].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[5].value.node);
    }
#line 1807 "ado.tab.cpp"
    break;

  case 44: // cmd_sep: NEWLINE
#line 513 "ado.ypp"
    {
        (yystack_[0].value.str); // suppressing a stupid bison warning

        (yylhs.value.node) = new ExprNode();
    }
#line 1817 "ado.tab.cpp"
    break;

  case 45: // cmd_sep: ";"
#line 519 "ado.ypp"
    {
        (yystack_[0].value.str); // suppressing a stupid bison warning

        (yylhs.value.node) = new ExprNode();
    }
#line 1827 "ado.tab.cpp"
    break;

  case 46: // modifier_cmd: CAPTURE
#line 528 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_modifier_cmd"});
        node->appendChild("verb", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1838 "ado.tab.cpp"
    break;

  case 47: // modifier_cmd: QUIETLY
#line 535 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_modifier_cmd"});
        node->appendChild("verb", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1849 "ado.tab.cpp"
    break;

  case 48: // modifier_cmd: NOISILY
#line 542 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_modifier_cmd"});
        node->appendChild("verb", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1860 "ado.tab.cpp"
    break;

  case 49: // long_modifier_cmd: BYSORT expression_list option_list
#line 552 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
          node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1876 "ado.tab.cpp"
    break;

  case 50: // long_modifier_cmd: BY expression_list option_list
#line 564 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
          node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1892 "ado.tab.cpp"
    break;

  case 51: // long_modifier_cmd: XI option_list
#line 576 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
          node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1906 "ado.tab.cpp"
    break;

  case 52: // modifier_cmd_list: modifier_cmd
#line 589 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_modifier_cmd_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 1916 "ado.tab.cpp"
    break;

  case 53: // modifier_cmd_list: modifier_cmd_list modifier_cmd
#line 595 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1925 "ado.tab.cpp"
    break;

  case 54: // nonmodifier_cmd: IDENT expression_list if_clause in_clause weight_clause using_clause option_list
#line 603 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[6].value.node));
        node->appendChild("expression_list", (yystack_[5].value.node));

        if((yystack_[4].value.node)->nChildren() > 0)
            node->appendChild("if_clause", (yystack_[4].value.node));

        if((yystack_[3].value.node)->nChildren() > 0)
            node->appendChild("in_clause", (yystack_[3].value.node));

        if((yystack_[2].value.node)->nChildren() > 0)
            node->appendChild("weight_clause", (yystack_[2].value.node));

        if((yystack_[1].value.node)->nChildren() > 0)
            node->appendChild("using_clause", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1952 "ado.tab.cpp"
    break;

  case 55: // nonmodifier_cmd: IDENT if_clause in_clause weight_clause using_clause option_list
#line 626 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[5].value.node));

        if((yystack_[4].value.node)->nChildren() > 0)
            node->appendChild("if_clause", (yystack_[4].value.node));

        if((yystack_[3].value.node)->nChildren() > 0)
            node->appendChild("in_clause", (yystack_[3].value.node));

        if((yystack_[2].value.node)->nChildren() > 0)
            node->appendChild("weight_clause", (yystack_[2].value.node));

        if((yystack_[1].value.node)->nChildren() > 0)
            node->appendChild("using_clause", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1978 "ado.tab.cpp"
    break;

  case 56: // nonmodifier_cmd: MERGE MERGE_SPEC expression_list using_clause option_list
#line 653 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[4].value.node));

        if((yystack_[2].value.node)->nChildren() > 0)
            node->appendChild("expression_list", (yystack_[2].value.node));

        if((yystack_[1].value.node)->nChildren() > 0)
            node->appendChild("using_clause", (yystack_[1].value.node));

        // we're going to make the merge_spec an option
        ExprNode *opt = new ExprNode("ado_option");
        ExprNode *name = new ExprNode({"ado_literal", "ado_ident"});
        name->addData("value", *(new std::string("merge_spec")));
        opt->appendChild("name", name);

        ExprNode *arglist = new ExprNode("ado_argument_expression_list");
        ExprNode *explist = new ExprNode("ado_expression_list");
        explist->appendChild((yystack_[3].value.node));
        arglist->appendChild(explist);
        opt->appendChild("args", arglist);

        (yystack_[0].value.node)->appendChild(opt);
        node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2010 "ado.tab.cpp"
    break;

  case 57: // nonmodifier_cmd: XI expression_list option_list
#line 681 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2026 "ado.tab.cpp"
    break;

  case 58: // nonmodifier_cmd: IVREGRESS TSLS varlist "(" varlist "=" varlist ")" if_clause in_clause weight_clause option_list
#line 693 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[11].value.node));

        (yystack_[9].value.node)->prependChild((yystack_[10].value.node));
        node->appendChild("expression_list", (yystack_[9].value.node));

        if((yystack_[3].value.node)->nChildren() > 0)
            node->appendChild("if_clause", (yystack_[3].value.node));

        if((yystack_[2].value.node)->nChildren() > 0)
            node->appendChild("in_clause", (yystack_[2].value.node));

        if((yystack_[1].value.node)->nChildren() > 0)
            node->appendChild("weight_clause", (yystack_[1].value.node));

        // We're going to make the other two varlists into options
        ExprNode *endogenous_opt = new ExprNode("ado_option");
        ExprNode *endogenous_name = new ExprNode({"ado_literal", "ado_ident"});
        endogenous_name->addData("value", *(new std::string("endogenous_vars")));
        endogenous_opt->appendChild("name", endogenous_name);

        ExprNode *endogenous_args = new ExprNode("ado_argument_expression_list");
        endogenous_args->appendChild((yystack_[7].value.node));
        endogenous_opt->appendChild("args", endogenous_args);

        ExprNode *instrumental_opt = new ExprNode("ado_option");
        ExprNode *instrumental_name = new ExprNode({"ado_literal", "ado_ident"});
        instrumental_name->addData("value", *(new std::string("instrumental_vars")));
        instrumental_opt->appendChild("name", instrumental_name);

        ExprNode *instrumental_args = new ExprNode("ado_argument_expression_list");
        instrumental_args->appendChild((yystack_[5].value.node));
        instrumental_opt->appendChild("args", instrumental_args);

        (yystack_[1].value.node)->appendChild(endogenous_opt);
        (yystack_[1].value.node)->appendChild(instrumental_opt);
        node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2072 "ado.tab.cpp"
    break;

  case 59: // nonmodifier_cmd: GSORT gsort_varlist option_list
#line 735 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2088 "ado.tab.cpp"
    break;

  case 60: // nonmodifier_cmd: COLLAPSE collapse_spec_base_list if_clause in_clause weight_clause option_list
#line 747 "ado.ypp"
    {
        ExprNode *cmd = new ExprNode({"ado_cmd", "ado_general_cmd"});
        cmd->appendChild("verb", (yystack_[5].value.node));

        /* the components which are correct as-is */
        if((yystack_[3].value.node)->nChildren() > 0)
            cmd->appendChild("if_clause", (yystack_[3].value.node));

        if((yystack_[2].value.node)->nChildren() > 0)
            cmd->appendChild("in_clause", (yystack_[2].value.node));

        if((yystack_[1].value.node)->nChildren() > 0)
            cmd->appendChild("weight_clause", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            cmd->appendChild("option_list", (yystack_[0].value.node));

        /* the expression list we need to wrap in a function call */
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));

        // the "left" child
        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("collapse_stat")));
        node->appendChild("left", left);

        // the "right" child
        ExprNode *mean = new ExprNode({"ado_literal", "ado_ident"});
        mean->addData("value", *(new std::string("mean")));

        ExprNode *explist = new ExprNode("ado_expression_list");
        ExprNode *arglist = new ExprNode("ado_argument_expression_list");

        explist->appendChild(mean); // stat goes first
        arglist->appendChild(explist);
        arglist->appendChild((yystack_[4].value.node)); // variable names or assignments follow

        node->appendChild("right", arglist);
        cmd->appendChild("expression_list", node);

        (yylhs.value.node) = cmd;
    }
#line 2135 "ado.tab.cpp"
    break;

  case 61: // nonmodifier_cmd: COLLAPSE collapse_list if_clause in_clause weight_clause option_list
#line 790 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[5].value.node));

        node->appendChild("expression_list", (yystack_[4].value.node));

        if((yystack_[3].value.node)->nChildren() > 0)
            node->appendChild("if_clause", (yystack_[3].value.node));

        if((yystack_[2].value.node)->nChildren() > 0)
            node->appendChild("in_clause", (yystack_[2].value.node));

        if((yystack_[1].value.node)->nChildren() > 0)
            node->appendChild("weight_clause", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2160 "ado.tab.cpp"
    break;

  case 62: // nonmodifier_cmd: LRTEST modelspec_list option_list
#line 811 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2176 "ado.tab.cpp"
    break;

  case 63: // nonmodifier_cmd: ANOVA IDENT anova_term_list if_clause in_clause weight_clause option_list
#line 823 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[6].value.node));

        (yystack_[4].value.node)->prependChild((yystack_[5].value.node));
        node->appendChild("expression_list", (yystack_[4].value.node));

        if((yystack_[3].value.node)->nChildren() > 0)
            node->appendChild("if_clause", (yystack_[3].value.node));

        if((yystack_[2].value.node)->nChildren() > 0)
            node->appendChild("in_clause", (yystack_[2].value.node));

        if((yystack_[1].value.node)->nChildren() > 0)
            node->appendChild("weight_clause", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2202 "ado.tab.cpp"
    break;

  case 64: // nonmodifier_cmd: RECODE recode_rule_list if_clause in_clause option_list
#line 845 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[4].value.node));

        node->appendChild("expression_list", (yystack_[3].value.node));

        if((yystack_[2].value.node)->nChildren() > 0)
            node->appendChild("if_clause", (yystack_[2].value.node));

        if((yystack_[1].value.node)->nChildren() > 0)
            node->appendChild("in_clause", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2224 "ado.tab.cpp"
    break;

  case 65: // varlist: IDENT
#line 867 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2234 "ado.tab.cpp"
    break;

  case 66: // varlist: varlist IDENT
#line 873 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2243 "ado.tab.cpp"
    break;

  case 67: // number_or_missing: NUMBER
#line 880 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2249 "ado.tab.cpp"
    break;

  case 68: // number_or_missing: "."
#line 881 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2255 "ado.tab.cpp"
    break;

  case 69: // numlist: number_or_missing
#line 886 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2265 "ado.tab.cpp"
    break;

  case 70: // numlist: numlist number_or_missing
#line 892 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2274 "ado.tab.cpp"
    break;

  case 71: // collapse_spec_base: IDENT
#line 900 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2280 "ado.tab.cpp"
    break;

  case 72: // collapse_spec_base: IDENT "=" IDENT
#line 902 "ado.ypp"
    {
        // this would be an assignment expression as usual, except that
        // for every single other command than this one, assignment expressions
        // shouldn't be allowed in function argument lists. they're not allowed here
        // syntactically either, and it'd be an even uglier hack to allow them everywhere
        // just for this internal representation.
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));

        // the "left" child
        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("collapse_newvar")));
        node->appendChild("left", left);

        // the "right" child
        ExprNode *arglist = new ExprNode("ado_argument_expression_list");
        ExprNode *explist = new ExprNode("ado_expression_list");
        explist->appendChild((yystack_[2].value.node));
        explist->appendChild((yystack_[0].value.node));
        arglist->appendChild(explist);

        node->appendChild("right", arglist);
        (yylhs.value.node) = node;
    }
#line 2309 "ado.tab.cpp"
    break;

  case 73: // collapse_spec_base_list: collapse_spec_base
#line 930 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2319 "ado.tab.cpp"
    break;

  case 74: // collapse_spec_base_list: collapse_spec_base_list collapse_spec_base
#line 936 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2328 "ado.tab.cpp"
    break;

  case 75: // collapse_spec: "(" IDENT ")" collapse_spec_base_list
#line 944 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));

        // the "left" child
        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("collapse_stat")));
        node->appendChild("left", left);

        // the "right" child
        ExprNode *explist = new ExprNode("ado_expression_list");
        explist->appendChild((yystack_[2].value.node)); // stat goes first
        ExprNode *arglist = new ExprNode("ado_argument_expression_list");
        arglist->appendChild(explist);
        arglist->appendChild((yystack_[0].value.node)); // variable names or assignments follow

        node->appendChild("right", arglist);
        (yylhs.value.node) = node;
    }
#line 2352 "ado.tab.cpp"
    break;

  case 76: // collapse_list: collapse_spec
#line 967 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2362 "ado.tab.cpp"
    break;

  case 77: // collapse_list: collapse_list collapse_spec
#line 973 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2371 "ado.tab.cpp"
    break;

  case 78: // recode_rule: IDENT
#line 981 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2377 "ado.tab.cpp"
    break;

  case 79: // recode_rule: "(" IDENT "=" NUMBER ")"
#line 983 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));

        // the "left" child
        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("recode_rule_ident")));
        node->appendChild("left", left);

        // the "right" child
        ExprNode *explist = new ExprNode("ado_expression_list");
        explist->appendChild((yystack_[1].value.node)); // destination value goes first
        explist->appendChild((yystack_[3].value.node));
        ExprNode *arglist = new ExprNode("ado_argument_expression_list");
        arglist->appendChild(explist);

        node->appendChild("right", arglist);
        (yylhs.value.node) = node;
    }
#line 2401 "ado.tab.cpp"
    break;

  case 80: // recode_rule: "(" NUMBER "/" NUMBER "=" NUMBER ")"
#line 1003 "ado.ypp"
    {
        (yystack_[4].value.str); // shut up, bison...

        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));

        // the "left" child
        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("recode_rule_range")));
        node->appendChild("left", left);

        // the "right" child
        ExprNode *explist = new ExprNode("ado_expression_list");
        explist->appendChild((yystack_[1].value.node)); // destination value goes first
        explist->appendChild((yystack_[3].value.node)); // then the upper range limit
        explist->appendChild((yystack_[5].value.node)); // then the lower range limit
        ExprNode *arglist = new ExprNode("ado_argument_expression_list");
        arglist->appendChild(explist);

        node->appendChild("right", arglist);
        (yylhs.value.node) = node;
    }
#line 2428 "ado.tab.cpp"
    break;

  case 81: // recode_rule: "(" numlist "=" NUMBER ")"
#line 1026 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));

        // the "left" child
        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("recode_rule_numlist")));
        node->appendChild("left", left);

        // the "right" child
        ExprNode *explist = new ExprNode("ado_expression_list");
        explist->appendChild((yystack_[1].value.node)); // destination value goes first
        ExprNode *arglist = new ExprNode("ado_argument_expression_list");
        arglist->appendChild(explist);
        arglist->appendChild((yystack_[3].value.node)); // this is flattened in the code generator

        node->appendChild("right", arglist);
        (yylhs.value.node) = node;
    }
#line 2452 "ado.tab.cpp"
    break;

  case 82: // recode_rule_list: recode_rule
#line 1049 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2462 "ado.tab.cpp"
    break;

  case 83: // recode_rule_list: recode_rule_list recode_rule
#line 1055 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2471 "ado.tab.cpp"
    break;

  case 84: // gsort_var: IDENT
#line 1064 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));
        node->appendChild("right", (yystack_[0].value.node));

        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("asc")));
        node->appendChild("left", left);

        (yylhs.value.node) = node;
    }
#line 2487 "ado.tab.cpp"
    break;

  case 85: // gsort_var: "+" IDENT
#line 1076 "ado.ypp"
    {
        (yystack_[1].value.str); // shut up, bison...

        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));
        node->appendChild("right", (yystack_[0].value.node));

        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("asc")));
        node->appendChild("left", left);

        (yylhs.value.node) = node;
    }
#line 2505 "ado.tab.cpp"
    break;

  case 86: // gsort_var: "-" IDENT
#line 1090 "ado.ypp"
    {
        (yystack_[1].value.str); // shut up, bison...

        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));
        node->appendChild("right", (yystack_[0].value.node));

        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("desc")));
        node->appendChild("left", left);

        (yylhs.value.node) = node;
    }
#line 2523 "ado.tab.cpp"
    break;

  case 87: // gsort_varlist: gsort_var
#line 1107 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2533 "ado.tab.cpp"
    break;

  case 88: // gsort_varlist: gsort_varlist gsort_var
#line 1113 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2542 "ado.tab.cpp"
    break;

  case 89: // modelspec: IDENT
#line 1121 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2548 "ado.tab.cpp"
    break;

  case 90: // modelspec: "."
#line 1122 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2554 "ado.tab.cpp"
    break;

  case 91: // modelspec: "(" varlist ")"
#line 1124 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));

        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("lrtest_term_list")));
        node->appendChild("left", left);

        ExprNode *arglist = new ExprNode("ado_argument_expression_list");
        arglist->appendChild((yystack_[1].value.node));
        node->appendChild("right", arglist);

        (yylhs.value.node) = node;
    }
#line 2573 "ado.tab.cpp"
    break;

  case 92: // modelspec_list: modelspec
#line 1142 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2583 "ado.tab.cpp"
    break;

  case 93: // modelspec_list: modelspec_list modelspec
#line 1148 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2592 "ado.tab.cpp"
    break;

  case 94: // anova_nest_expression: cross_expression
#line 1156 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2598 "ado.tab.cpp"
    break;

  case 95: // anova_nest_expression: anova_nest_expression "|" cross_expression
#line 1158 "ado.ypp"
    {
        (yystack_[1].value.str); // shut up, bison...

        ExprNode *node = new ExprNode({"ado_expression", "ado_anova_nest_expression"});
        node->addData("verb", *(new std::string("%anova_nest%")));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2613 "ado.tab.cpp"
    break;

  case 96: // anova_error_expression: anova_nest_expression
#line 1171 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2619 "ado.tab.cpp"
    break;

  case 97: // anova_error_expression: anova_nest_expression "/"
#line 1173 "ado.ypp"
    {
        (yystack_[0].value.str); // shut up, bison...

        ExprNode *node = new ExprNode({"ado_expression", "ado_anova_error_expression"});
        node->addData("verb", *(new std::string("%anova_error%")));
        node->appendChild("left", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 2633 "ado.tab.cpp"
    break;

  case 98: // anova_term_list: anova_error_expression
#line 1186 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2643 "ado.tab.cpp"
    break;

  case 99: // anova_term_list: anova_term_list anova_error_expression
#line 1192 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2652 "ado.tab.cpp"
    break;

  case 101: // unary_operator: "-"
#line 1211 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2658 "ado.tab.cpp"
    break;

  case 102: // unary_operator: "+"
#line 1212 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2664 "ado.tab.cpp"
    break;

  case 103: // unary_operator: "!"
#line 1213 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2670 "ado.tab.cpp"
    break;

  case 104: // unary_factor_operator: CONT_OPERATOR
#line 1217 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2676 "ado.tab.cpp"
    break;

  case 105: // unary_factor_operator: BASE_OPERATOR
#line 1218 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2682 "ado.tab.cpp"
    break;

  case 106: // unary_factor_operator: IND_OPERATOR
#line 1219 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2688 "ado.tab.cpp"
    break;

  case 107: // unary_factor_operator: OMIT_OPERATOR
#line 1220 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2694 "ado.tab.cpp"
    break;

  case 108: // power_operator: "^"
#line 1224 "ado.ypp"
    { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2700 "ado.tab.cpp"
    break;

  case 109: // multiplication_operator: "*"
#line 1228 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2706 "ado.tab.cpp"
    break;

  case 110: // multiplication_operator: "/"
#line 1229 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2712 "ado.tab.cpp"
    break;

  case 111: // additive_operator: "+"
#line 1233 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2718 "ado.tab.cpp"
    break;

  case 112: // additive_operator: "-"
#line 1234 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2724 "ado.tab.cpp"
    break;

  case 113: // relational_operator: "<"
#line 1238 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2730 "ado.tab.cpp"
    break;

  case 114: // relational_operator: ">"
#line 1239 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2736 "ado.tab.cpp"
    break;

  case 115: // relational_operator: ">="
#line 1240 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2742 "ado.tab.cpp"
    break;

  case 116: // relational_operator: "<="
#line 1241 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2748 "ado.tab.cpp"
    break;

  case 117: // equality_operator: "=="
#line 1245 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2754 "ado.tab.cpp"
    break;

  case 118: // equality_operator: "!="
#line 1246 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2760 "ado.tab.cpp"
    break;

  case 119: // logical_operator: "&"
#line 1250 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2766 "ado.tab.cpp"
    break;

  case 120: // logical_operator: "|"
#line 1251 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2772 "ado.tab.cpp"
    break;

  case 121: // cross_operator: "##"
#line 1255 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2778 "ado.tab.cpp"
    break;

  case 122: // cross_operator: "#"
#line 1256 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2784 "ado.tab.cpp"
    break;

  case 123: // format_spec: STRING_FORMAT
#line 1260 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2790 "ado.tab.cpp"
    break;

  case 124: // format_spec: NUMBER_FORMAT
#line 1261 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2796 "ado.tab.cpp"
    break;

  case 125: // format_spec: DATETIME_FORMAT
#line 1262 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2802 "ado.tab.cpp"
    break;

  case 126: // literal_expression: IDENT
#line 1283 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2808 "ado.tab.cpp"
    break;

  case 127: // literal_expression: BYTE
#line 1285 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_literal", "ado_ident"});
        node->addData("value", *((yystack_[0].value.str)));
        (yylhs.value.node) = node;
    }
#line 2818 "ado.tab.cpp"
    break;

  case 128: // literal_expression: INT
#line 1291 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_literal", "ado_ident"});
        node->addData("value", *((yystack_[0].value.str)));
        (yylhs.value.node) = node;
    }
#line 2828 "ado.tab.cpp"
    break;

  case 129: // literal_expression: LONG
#line 1297 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_literal", "ado_ident"});
        node->addData("value", *((yystack_[0].value.str)));
        (yylhs.value.node) = node;
    }
#line 2838 "ado.tab.cpp"
    break;

  case 130: // literal_expression: FLOAT
#line 1303 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_literal", "ado_ident"});
        node->addData("value", *((yystack_[0].value.str)));
        (yylhs.value.node) = node;
    }
#line 2848 "ado.tab.cpp"
    break;

  case 131: // literal_expression: DOUBLE
#line 1309 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_literal", "ado_ident"});
        node->addData("value", *((yystack_[0].value.str)));
        (yylhs.value.node) = node;
    }
#line 2858 "ado.tab.cpp"
    break;

  case 132: // literal_expression: STRING_TYPE_SPEC
#line 1315 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_literal", "ado_ident"});
        node->addData("value", *((yystack_[0].value.str)));
        (yylhs.value.node) = node;
    }
#line 2868 "ado.tab.cpp"
    break;

  case 133: // literal_expression: NUMBER
#line 1320 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2874 "ado.tab.cpp"
    break;

  case 134: // literal_expression: STRING_LITERAL
#line 1321 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2880 "ado.tab.cpp"
    break;

  case 135: // literal_expression: DATE
#line 1322 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2886 "ado.tab.cpp"
    break;

  case 136: // literal_expression: DATETIME
#line 1323 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2892 "ado.tab.cpp"
    break;

  case 137: // literal_expression: "."
#line 1324 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2898 "ado.tab.cpp"
    break;

  case 138: // literal_expression: format_spec
#line 1325 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2904 "ado.tab.cpp"
    break;

  case 139: // primary_expression: literal_expression
#line 1330 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[0].value.node);
    }
#line 2912 "ado.tab.cpp"
    break;

  case 140: // primary_expression: "(" expression ")"
#line 1334 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2920 "ado.tab.cpp"
    break;

  case 141: // primary_expression: BYTE "(" expression_list ")"
#line 1338 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[3].value.str)));
        node->appendChild("left", (yystack_[1].value.node));
        (yylhs.value.node) = node;
    }
#line 2931 "ado.tab.cpp"
    break;

  case 142: // primary_expression: INT "(" expression_list ")"
#line 1345 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[3].value.str)));
        node->appendChild("left", (yystack_[1].value.node));
        (yylhs.value.node) = node;
    }
#line 2942 "ado.tab.cpp"
    break;

  case 143: // primary_expression: LONG "(" expression_list ")"
#line 1352 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[3].value.str)));
        node->appendChild("left", (yystack_[1].value.node));
        (yylhs.value.node) = node;
    }
#line 2953 "ado.tab.cpp"
    break;

  case 144: // primary_expression: FLOAT "(" expression_list ")"
#line 1359 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[3].value.str)));
        node->appendChild("left", (yystack_[1].value.node));
        (yylhs.value.node) = node;
    }
#line 2964 "ado.tab.cpp"
    break;

  case 145: // primary_expression: DOUBLE "(" expression_list ")"
#line 1366 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[3].value.str)));
        node->appendChild("left", (yystack_[1].value.node));
        (yylhs.value.node) = node;
    }
#line 2975 "ado.tab.cpp"
    break;

  case 146: // primary_expression: STRING_TYPE_SPEC "(" expression_list ")"
#line 1373 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[3].value.str)));
        node->appendChild("left", (yystack_[1].value.node));
        (yylhs.value.node) = node;
    }
#line 2986 "ado.tab.cpp"
    break;

  case 147: // primary_expression: BYTE IDENT
#line 1380 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        ExprNode *lst = new ExprNode("ado_expression_list");
        lst->appendChild((yystack_[0].value.node));
        node->appendChild("left", lst);
        (yylhs.value.node) = node;
    }
#line 2999 "ado.tab.cpp"
    break;

  case 148: // primary_expression: INT IDENT
#line 1389 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        ExprNode *lst = new ExprNode("ado_expression_list");
        lst->appendChild((yystack_[0].value.node));
        node->appendChild("left", lst);
        (yylhs.value.node) = node;
    }
#line 3012 "ado.tab.cpp"
    break;

  case 149: // primary_expression: LONG IDENT
#line 1398 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        ExprNode *lst = new ExprNode("ado_expression_list");
        lst->appendChild((yystack_[0].value.node));
        node->appendChild("left", lst);
        (yylhs.value.node) = node;
    }
#line 3025 "ado.tab.cpp"
    break;

  case 150: // primary_expression: FLOAT IDENT
#line 1407 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        ExprNode *lst = new ExprNode("ado_expression_list");
        lst->appendChild((yystack_[0].value.node));
        node->appendChild("left", lst);
        (yylhs.value.node) = node;
    }
#line 3038 "ado.tab.cpp"
    break;

  case 151: // primary_expression: DOUBLE IDENT
#line 1416 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        ExprNode *lst = new ExprNode("ado_expression_list");
        lst->appendChild((yystack_[0].value.node));
        node->appendChild("left", lst);
        (yylhs.value.node) = node;
    }
#line 3051 "ado.tab.cpp"
    break;

  case 152: // primary_expression: STRING_TYPE_SPEC IDENT
#line 1425 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        ExprNode *lst = new ExprNode("ado_expression_list");
        lst->appendChild((yystack_[0].value.node));
        node->appendChild("left", lst);
        (yylhs.value.node) = node;
    }
#line 3064 "ado.tab.cpp"
    break;

  case 153: // unary_factor_expression: primary_expression
#line 1436 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3070 "ado.tab.cpp"
    break;

  case 154: // unary_factor_expression: unary_factor_operator primary_expression
#line 1438 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild("left", (yystack_[0].value.node));

        (yylhs.value.node) = (yystack_[1].value.node); // ExprNode constructed by the lexer, which is a bit of a hack
    }
#line 3080 "ado.tab.cpp"
    break;

  case 155: // cross_expression: unary_factor_expression
#line 1446 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3086 "ado.tab.cpp"
    break;

  case 156: // cross_expression: cross_expression cross_operator unary_factor_expression
#line 1448 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_cross_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3098 "ado.tab.cpp"
    break;

  case 157: // postfix_expression: cross_expression
#line 1458 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3104 "ado.tab.cpp"
    break;

  case 158: // postfix_expression: postfix_expression "[" additive_expression "]"
#line 1460 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", std::string("[]"));
        node->appendChild("left", (yystack_[3].value.node));
        node->appendChild("right", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 3117 "ado.tab.cpp"
    break;

  case 159: // postfix_expression: postfix_expression "(" ")"
#line 1469 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", std::string("()"));
        node->appendChild("left", (yystack_[2].value.node));

        (yylhs.value.node) = node;
    }
#line 3129 "ado.tab.cpp"
    break;

  case 160: // postfix_expression: postfix_expression "(" argument_expression_list ")"
#line 1477 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", std::string("()"));
        node->appendChild("left", (yystack_[3].value.node));
        node->appendChild("right", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 3142 "ado.tab.cpp"
    break;

  case 161: // power_expression: postfix_expression
#line 1488 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3148 "ado.tab.cpp"
    break;

  case 162: // power_expression: power_expression power_operator postfix_expression
#line 1490 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_arithmetic_expression", "ado_power_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3160 "ado.tab.cpp"
    break;

  case 163: // unary_expression: power_expression
#line 1500 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3166 "ado.tab.cpp"
    break;

  case 164: // unary_expression: unary_operator power_expression
#line 1502 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_arithmetic_expression", "ado_unary_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3177 "ado.tab.cpp"
    break;

  case 165: // multiplication_expression: unary_expression
#line 1511 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3183 "ado.tab.cpp"
    break;

  case 166: // multiplication_expression: multiplication_expression multiplication_operator unary_expression
#line 1513 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_arithmetic_expression", "ado_multiplication_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3195 "ado.tab.cpp"
    break;

  case 167: // additive_expression: multiplication_expression
#line 1523 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3201 "ado.tab.cpp"
    break;

  case 168: // additive_expression: additive_expression additive_operator multiplication_expression
#line 1525 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_arithmetic_expression", "ado_additive_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3213 "ado.tab.cpp"
    break;

  case 169: // relational_expression: additive_expression
#line 1535 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3219 "ado.tab.cpp"
    break;

  case 170: // relational_expression: relational_expression relational_operator additive_expression
#line 1537 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_relational_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3231 "ado.tab.cpp"
    break;

  case 171: // equality_expression: relational_expression
#line 1547 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3237 "ado.tab.cpp"
    break;

  case 172: // equality_expression: equality_expression equality_operator relational_expression
#line 1549 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_equality_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3249 "ado.tab.cpp"
    break;

  case 173: // logical_expression: equality_expression
#line 1559 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3255 "ado.tab.cpp"
    break;

  case 174: // logical_expression: logical_expression logical_operator equality_expression
#line 1561 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_logical_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3267 "ado.tab.cpp"
    break;

  case 175: // expression: logical_expression
#line 1571 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3273 "ado.tab.cpp"
    break;

  case 176: // expression: logical_expression assignment_operator logical_expression
#line 1573 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_assignment_expression"});
        node->addData("verb", "=");
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3285 "ado.tab.cpp"
    break;

  case 177: // expression_list: expression
#line 1584 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3295 "ado.tab.cpp"
    break;

  case 178: // expression_list: expression_list expression
#line 1590 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 3304 "ado.tab.cpp"
    break;

  case 179: // argument_expression_list: expression_list
#line 1598 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_argument_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3314 "ado.tab.cpp"
    break;

  case 180: // argument_expression_list: argument_expression_list "," expression_list
#line 1604 "ado.ypp"
    {
        (yystack_[2].value.node)->appendChild((yystack_[0].value.node));

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 3324 "ado.tab.cpp"
    break;

  case 181: // option_list: %empty
#line 1619 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_option_list");
    }
#line 3332 "ado.tab.cpp"
    break;

  case 182: // option_list: "," options
#line 1623 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[0].value.node);
    }
#line 3340 "ado.tab.cpp"
    break;

  case 183: // options: option
#line 1630 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_option_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3350 "ado.tab.cpp"
    break;

  case 184: // options: options option
#line 1636 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 3359 "ado.tab.cpp"
    break;

  case 185: // option: option_ident
#line 1644 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_option");
        node->appendChild("name", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3370 "ado.tab.cpp"
    break;

  case 186: // option: option_ident "(" argument_expression_list ")"
#line 1651 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_option");
        node->appendChild("name", (yystack_[3].value.node));
        node->appendChild("args", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 3382 "ado.tab.cpp"
    break;

  case 187: // option_ident: IDENT
#line 1663 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3388 "ado.tab.cpp"
    break;

  case 188: // option_ident: BY
#line 1664 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3394 "ado.tab.cpp"
    break;

  case 189: // option_ident: BYSORT
#line 1665 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3400 "ado.tab.cpp"
    break;

  case 190: // option_ident: XI
#line 1666 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3406 "ado.tab.cpp"
    break;

  case 191: // option_ident: CAPTURE
#line 1667 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3412 "ado.tab.cpp"
    break;

  case 192: // option_ident: QUIETLY
#line 1668 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3418 "ado.tab.cpp"
    break;

  case 193: // option_ident: NOISILY
#line 1669 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3424 "ado.tab.cpp"
    break;

  case 194: // option_ident: MERGE
#line 1670 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3430 "ado.tab.cpp"
    break;

  case 195: // option_ident: COLLAPSE
#line 1671 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3436 "ado.tab.cpp"
    break;

  case 196: // option_ident: RECODE
#line 1672 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3442 "ado.tab.cpp"
    break;

  case 197: // option_ident: IVREGRESS
#line 1673 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3448 "ado.tab.cpp"
    break;

  case 198: // option_ident: GSORT
#line 1674 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3454 "ado.tab.cpp"
    break;

  case 199: // option_ident: LRTEST
#line 1675 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3460 "ado.tab.cpp"
    break;

  case 200: // option_ident: ANOVA
#line 1676 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3466 "ado.tab.cpp"
    break;

  case 201: // weight_clause: %empty
#line 1687 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_weight_clause");
    }
#line 3474 "ado.tab.cpp"
    break;

  case 202: // weight_clause: WEIGHT_SPEC literal_expression "]"
#line 1691 "ado.ypp"
    {
        (yystack_[2].value.node)->appendChild("right", (yystack_[1].value.node));
        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 3483 "ado.tab.cpp"
    break;

  case 203: // if_clause: %empty
#line 1705 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_if_clause");
    }
#line 3491 "ado.tab.cpp"
    break;

  case 204: // if_clause: IF expression
#line 1709 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_if_clause");
        node->appendChild("if_expression", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3502 "ado.tab.cpp"
    break;

  case 205: // in_clause: %empty
#line 1725 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_in_clause");
    }
#line 3510 "ado.tab.cpp"
    break;

  case 206: // in_clause: IN unary_expression "/" unary_expression
#line 1729 "ado.ypp"
    {
        (yystack_[1].value.str); // suppressing a stupid bison warning

        ExprNode *node = new ExprNode("ado_in_clause");
        node->appendChild("lower", (yystack_[2].value.node));
        node->appendChild("upper", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3524 "ado.tab.cpp"
    break;

  case 207: // in_clause: IN unary_expression
#line 1739 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_in_clause");
        node->appendChild("upper", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3535 "ado.tab.cpp"
    break;

  case 208: // using_clause: %empty
#line 1755 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_using_clause");
    }
#line 3543 "ado.tab.cpp"
    break;

  case 209: // using_clause: USING STRING_LITERAL
#line 1759 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_using_clause");
        node->appendChild("filename", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3554 "ado.tab.cpp"
    break;

  case 210: // using_clause: USING IDENT
#line 1766 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_using_clause");
        node->appendChild("filename", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3565 "ado.tab.cpp"
    break;


#line 3569 "ado.tab.cpp"

            default:
              break;
            }
        }
#if YY_EXCEPTIONS
      catch (const syntax_error& yyexc)
        {
          YYCDEBUG << "Caught exception: " << yyexc.what() << '\n';
          error (yyexc);
          YYERROR;
        }
#endif // YY_EXCEPTIONS
      YY_SYMBOL_PRINT ("-> $$ =", yylhs);
      yypop_ (yylen);
      yylen = 0;

      // Shift the result of the reduction.
      yypush_ (YY_NULLPTR, YY_MOVE (yylhs));
    }
    goto yynewstate;


  /*--------------------------------------.
  | yyerrlab -- here on detecting error.  |
  `--------------------------------------*/
  yyerrlab:
    // If not already recovering from an error, report this error.
    if (!yyerrstatus_)
      {
        ++yynerrs_;
        context yyctx (*this, yyla);
        std::string msg = yysyntax_error_ (yyctx);
        error (yyla.location, YY_MOVE (msg));
      }


    yyerror_range[1].location = yyla.location;
    if (yyerrstatus_ == 3)
      {
        /* If just tried and failed to reuse lookahead token after an
           error, discard it.  */

        // Return failure if at end of input.
        if (yyla.kind () == symbol_kind::S_YYEOF)
          YYABORT;
        else if (!yyla.empty ())
          {
            yy_destroy_ ("Error: discarding", yyla);
            yyla.clear ();
          }
      }

    // Else will try to reuse lookahead token after shifting the error token.
    goto yyerrlab1;


  /*---------------------------------------------------.
  | yyerrorlab -- error raised explicitly by YYERROR.  |
  `---------------------------------------------------*/
  yyerrorlab:
    /* Pacify compilers when the user code never invokes YYERROR and
       the label yyerrorlab therefore never appears in user code.  */
    if (false)
      YYERROR;

    /* Do not reclaim the symbols of the rule whose action triggered
       this YYERROR.  */
    yypop_ (yylen);
    yylen = 0;
    YY_STACK_PRINT ();
    goto yyerrlab1;


  /*-------------------------------------------------------------.
  | yyerrlab1 -- common code for both syntax error and YYERROR.  |
  `-------------------------------------------------------------*/
  yyerrlab1:
    yyerrstatus_ = 3;   // Each real token shifted decrements this.
    // Pop stack until we find a state that shifts the error token.
    for (;;)
      {
        yyn = yypact_[+yystack_[0].state];
        if (!yy_pact_value_is_default_ (yyn))
          {
            yyn += symbol_kind::S_YYerror;
            if (0 <= yyn && yyn <= yylast_
                && yycheck_[yyn] == symbol_kind::S_YYerror)
              {
                yyn = yytable_[yyn];
                if (0 < yyn)
                  break;
              }
          }

        // Pop the current state because it cannot handle the error token.
        if (yystack_.size () == 1)
          YYABORT;

        yyerror_range[1].location = yystack_[0].location;
        yy_destroy_ ("Error: popping", yystack_[0]);
        yypop_ ();
        YY_STACK_PRINT ();
      }
    {
      stack_symbol_type error_token;

      yyerror_range[2].location = yyla.location;
      YYLLOC_DEFAULT (error_token.location, yyerror_range, 2);

      // Shift the error token.
      error_token.state = state_type (yyn);
      yypush_ ("Shifting", YY_MOVE (error_token));
    }
    goto yynewstate;


  /*-------------------------------------.
  | yyacceptlab -- YYACCEPT comes here.  |
  `-------------------------------------*/
  yyacceptlab:
    yyresult = 0;
    goto yyreturn;


  /*-----------------------------------.
  | yyabortlab -- YYABORT comes here.  |
  `-----------------------------------*/
  yyabortlab:
    yyresult = 1;
    goto yyreturn;


  /*-----------------------------------------------------.
  | yyreturn -- parsing is finished, return the result.  |
  `-----------------------------------------------------*/
  yyreturn:
    if (!yyla.empty ())
      yy_destroy_ ("Cleanup: discarding lookahead", yyla);

    /* Do not reclaim the symbols of the rule whose action triggered
       this YYABORT or YYACCEPT.  */
    yypop_ (yylen);
    YY_STACK_PRINT ();
    while (1 < yystack_.size ())
      {
        yy_destroy_ ("Cleanup: popping", yystack_[0]);
        yypop_ ();
      }

    return yyresult;
  }
#if YY_EXCEPTIONS
    catch (...)
      {
        YYCDEBUG << "Exception caught: cleaning lookahead and stack\n";
        // Do not try to display the values of the reclaimed symbols,
        // as their printers might throw an exception.
        if (!yyla.empty ())
          yy_destroy_ (YY_NULLPTR, yyla);

        while (1 < yystack_.size ())
          {
            yy_destroy_ (YY_NULLPTR, yystack_[0]);
            yypop_ ();
          }
        throw;
      }
#endif // YY_EXCEPTIONS
  }

  void
   AdoParser ::error (const syntax_error& yyexc)
  {
    error (yyexc.location, yyexc.what ());
  }

  /* Return YYSTR after stripping away unnecessary quotes and
     backslashes, so that it's suitable for yyerror.  The heuristic is
     that double-quoting is unnecessary unless the string contains an
     apostrophe, a comma, or backslash (other than backslash-backslash).
     YYSTR is taken from yytname.  */
  std::string
   AdoParser ::yytnamerr_ (const char *yystr)
  {
    if (*yystr == '"')
      {
        std::string yyr;
        char const *yyp = yystr;

        for (;;)
          switch (*++yyp)
            {
            case '\'':
            case ',':
              goto do_not_strip_quotes;

            case '\\':
              if (*++yyp != '\\')
                goto do_not_strip_quotes;
              else
                goto append;

            append:
            default:
              yyr += *yyp;
              break;

            case '"':
              return yyr;
            }
      do_not_strip_quotes: ;
      }

    return yystr;
  }

  std::string
   AdoParser ::symbol_name (symbol_kind_type yysymbol)
  {
    return yytnamerr_ (yytname_[yysymbol]);
  }



  //  AdoParser ::context.
   AdoParser ::context::context (const  AdoParser & yyparser, const symbol_type& yyla)
    : yyparser_ (yyparser)
    , yyla_ (yyla)
  {}

  int
   AdoParser ::context::expected_tokens (symbol_kind_type yyarg[], int yyargn) const
  {
    // Actual number of expected tokens
    int yycount = 0;

    const int yyn = yypact_[+yyparser_.yystack_[0].state];
    if (!yy_pact_value_is_default_ (yyn))
      {
        /* Start YYX at -YYN if negative to avoid negative indexes in
           YYCHECK.  In other words, skip the first -YYN actions for
           this state because they are default actions.  */
        const int yyxbegin = yyn < 0 ? -yyn : 0;
        // Stay within bounds of both yycheck and yytname.
        const int yychecklim = yylast_ - yyn + 1;
        const int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
        for (int yyx = yyxbegin; yyx < yyxend; ++yyx)
          if (yycheck_[yyx + yyn] == yyx && yyx != symbol_kind::S_YYerror
              && !yy_table_value_is_error_ (yytable_[yyx + yyn]))
            {
              if (!yyarg)
                ++yycount;
              else if (yycount == yyargn)
                return 0;
              else
                yyarg[yycount++] = YY_CAST (symbol_kind_type, yyx);
            }
      }

    if (yyarg && yycount == 0 && 0 < yyargn)
      yyarg[0] = symbol_kind::S_YYEMPTY;
    return yycount;
  }






  int
   AdoParser ::yy_syntax_error_arguments_ (const context& yyctx,
                                                 symbol_kind_type yyarg[], int yyargn) const
  {
    /* There are many possibilities here to consider:
       - If this state is a consistent state with a default action, then
         the only way this function was invoked is if the default action
         is an error action.  In that case, don't check for expected
         tokens because there are none.
       - The only way there can be no lookahead present (in yyla) is
         if this state is a consistent state with a default action.
         Thus, detecting the absence of a lookahead is sufficient to
         determine that there is no unexpected or expected token to
         report.  In that case, just report a simple "syntax error".
       - Don't assume there isn't a lookahead just because this state is
         a consistent state with a default action.  There might have
         been a previous inconsistent state, consistent state with a
         non-default action, or user semantic action that manipulated
         yyla.  (However, yyla is currently not documented for users.)
       - Of course, the expected token list depends on states to have
         correct lookahead information, and it depends on the parser not
         to perform extra reductions after fetching a lookahead from the
         scanner and before detecting a syntax error.  Thus, state merging
         (from LALR or IELR) and default reductions corrupt the expected
         token list.  However, the list is correct for canonical LR with
         one exception: it will still contain any token that will not be
         accepted due to an error action in a later state.
    */

    if (!yyctx.lookahead ().empty ())
      {
        if (yyarg)
          yyarg[0] = yyctx.token ();
        int yyn = yyctx.expected_tokens (yyarg ? yyarg + 1 : yyarg, yyargn - 1);
        return yyn + 1;
      }
    return 0;
  }

  // Generate an error message.
  std::string
   AdoParser ::yysyntax_error_ (const context& yyctx) const
  {
    // Its maximum.
    enum { YYARGS_MAX = 5 };
    // Arguments of yyformat.
    symbol_kind_type yyarg[YYARGS_MAX];
    int yycount = yy_syntax_error_arguments_ (yyctx, yyarg, YYARGS_MAX);

    char const* yyformat = YY_NULLPTR;
    switch (yycount)
      {
#define YYCASE_(N, S)                         \
        case N:                               \
          yyformat = S;                       \
        break
      default: // Avoid compiler warnings.
        YYCASE_ (0, YY_("syntax error"));
        YYCASE_ (1, YY_("syntax error, unexpected %s"));
        YYCASE_ (2, YY_("syntax error, unexpected %s, expecting %s"));
        YYCASE_ (3, YY_("syntax error, unexpected %s, expecting %s or %s"));
        YYCASE_ (4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
        YYCASE_ (5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
#undef YYCASE_
      }

    std::string yyres;
    // Argument number.
    std::ptrdiff_t yyi = 0;
    for (char const* yyp = yyformat; *yyp; ++yyp)
      if (yyp[0] == '%' && yyp[1] == 's' && yyi < yycount)
        {
          yyres += symbol_name (yyarg[yyi++]);
          ++yyp;
        }
      else
        yyres += *yyp;
    return yyres;
  }


  const short  AdoParser ::yypact_ninf_ = -228;

  const signed char  AdoParser ::yytable_ninf_ = -1;

  const short
   AdoParser ::yypact_[] =
  {
     304,  -228,  -228,  -228,   883,   361,  -228,   792,   405,   792,
    -228,  -228,  -228,   -30,    24,    11,    40,    54,    31,    51,
     792,    63,   131,   276,  -228,  -228,  -228,  -228,  -228,  -228,
    -228,  -228,   165,   911,   218,  -228,   855,  -228,  -228,  -228,
     792,  -228,  -228,  -228,  -228,  -228,  -228,  -228,    72,    90,
     100,   108,   111,   130,  -228,  -228,  -228,   792,  -228,  -228,
    -228,  -228,   807,   941,  -228,  -228,  -228,  -228,   182,    41,
     149,  -228,   209,   237,   221,   217,   204,  -228,   361,   110,
     405,   956,   405,  -228,   405,   792,   170,   181,  -228,    13,
    -228,    22,   175,   174,  -228,  -228,    18,   177,   190,  -228,
    -228,    49,   175,  -228,  -228,  -228,    38,   807,   224,   101,
     236,  -228,  -228,  -228,   968,    44,   218,  -228,   239,   218,
    -228,  -228,  -228,  -228,   251,   792,  -228,   792,  -228,   792,
    -228,   792,  -228,   792,  -228,   792,  -228,  -228,   149,  -228,
    -228,  -228,   807,   448,   792,  -228,   807,  -228,  -228,   792,
    -228,  -228,   792,  -228,  -228,  -228,  -228,   792,  -228,  -228,
     792,  -228,  -228,  -228,   792,   792,  -228,   110,   792,   198,
    -228,  -228,  -228,  -228,  -228,  -228,  -228,  -228,  -228,  -228,
    -228,  -228,  -228,  -228,  -228,   956,  -228,   260,  -228,  -228,
     491,   258,   240,  -228,   110,  -228,   110,  -228,   133,   247,
     253,  -228,  -228,   188,  -228,   110,  -228,  -228,  -228,  -228,
      84,  -228,  -228,    99,  -228,   115,   182,  -228,  -228,  -228,
      37,   242,   792,   939,   218,   218,   218,  -228,   939,  -228,
    -228,   534,   577,   620,   663,   706,   749,  -228,  -228,   792,
     241,   120,    41,  -228,   209,   237,   221,   219,   217,   198,
     256,   997,   213,  -228,   792,   225,   268,   248,  -228,   198,
     198,   175,  -228,   250,   254,   259,  -228,  -228,   268,  -228,
    -228,   807,  -228,   110,   257,   261,   175,   175,     7,    96,
      94,   155,   218,   218,  -228,  -228,  -228,   218,   939,   218,
    -228,  -228,  -228,  -228,  -228,  -228,  -228,   792,  -228,   213,
     792,  -228,  -228,  -228,  -228,  -228,  -228,   265,   268,   255,
    -228,  -228,  -228,   248,   268,   268,    33,   266,   277,   282,
    -228,   182,   198,   281,   283,   156,   167,   158,   262,   263,
     267,   269,     2,  -228,  -228,  -228,   218,   218,  -228,   792,
     268,  -228,  -228,  -228,  -228,  -228,  -228,   175,   270,  -228,
    -228,   268,   264,   272,   273,   280,   284,   297,   298,   305,
     307,   285,   289,  -228,  -228,  -228,   161,   328,  -228,   327,
     329,   330,   331,   332,  -228,  -228,   309,   312,   337,   338,
     306,  -228,  -228,  -228,  -228,  -228,  -228,   358,   359,   339,
     340,   110,   343,  -228,   365,   366,   198,   367,  -228,  -228,
     268,  -228,  -228
  };

  const unsigned char
   AdoParser ::yydefact_[] =
  {
       0,     5,    44,    45,     0,   203,    31,     0,   181,     0,
      47,    46,    48,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     2,     9,    10,     8,     7,     6,
      30,    52,     0,     0,     0,    27,     0,    26,   102,   101,
       0,   103,   133,   126,   134,   135,   136,   137,   127,   128,
     129,   130,   131,   132,   123,   125,   124,     0,   104,   106,
     105,   107,     0,     0,   138,   139,   153,   155,   157,   161,
     163,   165,   167,   169,   171,   173,   175,   177,   203,   205,
     181,     0,   181,    51,   181,     0,     0,    71,    73,   203,
      76,   203,     0,     0,    78,    82,   203,     0,     0,    84,
      87,   181,     0,    89,    90,    92,   181,     0,     0,     0,
       0,     1,     4,     3,     0,     0,     0,    53,     0,     0,
      32,    25,    29,    28,     0,     0,   147,     0,   148,     0,
     149,     0,   150,     0,   151,     0,   152,   204,   164,   154,
     121,   122,     0,     0,     0,   108,     0,   109,   110,     0,
     111,   112,     0,   113,   114,   115,   116,     0,   117,   118,
       0,   100,   120,   119,     0,     0,   178,   205,     0,   201,
      50,   187,   188,   190,   189,   192,   191,   193,   194,   195,
     197,   196,   198,   199,   200,   182,   183,   185,    57,    49,
     208,     0,     0,    74,   205,    77,   205,    65,     0,    67,
       0,    68,    69,     0,    83,   205,    85,    86,    88,    59,
       0,    93,    62,    96,    98,   203,    94,    24,    22,    23,
       0,     0,     0,     0,     0,     0,     0,    38,     0,    36,
     140,     0,     0,     0,     0,     0,     0,   156,   159,   179,
       0,     0,   162,   166,   168,   170,   172,   176,   174,   201,
     207,     0,   208,   184,     0,     0,   181,     0,    72,   201,
     201,     0,    66,     0,     0,     0,    67,    70,   181,    91,
      97,     0,    99,   205,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    35,    39,    37,     0,     0,     0,
     141,   142,   143,   144,   145,   146,   160,     0,   158,   208,
       0,   127,   128,   129,   130,   131,   132,     0,   181,     0,
     210,   209,    56,    75,   181,   181,     0,     0,     0,     0,
      64,    95,   201,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    33,    34,    41,     0,     0,    40,   180,
     181,   206,   202,    55,   186,    60,    61,     0,     0,    79,
      81,   181,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    43,    42,    54,     0,     0,    63,     0,
       0,     0,     0,     0,    11,    12,     0,     0,     0,     0,
     203,    80,    13,    14,    15,    16,    17,     0,     0,     0,
       0,   205,     0,    19,     0,     0,   201,     0,    20,    21,
     181,    18,    58
  };

  const short
   AdoParser ::yypgoto_[] =
  {
    -228,  -228,   348,  -228,  -228,  -228,  -228,     1,  -228,    26,
     -33,   -26,   349,   -86,   -24,   -75,  -188,  -200,   -76,   126,
     293,  -228,   290,  -228,   286,  -228,   279,  -228,  -228,   173,
    -228,  -228,  -228,  -228,  -228,  -228,  -228,  -228,  -228,  -228,
    -228,  -228,   138,   345,   249,   -96,   244,   351,  -133,   271,
      52,   232,   246,   292,   -17,     3,   160,   -80,  -228,   230,
    -228,  -227,   -72,  -153,  -210
  };

  const short
   AdoParser ::yydefgoto_[] =
  {
       0,    23,    24,    25,    26,   220,    27,    28,    36,    29,
      30,    31,    32,    33,    34,   198,   202,   203,    88,    89,
      90,    91,    95,    96,   100,   101,   105,   106,   213,   214,
     215,   164,    62,    63,   146,   149,   152,   157,   160,   165,
     142,    64,    65,    66,    67,    68,    69,    70,    71,    72,
      73,    74,    75,    76,    77,    82,   240,    83,   185,   186,
     187,   252,    79,   169,   256
  };

  const short
   AdoParser ::yytable_[] =
  {
     170,   120,   188,   108,   189,    35,   167,   117,    78,   119,
      80,   216,    84,   193,   249,   267,   243,   194,   361,   196,
     280,   209,   299,   124,   205,    93,   212,   210,   223,    86,
      37,    86,   314,   315,   116,   250,    85,   122,   102,   266,
     137,   259,   308,   260,   201,   102,    87,    93,   143,    81,
     347,    94,   268,    97,    98,   144,     4,    87,    97,    98,
      81,   166,   123,   166,   103,   166,   262,   166,   104,   266,
     197,   103,    92,    94,   201,   104,    57,     5,   327,   125,
     362,    57,    99,   227,   107,    57,   229,    99,   190,   340,
     224,   226,   267,   222,   269,   351,   109,   127,    13,    14,
      15,    16,    17,    18,    19,   126,   329,   129,   328,   217,
     274,   275,   276,   277,   278,   131,   225,   262,   133,   216,
     322,   270,    40,   128,   150,   151,   266,   271,   231,   262,
     232,   201,   233,   130,   234,   298,   235,   135,   236,   267,
     261,   132,   288,   273,   134,   279,   239,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,   330,   136,   110,   218,   262,   341,   354,   400,
     356,   380,   145,   166,   168,   321,   312,   331,    57,   355,
     219,   114,    58,    59,    60,    61,   316,   332,   320,   262,
     266,   284,   285,   286,   262,   201,   241,   117,   192,   283,
     262,   325,   326,   191,   289,   265,   199,   200,   197,   245,
     206,   201,   140,   141,   166,   166,   166,   166,   166,   166,
     266,   161,   166,   207,   282,   201,     2,     3,   343,   287,
     147,   148,   162,   163,   345,   346,     4,   193,   396,   153,
     154,   150,   151,   158,   159,   155,   156,   162,   163,   333,
     334,   296,   297,   221,   335,   228,   338,   239,   310,   311,
     365,   230,   117,   251,   337,   344,   297,   254,   257,   263,
     264,   368,   366,   258,   281,   255,   111,   112,   300,    81,
     342,    87,   317,   348,     2,     3,   318,   349,     4,   336,
     323,   319,   350,   352,   324,   353,   357,   358,   369,   359,
     339,   360,   367,   363,   364,     1,   370,   371,   391,     5,
     374,   375,     2,     3,   372,   376,     4,   378,   373,   377,
     402,   379,   166,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,     5,   381,    20,
     382,   387,   383,   384,   385,   386,   388,    21,    22,   389,
     390,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    38,    39,    20,    40,    57,
     392,   113,   393,   394,   395,    21,    22,   397,   398,   399,
     401,    41,   118,   313,   195,   211,   204,   208,   272,   307,
     242,   237,   246,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,   139,    38,
      39,   248,    40,   138,   309,   253,    81,     0,     0,     0,
       0,     0,     0,   244,    57,    41,     0,     0,    58,    59,
      60,    61,     0,     0,     0,     0,     0,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    38,    39,     0,    40,   247,     0,   238,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    41,     0,
       0,     0,    58,    59,    60,    61,     0,     0,     0,     0,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    38,    39,     0,    40,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    41,     0,     0,     0,    58,    59,    60,    61,     0,
       0,     0,     0,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    38,    39,
       0,    40,     0,     0,   290,     0,     0,     0,     0,     0,
       0,     0,     0,   255,    41,     0,     0,     0,    58,    59,
      60,    61,     0,     0,     0,     0,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    38,    39,     0,    40,     0,     0,   291,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    41,     0,     0,
       0,    58,    59,    60,    61,     0,     0,     0,     0,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    38,    39,     0,    40,     0,     0,
     292,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      41,     0,     0,     0,    58,    59,    60,    61,     0,     0,
       0,     0,    42,    43,    44,    45,    46,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    38,    39,     0,
      40,     0,     0,   293,     0,     0,     0,     0,     0,     0,
       0,     0,     0,    41,     0,     0,     0,    58,    59,    60,
      61,     0,     0,     0,     0,    42,    43,    44,    45,    46,
      47,    48,    49,    50,    51,    52,    53,    54,    55,    56,
      38,    39,     0,    40,     0,     0,   294,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    41,     0,     0,     0,
      58,    59,    60,    61,     0,     0,     0,     0,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    38,    39,     0,    40,     0,     0,   295,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    41,
       0,     0,     0,    58,    59,    60,    61,     0,     0,     0,
       0,    42,    43,    44,    45,    46,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    38,    39,     0,    40,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    41,     0,    40,     0,    58,    59,    60,    61,
       0,     0,     0,     0,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,     0,     0,     0,     0,     0,    58,
      59,    60,    61,     2,     3,     0,     0,     4,   121,     0,
       0,     0,     0,     0,    58,    59,    60,    61,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     5,     0,
       0,     2,     3,     0,     0,     4,     0,     0,     0,     0,
       0,     0,     6,     7,     8,     9,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,     5,     0,     0,     0,
       0,     0,     0,     4,     0,     0,     0,   115,     0,     0,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,     5,     0,     0,     0,    40,     0,
       0,     4,     0,     0,     0,     0,     0,     0,     0,     7,
       8,     9,    10,    11,    12,    13,    14,    15,    16,    17,
      18,    19,     5,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,   222,   171,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    19,
       0,     5,     0,     0,   172,   173,   174,   175,   176,   177,
     178,   179,   180,   181,   182,   183,   184,   222,     0,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,    42,
      43,    44,    45,    46,    47,   301,   302,   303,   304,   305,
     306,    54,    55,    56
  };

  const short
   AdoParser ::yycheck_[] =
  {
      80,    34,    82,    20,    84,     4,    78,    33,     5,    33,
       7,   107,     9,    89,   167,   203,   149,    89,    16,    91,
     220,   101,   249,    40,    96,     7,   106,   102,   114,     7,
       4,     7,   259,   260,    33,   168,    66,    36,     7,    32,
      57,   194,   252,   196,    37,     7,    33,     7,     7,    11,
      17,    33,   205,     4,     5,    14,    12,    33,     4,     5,
      11,    78,    36,    80,    33,    82,    33,    84,    37,    32,
      33,    33,    61,    33,    37,    37,    63,    33,   278,     7,
      78,    63,    33,   116,    33,    63,   119,    33,    85,   299,
     114,   115,   280,    49,    10,   322,    33,     7,    54,    55,
      56,    57,    58,    59,    60,    33,    12,     7,    12,   108,
      73,    74,    75,    76,    77,     7,   115,    33,     7,   215,
     273,    22,     7,    33,     4,     5,    32,    28,   125,    33,
     127,    37,   129,    33,   131,    15,   133,     7,   135,   327,
       7,    33,   228,   215,    33,   220,   143,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,     7,    33,    33,    64,    33,   300,    12,   396,
      12,    10,    23,   190,    64,   271,   256,    22,    63,    12,
      79,    16,    67,    68,    69,    70,   261,    32,   268,    33,
      32,   224,   225,   226,    33,    37,   144,   223,    17,   223,
      33,   276,   277,    33,   228,    17,    32,    33,    33,   157,
      33,    37,    30,    31,   231,   232,   233,   234,   235,   236,
      32,    17,   239,    33,   223,    37,     8,     9,   308,   228,
      21,    22,    28,    29,   314,   315,    12,   313,   391,    18,
      19,     4,     5,    26,    27,    24,    25,    28,    29,   282,
     283,    10,    11,    17,   287,    16,   289,   254,    33,    34,
     340,    10,   288,    65,   288,    10,    11,     7,    10,    22,
      17,   351,   347,    33,    32,    62,     0,     1,    22,    11,
      15,    33,    32,    17,     8,     9,    32,    10,    12,   288,
      33,    32,    10,    12,    33,    12,    34,    34,    34,    32,
     297,    32,    32,   336,   337,     1,    34,    34,   380,    33,
      13,    13,     8,     9,    34,    10,    12,    32,    34,    12,
     400,    32,   339,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    33,    10,    63,
      13,    32,    13,    13,    13,    13,    34,    71,    72,    12,
      12,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,     4,     5,    63,     7,    63,
      12,    23,    13,    34,    34,    71,    72,    34,    13,    13,
      13,    20,    33,   257,    91,   106,    96,   101,   215,   251,
     146,   142,   160,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    63,     4,
       5,   165,     7,    62,   254,   185,    11,    -1,    -1,    -1,
      -1,    -1,    -1,   152,    63,    20,    -1,    -1,    67,    68,
      69,    70,    -1,    -1,    -1,    -1,    -1,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,     4,     5,    -1,     7,   164,    -1,    10,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    20,    -1,
      -1,    -1,    67,    68,    69,    70,    -1,    -1,    -1,    -1,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,     4,     5,    -1,     7,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    20,    -1,    -1,    -1,    67,    68,    69,    70,    -1,
      -1,    -1,    -1,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,     4,     5,
      -1,     7,    -1,    -1,    10,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    62,    20,    -1,    -1,    -1,    67,    68,
      69,    70,    -1,    -1,    -1,    -1,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,     4,     5,    -1,     7,    -1,    -1,    10,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    20,    -1,    -1,
      -1,    67,    68,    69,    70,    -1,    -1,    -1,    -1,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,     4,     5,    -1,     7,    -1,    -1,
      10,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      20,    -1,    -1,    -1,    67,    68,    69,    70,    -1,    -1,
      -1,    -1,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,    44,    45,    46,     4,     5,    -1,
       7,    -1,    -1,    10,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    20,    -1,    -1,    -1,    67,    68,    69,
      70,    -1,    -1,    -1,    -1,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    41,    42,    43,    44,    45,    46,
       4,     5,    -1,     7,    -1,    -1,    10,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    20,    -1,    -1,    -1,
      67,    68,    69,    70,    -1,    -1,    -1,    -1,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,     4,     5,    -1,     7,    -1,    -1,    10,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    20,
      -1,    -1,    -1,    67,    68,    69,    70,    -1,    -1,    -1,
      -1,    32,    33,    34,    35,    36,    37,    38,    39,    40,
      41,    42,    43,    44,    45,    46,     4,     5,    -1,     7,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    20,    -1,     7,    -1,    67,    68,    69,    70,
      -1,    -1,    -1,    -1,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    -1,    -1,    -1,    -1,    -1,    67,
      68,    69,    70,     8,     9,    -1,    -1,    12,    13,    -1,
      -1,    -1,    -1,    -1,    67,    68,    69,    70,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    33,    -1,
      -1,     8,     9,    -1,    -1,    12,    -1,    -1,    -1,    -1,
      -1,    -1,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    33,    -1,    -1,    -1,
      -1,    -1,    -1,    12,    -1,    -1,    -1,    16,    -1,    -1,
      47,    48,    49,    50,    51,    52,    53,    54,    55,    56,
      57,    58,    59,    60,    33,    -1,    -1,    -1,     7,    -1,
      -1,    12,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    33,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,    49,    33,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      -1,    33,    -1,    -1,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    49,    -1,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46
  };

  const unsigned char
   AdoParser ::yystos_[] =
  {
       0,     1,     8,     9,    12,    33,    47,    48,    49,    50,
      51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
      63,    71,    72,    81,    82,    83,    84,    86,    87,    89,
      90,    91,    92,    93,    94,    87,    88,    89,     4,     5,
       7,    20,    32,    33,    34,    35,    36,    37,    38,    39,
      40,    41,    42,    43,    44,    45,    46,    63,    67,    68,
      69,    70,   112,   113,   121,   122,   123,   124,   125,   126,
     127,   128,   129,   130,   131,   132,   133,   134,   135,   142,
     135,    11,   135,   137,   135,    66,     7,    33,    98,    99,
     100,   101,    61,     7,    33,   102,   103,     4,     5,    33,
     104,   105,     7,    33,    37,   106,   107,    33,   134,    33,
      33,     0,     1,    82,    16,    16,    87,    91,    92,    94,
      90,    13,    87,    89,   134,     7,    33,     7,    33,     7,
      33,     7,    33,     7,    33,     7,    33,   134,   127,   123,
      30,    31,   120,     7,    14,    23,   114,    21,    22,   115,
       4,     5,   116,    18,    19,    24,    25,   117,    26,    27,
     118,    17,    28,    29,   111,   119,   134,   142,    64,   143,
     137,    33,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,   138,   139,   140,   137,   137,
     135,    33,    17,    98,   142,   100,   142,    33,    95,    32,
      33,    37,    96,    97,   102,   142,    33,    33,   104,   137,
      95,   106,   137,   108,   109,   110,   125,    87,    64,    79,
      85,    17,    49,    93,    94,    87,    94,    90,    16,    90,
      10,   135,   135,   135,   135,   135,   135,   124,    10,   135,
     136,   130,   126,   128,   129,   130,   131,   133,   132,   143,
     128,    65,   141,   139,     7,    62,   144,    10,    33,   143,
     143,     7,    33,    22,    17,    17,    32,    96,   143,    10,
      22,    28,   109,   142,    73,    74,    75,    76,    77,    95,
      97,    32,    87,    94,    90,    90,    90,    87,    93,    94,
      10,    10,    10,    10,    10,    10,    10,    11,    15,   141,
      22,    38,    39,    40,    41,    42,    43,   122,   144,   136,
      33,    34,   137,    99,   141,   141,    95,    32,    32,    32,
     137,   125,   143,    33,    33,    95,    95,    97,    12,    12,
       7,    22,    32,    90,    90,    90,    87,    94,    90,   135,
     144,   128,    15,   137,    10,   137,   137,    17,    17,    10,
      10,   141,    12,    12,    12,    12,    12,    34,    34,    32,
      32,    16,    78,    90,    90,   137,    95,    32,   137,    34,
      34,    34,    34,    34,    13,    13,    10,    12,    32,    32,
      10,    10,    13,    13,    13,    13,    13,    32,    34,    12,
      12,   142,    12,    13,    34,    34,   143,    34,    13,    13,
     141,    13,   137
  };

  const unsigned char
   AdoParser ::yyr1_[] =
  {
       0,    80,    81,    81,    81,    81,    82,    82,    82,    82,
      82,    83,    83,    83,    83,    83,    83,    83,    84,    84,
      84,    84,    85,    85,    86,    87,    88,    88,    88,    88,
      89,    89,    89,    89,    89,    89,    89,    89,    89,    89,
      89,    89,    89,    89,    90,    90,    91,    91,    91,    92,
      92,    92,    93,    93,    94,    94,    94,    94,    94,    94,
      94,    94,    94,    94,    94,    95,    95,    96,    96,    97,
      97,    98,    98,    99,    99,   100,   101,   101,   102,   102,
     102,   102,   103,   103,   104,   104,   104,   105,   105,   106,
     106,   106,   107,   107,   108,   108,   109,   109,   110,   110,
     111,   112,   112,   112,   113,   113,   113,   113,   114,   115,
     115,   116,   116,   117,   117,   117,   117,   118,   118,   119,
     119,   120,   120,   121,   121,   121,   122,   122,   122,   122,
     122,   122,   122,   122,   122,   122,   122,   122,   122,   123,
     123,   123,   123,   123,   123,   123,   123,   123,   123,   123,
     123,   123,   123,   124,   124,   125,   125,   126,   126,   126,
     126,   127,   127,   128,   128,   129,   129,   130,   130,   131,
     131,   132,   132,   133,   133,   134,   134,   135,   135,   136,
     136,   137,   137,   138,   138,   139,   139,   140,   140,   140,
     140,   140,   140,   140,   140,   140,   140,   140,   140,   140,
     140,   141,   141,   142,   142,   143,   143,   143,   144,   144,
     144
  };

  const signed char
   AdoParser ::yyr2_[] =
  {
       0,     2,     1,     2,     2,     1,     1,     1,     1,     1,
       1,     7,     7,     8,     8,     8,     8,     8,    11,     9,
      10,    10,     1,     1,     3,     3,     1,     1,     2,     2,
       1,     1,     2,     5,     5,     4,     3,     4,     3,     4,
       5,     5,     6,     6,     1,     1,     1,     1,     1,     3,
       3,     2,     1,     2,     7,     6,     5,     3,    12,     3,
       6,     6,     3,     7,     5,     1,     2,     1,     1,     1,
       2,     1,     3,     1,     2,     4,     1,     2,     1,     5,
       7,     5,     1,     2,     1,     2,     2,     1,     2,     1,
       1,     3,     1,     2,     1,     3,     1,     2,     1,     2,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       3,     4,     4,     4,     4,     4,     4,     2,     2,     2,
       2,     2,     2,     1,     2,     1,     3,     1,     4,     3,
       4,     1,     3,     1,     2,     1,     3,     1,     3,     1,
       3,     1,     3,     1,     3,     1,     3,     1,     2,     1,
       3,     0,     2,     1,     2,     1,     4,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     0,     3,     0,     2,     0,     4,     2,     0,     2,
       2
  };


#if YYDEBUG || 1
  // YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
  // First, the terminals, then, starting at \a YYNTOKENS, nonterminals.
  const char*
  const  AdoParser ::yytname_[] =
  {
  "\"end of file\"", "error", "\"invalid token\"", "RELATIONAL", "\"+\"",
  "\"-\"", "EXPONENT", "\"(\"", "NEWLINE", "\";\"", "\")\"", "\",\"",
  "\"{\"", "\"}\"", "\"[\"", "\"]\"", "\":\"", "\"=\"", "\"<\"", "\">\"",
  "\"!\"", "\"*\"", "\"/\"", "\"^\"", "\">=\"", "\"<=\"", "\"==\"",
  "\"!=\"", "\"|\"", "\"&\"", "\"##\"", "\"#\"", "NUMBER", "IDENT",
  "STRING_LITERAL", "DATE", "DATETIME", "\".\"", "BYTE", "INT", "LONG",
  "FLOAT", "DOUBLE", "STRING_TYPE_SPEC", "STRING_FORMAT",
  "DATETIME_FORMAT", "NUMBER_FORMAT", "EMBEDDED_CODE", "BY", "XI",
  "BYSORT", "QUIETLY", "CAPTURE", "NOISILY", "MERGE", "COLLAPSE",
  "IVREGRESS", "RECODE", "GSORT", "LRTEST", "ANOVA", "TSLS", "USING", "IF",
  "IN", "WEIGHT_SPEC", "MERGE_SPEC", "CONT_OPERATOR", "IND_OPERATOR",
  "BASE_OPERATOR", "OMIT_OPERATOR", "FOREACH", "FORVALUES", "LOCAL",
  "GLOBAL", "VARLIST", "NEWLIST", "NUMLIST", "TO", "OF", "$accept",
  "translation_unit", "external_statement", "foreach_cmd", "forvalues_cmd",
  "foreach_sep", "if_cmd", "compound_cmd", "cmds", "cmd", "cmd_sep",
  "modifier_cmd", "long_modifier_cmd", "modifier_cmd_list",
  "nonmodifier_cmd", "varlist", "number_or_missing", "numlist",
  "collapse_spec_base", "collapse_spec_base_list", "collapse_spec",
  "collapse_list", "recode_rule", "recode_rule_list", "gsort_var",
  "gsort_varlist", "modelspec", "modelspec_list", "anova_nest_expression",
  "anova_error_expression", "anova_term_list", "assignment_operator",
  "unary_operator", "unary_factor_operator", "power_operator",
  "multiplication_operator", "additive_operator", "relational_operator",
  "equality_operator", "logical_operator", "cross_operator", "format_spec",
  "literal_expression", "primary_expression", "unary_factor_expression",
  "cross_expression", "postfix_expression", "power_expression",
  "unary_expression", "multiplication_expression", "additive_expression",
  "relational_expression", "equality_expression", "logical_expression",
  "expression", "expression_list", "argument_expression_list",
  "option_list", "options", "option", "option_ident", "weight_clause",
  "if_clause", "in_clause", "using_clause", YY_NULLPTR
  };
#endif


#if YYDEBUG
  const short
   AdoParser ::yyrline_[] =
  {
       0,   172,   172,   185,   204,   213,   225,   226,   227,   228,
     229,   243,   251,   259,   267,   275,   283,   291,   302,   313,
     326,   337,   351,   352,   356,   367,   374,   382,   386,   392,
     401,   402,   404,   410,   419,   428,   439,   447,   455,   463,
     471,   480,   489,   499,   512,   518,   527,   534,   541,   551,
     563,   575,   588,   594,   602,   625,   652,   680,   692,   734,
     746,   789,   810,   822,   844,   866,   872,   880,   881,   885,
     891,   900,   901,   929,   935,   943,   966,   972,   981,   982,
    1002,  1025,  1048,  1054,  1063,  1075,  1089,  1106,  1112,  1121,
    1122,  1123,  1141,  1147,  1156,  1157,  1171,  1172,  1185,  1191,
    1207,  1211,  1212,  1213,  1217,  1218,  1219,  1220,  1224,  1228,
    1229,  1233,  1234,  1238,  1239,  1240,  1241,  1245,  1246,  1250,
    1251,  1255,  1256,  1260,  1261,  1262,  1283,  1284,  1290,  1296,
    1302,  1308,  1314,  1320,  1321,  1322,  1323,  1324,  1325,  1329,
    1333,  1337,  1344,  1351,  1358,  1365,  1372,  1379,  1388,  1397,
    1406,  1415,  1424,  1436,  1437,  1446,  1447,  1458,  1459,  1468,
    1476,  1488,  1489,  1500,  1501,  1511,  1512,  1523,  1524,  1535,
    1536,  1547,  1548,  1559,  1560,  1571,  1572,  1583,  1589,  1597,
    1603,  1618,  1622,  1629,  1635,  1643,  1650,  1663,  1664,  1665,
    1666,  1667,  1668,  1669,  1670,  1671,  1672,  1673,  1674,  1675,
    1676,  1686,  1690,  1704,  1708,  1724,  1728,  1738,  1754,  1758,
    1765
  };

  void
   AdoParser ::yy_stack_print_ () const
  {
    *yycdebug_ << "Stack now";
    for (stack_type::const_iterator
           i = yystack_.begin (),
           i_end = yystack_.end ();
         i != i_end; ++i)
      *yycdebug_ << ' ' << int (i->state);
    *yycdebug_ << '\n';
  }

  void
   AdoParser ::yy_reduce_print_ (int yyrule) const
  {
    int yylno = yyrline_[yyrule];
    int yynrhs = yyr2_[yyrule];
    // Print the symbols being reduced, and their result.
    *yycdebug_ << "Reducing stack by rule " << yyrule - 1
               << " (line " << yylno << "):\n";
    // The symbols being reduced.
    for (int yyi = 0; yyi < yynrhs; yyi++)
      YY_SYMBOL_PRINT ("   $" << yyi + 1 << " =",
                       yystack_[(yynrhs) - (yyi + 1)]);
  }
#endif // YYDEBUG

   AdoParser ::symbol_kind_type
   AdoParser ::yytranslate_ (int t) YY_NOEXCEPT
  {
    // YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to
    // TOKEN-NUM as returned by yylex.
    static
    const signed char
    translate_table[] =
    {
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79
    };
    // Last valid token kind.
    const int code_max = 334;

    if (t <= 0)
      return symbol_kind::S_YYEOF;
    else if (t <= code_max)
      return static_cast <symbol_kind_type> (translate_table[t]);
    else
      return symbol_kind::S_YYUNDEF;
  }

} // yy
#line 4514 "ado.tab.cpp"

#line 1774 "ado.ypp"


