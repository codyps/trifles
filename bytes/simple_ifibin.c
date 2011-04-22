#include <stdio.h>
#include <unistd.h> /* ssize_t */

int main(int argc, char **argv)
{
	char *line = NULL;
	size_t mem = 0;
	unsigned addr = 0;
	int line_num = 0;
	unsigned l[16];


	for (;;) {
		ssize_t r = getline(&line, &mem, stdin);

		if (r < 0)
			return -1;

		if (r == 0)
			return 0;
		/*                     0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 *
		 *                034070 32 7F 2C 20 64 8E 61 6E 6F 60 6D 3B AF 24 74 2D */
		int f = sscanf(line, "%X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X %X",
				&addr, l, l+1, l+2, l+3, l+4, l+5, l+6, l+7, l+8,
				l+9, l+10, l+11, l+12, l+13, l+14, l+15);


		if (f != 17) {
			fprintf(stderr, "%d: not enough fields matched", line_num);
		}

		size_t i;
		for (i = 0; i < 16; i++) {
			putchar(l[i]);
		}

		line_num++;
	}
}
