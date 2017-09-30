%{
#include <iostream>
#include <string>
#include <sstream>

#define YYSTYPE atributos

using namespace std;

struct atributos
{
	string label;
	string traducao;
	string tipo;
	string valor;
	bool lock;
};

string **matriz;
int numVar = 0;
int numCol = 4;

int  yylex(void);
void yyerror(string);

int qtd = 0;

string converte()
{
	stringstream ss;
	ss << qtd;
	string str = ss.str();
	qtd++;

	return "TEMP"+str;
}

%}

// tokens definidos

%token TK_FIM TK_ERROR

%token TK_MAIN TK_ID TK_TIPO_INT 

%token TK_INT TK_FLOAT TK_CHAR TK_BOOL

%token TK_SOMA TK_SUB TK_DIV TK_MULT

%token TK_MAIOR TK_MENOR TK_MAIOR_IGUAL TK_MENOR_IGUAL

%token TK_DIFERENTE TK_IGUAL_IGUAL TK_SUPER_IGUAL

%start S

// ordem de precedencia 

%left TK_OR
%left TK_AND
%left TK_OR_LOG TK_AND_LOG
%nonassoc TK_IGUAL_IGUAL TK_DIFERENTE
%nonassoc TK_MENOR TK_MAIOR TK_MAIOR_IGUAL TK_MENOR_IGUAL


%left TK_SOMA TK_SUB
%left TK_MULT TK_DIV
%left TK_MOD
%left '('

%nonassoc IF
%nonassoc TK_ELSE


%%

S 			: TK_TIPO_INT TK_MAIN '(' ')' BLOCO
			{
				cout << "/*Compilador FOCA*/\n" << "#include <iostream>\n#include<string.h>\n#include<stdio.h>\nint main(void)\n{\n" << $5.traducao << "\treturn 0;\n}" << endl; 
			}
			;

BLOCO		: '{' COMANDOS '}'
			{
				$$.traducao = $2.traducao;
			}
			;

COMANDOS	: COMANDO COMANDOS
			{		
				$$.traducao = $1.traducao + $2.traducao;
			}
			|
			;

COMANDO 	: E ';'
			;

			/* OPERADORES ARITMÉTICOS */

E 			: E TK_SOMA E
			{
				if($1.tipo == "float" && $3.tipo == "int")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux   = $3.traducao;
					$3.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $3.label + ";\n";
					aux 		 = $$.label;
					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + aux + ";\n";
				
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		 = $$.label;
					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " + " + $3.label + ";\n";
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + $3.label + ";\n";
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + $3.label + ";\n";
				}

				else
				{
					yyerror("O que você tá tentando fazer?\n");
				}			
			}
			| E TK_MULT E
			{
				if($1.tipo == "float" && $3.tipo == "int")
				{
					$$.tipo  	= "float";
					$$.label 	= converte();
					string aux 	= $3.traducao;
					$3.traducao = aux + "\t" + $$.label + " = " + "(float)" + $3.label + ";\n";
					aux 		= $$.label;
					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + aux + ";\n";
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux			 = $$.label;
					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " * " + $3.label + ";\n";
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";
				}
				else
				{
					yyerror("O que você tá tentando fazer?\n");
				}					

			}
			| E TK_DIV E
			{
				if($1.tipo == "float" && $3.tipo == "int")
				{
					$$.tipo  	= "float";
					$$.label 	= converte();
					string aux 	= $3.traducao;
					$3.traducao = aux + "\t" + $$.label + " = " + "(float)" + $3.label + ";\n";
					aux 		= $$.label;
					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + aux + ";\n";
				}

				else if ($1.tipo == "int" && $3.tipo == "float")
				{
					$$.tipo  	= "float";
					$$.label 	= converte();
					string aux 	= $3.traducao;
					$1.traducao = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		= $$.label;
					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + aux + ";\n";
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{
					$$.tipo 	= "float";
					$$.label 	= converte();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";
				}
				else if($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	= "int";
					$$.label 	= converte();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";
				}
				else
				{
					yyerror("O que você tá tentando fazer?\n");
				}	
				 
			}
			| E TK_SUB E
			{
				if($1.tipo == "float" && $3.tipo == "int")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux   = $3.traducao;
					$3.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $3.label + ";\n";
					aux 		 = $$.label;
					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + aux + ";\n";
				
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		 = $$.label;
					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " - " + $3.label + ";\n";
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + $3.label + ";\n";
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + $3.label + ";\n";
				}
				else
				{
					yyerror("O que você tá tentando fazer?\n");
				}					
				 
			}

			/* OPERADORES RELACIONAIS */
			
			| E TK_MENOR E
			{
				$$.tipo 	= "boolean";
				$$.label 	= converte();

				if($1.valor < $3.valor)
				{
					$$.valor = "1";
				}

				else
				{
					$$.valor = "0";
				}

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " < " + $3.label + ";\n"; 
				//+ "\t" + $$.label + " = " + $$.valor + ";\n";

			}

			| E TK_MAIOR E
			{
				$$.tipo 	= "boolean";
				$$.label	= converte();

				if($1.valor > $3.valor)
				{
					$$.valor = "1";
				}
				else
				{
					$$.valor = "0";
				}

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " > " + $3.label + ";\n"; 
				//+ "\t" + $$.label + " = " + $$.valor + ";\n";
			}
			
			| E TK_IGUAL_IGUAL E
			{
				$$.tipo 	= "boolean";
				$$.label 	= converte();

				if($1.valor == $3.valor)
				{
					$$.valor = "1";

				}
				else
				{
					$$.valor = "0";
				}

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.valor + " == " + $3.valor + ";\n"; 
				//+ "\t" + $$.label + " = " + $$.valor + ";\n";

			}
			
			| E TK_MENOR_IGUAL E
			{
				$$.tipo 	= "boolean";
				$$.label 	= converte();

				if($1.valor <= $3.valor)
				{
					$$.valor = "1";

				}
				else
				{
					$$.valor = "0";
				}

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " <= " + $3.label + ";\n";
				//+ "\t" + $$.label + " = " + $$.valor + ";\n";
			}
			

			| E TK_MAIOR_IGUAL E
			{
				$$.tipo 	= "boolean";
				$$.label 	= converte();

				if($1.valor >= $3.valor)
				{
					$$.valor = "1";

				}else
				{
					$$.valor = "0";
				}

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " >= " + $3.label + ";\n";
				//+ "\t" + $$.label + " = " + $$.valor + ";\n";
			}
			/* OPERADORES LÓGICOS */

			| E TK_OR E
			{
				$$.tipo  = "boolean";
				$$.label = converte();

				if($1.valor == "1" || $3.valor == "1")
				{
					$$.valor = "1";
				}

				else
				{
					$$.valor = "0";
				}

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " or " + $3.label + ";\n"
				+ "\t" + $$.label + " = " + $$.valor + ";\n";
			}
			| E TK_AND E 
			{
				$$.tipo  = "boolean";
				$$.label = converte();

				if($1.valor == "1" && $3.valor == "1")
				{
					$$.valor = "1";
				}

				else
				{
					$$.valor = "0";
				}

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " and " + $3.label + ";\n";
				//+ "\t" + $$.label + " = " + $$.valor + ";\n";
			}
			
			|'(' E ')'
			{
				$$.label 	= $2.label;
				$$.tipo 	= $2.tipo;
				$$.traducao = $2.traducao;
			}
			
			/* TIPOS PRIMITIVOS */

			| TK_INT
			{
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $1.valor + ";\n";
				$$.tipo 	 = $1.tipo;
				$$.valor 	 = $1.valor;
				
			}
			
			| TK_FLOAT
			{
				$$.label 	= converte();
				$$.traducao = "\t" + $$.label + " = " + $1.valor + ";\n";
				$$.tipo 	= $1.tipo;
				$$.valor 	= $1.valor;
			}
			| TK_CHAR
			{
				$$.label 	= converte();
				$$.traducao = "\t" + $$.label + " = " + $1.valor + ";\n";
				$$.tipo 	= $1.tipo;
				$$.valor 	= $1.valor;
			}

			| TK_ID
			{

				cout << "entrei";  
				$$.label 	= $1.label;
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
			}
			;


%%

#include "lex.yy.c"

int yyparse();

int main( int argc, char* argv[] )
{
	yyparse();

	return 0;
}

void yyerror( string MSG )
{
	cout << MSG << endl;
	exit (0);
}				
