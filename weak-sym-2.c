
#include <stdio.h>
void foo(void) __attribute__((weak, alias("magic")));

void magic(void)
{
	printf("HI\n");
}
