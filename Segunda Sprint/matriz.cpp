#include <iostream>
#include <string>
#include <sstream>
#include <stdio.h>
#include <vector>
using namespace std;

class Matriz
{

public:
		int numVar = 0;
		
		vector < vector<string> > variaveis;

		//string** variaveis = new std::string*[numCol];

		vector <string*> labels;

		void adicionaVariavel(string id, string temporario, string tipo, string valor, string lock);

		vector<string> recuperaVariavel(string label);		
};

void Matriz::adicionaVariavel(string id, string temporario, string tipo, string valor, string lock)
{
	std::vector<string> linha;
	variaveis.push_back(linha);

	stringstream conversor;
	conversor  << numVar;

	variaveis[numVar].push_back(id);
	variaveis[numVar].push_back(temporario);
	variaveis[numVar].push_back(tipo);
	variaveis[numVar].push_back(valor);
	variaveis[numVar].push_back(lock);
	variaveis[numVar].push_back(conversor.str());
	
	numVar ++;	
}

vector<string> Matriz::recuperaVariavel(string label){

	vector<string> retorno;

	for(int contador = 0; contador < numVar; contador++){

		if(variaveis[contador][0] == label){
			
			retorno = variaveis[contador];
		}
	}
	return retorno;
}



/*
int main(int argc, char const *argv[])
{
	Matriz teste;

	for(int i = 0; i < 1000; i++)
	{
		
		teste.adicionaVariavel("id", "bacon", "porco", "", "lockado");;
		if(i == 27)
		{
			teste.adicionaVariavel("id2", "bacon", "porco", "", "lockado");;
		}
	}
	
	vector<string> b = teste.recuperaVariavel("id2");


	if(b.size() == 0)
	{
		cout << "deu ruim" << endl;
	}
	else
	{
		cout << "ok!" << endl;
	}
	
	for(int i = 0; i < 6; i++)
	{
		cout << "atributo posicao i: " << b[i] << endl;
	}
}
*/