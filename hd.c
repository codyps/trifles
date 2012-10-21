#include <stdio.h>
#include <poll.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define COLS 80

int main(void)
{
	struct pollfd pfd[1];
	pfd[0].fd = fileno(stdin);
	pfd[0].events = POLLIN;

	int r;

	int c_per_line = 0;

	char buf[4096];

	for(;;) {
		r = poll(pfd, 1, -1);
		if (r == -1) {
			fprintf(stderr, "\nerror: %s\n", strerror(errno));
			exit(1);
		} else if (r == 1) {
			ssize_t rsz = read(pfd[0].fd, buf, sizeof(buf));
			size_t i;
			for (i = 0; i < rsz; i++) {
				if (c_per_line > COLS) {
					c_per_line = 0;
					putchar('\n');
				}
				printf("%x", buf[i]);
				c_per_line ++;
			}
			fflush(stdout);
		} else {
			fprintf(stderr, "\nerror: unknown r=%d\n", r);
			exit(1);
		}

	}

	return 0;

}
