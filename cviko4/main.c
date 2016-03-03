#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int asm_strlen(char* str);
int asm_strcmp(char* dest, char* src);
void asm_str2upper(char* str);
void asm_memcpy(void* dest, void* src, int l);
void asm_replace(char* str, char znak);

int main(int argc, char** argv)
{
	printf("Delka: %d\n", asm_strlen("12 3"));
	printf("Porovnani: %d\n", asm_strcmp("asd", "a"));
	printf("Porovnani: %d\n", asm_strcmp("ab", "add"));
	printf("Porovnani: %d\n", asm_strcmp("ab", "ac"));
	printf("Porovnani: %d\n", asm_strcmp("ab", "ab"));
	
	char str[] = "ahoj";
	asm_str2upper(str);
	printf("Upper: %s\n", str);
	
	char str2[] = "ah o j k a m a ra d e";
	asm_replace(str2, ' ');
	printf("Replaced: %s\n", str2);
	
	char pole1[] = "Ahojprogramatori"; // AAhojpogramatori
	char pole2[] = "Cauky";
	
	asm_memcpy(pole1 + 1, pole1, 5);
	
	printf("Memcpy: %s\n", pole1);
	
	return 0;
}
