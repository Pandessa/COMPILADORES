#include <iostream>
#include <string>
#include <sstream>
#include <stdio.h>
#include "matriz.cpp"
#include <vector>
using namespace std;

class Pilha
{
	public:
		
		vector <Matriz> mapa;
		Matriz auxiliar;
		
		public: Pilha()
		{
			Matriz matrizGlobal;
			mapa.push_back(matrizGlobal);
		}

		void adicionaVariavel(string id, string temporario, string tipo, string valor, string lock)
		{			
			//cout << "temporaria : " << temporario << endl;
			//cout << "tamanho mapa : " << mapa.size() << endl;
			mapa[mapa.size()-1].adicionaVariavel(id,temporario,tipo,valor,lock);
			auxiliar.adicionaVariavel(id, temporario, tipo, valor, lock);
		}

		void empilha()
		{
			Matriz nova;
			mapa.push_back(nova);
		}

		void desempilha()
		{
			mapa.pop_back();
		}

		void guardaLabel(string* label)
		{
			mapa[mapa.size()-1].labels.push_back(label);
			
		}

		string* recuperaLabel()
		{
			int tamanhoMap = mapa.size() - 1;
			int tamanhoLab = mapa[mapa.size()-1].labels.size() - 1;
			return mapa[tamanhoMap].labels[tamanhoLab];
		}
		/*
		vector<string> recuperaVariavel(string id)
		{
			vector<string> vetor;
			stringstream conversor;
			//vector<string> teste = mapa[mapa.size()-1].recuperaVariavel(id);
		
		
			vetor = mapa[mapa.size()-1].recuperaVariavel(id);
			if(vetor.size() >= 1)
			{
				//cout << vetor[0] << endl;
				conversor << mapa.size() - 1;
				vetor.push_back(conversor.str());
				return vetor;
			}
			
			return vetor;
		}
*/
		vector <string> recuperaVariavel(string id)
		{
			vector<string> vetor;
			stringstream conversor;
			//cout << "procurando : " << id << endl;
			for(int i = mapa.size()-1; i >= 0; i--)
			{
				vetor = mapa[i].recuperaVariavel(id);

				if(vetor.size() > 0)
				{
					//cout << "achei no : " << i << endl;
					conversor << i;
					vetor.push_back(conversor.str());
					return vetor;
				}
			}
			
			
			return vetor;
		}

};

/*
int main(int argc, char const *argv[])
{
	Pilha teste;

	teste.adicionaVariavel("oi","mais de dentro","","","");
	teste.empilha();
	teste.adicionaVariavel("oi","mais de fora","","","");

	vector<string> v = teste.recuperaVariavel("oi");

	cout << v[1] << endl;

	return 0;
}*/