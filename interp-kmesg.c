#include <stdio.h>
#include <stdbool.h>
#include <penny/math.h>

int main(void)
{
	char *line = NULL;
	size_t line_sz = 0;
	ssize_t line_len;

	int prev_lvl = -2;
	int lvl = -1;

	while ((line_len = getline(&line, &line_sz, stdin)) > 0) {
		bool split = true;
		prev_lvl = lvl;
		size_t skips = 0;

		/* check for '<' N '>' */
		if (line_len >= 3)
			if (line[0] == '<' && line[2] == '>') {
				lvl = line[1] - '0';
				skips += 3;
			} else {
				fprintf(stderr, "[E]: level not recognized\n");
				goto spit_it_out;
			}
		else {
			fprintf(stderr, "[E]: line too short\n");
			goto spit_it_out;
		}


		/* check of '<d>' following '<N>' */
		if (line_len >= 6 &&
				line[3] == '<' &&
				line[4] == 'd' &&
				line[5] == '>' &&
				lvl == prev_lvl) {
			split = false;
			skips += 3;
		} else
			split = true;

spit_it_out:
		if (split)
			putchar('\n');

		fwrite(line + skips, SUB_SAT(line_len, skips), 1, stdout);
	}

	return 0;
}
