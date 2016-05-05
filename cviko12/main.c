#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

#ifdef __cplusplus
extern "C" {
#endif

	float asm_retfl(float a);
	double asm_retdbl(double a);

	double asm_obvod(double r, double pi);
	int asm_round(float a);
	
	float asm_prumer(float* pole, int delka);
	float asm_findmax(float* pole, int delka);
	
	float asm_vec_sum(float* pole, int delka);
	
	float asm_objem_koule(float r, float pi);
	float asm_pythagoras(float a, float b);
	double asm_vec_sumd(double* pole, double* pole2, int delka);
	
	double asm_vec_length(double* vec, int delka);

#ifdef __cplusplus
}
#endif

// zaokrouhleni SSE defaultně k nejbližší, k sudé
int main(int argc, char** argv)
{
	double pole[] =
	{
		1.0, 2.0, 3.0, 4.0, 5.0, 6.0,
		7.0, 8.0, 9.0, 10.0, 11.0, 12.0
	};
	double pole2[] =
	{
		1.0, 2.0, 3.0, 4.0, 5.0, 6.0,
		7.0, 8.0, 9.0, 10.0, 11.0, 12.0
	};
	int delka = sizeof(pole) / sizeof(double);

	printf("%.4f\n", asm_objem_koule(10.0f, M_PI));
	printf("%f\n", asm_pythagoras(5.0f, 6.0f));
	printf("%f\n", asm_vec_sumd(pole, pole2, delka));
	printf("%f\n", asm_vec_length(pole, delka));

	return 0;
}
