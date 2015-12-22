#include <limits.h>

int main(int argc, char **argv)
{
	(void)argv;
	int x = argc + 1 + INT_MAX;
	return x;
}
