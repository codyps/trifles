#include <limits.h>
#include <stdint.h>

int main(int argc, char **argv)
{
	(void)argv;
	int x = argc + 1 + INT_MAX;
	intmax_t v = (argc + 1) * INTMAX_MAX;
	x = INT_MIN;
	x -= 2 + argc;
	int8_t y = INT8_MIN;
	y -= 2 + argc;
	return x | v | y;
}
