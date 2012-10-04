#define _XOPEN_SOURCE 500 /* for pread */

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/stat.h>
#include <sys/inotify.h>

#define DO_PATH "/sys/kernel/debug/debugfs-test/do-it"

int get_attr(int fd, long long *val, int base)
{
	char data[24];
	ssize_t r = pread(fd, data, sizeof(data), 0);
	if (r < 1) {
		*val = -1;
		return -1;
	}

	errno = 0;
	*val = strtoll(data, NULL, base);
	if (errno) {
		*val = -2;
		return -1;
	}

	return 0;
}

int get_attr_by_path(const char *path, long long *val, int base)
{
	int ret = 0, fd = open(path, O_RDONLY);
	if (fd < 0) {
		*val = -3;
		ret = -1;
		goto e_close;
	}

	ret = get_attr(fd, val, base);

e_close:
	close(fd);
	return ret;
}

void read_val(int fd)
{
	long long v;
	int ret = get_attr(fd, &v, 10);
	if (ret < 0) {
		fprintf(stderr, "failed to get attr: %s\n", strerror(errno));
		return;
	}

	printf("initial value = %lld\n", v);
}

int main(int argc, char **argv)
{
	int ifd = inotify_init();
	if (ifd < 0) {
		fprintf(stderr, "failed to initialize inotify: %d %d : %s\n", ifd, errno, strerror(errno));
		return 1;
	}

	int ret = inotify_add_watch(ifd, DO_PATH, IN_MODIFY);
	if (ret < 0) {
		fprintf(stderr, "failed to add watch: %s\n", strerror(errno));
		return 2;
	}


	int fd = open(DO_PATH, O_RDWR);
	if (fd < 0) {
		fprintf(stderr, "failed to open file: %s\n", strerror(errno));
		return 3;
	}

	read_val(fd);
	read_val(fd);

	for(;;) {
		struct inotify_event evbuf[1];
		ssize_t r = read(ifd, evbuf, sizeof(evbuf));
		if (r != sizeof(evbuf)) {
			fprintf(stderr, "failed to read event: %s\n", strerror(errno));
			return 4;
		}

		printf("It changed?\n");
		read_val(fd);
	}

	return 0;
}
