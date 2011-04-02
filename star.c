#include <stdio.h>

#define ABS(x) ((x < 0)?-(x):(x))

void pst(int lct, int width)
{
	int i;
	int odd = (width % 2) != 0;
	int stars = (lct + 1) * 2 - odd;
	int spaces = width - lct - odd;

	int dec = (lct + 1) > (width - odd);

	for (i = 0; i < ABS(spaces); i++) {
		putchar(' ');
	}

	for (i = 0; i < ABS(stars); i++) {
		putchar('*');
	}
}


int main(int argc, char **argv)
{
	int width;
	if (argc < 2)
		return -1;
	int ret = sscanf(argv[1], "%d", &width);

	if (ret != 1)
		return -2;

	int lines = 0;
	int line_max = (width % 2) ? width : width - 1;
	for (lines = 0; lines < line_max; lines++) {
		pst(lines, width);
		putchar('\n');
	}

	return 0;
}
