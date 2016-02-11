#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int delka;
extern char pozdrav[];
int index, value;

int do_pole();
int* vrat_pole();
void init_pole();

char retezec[] = "ahoj";
int retezec_index = 0;
void retezec_zmen();

int x1, x2, x3;
int secti();

void nuluj(int* ptr, int delka)
{
	memset(ptr, 0, delka * sizeof(int));
}

int main(int argc, char** argv)
{
	/*printf("%s", pozdrav);
	
	for (int i = 0; i < delka; i++)
	{
        index = i;
        value = i;
		do_pole();
		printf("%d\n", vrat_pole()[i]);
	}*/
	
	retezec_zmen();
	printf("%s\n", retezec);
	
	x1 = 1;
	x2 = 1;
	x3 = 3;
	printf("%d\n", secti());
	
	return 0;
}
