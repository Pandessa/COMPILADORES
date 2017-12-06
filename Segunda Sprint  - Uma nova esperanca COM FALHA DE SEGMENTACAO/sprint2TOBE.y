%{
#include <iostream>
#include <string>
#include <sstream>
#include <cstring>
#include <stdio.h>
#include "pilha.cpp"

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

Pilha pilha;

int  yylex(void);
void yyerror(string);

int qtd = 0;
int qtdLab = 0;

string converte()
{
	stringstream ss;
	ss << qtd;
	string str = ss.str();
	qtd++;

	return "TEMP"+str;
}

string* criaLabel()
{
	string* retorno = new string[2];
	stringstream ss;
	ss << qtdLab;
	string str = ss.str();
	qtdLab++;

	retorno[0] = "Loop"+str;
	retorno[1] = "FimLoop"+str;
	//retorno[2] = tipo;

	return retorno;
	
}

%}

// tokens definidos

%token TK_FIM TK_ERROR

%token TK_MAIN TK_ID 

%token TK_TIPO_FLOAT TK_TIPO_CHAR TK_TIPO_INT TK_TIPO_BOOL TK_STR

%token TK_INT TK_FLOAT TK_CHAR TK_BOOL

%token TK_SOMA TK_SUB TK_DIV TK_MULT

%token TK_REL TK_UNITARIO

%token TK_DIFERENTE TK_IGUAL_IGUAL TK_SUPER_IGUAL

%token TK_AND TK_OR TK_AND_LOG TK_OR_LOG

%token TK_CAST_FLOAT TK_CAST_INT

%token TK_SHOW

%token TK_IF TK_FOR TK_WHILE TK_DO

%token TK_BREAK TK_CONTINUE

%start S

// ordem de precedencia 

%right '='
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
%nonassoc TK_ELS

%%

S 			: TK_TIPO_INT TK_MAIN '(' ')' BLOCO
			{
				/*
				string* retorno = pilha.recuperaVariavel("a");

				for(int aux = 0; aux < 5; aux++){

					cout << retorno[aux] + "\n";
				}
				*/

				
				
				cout << "/* Compilador MEME */\n" << "#include <iostream>\n#include <string.h>\n#include <stdio.h>\n#include <stdlib.h>\nusing namespace std;\nint main(void)\n{\n";

				/*for(int j = pilha.mapa.size()-1; j >= 0; j--)
				{
					for (int i = 0; i < pilha.mapa[j].numVar; i++)
					{
						if(pilha.mapa[j].variaveis[i][2] == "boolean")
						{
							cout << "\tint " <<  pilha.mapa[j].variaveis[i][1] << ";\n";
						}
						else
						{
							cout << "\t" << pilha.mapa[j].variaveis[i][2] << " " << pilha.mapa[j].variaveis[i][1] << ";\n";	
						}
						

					}
				}*/

				for (int i = 0; i < pilha.auxiliar.numVar; i++)
				{
					if(pilha.auxiliar.variaveis[i][2] == "boolean")
					{
						cout << "\tint " <<  pilha.auxiliar.variaveis[i][1] << ";\n";
					}
					else
					{
						cout << "\t" << pilha.auxiliar.variaveis[i][2] << " " << pilha.auxiliar.variaveis[i][1] << ";\n";	
					}
				}

				cout << "\n" << $5.traducao << "\treturn 0;\n}" << endl;

			}
			;

BLOCO		: '{' COMANDOS '}'
			{
				$$.traducao = $2.traducao;
			}
			/*| COMANDO
			{
				$$.traducao = $1.traducao;
			}
			| SUMIDOURO '{' COMANDOS '}'
			{
				$$.traducao = $3.traducao;
			}*/
			;
SUMIDOURO	: /* Vazio */ 
			{
				pilha.empilha();
				string * label1 = criaLabel();
				pilha.guardaLabel(label1);
			}
			;
/*FONTE 		:
			{
				pilha.desempilha();
			}
			;*/
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

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");

					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + aux + ";\n";

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		 = $$.label;

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");

					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " + " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " + " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
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

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");


					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + aux + ";\n";

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux			 = $$.label;

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");

					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " * " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " * " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
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

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $3.lock);

					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + aux + ";\n";

					/* ALTEREI AQUI TAMBÉM  08-10 DE MADRUGADA - REPLICANDO NA SOMA, SUB E MULT */

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $3.lock);
				}

				else if ($1.tipo == "int" && $3.tipo == "float")
				{
					$$.tipo  	= "float";
					$$.label 	= converte();
					string aux 	= $1.traducao;

					/* PRIMEIRA ALTERAÇÃO FOI AQUI 08-10 DE MADRUGADA */
					$1.traducao = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		= $$.label;

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);

					$$.label	= converte();
					$$.traducao	= $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + aux + ";\n";

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{
					$$.tipo 	= "float";
					$$.label 	= converte();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}
				else if($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	= "int";
					$$.label 	= converte();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " / " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
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

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);

					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + aux + ";\n";

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				
				}

				else if($1.tipo == "int" && $3.tipo == "float")
				{

					$$.tipo 	 = "float";
					$$.label 	 = converte();
					string aux 	 = $1.traducao;
					$1.traducao  = aux + "\t" + $$.label + " = " + "(float)" + $1.label + ";\n";
					aux 		 = $$.label;

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $3.lock);

					$$.label 	 = converte();
					$$.traducao  =  $1.traducao + $3.traducao + "\t" + $$.label + " = " + aux + " - " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $3.lock);
				
				}

				else if ($1.tipo == "float" && $3.tipo == "float")
				{	
					$$.tipo 	 = "float";
					$$.label 	 = converte();					
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}

				else if ($1.tipo == "int" && $3.tipo == "int")
				{
					$$.tipo 	 = "int";
					$$.label 	 = converte();
					$$.traducao  = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " - " + $3.label + ";\n";

					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
				}
				else
				{
					yyerror("O que você tá tentando fazer?\n");
				}					
				 
			}

			/* OPERADORES RELACIONAIS */
			
			| E TK_REL E
			{
				$$.tipo 	= "boolean";
				$$.label 	= converte();

				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + $2.label + $3.label + ";\n";

				/* REPLICANDO EM TODOS OS RELACIONAIS */

				pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);

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
					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
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
					
					pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
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

				pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
			}
			| E TK_OR_LOG E 
			{
				$$.label 	= converte();
				$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label +  " = " + $1.label + " | " + $3.label + ";\n";

				pilha.adicionaVariavel("",$$.label, $$.tipo,"", $1.lock);
			}

			/* DECLARAÇÃO DE VARIÁVEIS EXPLÍCITA */

			|TK_TIPO_INT TK_ID
			{
				$$.label = converte();
				pilha.adicionaVariavel($2.label, $$.label, "int", "", "True");
				//$1.traducao = "\tint " + $$.label + ";\n";	
			}

			
			|TK_TIPO_FLOAT TK_ID
			{
				$$.label = converte();
				pilha.adicionaVariavel($2.label, $$.label, "float", "", "True");
				//$1.traducao = "\tfloat " + $$.label + ";\n";	
			}

			|TK_TIPO_CHAR TK_ID
			{
				$$.label = converte();
				pilha.adicionaVariavel($2.label, $$.label, "char", "", "True");
				//$1.traducao = "\tchar " + $$.label + ";\n";	
			}

			|TK_TIPO_BOOL TK_ID
			{
				$$.label = converte();
				pilha.adicionaVariavel($2.label, $$.label, "boolean", "", "True");
				//$1.traducao = "\tint " + $$.label + ";\n";	
			}

			| TK_TIPO_INT TK_ID '=' TK_INT
			{

				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $4.label + ";\n";
				$$.tipo 	 = $4.tipo;
				$$.valor 	 = "id";

				cout << "Tô setany o tipo como id: " << $$.valor << endl;
				pilha.adicionaVariavel($2.label,$$.label,$4.tipo,$4.label,"True");
			}

			| TK_TIPO_FLOAT TK_ID '=' TK_FLOAT
			{
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $4.label + ";\n";
				$$.tipo 	 = $4.tipo;

				pilha.adicionaVariavel($2.label,$$.label,$4.tipo,$4.label,"True");
			}

			| TK_TIPO_CHAR TK_ID '=' TK_CHAR 
			{		
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $4.label + ";\n";
				$$.tipo 	 = $4.tipo;

				pilha.adicionaVariavel($2.label,$$.label,$4.tipo,$4.label,"True");
			}

			| TK_TIPO_BOOL TK_ID '=' TK_BOOL
			{
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $4.label + ";\n";
				$$.tipo 	 = $4.tipo;

				pilha.adicionaVariavel($2.label,$$.label,$4.tipo,$4.label,"True");
			}

			/* INFERÊNCIA DE TIPO */

			| TK_ID '=' E
			{	
				cout << "Entrei no TK_ID = E" << endl;	
				vector<string> atributos;
				atributos = pilha.busca($1.label);							
				
				if(atributos.size() <= 1)
				{

					$$.label 	= converte();
					$$.traducao = $3.traducao + "\t" + $$.label + " = " + $3.label + ";\n";
					$$.tipo 	= $3.tipo;				
					
					pilha.adicionaVariavel($1.label,$$.label,$3.tipo,$3.label,"False");
				}
				/* VERIFICADO */
				else
				{
					int posicao = atoi(atributos[5].c_str());
					int mapaAtual = atoi(atributos[6].c_str());

					if(atributos[2] == $3.tipo)
					{	
						$$.label = atributos[1];	
						$$.traducao  = $3.traducao + "\t" + $$.label + " = " + $3.label + ";\n";				
						pilha.mapa[mapaAtual].variaveis[posicao][3] = $3.label;
					}
					else if(atributos[4] == "False")
					{
						/* atualiza a variavel na matriz - atributos[5] e a posicao da variavel na matriz */
						$$.label = converte();

						/* ALTEREI AQUI */

						pilha.adicionaVariavel(atributos[0],$$.label,$3.tipo,$3.label,"False");
						pilha.mapa[mapaAtual].variaveis[posicao][0] = "";      
						$$.traducao  = $3.traducao + "\t" + $$.label + " = " + $3.label + ";\n";
						

					
					}
					else
					{
						string mensagem = "Atribuição inválida da variavel "+ $1.label + "!\n";
						yyerror(mensagem);
					}				
				}
				
			}

			| TK_ID '=' TK_BOOL
			{			
				vector<string> atributos; 
				atributos = pilha.recuperaVariavel($1.label);		
				string aux;

				if 		($3.label == "true") aux = "1";
				else if ($3.label == "false") aux = "0";
				else 	yyerror("Booleano inválido!");
				
				if(atributos.size() <= 1)
				{
					$$.label 	= converte();
					$$.tipo 	= $3.tipo;
					$$.traducao = $3.traducao + "\t" + $$.label + " = " + aux + ";\n";				
					
					pilha.adicionaVariavel($1.label,$$.label,$3.tipo,aux,"False");
					
				}
				else
				{
					int posicao = atoi(atributos[5].c_str());
					int mapaAtual = atoi(atributos[6].c_str());

					if(atributos[2] == $3.tipo)
					{	
						$$.label = atributos[1];
						$$.traducao = $3.traducao + "\t" + $$.label + " = " + aux + ";\n";					
						pilha.mapa[mapaAtual].variaveis[posicao][3] = aux;
					}
					else if(atributos[4] == "False")
					{
						
						$$.label 	 = converte();
						$$.traducao  = "\t" + $$.label + " = " + aux + ";\n";					
						
						pilha.adicionaVariavel(atributos[0],$$.label,$3.tipo,aux,"False");
						pilha.mapa[mapaAtual].variaveis[posicao][0] = "";
						
					}
					else
					{
						string mensagem = "Atribuição inválida da variavel booleana "+ $1.label + "!\n";
						yyerror(mensagem);
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

			// IF E LOOPS

			| TK_IF '(' E ')' BLOCO
			{				
				if($3.tipo == "boolean")
				{
					$$.traducao = $3.traducao + "\n\tif(" + $3.label + ")" + "\n\t{\n\n" +  $5.traducao + "\t" + "\n\t}\n"  ;
				}
				else
				{
					yyerror("If inválido!!!");
				}								
			}
			
			| SUMIDOURO TK_FOR '('TK_ID '=' TK_INT ';' TK_ID TK_REL TK_INT ';' TK_ID TK_UNITARIO ')' BLOCO
			{	
				cout << "ENTREI NO FOR" << endl;
				
				vector<string> atributos = pilha.recuperaVariavel($3.label);
				string temp = "";
				string * minhaLabel = pilha.recuperaLabel();
				if(atributos.size() <= 1)
				{
					temp = converte();
					pilha.adicionaVariavel($3.label,temp,$3.tipo,"","False");
				}
				else
				{
					temp = atributos[1];
				}
				
				string aux1 = converte();
				string aux2 = converte();		

				$$.traducao = "\n\t" + temp + " = " + $6.label +     			 		   ";\n" +
							  "\t" + aux1 + " = " + $10.label + 	   			 		   	 ";\n\n" +
							  "\t" + minhaLabel[0] + ":" +		   			 		      "\n\n" +
							  "\t" + aux2 + " = " + temp + $9.label + aux1 + 		       ";\n" +							  
							  "\t" + "if( !"+ aux2 + " ) " + "goto " + minhaLabel[1] +     ";\n" + 	
							         $15.traducao +									         +
							  "\t" + temp + " = " + temp + $13.valor + "1" +		     ";\n\n" +
							  "\t" + "goto " + minhaLabel[0] +						     ";\n\n" +
							  "\t" + minhaLabel[1] + ":" +							       " \n" ;

				//pilha.desempilha();
			}
			| SUMIDOURO TK_WHILE '(' E ')' '{' COMANDOS '}'
			{
				if($4.tipo == "boolean")
				{

					//vector<string> atributos = pilha.recuperaVariavel($4.label);
					string *minhaLabel = pilha.recuperaLabel();

					$$.traducao = $4.traducao +"\t" + minhaLabel[0] + ":\n" +
								  "\n\tif(!" + $4.label+ ")" + " goto " + minhaLabel[1] + ";\n\n" +
								  $7.traducao + "\tgoto " + minhaLabel[0] + ";"+ "\n\n\t" + minhaLabel[1] + ":\n";
				}
				else
				{
					yyerror("Tem certeza que seu while está correto?\n");
				}

				pilha.desempilha();
			}
			|  SUMIDOURO TK_DO '{' COMANDOS '}' TK_WHILE '(' E ')'
			{
				//cout << "tipo: " << $7.tipo << endl;
				//vector<string> atributos = pilha.recuperaVariavel($4.label);
				string *label = pilha.recuperaLabel();

				if($8.tipo == "boolean")
				{
					$$.traducao   = "\n\t" + label[0] + ":\n" 
										   + $4.traducao + $8.traducao + "\n\tif(!" + $8.label + ") goto " + label[1] + ";\n\t"
										   + "goto " + label[0] + ";\n" + "\n\t" + label[1] + ":\n"; 
				}
				else
				{
					yyerror("Tem certeza que seu while está correto?\n");
				}

				pilha.desempilha();

			}
			/* CONSERTAR 

			| TK_DO '{' COMANDOS '}' TK_WHILE '(' TK_ID TK_REL TK_INT ')' 
			{
				vector<string> atributos;
				atributos 	  = pilha.busca($8.label);
				string *label = pilha.recuperaLabel();
				string temporaria = converte();

				if(atributos.size() <= 1)
				{
					string mensagem = "Variável " + $8.label + " não declarada!";
					yyerror(mensagem);
				}
				else
				{
					
					$$.traducao   = "\n\t" + label[0] + ":\n" 
										   + $3.traducao + "\t" + temporaria + " = " + atributos[1] + $9.label + $10.label 
										   + ";\n\tif(!" + temporaria
										   + ") goto " + label[1] + ";\n\t"
										   + "goto " + label[0] + ";\n" + "\n\t" + label[1] + ":\n";
				}
				
				pilha.desempilha();
			}*/

			| TK_BREAK
			{
				int indice	  = pilha.mapa.size();
				int qtdLabels = pilha.mapa[indice-1].labels.size(); // Pega o tamanho do vetor de labels

				if(qtdLabels == 0)
				{
					stringstream qtd;
					qtd << qtdLabels;
					
					string mensagem = "Quebra inválida! Tem " + qtd.str() + " labels.";
					yyerror(mensagem);
				}
				else
				{
					
					string* labels 	  = pilha.recuperaLabel(); // Pega a label de fato
					$$.traducao 	  = "\tgoto " + labels[1] + ";\n\n";
				}

				
			}

			| TK_CONTINUE
			{
				int indice	  = pilha.mapa.size();
				int qtdLabels = pilha.mapa[indice-1].labels.size(); // Pega o tamanho do vetor de labels

				if(qtdLabels == 0)
				{
					stringstream qtd;
					qtd << qtdLabels;
					
					string mensagem = "Quebra inválida! Tem " + qtd.str() + " labels.";
					yyerror(mensagem);
				}
				else
				{
					
					string* labels 	  = pilha.recuperaLabel(); // Pega a label de fato
					$$.traducao 	  = "\tgoto " + labels[0] + ";\n\n";
				}

				
			}
			/* TIPOS PRIMITIVOS */

			| TK_INT
			{
				$$.label	 = converte();
				$$.traducao  = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo 	 = $1.tipo;

				pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
			}
			
			| TK_FLOAT
			{
				$$.label 	= converte();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo 	= $1.tipo;

				pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
			}
			| TK_CHAR
			{
				$$.label 	= converte();
				$$.traducao = "\t" + $$.label + " = " + $1.label + ";\n";
				$$.tipo 	= $1.tipo;

				pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
				
			}
			| TK_BOOL
			{
				/* ACHO QUE TEM QUE VERIFICAR SE A LABEL DELE É TRUE OU FALSE PRA PODER COLOCAR 0 OU 1
				 * JÁ QUE O C SÓ ACEITA INTEIROS */

				$$.label 	= converte();
				string aux;

				if($1.label == "true") aux = "1";
				else if ($1.label == "false") aux = "0";
				else yyerror("Booleano inválido!\n");

				$$.traducao = "\t" + $$.label + " = " + aux + ";\n";
				$$.tipo 	= $1.tipo;

				pilha.adicionaVariavel("",$$.label,$$.tipo,"","False");
			}

			| TK_ID
			{  				
				vector<string> atributos;
				atributos = pilha.recuperaVariavel($1.label);

				if(atributos.size() <= 1)
				{
					string mensagem = "Variável " + $1.label + " não declarada!";
					yyerror(mensagem);
				}
				else
				{
					$$.tipo = atributos[2];
					$$.label = atributos[1];
				}				
			}
			//ENTRADA E SAIDA

			| TK_SHOW IMPRIMIR 
			{
				$$.traducao = $2.traducao;
			}
			;

IMPRIMIR	: IMPRIME IMPRIMIR
			{
				$$.traducao = "\tcout << " + $1.traducao + $2.traducao + "<< endl;\n";
			}
			| IMPRIME
			{
				if($1.tipo == "string")
				{
					$$.traducao = $1.traducao + "\tcout << " + $1.label + " << endl;\n" + "\tfree(" + $$.label + ");\n";
				}
				else
				{
					$$.traducao = $1.traducao + "\tcout << " + $1.label + " << endl;\n";
				}
				
			}
			|
			;
			
IMPRIME 	: '(' TK_STR ')'
			{
				std::string conteudo = $2.label;
				int tam 			 = conteudo.length();
				tam 				 = tam - 2;

				stringstream tamanho;
				tamanho << tam;
				string str = tamanho.str();

				$$.label    	= converte();
				$$.traducao 	= "\t" + $$.label + " = " + "(char *) malloc(" + str + "*sizeof(char));"+"\n"
									   + "\tstrcpy(" + $$.label + "," + $2.label + ");\n";
				pilha.adicionaVariavel($2.label, $$.label,"char *", "", "False");
			} 
			| '(' TK_ID ')'
			{
				vector<string> atributos;
				atributos = pilha.busca($2.label);

				if(atributos.size() <= 1)
				{
					string mensagem = "Variável " + $2.label + " não declarada!";
					yyerror(mensagem);
				}
				else
				{
					$$.traducao = $2.traducao;
					$$.label = atributos[1];
				}


			}
			| '(' TK_STR ',' E ')'
			{
				cout << "temp: " << $4.label << "\ntipo: " << $4.valor << endl;
				if($4.valor == "id")
				{
					/*vector<string> atributos;
					string *var = pilha.recuperaVariavel;
					atributos 	  = pilha.busca(label[0]);

					if(atributos.size() <= 1)
					{
						string mensagem = "Variável " + $2.label + " não declarada!";
						yyerror(mensagem);
					}
					else
					{
						$$.traducao = $2.label + " << " + $4.traducao;
						$$.label = atributos[1];
					}	*/

					cout << "entrei no show" << endl;
				}
			}
			|
			'(' E ')'
			{
				$$.label 	= $2.label;
				$$.traducao = $2.traducao;
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
