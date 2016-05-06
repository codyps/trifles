#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
	if (argc != 3) {
		fprintf(stderr, "usage: %s <character number> <string>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	const unsigned long long pos = strtoull(argv[1], NULL, 0);
	char *str = argv[2];

	/* FIXME: we assume 8-bit characters when we probably have utf-8 */
	size_t cur_pos = 0;
	size_t line_num = 0;
	size_t char_in_line = 0;
	char *line = str;
	for (;;) {
		if (cur_pos == pos) {
			/* scan to end of line and then print line */
			char *end = str;
			for (;;) {
				if (*end == '\n' || *end == '\0') {
					*end = '\0';
					break;
				}
				end++;
			}
			puts(line);
			size_t i;
			for (i = 0; i < char_in_line; i++) {
				putchar(' ');
			}
			putchar('^');
			putchar('\n');
			return 0;
		}
		if (*str == '\0') {
			fprintf(stderr, "*** End of string, position not found (%zu lines, %zu chars)",
					line_num, cur_pos);
			exit(EXIT_FAILURE);
		}
		if (*str == '\n') {
			line_num++;
			line = str + 1;
			char_in_line = 0;
		}

		cur_pos ++;
		char_in_line ++;
		str ++;
	}

	return 0;
}
