all: 	
		clear
		lex expressaoTOBE.l
		yacc -d sprint2TOBE.y
		g++ -o glf y.tab.c -lfl

		./glf < exemplo4.meme
