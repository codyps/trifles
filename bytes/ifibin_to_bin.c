#include <stdio.h>

#define ERROR(fmt, ...) do {			\
	fprintf(stderr, fmt, ## __VA_ARGS__);	\
} while(0)

int parse_line(line

int main(int argc, char **argv)
{
	char *line = NULL;
	size_t line_mem = 0;

	for (;;) {
		size_t ret = getline(&line, &line_mem, stdin);

		if (ret < 0) {
			ERROR("got %zd", ret);
			break;

		int r;
		if ((r = parse_line(line, ret))) {
			ERROR("got %d", ret);
			break;
		}
	}

	return 0;

}
