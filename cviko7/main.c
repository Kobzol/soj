#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

__int128 deleni(__int128 delenec, long delitel, long* zbytek);
void int128_to_str(unsigned __int128 n, char* cislo)
{
	int delka = 0;
	while (n > 0)
	{
		long zbytek;
		unsigned __int128 vysledek = deleni(n, 10, &zbytek);
		
		cislo[delka++] = zbytek + '0';
		n = vysledek;
	}
	
	for (int i = 0; i < delka / 2; i++)
	{
		char tmp = cislo[i];
		cislo[i] = cislo[delka - i - 1];
		cislo[delka - i - 1] = tmp;
	}
	
	cislo[delka] = '\0';
}

int main(int argc, char** argv)
{
	unsigned __int128 a = 0x9999999999999999LL;
	a = (a << 64);
	a |= 0x9999999999999999LL;
	
	unsigned __int128 tmp = a;
	
	printf("%lx %lx\n", (long) (a >> 64), (long) a);
	
	long zbytek;
	long b = (long) a;
	unsigned __int128 vysledek = deleni(a, b, &zbytek);
	printf("%lx %lx (%ld)\n", (long) (vysledek >> 64), (long) vysledek, zbytek);
	
	char buffer[512];
	int128_to_str(vysledek, buffer);
	printf("%s\n", buffer);
	
	return 0;
}
