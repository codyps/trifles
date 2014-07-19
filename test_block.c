#include <stdio.h>

int main(void)
{
	void (^y)(void) = ^ { printf("HI\n"); };
	y();
	return 0;
}
