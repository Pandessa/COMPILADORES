all: 	
		clear
		lex expressao.l #trocar aqui pra lexica.l
		yacc -d sintatica.y
		g++ -o glf y.tab.c -lfl

		./glf < exemplo.meme
