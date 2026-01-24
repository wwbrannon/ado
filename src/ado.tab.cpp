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
#line 35 "ado.ypp"

#include <string>
#include <Rcpp.h>

YY_DECL;

void
yy::AdoParser::error(const location_type& l, const std::string& m)
{
    driver.error(l.begin.line, l.begin.column, m);
}


#line 60 "ado.tab.cpp"


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
#line 152 "ado.tab.cpp"

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
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 365 "ado.tab.cpp"
        break;

      case symbol_kind::S_PLUS: // "+"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 371 "ado.tab.cpp"
        break;

      case symbol_kind::S_MINUS: // "-"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 377 "ado.tab.cpp"
        break;

      case symbol_kind::S_NEWLINE: // NEWLINE
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 383 "ado.tab.cpp"
        break;

      case symbol_kind::S_SEMICOLON: // ";"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 389 "ado.tab.cpp"
        break;

      case symbol_kind::S_LT_OP: // "<"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 395 "ado.tab.cpp"
        break;

      case symbol_kind::S_GT_OP: // ">"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 401 "ado.tab.cpp"
        break;

      case symbol_kind::S_NEG_OP: // "!"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 407 "ado.tab.cpp"
        break;

      case symbol_kind::S_STAR: // "*"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 413 "ado.tab.cpp"
        break;

      case symbol_kind::S_SLASH: // "/"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 419 "ado.tab.cpp"
        break;

      case symbol_kind::S_CARET: // "^"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 425 "ado.tab.cpp"
        break;

      case symbol_kind::S_GE_OP: // ">="
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 431 "ado.tab.cpp"
        break;

      case symbol_kind::S_LE_OP: // "<="
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 437 "ado.tab.cpp"
        break;

      case symbol_kind::S_EQ_OP: // "=="
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 443 "ado.tab.cpp"
        break;

      case symbol_kind::S_NE_OP: // "!="
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 449 "ado.tab.cpp"
        break;

      case symbol_kind::S_OR_OP: // "|"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 455 "ado.tab.cpp"
        break;

      case symbol_kind::S_AND_OP: // "&"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 461 "ado.tab.cpp"
        break;

      case symbol_kind::S_FACT_CROSS: // "##"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 467 "ado.tab.cpp"
        break;

      case symbol_kind::S_CROSS: // "#"
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 473 "ado.tab.cpp"
        break;

      case symbol_kind::S_NUMBER: // NUMBER
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 479 "ado.tab.cpp"
        break;

      case symbol_kind::S_IDENT: // IDENT
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 485 "ado.tab.cpp"
        break;

      case symbol_kind::S_STRING_LITERAL: // STRING_LITERAL
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 491 "ado.tab.cpp"
        break;

      case symbol_kind::S_DATE: // DATE
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 497 "ado.tab.cpp"
        break;

      case symbol_kind::S_DATETIME: // DATETIME
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 503 "ado.tab.cpp"
        break;

      case symbol_kind::S_PERIOD: // "."
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 509 "ado.tab.cpp"
        break;

      case symbol_kind::S_BYTE: // BYTE
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 515 "ado.tab.cpp"
        break;

      case symbol_kind::S_INT: // INT
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 521 "ado.tab.cpp"
        break;

      case symbol_kind::S_LONG: // LONG
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 527 "ado.tab.cpp"
        break;

      case symbol_kind::S_FLOAT: // FLOAT
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 533 "ado.tab.cpp"
        break;

      case symbol_kind::S_DOUBLE: // DOUBLE
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 539 "ado.tab.cpp"
        break;

      case symbol_kind::S_STRING_TYPE_SPEC: // STRING_TYPE_SPEC
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 545 "ado.tab.cpp"
        break;

      case symbol_kind::S_STRING_FORMAT: // STRING_FORMAT
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 551 "ado.tab.cpp"
        break;

      case symbol_kind::S_DATETIME_FORMAT: // DATETIME_FORMAT
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 557 "ado.tab.cpp"
        break;

      case symbol_kind::S_NUMBER_FORMAT: // NUMBER_FORMAT
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 563 "ado.tab.cpp"
        break;

      case symbol_kind::S_EMBEDDED_CODE: // EMBEDDED_CODE
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 569 "ado.tab.cpp"
        break;

      case symbol_kind::S_BY: // BY
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 575 "ado.tab.cpp"
        break;

      case symbol_kind::S_XI: // XI
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 581 "ado.tab.cpp"
        break;

      case symbol_kind::S_BYSORT: // BYSORT
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 587 "ado.tab.cpp"
        break;

      case symbol_kind::S_QUIETLY: // QUIETLY
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 593 "ado.tab.cpp"
        break;

      case symbol_kind::S_CAPTURE: // CAPTURE
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 599 "ado.tab.cpp"
        break;

      case symbol_kind::S_NOISILY: // NOISILY
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 605 "ado.tab.cpp"
        break;

      case symbol_kind::S_MERGE: // MERGE
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 611 "ado.tab.cpp"
        break;

      case symbol_kind::S_COLLAPSE: // COLLAPSE
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 617 "ado.tab.cpp"
        break;

      case symbol_kind::S_IVREGRESS: // IVREGRESS
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 623 "ado.tab.cpp"
        break;

      case symbol_kind::S_RECODE: // RECODE
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 629 "ado.tab.cpp"
        break;

      case symbol_kind::S_GSORT: // GSORT
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 635 "ado.tab.cpp"
        break;

      case symbol_kind::S_LRTEST: // LRTEST
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 641 "ado.tab.cpp"
        break;

      case symbol_kind::S_ANOVA: // ANOVA
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 647 "ado.tab.cpp"
        break;

      case symbol_kind::S_TSLS: // TSLS
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 653 "ado.tab.cpp"
        break;

      case symbol_kind::S_WEIGHT_SPEC: // WEIGHT_SPEC
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 659 "ado.tab.cpp"
        break;

      case symbol_kind::S_MERGE_SPEC: // MERGE_SPEC
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 665 "ado.tab.cpp"
        break;

      case symbol_kind::S_CONT_OPERATOR: // CONT_OPERATOR
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 671 "ado.tab.cpp"
        break;

      case symbol_kind::S_IND_OPERATOR: // IND_OPERATOR
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 677 "ado.tab.cpp"
        break;

      case symbol_kind::S_BASE_OPERATOR: // BASE_OPERATOR
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 683 "ado.tab.cpp"
        break;

      case symbol_kind::S_OMIT_OPERATOR: // OMIT_OPERATOR
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 689 "ado.tab.cpp"
        break;

      case symbol_kind::S_FOREACH: // FOREACH
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 695 "ado.tab.cpp"
        break;

      case symbol_kind::S_FORVALUES: // FORVALUES
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 701 "ado.tab.cpp"
        break;

      case symbol_kind::S_translation_unit: // translation_unit
#line 159 "ado.ypp"
                    { }
#line 707 "ado.tab.cpp"
        break;

      case symbol_kind::S_external_statement: // external_statement
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 713 "ado.tab.cpp"
        break;

      case symbol_kind::S_foreach_cmd: // foreach_cmd
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 719 "ado.tab.cpp"
        break;

      case symbol_kind::S_forvalues_cmd: // forvalues_cmd
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 725 "ado.tab.cpp"
        break;

      case symbol_kind::S_if_cmd: // if_cmd
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 731 "ado.tab.cpp"
        break;

      case symbol_kind::S_compound_cmd: // compound_cmd
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 737 "ado.tab.cpp"
        break;

      case symbol_kind::S_cmds: // cmds
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 743 "ado.tab.cpp"
        break;

      case symbol_kind::S_cmd: // cmd
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 749 "ado.tab.cpp"
        break;

      case symbol_kind::S_cmd_sep: // cmd_sep
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 755 "ado.tab.cpp"
        break;

      case symbol_kind::S_modifier_cmd: // modifier_cmd
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 761 "ado.tab.cpp"
        break;

      case symbol_kind::S_long_modifier_cmd: // long_modifier_cmd
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 767 "ado.tab.cpp"
        break;

      case symbol_kind::S_modifier_cmd_list: // modifier_cmd_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 773 "ado.tab.cpp"
        break;

      case symbol_kind::S_nonmodifier_cmd: // nonmodifier_cmd
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 779 "ado.tab.cpp"
        break;

      case symbol_kind::S_varlist: // varlist
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 785 "ado.tab.cpp"
        break;

      case symbol_kind::S_number_or_missing: // number_or_missing
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 791 "ado.tab.cpp"
        break;

      case symbol_kind::S_numlist: // numlist
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 797 "ado.tab.cpp"
        break;

      case symbol_kind::S_collapse_spec_base: // collapse_spec_base
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 803 "ado.tab.cpp"
        break;

      case symbol_kind::S_collapse_spec_base_list: // collapse_spec_base_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 809 "ado.tab.cpp"
        break;

      case symbol_kind::S_collapse_spec: // collapse_spec
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 815 "ado.tab.cpp"
        break;

      case symbol_kind::S_collapse_list: // collapse_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 821 "ado.tab.cpp"
        break;

      case symbol_kind::S_recode_rule: // recode_rule
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 827 "ado.tab.cpp"
        break;

      case symbol_kind::S_recode_rule_list: // recode_rule_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 833 "ado.tab.cpp"
        break;

      case symbol_kind::S_gsort_var: // gsort_var
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 839 "ado.tab.cpp"
        break;

      case symbol_kind::S_gsort_varlist: // gsort_varlist
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 845 "ado.tab.cpp"
        break;

      case symbol_kind::S_modelspec: // modelspec
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 851 "ado.tab.cpp"
        break;

      case symbol_kind::S_modelspec_list: // modelspec_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 857 "ado.tab.cpp"
        break;

      case symbol_kind::S_anova_nest_expression: // anova_nest_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 863 "ado.tab.cpp"
        break;

      case symbol_kind::S_anova_error_expression: // anova_error_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 869 "ado.tab.cpp"
        break;

      case symbol_kind::S_anova_term_list: // anova_term_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 875 "ado.tab.cpp"
        break;

      case symbol_kind::S_type_operator: // type_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 881 "ado.tab.cpp"
        break;

      case symbol_kind::S_unary_operator: // unary_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 887 "ado.tab.cpp"
        break;

      case symbol_kind::S_unary_factor_operator: // unary_factor_operator
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 893 "ado.tab.cpp"
        break;

      case symbol_kind::S_power_operator: // power_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 899 "ado.tab.cpp"
        break;

      case symbol_kind::S_multiplication_operator: // multiplication_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 905 "ado.tab.cpp"
        break;

      case symbol_kind::S_additive_operator: // additive_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 911 "ado.tab.cpp"
        break;

      case symbol_kind::S_relational_operator: // relational_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 917 "ado.tab.cpp"
        break;

      case symbol_kind::S_equality_operator: // equality_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 923 "ado.tab.cpp"
        break;

      case symbol_kind::S_logical_operator: // logical_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 929 "ado.tab.cpp"
        break;

      case symbol_kind::S_cross_operator: // cross_operator
#line 160 "ado.ypp"
                    { delete (yysym.value.str); }
#line 935 "ado.tab.cpp"
        break;

      case symbol_kind::S_format_spec: // format_spec
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 941 "ado.tab.cpp"
        break;

      case symbol_kind::S_literal_expression: // literal_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 947 "ado.tab.cpp"
        break;

      case symbol_kind::S_primary_expression: // primary_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 953 "ado.tab.cpp"
        break;

      case symbol_kind::S_unary_factor_expression: // unary_factor_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 959 "ado.tab.cpp"
        break;

      case symbol_kind::S_cross_expression: // cross_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 965 "ado.tab.cpp"
        break;

      case symbol_kind::S_postfix_expression: // postfix_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 971 "ado.tab.cpp"
        break;

      case symbol_kind::S_power_expression: // power_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 977 "ado.tab.cpp"
        break;

      case symbol_kind::S_unary_expression: // unary_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 983 "ado.tab.cpp"
        break;

      case symbol_kind::S_multiplication_expression: // multiplication_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 989 "ado.tab.cpp"
        break;

      case symbol_kind::S_additive_expression: // additive_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 995 "ado.tab.cpp"
        break;

      case symbol_kind::S_relational_expression: // relational_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1001 "ado.tab.cpp"
        break;

      case symbol_kind::S_equality_expression: // equality_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1007 "ado.tab.cpp"
        break;

      case symbol_kind::S_logical_expression: // logical_expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1013 "ado.tab.cpp"
        break;

      case symbol_kind::S_expression: // expression
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1019 "ado.tab.cpp"
        break;

      case symbol_kind::S_expression_list: // expression_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1025 "ado.tab.cpp"
        break;

      case symbol_kind::S_argument_expression_list: // argument_expression_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1031 "ado.tab.cpp"
        break;

      case symbol_kind::S_option_list: // option_list
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1037 "ado.tab.cpp"
        break;

      case symbol_kind::S_options: // options
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1043 "ado.tab.cpp"
        break;

      case symbol_kind::S_option: // option
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1049 "ado.tab.cpp"
        break;

      case symbol_kind::S_option_ident: // option_ident
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1055 "ado.tab.cpp"
        break;

      case symbol_kind::S_weight_clause: // weight_clause
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1061 "ado.tab.cpp"
        break;

      case symbol_kind::S_if_clause: // if_clause
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1067 "ado.tab.cpp"
        break;

      case symbol_kind::S_in_clause: // in_clause
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1073 "ado.tab.cpp"
        break;

      case symbol_kind::S_using_clause: // using_clause
#line 161 "ado.ypp"
                    { delete (yysym.value.node); }
#line 1079 "ado.tab.cpp"
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
#line 174 "ado.ypp"
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
#line 1361 "ado.tab.cpp"
    break;

  case 3: // translation_unit: translation_unit external_statement
#line 187 "ado.ypp"
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
#line 1384 "ado.tab.cpp"
    break;

  case 4: // translation_unit: translation_unit error
#line 206 "ado.ypp"
    {
        (yystack_[0].value.node); // shut up, bison...

        // we shouldn't need to use set_ast here, because the earlier
        // production that created the translation_unit will have done
        // so already (unlike the one-statement error production below)
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1397 "ado.tab.cpp"
    break;

  case 5: // translation_unit: error
#line 215 "ado.ypp"
    {
        (yystack_[0].value.node); // shut up, bison...
        
        ExprNode *node = new ExprNode("ado_compound_cmd");
        
        RETURN_AST(node);
        (yylhs.value.node) = node;
    }
#line 1410 "ado.tab.cpp"
    break;

  case 6: // external_statement: cmd
#line 226 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1416 "ado.tab.cpp"
    break;

  case 7: // external_statement: compound_cmd
#line 227 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1422 "ado.tab.cpp"
    break;

  case 8: // external_statement: if_cmd
#line 228 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1428 "ado.tab.cpp"
    break;

  case 9: // external_statement: foreach_cmd
#line 229 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1434 "ado.tab.cpp"
    break;

  case 10: // external_statement: forvalues_cmd
#line 230 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1440 "ado.tab.cpp"
    break;

  case 11: // foreach_cmd: FOREACH IDENT foreach_sep varlist "{" STRING_LITERAL "}"
#line 245 "ado.ypp"
    {
        (yystack_[6].value.node)->appendChild("macro_name", (yystack_[5].value.node));
        (yystack_[6].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[6].value.node)->appendChild("varlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[6].value.node);
    }
#line 1452 "ado.tab.cpp"
    break;

  case 12: // foreach_cmd: FOREACH IDENT foreach_sep numlist "{" STRING_LITERAL "}"
#line 253 "ado.ypp"
    {
        (yystack_[6].value.node)->appendChild("macro_name", (yystack_[5].value.node));
        (yystack_[6].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[6].value.node)->appendChild("numlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[6].value.node);
    }
#line 1464 "ado.tab.cpp"
    break;

  case 13: // foreach_cmd: FOREACH IDENT foreach_sep LOCAL IDENT "{" STRING_LITERAL "}"
#line 261 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("local_macro_source", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1476 "ado.tab.cpp"
    break;

  case 14: // foreach_cmd: FOREACH IDENT foreach_sep GLOBAL IDENT "{" STRING_LITERAL "}"
#line 269 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("global_macro_source", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1488 "ado.tab.cpp"
    break;

  case 15: // foreach_cmd: FOREACH IDENT foreach_sep VARLIST varlist "{" STRING_LITERAL "}"
#line 277 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("varlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1500 "ado.tab.cpp"
    break;

  case 16: // foreach_cmd: FOREACH IDENT foreach_sep NEWLIST varlist "{" STRING_LITERAL "}"
#line 285 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("varlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1512 "ado.tab.cpp"
    break;

  case 17: // foreach_cmd: FOREACH IDENT foreach_sep NUMLIST numlist "{" STRING_LITERAL "}"
#line 293 "ado.ypp"
    {
        (yystack_[7].value.node)->appendChild("macro_name", (yystack_[6].value.node));
        (yystack_[7].value.node)->appendChild("text", (yystack_[1].value.node));
        (yystack_[7].value.node)->appendChild("numlist", (yystack_[3].value.node));

        (yylhs.value.node) = (yystack_[7].value.node);
    }
#line 1524 "ado.tab.cpp"
    break;

  case 18: // forvalues_cmd: FORVALUES IDENT "=" NUMBER "(" NUMBER ")" NUMBER "{" STRING_LITERAL "}"
#line 304 "ado.ypp"
    {
        (yystack_[10].value.node)->appendChild("macro_name", (yystack_[9].value.node));
        (yystack_[10].value.node)->appendChild("text", (yystack_[1].value.node));

        (yystack_[10].value.node)->appendChild("upper", (yystack_[3].value.node));
        (yystack_[10].value.node)->appendChild("lower", (yystack_[7].value.node));
        (yystack_[10].value.node)->appendChild("increment", (yystack_[5].value.node));

        (yylhs.value.node) = (yystack_[10].value.node);
    }
#line 1539 "ado.tab.cpp"
    break;

  case 19: // forvalues_cmd: FORVALUES IDENT "=" NUMBER "/" NUMBER "{" STRING_LITERAL "}"
#line 315 "ado.ypp"
    {
        (yystack_[4].value.str); // shut up, bison...
        
        (yystack_[8].value.node)->appendChild("macro_name", (yystack_[7].value.node));
        (yystack_[8].value.node)->appendChild("text", (yystack_[1].value.node));

        (yystack_[8].value.node)->appendChild("upper", (yystack_[3].value.node));
        (yystack_[8].value.node)->appendChild("lower", (yystack_[5].value.node));
        // if "increment" and "increment_t" are both missing, assume increment = 1

        (yylhs.value.node) = (yystack_[8].value.node);
    }
#line 1556 "ado.tab.cpp"
    break;

  case 20: // forvalues_cmd: FORVALUES IDENT "=" NUMBER NUMBER ":" NUMBER "{" STRING_LITERAL "}"
#line 328 "ado.ypp"
    {
        (yystack_[9].value.node)->appendChild("macro_name", (yystack_[8].value.node));
        (yystack_[9].value.node)->appendChild("text", (yystack_[1].value.node));

        (yystack_[9].value.node)->appendChild("upper", (yystack_[3].value.node));
        (yystack_[9].value.node)->appendChild("lower", (yystack_[6].value.node));
        (yystack_[9].value.node)->appendChild("increment_t", (yystack_[5].value.node));

        (yylhs.value.node) = (yystack_[9].value.node);
    }
#line 1571 "ado.tab.cpp"
    break;

  case 21: // forvalues_cmd: FORVALUES IDENT "=" NUMBER NUMBER TO NUMBER "{" STRING_LITERAL "}"
#line 339 "ado.ypp"
    {
        (yystack_[9].value.node)->appendChild("macro_name", (yystack_[8].value.node));
        (yystack_[9].value.node)->appendChild("text", (yystack_[1].value.node));

        (yystack_[9].value.node)->appendChild("upper", (yystack_[3].value.node));
        (yystack_[9].value.node)->appendChild("lower", (yystack_[6].value.node));
        (yystack_[9].value.node)->appendChild("increment_t", (yystack_[5].value.node));

        (yylhs.value.node) = (yystack_[9].value.node);
    }
#line 1586 "ado.tab.cpp"
    break;

  case 24: // if_cmd: IF expression compound_cmd
#line 358 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_if_cmd");
        node->appendChild("expression", (yystack_[1].value.node));
        node->appendChild("compound_cmd", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1598 "ado.tab.cpp"
    break;

  case 25: // compound_cmd: "{" cmds "}"
#line 369 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1606 "ado.tab.cpp"
    break;

  case 26: // cmds: cmd
#line 376 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_compound_cmd");

        node->appendChild((yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1618 "ado.tab.cpp"
    break;

  case 27: // cmds: compound_cmd
#line 384 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[0].value.node);
    }
#line 1626 "ado.tab.cpp"
    break;

  case 28: // cmds: cmds cmd
#line 388 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));

        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1636 "ado.tab.cpp"
    break;

  case 29: // cmds: cmds compound_cmd
#line 394 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));

        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1646 "ado.tab.cpp"
    break;

  case 30: // cmd: cmd_sep
#line 402 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1652 "ado.tab.cpp"
    break;

  case 31: // cmd: EMBEDDED_CODE
#line 403 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 1658 "ado.tab.cpp"
    break;

  case 32: // cmd: nonmodifier_cmd cmd_sep
#line 406 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1668 "ado.tab.cpp"
    break;

  case 33: // cmd: long_modifier_cmd ":" modifier_cmd_list compound_cmd cmd_sep
#line 412 "ado.ypp"
    {
        (yystack_[2].value.node)->prependChild((yystack_[4].value.node));
        (yystack_[2].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 1681 "ado.tab.cpp"
    break;

  case 34: // cmd: long_modifier_cmd ":" modifier_cmd_list nonmodifier_cmd cmd_sep
#line 421 "ado.ypp"
    {
        (yystack_[2].value.node)->prependChild((yystack_[4].value.node));
        (yystack_[2].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 1694 "ado.tab.cpp"
    break;

  case 35: // cmd: long_modifier_cmd ":" nonmodifier_cmd cmd_sep
#line 430 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_modifier_cmd_list");

        (yystack_[0].value.node); // suppressing a stupid bison warning

        node->appendChild((yystack_[3].value.node));
        node->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 1709 "ado.tab.cpp"
    break;

  case 36: // cmd: modifier_cmd_list nonmodifier_cmd cmd_sep
#line 441 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[2].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 1721 "ado.tab.cpp"
    break;

  case 37: // cmd: modifier_cmd_list ":" nonmodifier_cmd cmd_sep
#line 449 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[3].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[3].value.node);
    }
#line 1733 "ado.tab.cpp"
    break;

  case 38: // cmd: modifier_cmd_list compound_cmd cmd_sep
#line 457 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[2].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 1745 "ado.tab.cpp"
    break;

  case 39: // cmd: modifier_cmd_list ":" compound_cmd cmd_sep
#line 465 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[3].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[3].value.node);
    }
#line 1757 "ado.tab.cpp"
    break;

  case 40: // cmd: modifier_cmd_list long_modifier_cmd ":" nonmodifier_cmd cmd_sep
#line 473 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[4].value.node)->appendChild((yystack_[3].value.node));
        (yystack_[4].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[4].value.node);
    }
#line 1770 "ado.tab.cpp"
    break;

  case 41: // cmd: modifier_cmd_list long_modifier_cmd ":" compound_cmd cmd_sep
#line 482 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[4].value.node)->appendChild((yystack_[3].value.node));
        (yystack_[4].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[4].value.node);
    }
#line 1783 "ado.tab.cpp"
    break;

  case 42: // cmd: modifier_cmd_list long_modifier_cmd ":" modifier_cmd_list nonmodifier_cmd cmd_sep
#line 491 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[5].value.node)->appendChild((yystack_[4].value.node));
        (yystack_[5].value.node)->appendChild((yystack_[2].value.node));
        (yystack_[5].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[5].value.node);
    }
#line 1797 "ado.tab.cpp"
    break;

  case 43: // cmd: modifier_cmd_list long_modifier_cmd ":" modifier_cmd_list compound_cmd cmd_sep
#line 501 "ado.ypp"
    {
        (yystack_[0].value.node); // suppressing a stupid bison warning

        (yystack_[5].value.node)->appendChild((yystack_[4].value.node));
        (yystack_[5].value.node)->appendChild((yystack_[2].value.node));
        (yystack_[5].value.node)->appendChild("main_cmd", (yystack_[1].value.node));

        (yylhs.value.node) = (yystack_[5].value.node);
    }
#line 1811 "ado.tab.cpp"
    break;

  case 44: // cmd_sep: NEWLINE
#line 514 "ado.ypp"
    {
        (yystack_[0].value.str); // suppressing a stupid bison warning

        (yylhs.value.node) = new ExprNode();
    }
#line 1821 "ado.tab.cpp"
    break;

  case 45: // cmd_sep: ";"
#line 520 "ado.ypp"
    {
        (yystack_[0].value.str); // suppressing a stupid bison warning

        (yylhs.value.node) = new ExprNode();
    }
#line 1831 "ado.tab.cpp"
    break;

  case 46: // modifier_cmd: CAPTURE
#line 529 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_modifier_cmd"});
        node->appendChild("verb", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1842 "ado.tab.cpp"
    break;

  case 47: // modifier_cmd: QUIETLY
#line 536 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_modifier_cmd"});
        node->appendChild("verb", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1853 "ado.tab.cpp"
    break;

  case 48: // modifier_cmd: NOISILY
#line 543 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_modifier_cmd"});
        node->appendChild("verb", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1864 "ado.tab.cpp"
    break;

  case 49: // long_modifier_cmd: BYSORT expression_list option_list
#line 553 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
          node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1880 "ado.tab.cpp"
    break;

  case 50: // long_modifier_cmd: BY expression_list option_list
#line 565 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
          node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1896 "ado.tab.cpp"
    break;

  case 51: // long_modifier_cmd: XI option_list
#line 577 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
          node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 1910 "ado.tab.cpp"
    break;

  case 52: // modifier_cmd_list: modifier_cmd
#line 590 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_modifier_cmd_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 1920 "ado.tab.cpp"
    break;

  case 53: // modifier_cmd_list: modifier_cmd_list modifier_cmd
#line 596 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 1929 "ado.tab.cpp"
    break;

  case 54: // nonmodifier_cmd: IDENT expression_list if_clause in_clause weight_clause using_clause option_list
#line 604 "ado.ypp"
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
#line 1956 "ado.tab.cpp"
    break;

  case 55: // nonmodifier_cmd: IDENT if_clause in_clause weight_clause using_clause option_list
#line 627 "ado.ypp"
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
#line 1982 "ado.tab.cpp"
    break;

  case 56: // nonmodifier_cmd: MERGE MERGE_SPEC expression_list using_clause option_list
#line 654 "ado.ypp"
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
#line 2014 "ado.tab.cpp"
    break;

  case 57: // nonmodifier_cmd: XI expression_list option_list
#line 682 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));
        
        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2030 "ado.tab.cpp"
    break;

  case 58: // nonmodifier_cmd: IVREGRESS TSLS varlist "(" varlist "=" varlist ")" if_clause in_clause weight_clause option_list
#line 694 "ado.ypp"
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
#line 2076 "ado.tab.cpp"
    break;

  case 59: // nonmodifier_cmd: GSORT gsort_varlist option_list
#line 736 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2092 "ado.tab.cpp"
    break;

  case 60: // nonmodifier_cmd: COLLAPSE collapse_spec_base_list if_clause in_clause weight_clause option_list
#line 748 "ado.ypp"
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
#line 2139 "ado.tab.cpp"
    break;

  case 61: // nonmodifier_cmd: COLLAPSE collapse_list if_clause in_clause weight_clause option_list
#line 791 "ado.ypp"
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
#line 2164 "ado.tab.cpp"
    break;

  case 62: // nonmodifier_cmd: LRTEST modelspec_list option_list
#line 812 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_cmd", "ado_general_cmd"});
        node->appendChild("verb", (yystack_[2].value.node));

        node->appendChild("expression_list", (yystack_[1].value.node));

        if((yystack_[0].value.node)->nChildren() > 0)
            node->appendChild("option_list", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 2180 "ado.tab.cpp"
    break;

  case 63: // nonmodifier_cmd: ANOVA IDENT anova_term_list if_clause in_clause weight_clause option_list
#line 824 "ado.ypp"
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
#line 2206 "ado.tab.cpp"
    break;

  case 64: // nonmodifier_cmd: RECODE recode_rule_list if_clause in_clause option_list
#line 846 "ado.ypp"
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
#line 2228 "ado.tab.cpp"
    break;

  case 65: // varlist: IDENT
#line 868 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2238 "ado.tab.cpp"
    break;

  case 66: // varlist: varlist IDENT
#line 874 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2247 "ado.tab.cpp"
    break;

  case 67: // number_or_missing: NUMBER
#line 881 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2253 "ado.tab.cpp"
    break;

  case 68: // number_or_missing: "."
#line 882 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2259 "ado.tab.cpp"
    break;

  case 69: // numlist: number_or_missing
#line 887 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2269 "ado.tab.cpp"
    break;

  case 70: // numlist: numlist number_or_missing
#line 893 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2278 "ado.tab.cpp"
    break;

  case 71: // collapse_spec_base: IDENT
#line 901 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2284 "ado.tab.cpp"
    break;

  case 72: // collapse_spec_base: IDENT "=" IDENT
#line 903 "ado.ypp"
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
#line 2313 "ado.tab.cpp"
    break;

  case 73: // collapse_spec_base_list: collapse_spec_base
#line 931 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2323 "ado.tab.cpp"
    break;

  case 74: // collapse_spec_base_list: collapse_spec_base_list collapse_spec_base
#line 937 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2332 "ado.tab.cpp"
    break;

  case 75: // collapse_spec: "(" IDENT ")" collapse_spec_base_list
#line 945 "ado.ypp"
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
#line 2356 "ado.tab.cpp"
    break;

  case 76: // collapse_list: collapse_spec
#line 968 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2366 "ado.tab.cpp"
    break;

  case 77: // collapse_list: collapse_list collapse_spec
#line 974 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2375 "ado.tab.cpp"
    break;

  case 78: // recode_rule: IDENT
#line 982 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2381 "ado.tab.cpp"
    break;

  case 79: // recode_rule: "(" IDENT "=" NUMBER ")"
#line 984 "ado.ypp"
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
#line 2405 "ado.tab.cpp"
    break;

  case 80: // recode_rule: "(" NUMBER "/" NUMBER "=" NUMBER ")"
#line 1004 "ado.ypp"
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
#line 2432 "ado.tab.cpp"
    break;

  case 81: // recode_rule: "(" numlist "=" NUMBER ")"
#line 1027 "ado.ypp"
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
#line 2456 "ado.tab.cpp"
    break;

  case 82: // recode_rule_list: recode_rule
#line 1050 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2466 "ado.tab.cpp"
    break;

  case 83: // recode_rule_list: recode_rule_list recode_rule
#line 1056 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2475 "ado.tab.cpp"
    break;

  case 84: // gsort_var: IDENT
#line 1065 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", *(new std::string("()")));
        node->appendChild("right", (yystack_[0].value.node));
        
        ExprNode *left = new ExprNode({"ado_literal", "ado_ident"});
        left->addData("value", *(new std::string("asc")));
        node->appendChild("left", left);
        
        (yylhs.value.node) = node;
    }
#line 2491 "ado.tab.cpp"
    break;

  case 85: // gsort_var: "+" IDENT
#line 1077 "ado.ypp"
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
#line 2509 "ado.tab.cpp"
    break;

  case 86: // gsort_var: "-" IDENT
#line 1091 "ado.ypp"
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
#line 2527 "ado.tab.cpp"
    break;

  case 87: // gsort_varlist: gsort_var
#line 1108 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2537 "ado.tab.cpp"
    break;

  case 88: // gsort_varlist: gsort_varlist gsort_var
#line 1114 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2546 "ado.tab.cpp"
    break;

  case 89: // modelspec: IDENT
#line 1122 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2552 "ado.tab.cpp"
    break;

  case 90: // modelspec: "."
#line 1123 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2558 "ado.tab.cpp"
    break;

  case 91: // modelspec: "(" varlist ")"
#line 1125 "ado.ypp"
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
#line 2577 "ado.tab.cpp"
    break;

  case 92: // modelspec_list: modelspec
#line 1143 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2587 "ado.tab.cpp"
    break;

  case 93: // modelspec_list: modelspec_list modelspec
#line 1149 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2596 "ado.tab.cpp"
    break;

  case 94: // anova_nest_expression: cross_expression
#line 1157 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2602 "ado.tab.cpp"
    break;

  case 95: // anova_nest_expression: anova_nest_expression "|" cross_expression
#line 1159 "ado.ypp"
    {
        (yystack_[1].value.str); // shut up, bison...
        
        ExprNode *node = new ExprNode({"ado_expression", "ado_anova_nest_expression"});
        node->addData("verb", *(new std::string("%anova_nest%")));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        
        (yylhs.value.node) = node;
    }
#line 2617 "ado.tab.cpp"
    break;

  case 96: // anova_error_expression: anova_nest_expression
#line 1172 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2623 "ado.tab.cpp"
    break;

  case 97: // anova_error_expression: anova_nest_expression "/"
#line 1174 "ado.ypp"
    {
        (yystack_[0].value.str); // shut up, bison...
        
        ExprNode *node = new ExprNode({"ado_expression", "ado_anova_error_expression"});
        node->addData("verb", *(new std::string("%anova_error%")));
        node->appendChild("left", (yystack_[1].value.node));
        
        (yylhs.value.node) = node;
    }
#line 2637 "ado.tab.cpp"
    break;

  case 98: // anova_term_list: anova_error_expression
#line 1187 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2647 "ado.tab.cpp"
    break;

  case 99: // anova_term_list: anova_term_list anova_error_expression
#line 1193 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2656 "ado.tab.cpp"
    break;

  case 100: // type_operator: BYTE
#line 1208 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2662 "ado.tab.cpp"
    break;

  case 101: // type_operator: INT
#line 1209 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2668 "ado.tab.cpp"
    break;

  case 102: // type_operator: LONG
#line 1210 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2674 "ado.tab.cpp"
    break;

  case 103: // type_operator: FLOAT
#line 1211 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2680 "ado.tab.cpp"
    break;

  case 104: // type_operator: DOUBLE
#line 1212 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2686 "ado.tab.cpp"
    break;

  case 105: // type_operator: STRING_TYPE_SPEC
#line 1213 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2692 "ado.tab.cpp"
    break;

  case 107: // unary_operator: "-"
#line 1221 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2698 "ado.tab.cpp"
    break;

  case 108: // unary_operator: "+"
#line 1222 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2704 "ado.tab.cpp"
    break;

  case 109: // unary_operator: "!"
#line 1223 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2710 "ado.tab.cpp"
    break;

  case 110: // unary_factor_operator: CONT_OPERATOR
#line 1227 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2716 "ado.tab.cpp"
    break;

  case 111: // unary_factor_operator: BASE_OPERATOR
#line 1228 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2722 "ado.tab.cpp"
    break;

  case 112: // unary_factor_operator: IND_OPERATOR
#line 1229 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2728 "ado.tab.cpp"
    break;

  case 113: // unary_factor_operator: OMIT_OPERATOR
#line 1230 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2734 "ado.tab.cpp"
    break;

  case 114: // power_operator: "^"
#line 1234 "ado.ypp"
    { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2740 "ado.tab.cpp"
    break;

  case 115: // multiplication_operator: "*"
#line 1238 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2746 "ado.tab.cpp"
    break;

  case 116: // multiplication_operator: "/"
#line 1239 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2752 "ado.tab.cpp"
    break;

  case 117: // additive_operator: "+"
#line 1243 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2758 "ado.tab.cpp"
    break;

  case 118: // additive_operator: "-"
#line 1244 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2764 "ado.tab.cpp"
    break;

  case 119: // relational_operator: "<"
#line 1248 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2770 "ado.tab.cpp"
    break;

  case 120: // relational_operator: ">"
#line 1249 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2776 "ado.tab.cpp"
    break;

  case 121: // relational_operator: ">="
#line 1250 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2782 "ado.tab.cpp"
    break;

  case 122: // relational_operator: "<="
#line 1251 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2788 "ado.tab.cpp"
    break;

  case 123: // equality_operator: "=="
#line 1255 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2794 "ado.tab.cpp"
    break;

  case 124: // equality_operator: "!="
#line 1256 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2800 "ado.tab.cpp"
    break;

  case 125: // logical_operator: "&"
#line 1260 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2806 "ado.tab.cpp"
    break;

  case 126: // logical_operator: "|"
#line 1261 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2812 "ado.tab.cpp"
    break;

  case 127: // cross_operator: "##"
#line 1265 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2818 "ado.tab.cpp"
    break;

  case 128: // cross_operator: "#"
#line 1266 "ado.ypp"
      { (yylhs.value.str) = (yystack_[0].value.str); }
#line 2824 "ado.tab.cpp"
    break;

  case 129: // format_spec: STRING_FORMAT
#line 1270 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2830 "ado.tab.cpp"
    break;

  case 130: // format_spec: NUMBER_FORMAT
#line 1271 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2836 "ado.tab.cpp"
    break;

  case 131: // format_spec: DATETIME_FORMAT
#line 1272 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2842 "ado.tab.cpp"
    break;

  case 132: // literal_expression: IDENT
#line 1276 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2848 "ado.tab.cpp"
    break;

  case 133: // literal_expression: NUMBER
#line 1277 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2854 "ado.tab.cpp"
    break;

  case 134: // literal_expression: STRING_LITERAL
#line 1278 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2860 "ado.tab.cpp"
    break;

  case 135: // literal_expression: DATE
#line 1279 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2866 "ado.tab.cpp"
    break;

  case 136: // literal_expression: DATETIME
#line 1280 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2872 "ado.tab.cpp"
    break;

  case 137: // literal_expression: "."
#line 1281 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2878 "ado.tab.cpp"
    break;

  case 138: // literal_expression: format_spec
#line 1282 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2884 "ado.tab.cpp"
    break;

  case 139: // primary_expression: literal_expression
#line 1287 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[0].value.node);
    }
#line 2892 "ado.tab.cpp"
    break;

  case 140: // primary_expression: "(" expression ")"
#line 1291 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 2900 "ado.tab.cpp"
    break;

  case 141: // primary_expression: type_operator "(" expression_list ")"
#line 1295 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[3].value.str)));
        node->appendChild("left", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 2912 "ado.tab.cpp"
    break;

  case 142: // primary_expression: type_operator IDENT
#line 1303 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_type_expression"});
        node->addData("verb", *((yystack_[1].value.str)));

        ExprNode *lst = new ExprNode("ado_expression_list");
        lst->appendChild((yystack_[0].value.node));
        node->appendChild("left", lst);

        (yylhs.value.node) = node;
    }
#line 2927 "ado.tab.cpp"
    break;

  case 143: // unary_factor_expression: primary_expression
#line 1316 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2933 "ado.tab.cpp"
    break;

  case 144: // unary_factor_expression: unary_factor_operator primary_expression
#line 1318 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild("left", (yystack_[0].value.node));

        (yylhs.value.node) = (yystack_[1].value.node); // ExprNode constructed by the lexer, which is a bit of a hack
    }
#line 2943 "ado.tab.cpp"
    break;

  case 145: // cross_expression: unary_factor_expression
#line 1326 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2949 "ado.tab.cpp"
    break;

  case 146: // cross_expression: cross_expression cross_operator unary_factor_expression
#line 1328 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_cross_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 2961 "ado.tab.cpp"
    break;

  case 147: // postfix_expression: cross_expression
#line 1338 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 2967 "ado.tab.cpp"
    break;

  case 148: // postfix_expression: postfix_expression "[" additive_expression "]"
#line 1340 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", std::string("[]"));
        node->appendChild("left", (yystack_[3].value.node));
        node->appendChild("right", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 2980 "ado.tab.cpp"
    break;

  case 149: // postfix_expression: postfix_expression "(" ")"
#line 1349 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", std::string("()"));
        node->appendChild("left", (yystack_[2].value.node));

        (yylhs.value.node) = node;
    }
#line 2992 "ado.tab.cpp"
    break;

  case 150: // postfix_expression: postfix_expression "(" argument_expression_list ")"
#line 1357 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_postfix_expression"});
        node->addData("verb", std::string("()"));
        node->appendChild("left", (yystack_[3].value.node));
        node->appendChild("right", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 3005 "ado.tab.cpp"
    break;

  case 151: // power_expression: postfix_expression
#line 1368 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3011 "ado.tab.cpp"
    break;

  case 152: // power_expression: power_expression power_operator postfix_expression
#line 1370 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_arithmetic_expression", "ado_power_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3023 "ado.tab.cpp"
    break;

  case 153: // unary_expression: power_expression
#line 1380 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3029 "ado.tab.cpp"
    break;

  case 154: // unary_expression: unary_operator power_expression
#line 1382 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_arithmetic_expression", "ado_unary_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3040 "ado.tab.cpp"
    break;

  case 155: // multiplication_expression: unary_expression
#line 1391 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3046 "ado.tab.cpp"
    break;

  case 156: // multiplication_expression: multiplication_expression multiplication_operator unary_expression
#line 1393 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_arithmetic_expression", "ado_multiplication_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3058 "ado.tab.cpp"
    break;

  case 157: // additive_expression: multiplication_expression
#line 1403 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3064 "ado.tab.cpp"
    break;

  case 158: // additive_expression: additive_expression additive_operator multiplication_expression
#line 1405 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_arithmetic_expression", "ado_additive_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3076 "ado.tab.cpp"
    break;

  case 159: // relational_expression: additive_expression
#line 1415 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3082 "ado.tab.cpp"
    break;

  case 160: // relational_expression: relational_expression relational_operator additive_expression
#line 1417 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_relational_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3094 "ado.tab.cpp"
    break;

  case 161: // equality_expression: relational_expression
#line 1427 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3100 "ado.tab.cpp"
    break;

  case 162: // equality_expression: equality_expression equality_operator relational_expression
#line 1429 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_equality_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3112 "ado.tab.cpp"
    break;

  case 163: // logical_expression: equality_expression
#line 1439 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3118 "ado.tab.cpp"
    break;

  case 164: // logical_expression: logical_expression logical_operator equality_expression
#line 1441 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_logical_expression"});
        node->addData("verb", *((yystack_[1].value.str)));
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3130 "ado.tab.cpp"
    break;

  case 165: // expression: logical_expression
#line 1451 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3136 "ado.tab.cpp"
    break;

  case 166: // expression: logical_expression assignment_operator logical_expression
#line 1453 "ado.ypp"
    {
        ExprNode *node = new ExprNode({"ado_expression", "ado_assignment_expression"});
        node->addData("verb", "=");
        node->appendChild("left", (yystack_[2].value.node));
        node->appendChild("right", (yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3148 "ado.tab.cpp"
    break;

  case 167: // expression_list: expression
#line 1464 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3158 "ado.tab.cpp"
    break;

  case 168: // expression_list: expression_list expression
#line 1470 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 3167 "ado.tab.cpp"
    break;

  case 169: // argument_expression_list: expression_list
#line 1478 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_argument_expression_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3177 "ado.tab.cpp"
    break;

  case 170: // argument_expression_list: argument_expression_list "," expression_list
#line 1484 "ado.ypp"
    {
        (yystack_[2].value.node)->appendChild((yystack_[0].value.node));

        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 3187 "ado.tab.cpp"
    break;

  case 171: // option_list: %empty
#line 1499 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_option_list");
    }
#line 3195 "ado.tab.cpp"
    break;

  case 172: // option_list: "," options
#line 1503 "ado.ypp"
    {
        (yylhs.value.node) = (yystack_[0].value.node);
    }
#line 3203 "ado.tab.cpp"
    break;

  case 173: // options: option
#line 1510 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_option_list");
        node->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = node;
    }
#line 3213 "ado.tab.cpp"
    break;

  case 174: // options: options option
#line 1516 "ado.ypp"
    {
        (yystack_[1].value.node)->appendChild((yystack_[0].value.node));
        (yylhs.value.node) = (yystack_[1].value.node);
    }
#line 3222 "ado.tab.cpp"
    break;

  case 175: // option: option_ident
#line 1524 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_option");
        node->appendChild("name", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3233 "ado.tab.cpp"
    break;

  case 176: // option: option_ident "(" argument_expression_list ")"
#line 1531 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_option");
        node->appendChild("name", (yystack_[3].value.node));
        node->appendChild("args", (yystack_[1].value.node));

        (yylhs.value.node) = node;
    }
#line 3245 "ado.tab.cpp"
    break;

  case 177: // option_ident: IDENT
#line 1543 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3251 "ado.tab.cpp"
    break;

  case 178: // option_ident: BY
#line 1544 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3257 "ado.tab.cpp"
    break;

  case 179: // option_ident: BYSORT
#line 1545 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3263 "ado.tab.cpp"
    break;

  case 180: // option_ident: XI
#line 1546 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3269 "ado.tab.cpp"
    break;

  case 181: // option_ident: CAPTURE
#line 1547 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3275 "ado.tab.cpp"
    break;

  case 182: // option_ident: QUIETLY
#line 1548 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3281 "ado.tab.cpp"
    break;

  case 183: // option_ident: NOISILY
#line 1549 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3287 "ado.tab.cpp"
    break;

  case 184: // option_ident: MERGE
#line 1550 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3293 "ado.tab.cpp"
    break;

  case 185: // option_ident: COLLAPSE
#line 1551 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3299 "ado.tab.cpp"
    break;

  case 186: // option_ident: RECODE
#line 1552 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3305 "ado.tab.cpp"
    break;

  case 187: // option_ident: IVREGRESS
#line 1553 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3311 "ado.tab.cpp"
    break;

  case 188: // option_ident: GSORT
#line 1554 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3317 "ado.tab.cpp"
    break;

  case 189: // option_ident: LRTEST
#line 1555 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3323 "ado.tab.cpp"
    break;

  case 190: // option_ident: ANOVA
#line 1556 "ado.ypp"
      { (yylhs.value.node) = (yystack_[0].value.node); }
#line 3329 "ado.tab.cpp"
    break;

  case 191: // weight_clause: %empty
#line 1567 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_weight_clause");
    }
#line 3337 "ado.tab.cpp"
    break;

  case 192: // weight_clause: WEIGHT_SPEC literal_expression "]"
#line 1571 "ado.ypp"
    {
        (yystack_[2].value.node)->appendChild("right", (yystack_[1].value.node));
        (yylhs.value.node) = (yystack_[2].value.node);
    }
#line 3346 "ado.tab.cpp"
    break;

  case 193: // if_clause: %empty
#line 1585 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_if_clause");
    }
#line 3354 "ado.tab.cpp"
    break;

  case 194: // if_clause: IF expression
#line 1589 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_if_clause");
        node->appendChild("if_expression", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3365 "ado.tab.cpp"
    break;

  case 195: // in_clause: %empty
#line 1605 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_in_clause");
    }
#line 3373 "ado.tab.cpp"
    break;

  case 196: // in_clause: IN unary_expression "/" unary_expression
#line 1609 "ado.ypp"
    {
        (yystack_[1].value.str); // suppressing a stupid bison warning

        ExprNode *node = new ExprNode("ado_in_clause");
        node->appendChild("lower", (yystack_[2].value.node));
        node->appendChild("upper", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3387 "ado.tab.cpp"
    break;

  case 197: // in_clause: IN unary_expression
#line 1619 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_in_clause");
        node->appendChild("upper", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3398 "ado.tab.cpp"
    break;

  case 198: // using_clause: %empty
#line 1635 "ado.ypp"
    {
        (yylhs.value.node) = new ExprNode("ado_using_clause");
    }
#line 3406 "ado.tab.cpp"
    break;

  case 199: // using_clause: USING STRING_LITERAL
#line 1639 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_using_clause");
        node->appendChild("filename", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3417 "ado.tab.cpp"
    break;

  case 200: // using_clause: USING IDENT
#line 1646 "ado.ypp"
    {
        ExprNode *node = new ExprNode("ado_using_clause");
        node->appendChild("filename", (yystack_[0].value.node));

        (yylhs.value.node) = node;
    }
#line 3428 "ado.tab.cpp"
    break;


#line 3432 "ado.tab.cpp"

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


  const short  AdoParser ::yypact_ninf_ = -218;

  const signed char  AdoParser ::yytable_ninf_ = -1;

  const short
   AdoParser ::yypact_[] =
  {
     284,  -218,  -218,  -218,   648,   341,  -218,   557,   385,   557,
    -218,  -218,  -218,   -22,    40,     1,    49,    55,    34,    83,
     557,    85,    95,   253,  -218,  -218,  -218,  -218,  -218,  -218,
    -218,  -218,   142,   676,   190,  -218,   620,  -218,  -218,  -218,
     557,  -218,  -218,  -218,  -218,  -218,  -218,  -218,  -218,  -218,
    -218,  -218,  -218,  -218,  -218,  -218,  -218,   557,  -218,  -218,
    -218,  -218,    74,   107,   706,  -218,  -218,  -218,  -218,   173,
     155,   137,  -218,   184,   212,   168,   194,   150,  -218,   341,
     100,   385,   721,   385,  -218,   385,   557,   135,   174,  -218,
       6,  -218,    23,   167,   164,  -218,  -218,    20,   179,   196,
    -218,  -218,    44,   167,  -218,  -218,  -218,    39,   107,   169,
      59,   216,  -218,  -218,  -218,   733,   704,   190,  -218,   222,
     190,  -218,  -218,  -218,  -218,   227,  -218,   557,  -218,   137,
    -218,  -218,  -218,   107,   428,   557,  -218,   107,  -218,  -218,
     557,  -218,  -218,   557,  -218,  -218,  -218,  -218,   557,  -218,
    -218,   557,  -218,  -218,  -218,   557,   557,  -218,   100,   557,
     176,  -218,  -218,  -218,  -218,  -218,  -218,  -218,  -218,  -218,
    -218,  -218,  -218,  -218,  -218,  -218,   721,  -218,   232,  -218,
    -218,   471,   234,   213,  -218,   100,  -218,   100,  -218,    78,
     225,   235,  -218,  -218,   148,  -218,   100,  -218,  -218,  -218,
    -218,    41,  -218,  -218,    98,  -218,   572,   173,  -218,  -218,
    -218,   182,   217,   557,    45,   190,   190,   190,  -218,    45,
    -218,  -218,   514,  -218,  -218,   557,   215,   117,   155,  -218,
     184,   212,   168,   199,   194,   176,   229,   448,   198,  -218,
     557,   189,   252,   231,  -218,   176,   176,   167,  -218,   236,
     237,   238,  -218,  -218,   252,  -218,  -218,   107,  -218,   100,
     233,   239,   167,   167,   157,    28,    26,   103,   190,   190,
    -218,  -218,  -218,   190,    45,   190,  -218,  -218,   557,  -218,
     198,   557,   256,   252,   221,  -218,  -218,  -218,   231,   252,
     252,    19,   250,   264,   265,  -218,   173,   176,   268,   271,
      94,   124,    97,   242,   243,   255,   257,    15,  -218,  -218,
    -218,   190,   190,  -218,   557,   252,  -218,  -218,  -218,  -218,
    -218,  -218,   167,   258,  -218,  -218,   252,   254,   261,   263,
     280,   281,   278,   285,   274,   306,   287,   288,  -218,  -218,
    -218,    80,   311,  -218,   309,   310,   313,   314,   315,  -218,
    -218,   297,   296,   337,   338,   289,  -218,  -218,  -218,  -218,
    -218,  -218,   339,   340,   320,   323,   100,   324,  -218,   346,
     347,   176,   349,  -218,  -218,   252,  -218,  -218
  };

  const unsigned char
   AdoParser ::yydefact_[] =
  {
       0,     5,    44,    45,     0,   193,    31,     0,   171,     0,
      47,    46,    48,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     2,     9,    10,     8,     7,     6,
      30,    52,     0,     0,     0,    27,     0,    26,   108,   107,
       0,   109,   133,   132,   134,   135,   136,   137,   100,   101,
     102,   103,   104,   105,   129,   131,   130,     0,   110,   112,
     111,   113,     0,     0,     0,   138,   139,   143,   145,   147,
     151,   153,   155,   157,   159,   161,   163,   165,   167,   193,
     195,   171,     0,   171,    51,   171,     0,     0,    71,    73,
     193,    76,   193,     0,     0,    78,    82,   193,     0,     0,
      84,    87,   171,     0,    89,    90,    92,   171,     0,     0,
       0,     0,     1,     4,     3,     0,     0,     0,    53,     0,
       0,    32,    25,    29,    28,     0,   194,     0,   142,   154,
     144,   127,   128,     0,     0,     0,   114,     0,   115,   116,
       0,   117,   118,     0,   119,   120,   121,   122,     0,   123,
     124,     0,   106,   126,   125,     0,     0,   168,   195,     0,
     191,    50,   177,   178,   180,   179,   182,   181,   183,   184,
     185,   187,   186,   188,   189,   190,   172,   173,   175,    57,
      49,   198,     0,     0,    74,   195,    77,   195,    65,     0,
      67,     0,    68,    69,     0,    83,   195,    85,    86,    88,
      59,     0,    93,    62,    96,    98,   193,    94,    24,    22,
      23,     0,     0,     0,     0,     0,     0,     0,    38,     0,
      36,   140,     0,   146,   149,   169,     0,     0,   152,   156,
     158,   160,   162,   166,   164,   191,   197,     0,   198,   174,
       0,     0,   171,     0,    72,   191,   191,     0,    66,     0,
       0,     0,    67,    70,   171,    91,    97,     0,    99,   195,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      35,    39,    37,     0,     0,     0,   141,   150,     0,   148,
     198,     0,     0,   171,     0,   200,   199,    56,    75,   171,
     171,     0,     0,     0,     0,    64,    95,   191,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    33,    34,
      41,     0,     0,    40,   170,   171,   196,   192,    55,   176,
      60,    61,     0,     0,    79,    81,   171,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    43,    42,
      54,     0,     0,    63,     0,     0,     0,     0,     0,    11,
      12,     0,     0,     0,     0,   193,    80,    13,    14,    15,
      16,    17,     0,     0,     0,     0,   195,     0,    19,     0,
       0,   191,     0,    20,    21,   171,    18,    58
  };

  const short
   AdoParser ::yypgoto_[] =
  {
    -218,  -218,   342,  -218,  -218,  -218,  -218,    -1,  -218,    29,
     -33,   -26,   330,   -95,   -24,   -92,  -171,  -189,   -77,   121,
     275,  -218,   269,  -218,   266,  -218,   262,  -218,  -218,   165,
    -218,  -218,  -218,  -218,  -218,  -218,  -218,  -218,  -218,  -218,
    -218,  -218,  -218,   133,   308,   260,   -94,   251,   328,  -125,
     259,    24,   244,   241,   245,   -15,     3,   154,   -81,  -218,
     223,  -218,  -217,   -73,  -142,  -201
  };

  const unsigned char
   AdoParser ::yydefgoto_[] =
  {
       0,    23,    24,    25,    26,   211,    27,    28,    36,    29,
      30,    31,    32,    33,    34,   189,   193,   194,    89,    90,
      91,    92,    96,    97,   101,   102,   106,   107,   204,   205,
     206,    62,   155,    63,    64,   137,   140,   143,   148,   151,
     156,   133,    65,    66,    67,    68,    69,    70,    71,    72,
      73,    74,    75,    76,    77,    78,    83,   226,    84,   176,
     177,   178,   238,    80,   160,   242
  };

  const short
   AdoParser ::yytable_[] =
  {
     161,   121,   179,    35,   180,   109,   158,   118,    79,   120,
      81,   201,    85,   184,   207,   229,   235,   185,   280,   187,
     214,   200,   266,   253,   196,   125,   203,    94,   289,   290,
      87,   336,   117,    37,   236,   123,   322,   283,   304,    88,
     303,   103,   126,   245,    86,   246,   103,    87,    98,    99,
      82,   255,   248,    95,   254,    82,    94,     4,   252,    98,
      99,   248,    93,   192,   157,   124,   157,   104,   157,    57,
     157,   105,   104,    88,   248,   302,   105,   100,     5,   315,
     326,   127,    95,    57,   218,   247,    57,   220,   100,   181,
     355,   215,   217,   337,   213,   253,    10,    11,    12,    13,
      14,    15,    16,    17,    18,    19,   329,   128,   208,   331,
     305,   248,   207,   248,    40,   216,   108,   297,   110,   265,
     256,   141,   142,   209,   274,   306,   257,   248,   111,   252,
     222,   253,   279,   259,   192,   307,   330,   225,   210,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,   375,   291,   316,   248,   115,   227,
     136,   287,   134,   296,   159,   251,   157,   152,   182,   135,
     300,   301,   231,   295,    58,    59,    60,    61,   153,   154,
     252,     4,   270,   271,   272,   192,   144,   145,   118,   252,
     269,   183,   146,   147,   192,   275,   190,   191,     2,     3,
     188,   192,   318,   131,   132,   138,   139,   157,   320,   321,
     157,   184,   197,   268,   252,   188,   141,   142,   273,   192,
     149,   150,   285,   286,   371,   277,   278,   153,   154,   198,
     341,   319,   278,   212,   340,   308,   309,   221,   219,   240,
     310,   237,   313,   225,   243,   343,   244,   249,   118,   267,
     312,   281,   250,   112,   113,   260,   261,   262,   263,   264,
     241,     2,     3,    82,    88,     4,   298,   323,   292,   293,
     294,   317,   299,   311,   324,   325,   332,   333,   338,   339,
     327,   314,   366,   328,   351,     1,     5,   334,   344,   335,
     342,   349,     2,     3,   377,   345,     4,   346,   350,   157,
       6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19,   347,   348,    20,     5,   352,   353,
     354,   356,   357,   358,    21,    22,   359,   360,   361,   362,
     363,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    38,    39,    20,    40,   364,
     365,   367,    57,   368,   369,    21,    22,   370,   372,   373,
     374,    41,   376,   119,   288,   114,   195,   186,   199,   202,
     282,   258,   130,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,   228,    38,
      39,   129,    40,   223,   284,   232,    82,   234,     0,   239,
     233,     0,   230,     0,    57,    41,     0,     0,    58,    59,
      60,    61,     0,     0,     0,     0,     0,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    38,    39,     0,    40,     0,     0,   224,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    41,     0,
       0,     0,    58,    59,    60,    61,     0,     0,     0,     0,
      42,    43,    44,    45,    46,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    38,    39,     0,    40,     0,
      42,    43,    44,    45,    46,    47,     0,     0,     0,     0,
       0,    41,    54,    55,    56,    58,    59,    60,    61,     0,
       0,     0,     0,    42,    43,    44,    45,    46,    47,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    38,    39,
       0,    40,     0,     0,   276,     0,     0,     0,     0,     0,
       0,     0,     0,   241,    41,     0,     0,     0,    58,    59,
      60,    61,     0,     0,     0,     0,    42,    43,    44,    45,
      46,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    38,    39,     0,    40,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,    41,     0,    40,
       0,    58,    59,    60,    61,     0,     0,     0,     0,    42,
      43,    44,    45,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    55,    56,    42,    43,    44,    45,    46,    47,
      48,    49,    50,    51,    52,    53,    54,    55,    56,     0,
       0,     0,     0,     0,    58,    59,    60,    61,     2,     3,
       0,     0,     4,   122,     0,    57,     0,     0,     0,    58,
      59,    60,    61,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     5,     0,     0,     2,     3,     0,     0,
       4,     0,     0,     0,     0,     0,     0,     6,     7,     8,
       9,    10,    11,    12,    13,    14,    15,    16,    17,    18,
      19,     5,     0,     0,     0,     0,     0,     0,     4,     0,
       0,     0,   116,     0,     0,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    15,    16,    17,    18,    19,     5,
       0,     0,     0,    40,     0,     0,     4,     0,     0,     0,
       0,     0,     0,     0,     7,     8,     9,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    19,     5,    42,    43,
      44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,   213,   162,     0,     0,     0,    13,    14,
      15,    16,    17,    18,    19,     0,     5,     0,     0,   163,
     164,   165,   166,   167,   168,   169,   170,   171,   172,   173,
     174,   175,   213,     0,    10,    11,    12,    13,    14,    15,
      16,    17,    18,    19
  };

  const short
   AdoParser ::yycheck_[] =
  {
      81,    34,    83,     4,    85,    20,    79,    33,     5,    33,
       7,   103,     9,    90,   108,   140,   158,    90,   235,    92,
     115,   102,   211,   194,    97,    40,   107,     7,   245,   246,
       7,    16,    33,     4,   159,    36,    17,   238,    12,    33,
      12,     7,    57,   185,    66,   187,     7,     7,     4,     5,
      11,    10,    33,    33,   196,    11,     7,    12,    32,     4,
       5,    33,    61,    37,    79,    36,    81,    33,    83,    63,
      85,    37,    33,    33,    33,   264,    37,    33,    33,   280,
     297,     7,    33,    63,   117,     7,    63,   120,    33,    86,
      10,   115,   116,    78,    49,   266,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    12,    33,   109,    12,
       7,    33,   206,    33,     7,   116,    33,   259,    33,   211,
      22,     4,     5,    64,   219,    22,    28,    33,    33,    32,
     127,   302,    15,   206,    37,    32,    12,   134,    79,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,   371,   247,   281,    33,    16,   135,
      23,   242,     7,   257,    64,    17,   181,    17,    33,    14,
     262,   263,   148,   254,    67,    68,    69,    70,    28,    29,
      32,    12,   215,   216,   217,    37,    18,    19,   214,    32,
     214,    17,    24,    25,    37,   219,    32,    33,     8,     9,
      33,    37,   283,    30,    31,    21,    22,   222,   289,   290,
     225,   288,    33,   214,    32,    33,     4,     5,   219,    37,
      26,    27,    33,    34,   366,    10,    11,    28,    29,    33,
     322,    10,    11,    17,   315,   268,   269,    10,    16,     7,
     273,    65,   275,   240,    10,   326,    33,    22,   274,    32,
     274,    22,    17,     0,     1,    73,    74,    75,    76,    77,
      62,     8,     9,    11,    33,    12,    33,    17,    32,    32,
      32,    15,    33,   274,    10,    10,    34,    34,   311,   312,
      12,   278,   355,    12,    10,     1,    33,    32,    34,    32,
      32,    13,     8,     9,   375,    34,    12,    34,    13,   314,
      47,    48,    49,    50,    51,    52,    53,    54,    55,    56,
      57,    58,    59,    60,    34,    34,    63,    33,    12,    32,
      32,    10,    13,    13,    71,    72,    13,    13,    13,    32,
      34,    47,    48,    49,    50,    51,    52,    53,    54,    55,
      56,    57,    58,    59,    60,     4,     5,    63,     7,    12,
      12,    12,    63,    13,    34,    71,    72,    34,    34,    13,
      13,    20,    13,    33,   243,    23,    97,    92,   102,   107,
     237,   206,    64,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,   137,     4,
       5,    63,     7,   133,   240,   151,    11,   156,    -1,   176,
     155,    -1,   143,    -1,    63,    20,    -1,    -1,    67,    68,
      69,    70,    -1,    -1,    -1,    -1,    -1,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,     4,     5,    -1,     7,    -1,    -1,    10,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    20,    -1,
      -1,    -1,    67,    68,    69,    70,    -1,    -1,    -1,    -1,
      32,    33,    34,    35,    36,    37,    38,    39,    40,    41,
      42,    43,    44,    45,    46,     4,     5,    -1,     7,    -1,
      32,    33,    34,    35,    36,    37,    -1,    -1,    -1,    -1,
      -1,    20,    44,    45,    46,    67,    68,    69,    70,    -1,
      -1,    -1,    -1,    32,    33,    34,    35,    36,    37,    38,
      39,    40,    41,    42,    43,    44,    45,    46,     4,     5,
      -1,     7,    -1,    -1,    10,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    62,    20,    -1,    -1,    -1,    67,    68,
      69,    70,    -1,    -1,    -1,    -1,    32,    33,    34,    35,
      36,    37,    38,    39,    40,    41,    42,    43,    44,    45,
      46,     4,     5,    -1,     7,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    20,    -1,     7,
      -1,    67,    68,    69,    70,    -1,    -1,    -1,    -1,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    41,    42,
      43,    44,    45,    46,    32,    33,    34,    35,    36,    37,
      38,    39,    40,    41,    42,    43,    44,    45,    46,    -1,
      -1,    -1,    -1,    -1,    67,    68,    69,    70,     8,     9,
      -1,    -1,    12,    13,    -1,    63,    -1,    -1,    -1,    67,
      68,    69,    70,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    33,    -1,    -1,     8,     9,    -1,    -1,
      12,    -1,    -1,    -1,    -1,    -1,    -1,    47,    48,    49,
      50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
      60,    33,    -1,    -1,    -1,    -1,    -1,    -1,    12,    -1,
      -1,    -1,    16,    -1,    -1,    47,    48,    49,    50,    51,
      52,    53,    54,    55,    56,    57,    58,    59,    60,    33,
      -1,    -1,    -1,     7,    -1,    -1,    12,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,    58,    59,    60,    33,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
      44,    45,    46,    49,    33,    -1,    -1,    -1,    54,    55,
      56,    57,    58,    59,    60,    -1,    33,    -1,    -1,    48,
      49,    50,    51,    52,    53,    54,    55,    56,    57,    58,
      59,    60,    49,    -1,    51,    52,    53,    54,    55,    56,
      57,    58,    59,    60
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
      69,    70,   111,   113,   114,   122,   123,   124,   125,   126,
     127,   128,   129,   130,   131,   132,   133,   134,   135,   136,
     143,   136,    11,   136,   138,   136,    66,     7,    33,    98,
      99,   100,   101,    61,     7,    33,   102,   103,     4,     5,
      33,   104,   105,     7,    33,    37,   106,   107,    33,   135,
      33,    33,     0,     1,    82,    16,    16,    87,    91,    92,
      94,    90,    13,    87,    89,   135,   135,     7,    33,   128,
     124,    30,    31,   121,     7,    14,    23,   115,    21,    22,
     116,     4,     5,   117,    18,    19,    24,    25,   118,    26,
      27,   119,    17,    28,    29,   112,   120,   135,   143,    64,
     144,   138,    33,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,   139,   140,   141,   138,
     138,   136,    33,    17,    98,   143,   100,   143,    33,    95,
      32,    33,    37,    96,    97,   102,   143,    33,    33,   104,
     138,    95,   106,   138,   108,   109,   110,   126,    87,    64,
      79,    85,    17,    49,    93,    94,    87,    94,    90,    16,
      90,    10,   136,   125,    10,   136,   137,   131,   127,   129,
     130,   131,   132,   134,   133,   144,   129,    65,   142,   140,
       7,    62,   145,    10,    33,   144,   144,     7,    33,    22,
      17,    17,    32,    96,   144,    10,    22,    28,   109,   143,
      73,    74,    75,    76,    77,    95,    97,    32,    87,    94,
      90,    90,    90,    87,    93,    94,    10,    10,    11,    15,
     142,    22,   123,   145,   137,    33,    34,   138,    99,   142,
     142,    95,    32,    32,    32,   138,   126,   144,    33,    33,
      95,    95,    97,    12,    12,     7,    22,    32,    90,    90,
      90,    87,    94,    90,   136,   145,   129,    15,   138,    10,
     138,   138,    17,    17,    10,    10,   142,    12,    12,    12,
      12,    12,    34,    34,    32,    32,    16,    78,    90,    90,
     138,    95,    32,   138,    34,    34,    34,    34,    34,    13,
      13,    10,    12,    32,    32,    10,    10,    13,    13,    13,
      13,    13,    32,    34,    12,    12,   143,    12,    13,    34,
      34,   144,    34,    13,    13,   142,    13,   138
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
     111,   111,   111,   111,   111,   111,   112,   113,   113,   113,
     114,   114,   114,   114,   115,   116,   116,   117,   117,   118,
     118,   118,   118,   119,   119,   120,   120,   121,   121,   122,
     122,   122,   123,   123,   123,   123,   123,   123,   123,   124,
     124,   124,   124,   125,   125,   126,   126,   127,   127,   127,
     127,   128,   128,   129,   129,   130,   130,   131,   131,   132,
     132,   133,   133,   134,   134,   135,   135,   136,   136,   137,
     137,   138,   138,   139,   139,   140,   140,   141,   141,   141,
     141,   141,   141,   141,   141,   141,   141,   141,   141,   141,
     141,   142,   142,   143,   143,   144,   144,   144,   145,   145,
     145
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
       3,     4,     2,     1,     2,     1,     3,     1,     4,     3,
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
  "anova_error_expression", "anova_term_list", "type_operator",
  "assignment_operator", "unary_operator", "unary_factor_operator",
  "power_operator", "multiplication_operator", "additive_operator",
  "relational_operator", "equality_operator", "logical_operator",
  "cross_operator", "format_spec", "literal_expression",
  "primary_expression", "unary_factor_expression", "cross_expression",
  "postfix_expression", "power_expression", "unary_expression",
  "multiplication_expression", "additive_expression",
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
       0,   173,   173,   186,   205,   214,   226,   227,   228,   229,
     230,   244,   252,   260,   268,   276,   284,   292,   303,   314,
     327,   338,   352,   353,   357,   368,   375,   383,   387,   393,
     402,   403,   405,   411,   420,   429,   440,   448,   456,   464,
     472,   481,   490,   500,   513,   519,   528,   535,   542,   552,
     564,   576,   589,   595,   603,   626,   653,   681,   693,   735,
     747,   790,   811,   823,   845,   867,   873,   881,   882,   886,
     892,   901,   902,   930,   936,   944,   967,   973,   982,   983,
    1003,  1026,  1049,  1055,  1064,  1076,  1090,  1107,  1113,  1122,
    1123,  1124,  1142,  1148,  1157,  1158,  1172,  1173,  1186,  1192,
    1208,  1209,  1210,  1211,  1212,  1213,  1217,  1221,  1222,  1223,
    1227,  1228,  1229,  1230,  1234,  1238,  1239,  1243,  1244,  1248,
    1249,  1250,  1251,  1255,  1256,  1260,  1261,  1265,  1266,  1270,
    1271,  1272,  1276,  1277,  1278,  1279,  1280,  1281,  1282,  1286,
    1290,  1294,  1302,  1316,  1317,  1326,  1327,  1338,  1339,  1348,
    1356,  1368,  1369,  1380,  1381,  1391,  1392,  1403,  1404,  1415,
    1416,  1427,  1428,  1439,  1440,  1451,  1452,  1463,  1469,  1477,
    1483,  1498,  1502,  1509,  1515,  1523,  1530,  1543,  1544,  1545,
    1546,  1547,  1548,  1549,  1550,  1551,  1552,  1553,  1554,  1555,
    1556,  1566,  1570,  1584,  1588,  1604,  1608,  1618,  1634,  1638,
    1645
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
#line 4316 "ado.tab.cpp"

#line 1654 "ado.ypp"


