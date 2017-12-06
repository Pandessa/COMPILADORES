/* Compilador MEME */
#include <iostream>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
using namespace std;
int main(void)
{
	char * TEMP0;

	TEMP0 = (char *) malloc(3*sizeof(char));
	strcpy(TEMP0,"ola");
	cout << TEMP0 << endl;
	free(TEMP0);
	return 0;
}
