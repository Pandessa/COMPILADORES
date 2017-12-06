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
		
		vector <Matriz> minhaPilha;
		
		public: Pilha()
		{
			Matriz matrizGlobal;
			minhaPilha.push_back(matrizGlobal);
		}

		void adicionaVariavel(string id, string temporario, string tipo, string valor, string lock)
		{			

			minhaPilha[minhaPilha.size()-1].adicionaVariavel(id,temporario,tipo,valor,lock);
		}

		void empilha()
		{
			Matriz nova;
			minhaPilha.push_back(nova);
		}

		void desempilha()
		{
			minhaPilha.pop_back();
		}

		vector<string> recuperaVariavel(string id)
		{
			vector<string> vetor;
			stringstream conversor;

			if(minhaPilha.size() > 1)
			{
				for (int i = (minhaPilha.size()-1); i >= 0; i--)
				{
					vetor = minhaPilha[i].recuperaVariavel(id);

					if(vetor.size() > 0)
						conversor << i;
						vetor.push_back(conversor.str());
						return vetor;
				}

			}

			else
			{							
				vetor = minhaPilha[0].recuperaVariavel(id);
				if (vetor.size() > 0)
				{
					conversor << 0;	
					vetor.push_back(conversor.str());
				}
			}

			return vetor;
		}

};


int main(int argc, char const *argv[])
{
	
	Pilha p;
	
	p.adicionaVariavel("id", "bacon", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");	
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");	
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");
	p.adicionaVariavel("id1", "carré", "porco", "", "lockado");	
	
	
	cout << p.minhaPilha[0].mapaVar.size() << endl;	


	return 0;
}