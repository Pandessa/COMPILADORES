%{
#include <iostream>
#include <string>
#include <sstream>
#include <stdio.h>
#include "matriz.cpp"

#define YYSTYPE atributos

using namespace std;

struct atributos
{
	string label;
	string traducao;
	string tipo;
	string valor;
	string lock;
};

Matriz meuMapa;

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

%token TK_MAIN TK_ID 

%token TK_TIPO_FLOAT TK_TIPO_CHAR TK_TIPO_INT TK_TIPO_BOOL

%token TK_INT TK_FLOAT TK_CHAR TK_BOOL

%token TK_SOMA TK_SUB TK_DIV TK_MULT

%token TK_MAIOR TK_MENOR TK_MAIOR_IGUAL TK_MENOR_IGUAL

%token TK_DIFERENTE TK_IGUAL_IGUAL TK_SUPER_IGUAL

%token TK_AND TK_OR TK_AND_LOG TK_OR_LOG

%token TK_CAST_FLOAT TK_CAST_INT

%start S

// ordem de precedencia 

%right '='
%left TK_OR
%left TK_AND
%left TK_OR_LOG TK_AND_LOG
%nonassoc TK_IGUAL_IGUAL TK_DIFERENTE
%nonassoc TK_MENOR TK_MAIOR TK_MAIOR_IGUAL TK_MENOR_IGUAL

%left TK_INT
%left TK_SOMA TK_SUB

%left TK_MULT TK_DIV
%left TK_MOD
%left '('

%nonassoc IF
%nonassoc TK_ELS

%%

S 			: TK_TIPO_INT TK_MAIN '(' ')' BLOCO
			{
				/*
				string* retorno = meuMapa.recuperaVariavel("a");

				for(int aux = 0; aux < 5; aux++){

					cout << retorno[aux] + "\n";
				}
				*/
				
				cout << "/*Compilador FOCA*/\n" << "#include <iostream>\n#include <string.h>\n#include <stdio.h>\nint main(void)\n{\n";

				for (int i = 0; i < meuMapa.numVar; i++)
				{
					if(meuMapa.mapaVar[i][2] == "boolean")
					{
						cout << "\tint " <<  meuMapa.mapaVar[i][1] << ";\n";
					}
					else
					{
						cout << "\t" << meuMapa.mapaVar[i][2] << " " << meuMapa.mapaVar[i][1] << ";\n";	
					}
					

				}

				cout << "\n" << $5.traducao << "\treturn 0;\n}" << endl;

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

					/* SE DER ERRADO, PODE SER POR CAUSA DESSA LINHA. MAS ACHO QUE NÃO */

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");

					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + aux + ";\n";

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		 = $$.label;

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");

					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " + " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				}

				else
				{
					yyerror("Variáveis inválidas.\n");
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

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");


					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + aux + ";\n";

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux			 = $$.label;

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");

					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " * " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
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

					/* ALTEREI AQUI TAMBÉM  08-10 DE MADRUGADA */

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $3.lock);

					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + aux + ";\n";

					/* ALTEREI AQUI TAMBÉM  08-10 DE MADRUGADA - REPLICANDO NA SOMA, SUB E MULT */

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $3.lock);
				}

				else if ($1.tipo == "int" && $3.tipo == "float")
				{
					$$.tipo  	= "float";
					$$.label 	= converte();
					string aux 	= $1.traducao;

					/* PRIMEIRA ALTERAÇÃO FOI AQUI 08-10 DE MADRUGADA */
					$1.traducao = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		= $$.label;

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);

					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + aux + ";\n";

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{
					$$.tipo 	= "float";
					$$.label 	= converte();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}
				else if($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	= "int";
					$$.label 	= converte();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
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

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);

					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + aux + ";\n";

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		 = $$.label;

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $3.lock);

					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " - " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $3.lock);
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + $3.label + ";\n";

					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
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

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " < " + $3.label + ";\n";

				/* REPLICANDO EM TODOS OS RELACIONAIS */

				meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);

			}

			| E TK_MAIOR E
			{
				$$.tipo 	= "boolean";
				$$.label	= converte();

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " > " + $3.label + ";\n"; 
				
				meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
			}
			
			| E TK_IGUAL_IGUAL E
			{
				$$.tipo 	= "boolean";
				$$.label 	= converte();


				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " == " + $3.label + ";\n"; 
				
				meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);

			}
			
			| E TK_MENOR_IGUAL E
			{
				$$.tipo 	= "boolean";
				$$.label 	= converte();

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " <= " + $3.label + ";\n";
				
				meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
			}
			

			| E TK_MAIOR_IGUAL E
			{
				$$.tipo 	= "boolean";
				$$.label 	= converte();

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " >= " + $3.label + ";\n";
				
				meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
			}

			/* OPERADORES LÓGICOS */

			| E TK_OR E
			{
				$$.tipo  = "boolean";
				$$.label = converte();

				if($1.tipo == "boolean" && $3.tipo == "boolean")
				{
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " || " + $3.label + ";\n";

					/* ALTEREI AQUI 08-10 DE MADRUGADA - (REPLICANDO EM TODOS OS LÓGICOS) */
					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}

				else
				{
					yyerror("O que que tá acontecendo?\n");
				}
				
			}
			| E TK_AND E 
			{ 
				$$.tipo  = "boolean";
				$$.label = converte();

				if($1.tipo == "boolean" && $3.tipo == "boolean")
				{
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " && " + $3.label + ";\n";
					
					meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}

				else
				{
					yyerror("O que que tá acontecendo?\n");
				}
				
			}
			| E TK_AND_LOG E
			{
				$$.label 	= converte();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " & " + $3.label + ";\n";

				meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
			}
			| E TK_OR_LOG E 
			{
				$$.label 	= converte();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " | " + $3.label + ";\n";

				meuMapa.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
			}

			/* DECLARAÇÃO DE VARIÁVEIS EXPLÍCITA */

			| TK_TIPO_INT TK_ID '=' TK_INT
			{

				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $4.label + ";\n";
				$$.tipo 	 = $4.tipo;

				meuMapa.adicionaVariavel($2.label,$$.label,$4.tipo,$4.label,"True");
			}

			| TK_TIPO_FLOAT TK_ID '=' TK_FLOAT
			{
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $4.label + ";\n";
				$$.tipo 	 = $4.tipo;

				meuMapa.adicionaVariavel($2.label,$$.label,$4.tipo,$4.label,"True");
			}

			| TK_TIPO_CHAR TK_ID '=' TK_CHAR 
			{		
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $4.label + ";\n";
				$$.tipo 	 = $4.tipo;

				meuMapa.adicionaVariavel($2.label,$$.label,$4.tipo,$4.label,"True");
			}

			| TK_TIPO_BOOL TK_ID '=' TK_BOOL
			{
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $4.label + ";\n";
				$$.tipo 	 = $4.tipo;

				meuMapa.adicionaVariavel($2.label,$$.label,$4.tipo,$4.label,"True");
			}

			/* INFERÊNCIA DE TIPO */

			| TK_ID '=' E
			{			
				string* atributos = meuMapa.recuperaVariavel($1.label);				
				
				if(atributos == NULL)
				{

					$$.label 	= converte();
					$$.traducao = $3.traducao + "\t" + $$.label + " = " + $3.label + ";\n";
					$$.tipo 	= $3.tipo;	

					meuMapa.adicionaVariavel($1.label,$$.label,$3.tipo,$3.label,"False");
				}
				/* VERIFICADO */
				else
				{
					int posicao = atoi(atributos[5].c_str());

					if(atributos[2] == $3.tipo)
					{	
						$$.label = atributos[1];	
						$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";				
						meuMapa.mapaVar[posicao][3] = $3.label;
					}
					else if(atributos[4] == "False")
					{
						/* atualiza a variavel na matriz - atributos[5] e a posicao da variavel na matriz */
						$$.label = converte();

						/* ALTEREI AQUI */

						$$.traducao  = $3.traducao + "\t" + $$.label + " = " + $3.label + ";\n";
						meuMapa.adicionaVariavel(atributos[0],$$.label,$3.tipo,$3.label,"False");
					}
					else
					{
						yyerror("Apenas pare!\n");
					}				
				}
				
			}

			| TK_ID '=' TK_CHAR
			{			
				string* atributos = meuMapa.recuperaVariavel($1.label);				
			
				if(atributos == NULL)
				{

					$$.label = converte();
					$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";
					$$.tipo = $3.tipo;	

					meuMapa.adicionaVariavel($1.label,$$.label,$3.tipo,$3.label,"False");
				}
				else
				{
					int posicao = atoi(atributos[5].c_str());

					if(atributos[2] == $3.tipo)
					{	
						$$.label = atributos[1];
						$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";

						meuMapa.mapaVar[posicao][3] = $3.label;
					}
					else if(atributos[4] == "False")
					{
						// atualiza a variavel na matriz - atributos[5] e a posicao da variavel na matriz
						$$.label = converte();
						$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";


						meuMapa.adicionaVariavel(atributos[0],$$.label,$3.tipo,$3.label,"False");
					}
					else
					{
						yyerror("Apenas pare!\n");
					}

				}
				
			}

			| TK_ID '=' TK_INT
			{			
				string* atributos = meuMapa.recuperaVariavel($1.label);				
			
				if(atributos == NULL)
				{

					$$.label = converte();
					$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";
					$$.tipo = $3.tipo;	

					meuMapa.adicionaVariavel($1.label,$$.label,$3.tipo,$3.label,"False");
				}
				else
				{
					int posicao = atoi(atributos[5].c_str());

					if(atributos[2] == $3.tipo)
					{	
						$$.label = atributos[1];	
						$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";


						meuMapa.mapaVar[posicao][3] = $3.label;
					}
					else if(atributos[4] == "False")
					{
						// atualiza a variavel na matriz - atributos[5] e a posicao da variavel na matriz
						$$.label = converte();
						$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";


						meuMapa.adicionaVariavel(atributos[0],$$.label,$3.tipo,$3.label,"False");
					}
					else
					{
						yyerror("Apenas pare!\n");
					}

				}
				
			}


			| TK_ID '=' TK_FLOAT
			{

				string* atributos = meuMapa.recuperaVariavel($1.label);				

				if(atributos == NULL)
				{		
					$$.label = converte();
					$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";
					$$.tipo = $3.tipo;	

					meuMapa.adicionaVariavel($1.label,$$.label,$3.tipo,$3.label,"False");
				}
				else
				{
					int posicao = atoi(atributos[5].c_str());

					if(atributos[2] == $3.tipo)
					{	
						$$.label = atributos[1];
						$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";


						meuMapa.mapaVar[posicao][3] = $3.label;
					}
					else if(atributos[4] == "False")
					{
						// atualiza a variavel na matriz - atributos[5] e a posicao da variavel na matriz
						$$.label = converte();
						$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";


						meuMapa.adicionaVariavel(atributos[0],$$.label,$3.tipo,$3.label,"False");
					}
					else
					{
						yyerror("Apenas pare!\n");
					}
					
				}

			}
			
			| TK_ID '=' TK_BOOL
			{			
				string* atributos = meuMapa.recuperaVariavel($1.label);		
				string aux; // O QUE ESSE AUX TÁ FAZENDO AQUI? 
				
				if(atributos == NULL)
				{

					$$.label 	= converte();
					$$.tipo 	= $3.tipo;
					$$.traducao = $3.traducao + "\t" + $$.label + " = " + aux + ";\n";
					

					meuMapa.adicionaVariavel($1.label,$$.label,$3.tipo,aux,"False");
				}
				else
				{
					int posicao = atoi(atributos[5].c_str());

					if(atributos[2] == $3.tipo)
					{	
						$$.label = atributos[1];
						$$.traducao = $3.traducao + "\t" + $$.label + " = " + aux + ";\n";					
						meuMapa.mapaVar[posicao][3] = aux;
					}
					else if(atributos[4] == "False")
					{
						// atualiza a variavel na matriz - atributos[5] e a posicao da variavel na matriz
						$$.label = converte();
						$$.traducao  = "\t" + $$.label + " = " + $3.label + ";\n";


						meuMapa.adicionaVariavel(atributos[0],$$.label,$3.tipo,aux,"False");
					}
					else
					{
						yyerror("Apenas pare!\n");
					}				
				}
				
			}
			
			
			|'(' E ')'
			{
				$$.label 	= $2.label;
				$$.tipo 	= $2.tipo;
				$$.traducao = $2.traducao;
			}			

			/* CAST CONVERSÃO EXPLÍCITA 
			 * VER COMO VAI ADICIONAR ESSA PARTE NO MAPA */

			| TK_ID '=' TK_CAST_FLOAT TK_INT ')'
			{				
				
				$$.label 	= converte();
				$$.tipo  	= "float";
				$$.traducao =  $$.traducao + "\t" + $$.label + " = " + "(float)" + $4.label + ";\n"; 
				
			}

			| TK_ID '=' TK_CAST_INT TK_FLOAT ')'
			{				
				
				$$.label 	= converte();
				$$.tipo  	= "int";
				$$.traducao =  $$.traducao + "\t" + $$.label + " = " + "(int)" + $4.label + ";\n"; 
			
			}
			| TK_ID '=' TK_CAST_INT TK_CHAR ')'
			{				
			
				$$.label 	= converte();
				$$.tipo  	= "int";
				$$.traducao =  $$.traducao + "\t" + $$.label + " = " + "(int)" + $4.label + ";\n"; 
			
			}


			/* TIPOS PRIMITIVOS */

			| TK_INT
			{
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo 	 = $1.tipo;

				meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
			}
			
			| TK_FLOAT
			{
				$$.label 	= converte();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo 	= $1.tipo;

				meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
			}
			| TK_CHAR
			{

				
				$$.label 	= converte();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo 	= $1.tipo;

				meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
			}
			| TK_BOOL
			{
				/* ACHO QUE TEM QUE VERIFICAR SE A LABEL DELE É TRUE OU FALSE PRA PODER COLOCAR 0 OU 1
				 * JÁ QUE O C SÓ ACEITA INTEIROS */

				$$.label 	= converte();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo 	= $1.tipo;

				meuMapa.adicionaVariavel("",$$.label,$$.tipo,"","False");
			}

			
			| TK_ID
			{  				
				string* atributos = meuMapa.recuperaVariavel($1.label);

				if(atributos == NULL)
				{
					string mensagem = "Variável " + $1.label + " não declarada!";
					yyerror(mensagem);
				}
				else
				{
					$$.label = atributos[1];
				}
				
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
