/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TK_FIM = 258,
    TK_ERROR = 259,
    TK_MAIN = 260,
    TK_ID = 261,
    TK_TIPO_FLOAT = 262,
    TK_TIPO_CHAR = 263,
    TK_TIPO_INT = 264,
    TK_TIPO_BOOL = 265,
    TK_STR = 266,
    TK_INT = 267,
    TK_FLOAT = 268,
    TK_CHAR = 269,
    TK_BOOL = 270,
    TK_SOMA = 271,
    TK_SUB = 272,
    TK_DIV = 273,
    TK_MULT = 274,
    TK_REL = 275,
    TK_UNITARIO = 276,
    TK_DIFERENTE = 277,
    TK_IGUAL_IGUAL = 278,
    TK_SUPER_IGUAL = 279,
    TK_AND = 280,
    TK_OR = 281,
    TK_AND_LOG = 282,
    TK_OR_LOG = 283,
    TK_CAST_FLOAT = 284,
    TK_CAST_INT = 285,
    TK_SHOW = 286,
    TK_IF = 287,
    TK_FOR = 288,
    TK_WHILE = 289,
    TK_DO = 290,
    TK_BREAK = 291,
    TK_CONTINUE = 292,
    TK_MENOR = 293,
    TK_MAIOR = 294,
    TK_MAIOR_IGUAL = 295,
    TK_MENOR_IGUAL = 296,
    TK_MOD = 297,
    IF = 298,
    TK_ELS = 299
  };
#endif
/* Tokens.  */
#define TK_FIM 258
#define TK_ERROR 259
#define TK_MAIN 260
#define TK_ID 261
#define TK_TIPO_FLOAT 262
#define TK_TIPO_CHAR 263
#define TK_TIPO_INT 264
#define TK_TIPO_BOOL 265
#define TK_STR 266
#define TK_INT 267
#define TK_FLOAT 268
#define TK_CHAR 269
#define TK_BOOL 270
#define TK_SOMA 271
#define TK_SUB 272
#define TK_DIV 273
#define TK_MULT 274
#define TK_REL 275
#define TK_UNITARIO 276
#define TK_DIFERENTE 277
#define TK_IGUAL_IGUAL 278
#define TK_SUPER_IGUAL 279
#define TK_AND 280
#define TK_OR 281
#define TK_AND_LOG 282
#define TK_OR_LOG 283
#define TK_CAST_FLOAT 284
#define TK_CAST_INT 285
#define TK_SHOW 286
#define TK_IF 287
#define TK_FOR 288
#define TK_WHILE 289
#define TK_DO 290
#define TK_BREAK 291
#define TK_CONTINUE 292
#define TK_MENOR 293
#define TK_MAIOR 294
#define TK_MAIOR_IGUAL 295
#define TK_MENOR_IGUAL 296
#define TK_MOD 297
#define IF 298
#define TK_ELS 299

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
