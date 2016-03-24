#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

long long asm_soucetll(long long x, long long y);
// negace - odečtení od nuly

long long asm_nasobii(int x, int y);
long long asm_nasobli(long long x, int y);
long long asm_nasobll(long long x, long long y);

long long asm_delenili(long long x, int y, int* zbytek);

int main(int argc, char** argv)
{
	long long x = 5000000000;
	long long y = 5000000000;
	
	printf("%Ld\n", asm_soucetll(x, y));
	printf("%Ld\n", asm_nasobli(x, 2));
	printf("%Ld\n", asm_nasobll(2, x));
	
	int zbytek;
	long long vysledek = asm_delenili(x, 3, &zbytek);
	printf("%Ld (%d)\n", vysledek, zbytek);
		
	return 0;
}
