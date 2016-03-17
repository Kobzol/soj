#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int nasob(int a, int b);
long nasobl(long a, long b);

int pole[] = { 10, 20, -3, -4, -5, 60, -7, 8, -9, 100 };
long polel[] = { 3000000000, 3000000000, 3000000000, 3000000000,
	3000000000, 3000000000, 3000000000, 3000000000, 3000000000,
	3000000000, 3000000000 };

int soucet(int* pole, int delka);
long soucetl(int* pole, int delka);
long soucetll(long* pole, int delka);

char* atob(long cislo, char* str);
long asm_atoi(char* str);
int asm_strlen(char* str);
int asm_strcmp(char* str1, char* str2);
void asm_find_min_max(int* pole, int delka, int* min, int* max);

char* asm_strstr(char* str1, char* str2);

int main(int argc, char** argv)
{
	printf("Nasob: %d\n", nasob(1000, 1000000));
	printf("Nasobl: %ld\n", nasobl(1000000, 1000000));
	printf("Soucet: %d\n", soucet(pole, 10));
	printf("Soucetl: %ld\n", soucetl(pole, 10));
	printf("Soucetll: %ld\n", soucetll(polel, 10));
		
	char buffer[65];
	long cislo = 128;
	
	printf("%ld\n", INT64_MAX);
	
	printf("Atob: %s\n", atob(cislo, buffer));
	
	char buf[] = "-55555";
	printf("Atoi: %ld\n", asm_atoi(buf));
	
	printf("Strlen: %d\n", asm_strlen("123456789"));
	printf("Strcmp: %d\n", asm_strcmp("ahokk", "ahoj"));
	
	int min, max;
	asm_find_min_max(pole, 10, &min, &max);
	printf("Min: %d\nMax: %d\n", min, max);
	
	char buf1[] = "ahoj";
	char buf2[] = "ah";
	char* result = asm_strstr(buf1, buf2);
	if (result)
	{
		printf("Strstr: %d\n", result - buf1);
	}
	else printf("Strstr: null\n");
		
	return 0;
}
