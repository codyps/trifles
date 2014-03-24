
#include <stdio.h>
#define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))

static void foo(int x[static 16])
{
	printf("%zu\n", ARRAY_SIZE(x));
}

int main(void)
{
	int x[16];
	foo(x);
	return 0;
}
