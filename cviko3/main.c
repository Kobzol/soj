#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int testret(int x);
int soucet(int a, int b);
int sumapole(int *pole, int n);
int pocet_mezer(char* str);
int pocet_malych(char* str);
void pocet_kl_zp(int *pole, int delka, int *kladne, int* zaporne);
void to_lower(char * str);
void prumer_kl_zp(int *pole, int delka, int *kladne, int* zaporne);
void nahrada(char* str, char znak);
int pocet_lichych(int* pole, int n);

int main(int argc, char** argv)
{
	int delka = 10;
	int pole[10] = { -1, 2, 3, -4, -5, 6, 7, 8, 9, 10 };

	/*printf("%d\n", testret(5));
	printf("%d\n", soucet(1, 2));
	printf("%d\n", sumapole(pole, delka));
	printf("%d\n", pocet_mezer("a b c"));
	printf("%d\n", pocet_malych("a b C D x"));*/
	
	int kladne, zaporne;
	pocet_kl_zp(pole, 10, &kladne, &zaporne);
	
	printf("kladne: %d\nzaporne: %d\n", kladne, zaporne);
	
	char retezec[] = "AHOJ KAMARADE asd984";
	to_lower(retezec);
	printf("%s\n", retezec);
	
	prumer_kl_zp(pole, delka, &kladne, &zaporne);
	printf("kladne prumer: %d\nzaporne prumer: %d\n", kladne, zaporne);
	
	char retezec2[] = "ahoj 5s6s8s7a6";
	nahrada(retezec2, 'x');
	printf("%s\n", retezec2);
	
	printf("%d\n", pocet_lichych(pole, delka));
	
	return 0;
}
