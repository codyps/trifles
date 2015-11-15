#include <sys/socket.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>


int main(int argc, char **argv)
{
	const char *file = "test";
	if (argc == 2)
		file = argv[1];

	int f = open(file, O_CREAT | O_RDWR);
	if (f < 0) {
		printf("open(%s) error: %d %d %s\n", file, f, errno, strerror(errno));
		return -1;
	}

	const char *foo = "foo";
	/*
	 * Doesn't work because who would want flags on a per-call level for files?
	 */
	int r = send(f, foo, strlen(foo), MSG_DONTWAIT);
	if (r < 0) {
		printf("send() error: %d %d %s\n", r, errno, strerror(errno));
		return -2;
	}

	return 0;
}
