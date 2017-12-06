%{
	#include <string>
%}

ESPACO		[ \t]
LETRAS		[A-Za-z]
DIGITO		[0-9]
OP			[+\-\*\/]

DELIM		{ESPACO}+
INT			([1-9]{DIGITO}*|0)
FLOAT 		{DIGITO}+[.]{DIGITO}+

CHAR   		['\'']{LETRAS}['\'']
ID 			[a-z]([0-9]|[a-zA-Z])*
STRING 		\"([^\"\n]|\\\")*\"


%%

"\n"		{}

{DELIM}		{}

"main"		{	return TK_MAIN;		}

"int"		{	return TK_TIPO_INT;		}
"float"		{	return TK_TIPO_FLOAT;	}
"char"		{	return TK_TIPO_CHAR;	}
"boolean"	{	return TK_TIPO_BOOL;	}
"float("	{ 	return TK_CAST_FLOAT; 	}
"int("		{ 	return TK_CAST_INT; 	}
"true"		{ yylval.label = yytext; yylval.tipo = "boolean"; return TK_BOOL;	 }
"false" 	{ yylval.label = yytext; yylval.tipo = "boolean"; return TK_BOOL;	 }


[(){}[\];,]	{ return *yytext; }

[+]			{  return TK_SOMA; }
[-]			{  return TK_SUB;  }
[*]			{  return TK_MULT; }
[/]			{  return TK_DIV;  }

"or"		{ return TK_OR;			 }
"and" 		{ return TK_AND;		 }
"&"			{ return TK_AND_LOG;	 }
"|"			{ return TK_OR_LOG;		 }

"if"		{yylval.label = yytext; return TK_IF;			 }
"do"		{yylval.label = yytext; return TK_DO;			 }
"for"		{yylval.label = yytext; return TK_FOR;			 }
"while"		{yylval.label = yytext; return TK_WHILE;		 }
"break"		{ return TK_BREAK;		 }
"continue"	{ return TK_CONTINUE;	 }

"show" 		{ return TK_SHOW;	}

{INT}		{ yylval.label = yytext; yylval.tipo = "int"; 	  return TK_INT; 	 }
{FLOAT}		{ yylval.label = yytext; yylval.tipo = "float";	  return TK_FLOAT; 	 }
{ID} 		{ yylval.label = yytext; yylval.tipo = "id";  	  return TK_ID;		 }
{CHAR}		{ yylval.label = yytext; yylval.tipo = "char"; 	  return TK_CHAR;  	 }
{STRING}	{ yylval.label = yytext; yylval.tipo = "string";  return TK_STR; 	 }


"="			{ return *yytext;			 					 }
"<"			{ yylval.label = yytext; return TK_REL; 		 }
">"			{ yylval.label = yytext; return TK_REL; 		 }
"=="		{ yylval.label = yytext; return TK_REL;			 }
"<="		{ yylval.label = yytext; return TK_REL;			 }
">="		{ yylval.label = yytext; return TK_REL;			 }

"++"		{ yylval.label = yytext; yylval.valor = "+"; return TK_UNITARIO; }
"--"		{ yylval.label = yytext; yylval.valor = "-"; return TK_UNITARIO; }

%%