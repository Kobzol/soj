#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

int div_intN_int32(int* cislo, int delitel, int N);
void add_intN_int32(int* cislo, int scitatel, int N);
void mul_intN_int32(int* cislo, int nasobitel, int N);

int add_intN_intN(int* cislo1, int* cislo2, int N);
int sub_intN_intN(int* cislo1, int* cislo2, int N);
int shr_intN(int* cislo, int N);
int shl_intN(int* cislo, int N);
int shrd_intN(int* cislo, int N, int posun);
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
void div_intN_intN(int* cislo1, int* cislo2, int N)
{
	int N2 = N * 2;
	
	// prekopirovani delence
	int* divadlo = malloc(N2 * sizeof(int));
	for (int i = 0; i < N2; i++)
	{
		if (i < N) divadlo[i] = cislo1[i];
		else divadlo[i] = 0;
	}
	
	// vynulovani vysledku
	int* vysledek = cislo1;
	memset(vysledek, 0, sizeof(int) * N);
	
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

int square_root(int x)
{
	long long divadlo = x;
	int* scena = (int*) &divadlo;
	scena++;

	int vysledek = 0;

	for (int i = 0; i < sizeof(int) * 8 / 2; i++)
	{
		divadlo <<= 2;
		vysledek <<= 1;
		
		int tmp = (vysledek << 1) | 1;	//	2*ab + b^2, b = 1
		if (*scena >= tmp)
		{
			*scena -= tmp;
			vysledek |= 1;
		}
	}
	
	return vysledek;
}

int calculate_bits(int x, int base)
{
	if (base == 2) return (int) ceilf(log2(x));
	if (base == 10) return (int) ceilf(log10(x));
	return -1;
}

void euler(int digits)
{
	int bits = (int) ceilf(digits * 3.3f);
	int ilen = (int) ceilf(bits / 32.0f);
	int* n = malloc(sizeof(int) * ilen);
	char* str = malloc(sizeof(char) * (digits + 2));
	int* iK = malloc(sizeof(int) * ilen);
	
	
	
	
	intN_to_str(n, ilen, str);
	printf("%s\n", str);
	
	free(str);
	free(n);
}

int main(int argc, char** argv)
{
#define ILEN 1050
#define SLEN 30002
	char sK[SLEN], se[SLEN];
	int iK[ILEN], e[ILEN] = { 0 }, itmp[ILEN], ifak[ILEN] = { 0 }, tmpfak[ILEN] = { 0 };
	memset(sK, '0', SLEN);
	sK[10001] = '\0';
	sK[0] = '1';	// 1 * 10^10000
	
	str_to_intN(sK, iK, ILEN);
	
	memcpy(e, iK, sizeof(e));
	mul_intN_int32(e, 2, ILEN);
	ifak[0] = 1;
	
	// e calculation
	for (int i = 2; i < 30; i++)
	{
		memcpy(itmp, iK, sizeof(iK));	// itmp = iK
		mul_intN_int32(ifak, i, ILEN);	// fak * i
		memcpy(tmpfak, ifak, sizeof(ifak));
		div_intN_intN(itmp, tmpfak, ILEN);
		add_intN_intN(e, itmp, ILEN);
	}
	
	intN_to_str(e, ILEN, se);
	printf("%s\n", se);
	return 0;
	
	/*char sK[SLEN], sPi[SLEN];
	int iK[ILEN], pi[ILEN] = { 0 };
	int iK2[ILEN], iK4[ILEN];
	int tmpInner[ILEN], tmpSub[ILEN], mulResult[ILEN * 2 + 1] = { 0 };
	memset(sK, '0', SLEN);
	sK[10001] = '\0';
	sK[0] = '1';	// 1 * 10^10000*/
	
	/*char x[SLEN * 2] = "12358983616874687";
	int iX[ILEN], iY[ILEN], iResult[ILEN * 2];
	str_to_intN(x, iX, ILEN);
	
	memcpy(iY, iX, sizeof(iY));
	mul_intN_int32(iY, 257, ILEN);
	shrd_intN(iY, ILEN, 4 * 7);
	
	intN_to_str(iY, ILEN, x);
	printf("%s\n", x);
	return 0;*/
	
	/*str_to_intN(sK, iK, ILEN);
	memcpy(iK2, iK, sizeof(iK));
	mul_intN_int32(iK2, 2, ILEN);
	memcpy(iK4, iK, sizeof(iK));
	mul_intN_int32(iK4, 4, ILEN);
	
	// pi calculation
	for (int i = 0; i < 10; i++)
	{
		// first part
		memcpy(tmpInner, iK4, sizeof(tmpInner));
		int c1 = 8 * i + 1;
		div_intN_int32(tmpInner, c1, ILEN);
		
		// second part
		memcpy(tmpSub, iK2, sizeof(tmpSub));
		int c2 = 8 * i + 4;
		div_intN_int32(tmpSub, c2, ILEN);
		sub_intN_intN(tmpInner, tmpSub, ILEN);
		
		// third part
		memcpy(tmpSub, iK, sizeof(tmpSub));
		int c3 = 8 * i + 5;
		div_intN_int32(tmpSub, c3, ILEN);
		sub_intN_intN(tmpInner, tmpSub, ILEN);
		
		// fourth part
		memcpy(tmpSub, iK, sizeof(tmpSub));
		int c4 = 8 * i + 6;
		div_intN_int32(tmpSub, c4, ILEN);
		sub_intN_intN(tmpInner, tmpSub, ILEN);
		
		// tmpInner now contains the value
		for (int j = 0; j < i; j++)
		{
			shrd_intN(tmpInner, ILEN, 4);
		}
		add_intN_intN(pi, tmpInner, ILEN);
	}
	
	intN_to_str(pi, ILEN, sPi);
	printf("%s\n", sPi);*/
	
	return 0;
}
