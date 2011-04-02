#include <stdio.h>

struct x {
	int y;
};

int main(void)
{
	struct x z = { 1 };
	struct x c = { 3 };

	printf("z == c = %d", z == c);

	return 0;
}
