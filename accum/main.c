#include <stdio.h>

int main(void)
{
	unsigned Z_A = 0;
	unsigned Z_B = 0;

#define A(l, n) Z_##l = n | Z_##l,
	#include "a.def"
#undef A

	printf("A = %u, B = %u\n", Z_A, Z_B);

	return 0;
}
