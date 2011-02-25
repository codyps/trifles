#include <stdio.h>

void test(int &a, int &b)
{
	a = 2;
	b = 12;
}

int main(int argc, char **argv)
{
	int x,y;
	test(x,y);
	printf("%d %d\n", x, y);
	return 0;
}

