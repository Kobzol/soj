#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int div_intN_int32(int* cislo, int delitel, int N);
void add_intN_int32(int* cislo, int scitatel, int N);
void mul_intN_int32(int* cislo, int nasobitel, int N);

int add_intN_intN(int* cislo1, int* cislo2, int N);
int sub_intN_intN(int* cislo1, int* cislo2, int N);
int shr_intN(int* cislo, int N);
int shl_intN(int* cislo, int N);

void mul_intN_intN(int* cislo1, int* cislo, int N, int* vysledek);

int intN_is_zero(int* cislo, int N)
{
	for (int i = 0; i < N; i++)
	{
		if (cislo[i]) return 0;
	}

	return 1;
}
void intN_to_str(int* cislo, int N, char* str)
{
	int* cisloVypis = malloc(N * sizeof(int));
	memcpy(cisloVypis, cislo, N * sizeof(int));
	
	int delka = 0;
	char* strDigits = str;
	
	do
	{
		*strDigits++ = div_intN_int32(cisloVypis, 10, N) + '0';
		delka++;
	}
	while (!intN_is_zero(cisloVypis, N));
	
	*strDigits = '\0';
	
	for (int i = 0; i < delka / 2; i++)
	{
		char tmp = str[i];
		str[i] = str[delka - 1 - i];
		str[delka - 1 - i] = tmp;
	}
	
	free(cisloVypis);
}
void str_to_intN(char* str, int* cislo, int N)
{
	memset(cislo, 0, sizeof(int) * N);
	
	while (*str)
	{
		mul_intN_int32(cislo, 10, N);
		add_intN_int32(cislo, *str - '0', N);
		str++;
	}
}
void print_intN(int* cislo, int N)
{
	for (int i = 0; i < N; i++)
	{
		printf("%x ", cislo[i]);
	}
	printf("\n");
}

int intN_jge(int* cislo1, int* cislo2, int N)
{
	for (int i = N - 1; i >= 0; i--)
	{
		unsigned int c1 = cislo1[i];
		unsigned int c2 = cislo2[i];
		
		if (c1 > c2)
		{
			return 1;
		}
		else if (c1 < c2)
		{
			return 0;
		}
	}
	
	return 1;
}

long long mul_i32_i32(int cislo1, int cislo2)
{
	long long vysledek = 0;
	long long llc1 = cislo1;
	
	while (cislo2)
	{
		if (cislo2 & 1)
		{
			vysledek += llc1;
		}
		llc1 <<= 1;
		cislo2 >>= 1;
	}
	
	return vysledek;
}
long long div_i32_i32(int cislo1, int cislo2)
{
	long long vysledek = 0;
	long long divadlo = cislo1;
	int* scena = (int*) &divadlo;
	scena++;
	*scena = 0;
	
	for (int i = 0; i < 32; i++)
	{
		vysledek <<= 1;
		divadlo <<= 1;
		
		if (*scena >= cislo2)
		{
			vysledek |= 1;
			*scena -= cislo2;
		}
	}
	
	return vysledek;
}

void mul_intN_intN(int* cislo1, int* cislo2, int N, int* vysledek)
{
	for (int i = 0; i < N * 2; i++)
	{
		vysledek[i] = 0;
	}
	
	while (!intN_is_zero(cislo2, N))
	{
		if (*cislo2 & 1)
		{
			add_intN_intN(vysledek, cislo1, N);
		}
		shr_intN(cislo2, N);
		shl_intN(cislo1, N);
	}
}
void div_intN_intN(int* cislo1, int* cislo2, int N, int* vysledek)
{
	int N2 = N * 2;
	
	// vynulovani vysledku
	for (int i = 0; i < N2; i++)
	{
		vysledek[i] = 0;
	}
	
	// prekopirovani delence
	int* divadlo = malloc(N2 * sizeof(int));
	for (int i = 0; i < N2; i++)
	{
		if (i < N) divadlo[i] = cislo1[i];
		else divadlo[i] = 0;
	}
	
	int* scena = divadlo + N;
	
	for (int i = 0; i < N * sizeof(int) * 8; i++)
	{
		shl_intN(vysledek, N2);
		shl_intN(divadlo, N2);
		
		if (intN_jge(scena, cislo2, N))
		{
			*vysledek |= 1;
			sub_intN_intN(scena, cislo2, N);
		}
	}
	
	free(divadlo);
}

int main(int argc, char** argv)
{
#define N 8
	char s1[128] = "99999999999546587549999999999999999999";
	char s2[128] = "111111111111111111111111111111";
	char s3[128];

	int n1[N] = { 0 }, n2[N] = { 0 };
	int vysledek[N * 2] = { 0 };
	
	str_to_intN(s1, n1, N);
	str_to_intN(s2, n2, N);
	
	mul_intN_intN(n1, n2, N, vysledek);
	intN_to_str(vysledek, N * 2, s3);
	printf("%s\n", s3);
	
	/*div_intN_intN(n1, n2, N, vysledek);
	intN_to_str(vysledek, N * 2, s3);
	printf("%s\n", s3);*/
	
	return 0;
}
