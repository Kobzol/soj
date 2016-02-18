#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int delka = 10;
//int pole[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
int pole[10] = { -1000, -1000, -1000, -1000, -1000, -1000, -1000, -1000, -1000, -1000 };
int soucet;
int nasob32 = 8;
signed char nasob8 = 2;

//signed char bajty[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
signed char bajty[10] = { -50, -50, -50, -50, -50, -50, -50, -50, -50, -50 };

void prumer();
void prumer_bajty();
void vynasob32();
void vynasob8();

int posun = 2;
void posun_doprava32();
void posun_doprava8();

int main(int argc, char** argv)
{
	prumer();
	printf("Prumer 32bit: %d\n", soucet);
	
	prumer_bajty();
	printf("Prumer 8bit: %d\n", soucet);
	
	//vynasob32();
	posun_doprava32();
	for (int i = 0; i < delka; i++)
	{
		printf("%d ", pole[i]);
	}
	printf("\n");
	
	//vynasob8();
	posun_doprava8();
	for (int i = 0; i < delka; i++)
	{
		printf("%d ", (int) bajty[i]);
	}
	printf("\n");
	
	return 0;
}
