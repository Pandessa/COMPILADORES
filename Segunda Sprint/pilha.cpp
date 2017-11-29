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
		
		public: Pilha()
		{
			Matriz matrizGlobal;
			mapa.push_back(matrizGlobal);
		}

		void adicionaVariavel(string id, string temporario, string tipo, string valor, string lock)
		{			

			mapa[mapa.size()-1].adicionaVariavel(id,temporario,tipo,valor,lock);
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

		vector<string> recuperaVariavel(string id)
		{
			vector<string> vetor;
			stringstream conversor;
			vector<string> teste = mapa[mapa.size()-1].recuperaVariavel(id);
		
			cout << mapa.size() << endl;
			vetor = mapa[mapa.size()-1].recuperaVariavel(id);
			if(vetor.size() >= 1)
			{
				cout << vetor[0] << endl;
				conversor << mapa.size() - 1;
				vetor.push_back(conversor.str());
				return vetor;
			}
				
			
			/*
			if(mapa.size() > 1)
			{
				for (int i = (mapa.size()-1); i >= 0; i--)
				{
					vetor = mapa[i].recuperaVariavel(id);
					
					if(vetor.size() > 1)
					{
						cout << vetor.size() << endl;
						conversor << i;
						vetor.push_back(conversor.str());
						return vetor;
					}						
				}
			}
			else
			{							
				vetor = mapa[0].recuperaVariavel(id);
				if (vetor.size() > 1)
				{
					conversor << 0;	
					vetor.push_back(conversor.str());
				}
			}
			
			cout << vetor.size()
			*/
			return vetor;
		}

};