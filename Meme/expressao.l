%{
	#include <string>
%}

ESPACO		[ \t]
LETRAS		[A-Za-z]
DIGITO		[0-9]
OP			[+\-\*\/]

DELIM		{ESPACO}+
INTEIRO		[1-9]{DIGITO}*
FLOAT 		{DIGITO}+[.]{DIGITO}+
BOOLEAN		["true" | "false"]
ID 			[a-z]([0-9]|[a-zA-Z])*

%%

"\n"		{}

{DELIM}		{}

"main"		{	return TK_MAIN;		}

"int"		{	return TK_TIPO_INT;	}

[(){}[\];,]	{ return *yytext; }

[+]			{  return TK_SOMA; }
[-]			{  return TK_SUB;  }
[*]			{  return TK_MULT; }
[/]			{  return TK_DIV;  }

{INTEIRO}	{ yylval.valor = yytext; yylval.tipo = "int"; 	  return TK_INT; 	 }
{FLOAT}		{ yylval.valor = yytext; yylval.tipo = "float";	  return TK_FLOAT; 	 }
{LETRAS}	{ yylval.valor = yytext; yylval.tipo = "char"; 	  return TK_CHAR;  	 }
{BOOLEAN}	{ yylval.valor = yytext; yylval.tipo = "boolean"; return TK_BOOL;	 }
{ID} 		{ yylval.label = yytext; return TK_ID; 								 }

"<"			{ return TK_MENOR; 		 }
">"			{ return TK_MAIOR; 		 }
"=="		{ return TK_IGUAL_IGUAL; }
"<="		{ return TK_MENOR_IGUAL; }
">="		{ return TK_MAIOR_IGUAL; }
"or"		{ return TK_OR;			 }
"and" 		{ return TK_AND;		 }
"&&"		{ return TK_AND_LOG;	 }
"||"		{ return TK_OR_LOG;		 }


%%