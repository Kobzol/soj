#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int asm_strlen(char* str);
int asm_strcmp(char* dest, char* src);
char* asm_strstr(const char* haystack, const char* needle);
void asm_find_min_max(int* pole, int delka, int* min, int* max);
int asm_atoi(char* str);

int main(int argc, char** argv)
{
	char ahoj[] = "ahoj";
	char asd[] = "asd";
	
	printf("Strstr 1: %p\n", asm_strstr(ahoj, asd));
	
	char haystack[] = "skulia";
	char needle[] = "kulia";
	char* pos = asm_strstr(haystack, needle);
	printf("Strstr 2: %d\n", pos ? (pos - haystack) : -1);
	
	/*int pole[] = { -1, 1, 2, 3, -8, 16, 2, 18, 0, -5 };
	int min = 0, max = 0;
	
	asm_find_min_max(pole, 10, &min, &max);
	printf("Min: %d\nMax: %d\n", min, max);
	
	printf("Atoi %d\n", asm_atoi(""));
	printf("Atoi %d\n", asm_atoi("1"));
	printf("Atoi %d\n", asm_atoi("-235"));
	printf("Atoi %d\n", asm_atoi("65987"));*/
	
	return 0;
}
