#include <stdio.h>
#include <stdlib.h>

static int pole[10];
int delka = 10;
extern int index, value;

void nuluj(int* ptr, int delka);

void init_pole()
{
	nuluj(pole, 10);
}

int do_pole()
{
	pole[index] = value;
	return value;
}

int* vrat_pole()
{
	return pole;
}
