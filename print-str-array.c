#include <stdio.h>

static char hmap[] = {
	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
};

static void puth2(unsigned char c, FILE *f) {
	putc(hmap[c], f);
}

static void puth(unsigned char c, FILE *f) {
	puth2((c & 0xf0) >> 4, f);
	puth2(c & 0x0f, f);
}

static void print_str_array(int argc, char **argv, FILE *f) {
	int i = 0;
	for (;;) {
		putc('\'', f);
		char *arg = argv[i];
		char c;
		while ((c = *arg++)) {
			if (c == '\'') {
				fputs("'\''", f);
			} else if (isprint(c)) {
				fputc(c, f);
			} else {
				fputc('\\', f);
				puth(c, f);
			}
		}
		putc('\'', f);

		i++;
		if (i == argc)
			break;

		putc(' ', f);
	}
}
