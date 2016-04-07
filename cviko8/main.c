#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int div_intN_int32(int* cislo, int delitel, int N);
void add_intN_int32(int* cislo, int scitatel, int N);
void mul_intN_int32(int* cislo, int nasobitel, int N);

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
	int delka = 0;
	char* strDigits = str;
	
	do
	{
		*strDigits++ = div_intN_int32(cislo, 10, N) + '0';
		delka++;
	}
	while (!intN_is_zero(cislo, N));
	
	*strDigits = '\0';
	
	for (int i = 0; i < delka / 2; i++)
	{
		char tmp = str[i];
		str[i] = str[delka - 1 - i];
		str[delka - 1 - i] = tmp;
	}
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

int main(int argc, char** argv)
{
	const int N = 8;
	int pole[] = { 0x22222222, 0x22222222, 0x22222222, 0x22222222,
				   0x22222222, 0x22222222, 0x22222222, 0x22222222 };
	
	/*char buffer[512];
	intN_to_str(pole, N, buffer);
	printf("Vypis: %s\n", buffer);*/
	
	/*mul_intN_int32(pole, 4, N);
	
	for (int i = 0; i < N; i++)
	{
		printf("%08x ", pole[N - i - 1]);
	}
	printf("\n");*/
	
	char buffer[512];
	intN_to_str(pole, N, buffer);
	str_to_intN(buffer, pole, N);
	
	for (int i = 0; i < N; i++)
	{
		printf("%08x ", pole[N - i - 1]);
	}
	printf("\n");
	
	return 0;
}
