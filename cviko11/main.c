#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#ifndef M_PI
    #define M_PI 3.14159265358979323846
#endif

#define D (16)
#define Z (1 << D) // 2^16

int fl2fix(float x)
{
	return (int) (x * Z);
}
float fix2fl(int fix)
{
	return ((float) fix) / Z;
}
int mulfix(int a, int b)
{
	long long tmp = a;
	tmp *= b;
	tmp >>= D;	// remove unnecessary Z (divison by Z)
	return tmp;
}
int divfix(int a, int b)
{
	long long tmp = a;
	tmp <<= D;	// * Z
	tmp /= b;
	return tmp;
}

typedef struct
{
	unsigned int m:23;
	unsigned int e:8;
	unsigned int s:1;
} _kuchfl;
typedef struct
{
	unsigned int m:23;
	unsigned int m1:9;
} _kuchfl_implicit;

typedef union
{
	_kuchfl k;
	float a;
} kuchfl;
typedef union
{
	_kuchfl_implicit k;
	int i;
} kuchfl_implicit;

float mulfl(float a, float b)
{
	kuchfl ka, kb, kc;
	ka.a = a;
	kb.a = b;
	
	kc.k.s = (ka.k.s + kb.k.s) % 2;	// sign
	kc.k.e = (ka.k.e + kb.k.e) - 127;	// ea * eb - bias
	
	kuchfl_implicit ta, tb, tc;
	ta.k.m = ka.k.m;	// copy mantissa
	ta.k.m1 = 1;		// add hidden bit
	tb.k.m = kb.k.m;
	tb.k.m1 = 1;
	
	long long tmp = ta.i;
	tmp *= tb.i;
	tmp >>= 23;	// posunuti zpet po pricteni fixed pointu mantissy
	
	tc.i = tmp;
	while (tc.k.m1 >= 2)	// preteceni mantissy
	{
		tc.i >>= 1;
		kc.k.e++;
	}
	kc.k.m = tc.k.m;
	
	return kc.a;
}

float divfl(float a, float b)
{
	kuchfl ka, kb, kc;
	ka.a = a;
	kb.a = b;
	
	kc.k.s = (ka.k.s + kb.k.s) % 2;		// sign
	kc.k.e = (ka.k.e - kb.k.e) + 127;	// ea / eb + bias
	
	kuchfl_implicit ta, tb, tc;
	ta.k.m = ka.k.m;	// copy mantissa
	ta.k.m1 = 1;		// add hidden bit
	tb.k.m = kb.k.m;
	tb.k.m1 = 1;
	
	long long tmp = ta.i;
	tmp <<= 23;
	tmp /= tb.i;
	
	tc.i = tmp;
	while (tc.k.m1 < 1)	// preteceni mantissy
	{
		tc.i <<= 1;
		kc.k.e--;
	}
	kc.k.m = tc.k.m;
	
	return kc.a;
}

float addfl(float a, float b)
{
	kuchfl ka, kb, kc;
	ka.a = a;
	kb.a = b;
	
	int expA = ka.k.e - 127;
	int expB = kb.k.e - 127;
	
	kuchfl_implicit tA, tB;
	tA.k.m = ka.k.m;
	tA.k.m1 = 1;
	tB.k.m = kb.k.m;
	tB.k.m1 = 1;
	
	int exponentDiff = abs(expA - expB);
	if (expA < expB)
	{
		kc.k.e = kb.k.e;
		tA.i >>= exponentDiff;	// move the mantissa
	}
	else
	{
		kc.k.e = ka.k.e;
		tB.i >>= exponentDiff;	// move the mantissa
	}
	
	long long result = pow(-1, ka.k.s) * tA.i + pow(-1, kb.k.s) * tB.i;

	if (result < 0)
	{
		kc.k.s = 1;
		result *= -1;
	}
	else kc.k.s = 0;
	
	kuchfl_implicit tmp;
	tmp.i = result;

	while (tmp.k.m1 >= 2)	// overflow check
	{
		tmp.i >>= 1;
		kc.k.e++;
	}
	
	while (tmp.k.m1 < 1)
	{
		tmp.i <<= 1;
		kc.k.e--;
	}
	
	kc.k.m = tmp.k.m;
	
	return kc.a;
}

int main(int argc, char** argv)
{
	printf("%f\n", addfl(16.0f, -23.0f));

	return 0;
}
