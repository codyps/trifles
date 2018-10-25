#include <stdio.h>
#include "count.h"

#define A printf("A: %d\n", __COUNTER__)
#define B printf("B: %d\n", __COUNTER__)

int main(void)
{
	A; B; A; B; B; A;
	C; D; C; C; D; D;
	return 0;
}
