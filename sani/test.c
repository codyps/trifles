#include <limits.h>
#include <stdint.h>

int main(int argc, char **argv)
{
	(void)argv;
	int x = argc + 1 + INT_MAX;
	intmax_t v = (argc + 1) * INTMAX_MAX;
	return x | v;
}
