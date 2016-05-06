#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <limits.h>

#include <sys/stat.h>
#include <fcntl.h>

#include <linux/input.h>

int main(int argc, char **argv)
{
	if (argc < 1) {
		fprintf(stderr, "usage: %s <event-dev>...\n",
				argv[0]);
		return 1;
	}

	int i;
	for (i = 1; i < argc; i++) {
		const char *dev = argv[i];
		int fd = open(dev, O_RDONLY);
		if (fd == -1) {
			fprintf(stderr, "could not open '%s': %s\n", dev, strerror(errno));
			continue;
		}

		unsigned long keys[KEY_MAX / sizeof(unsigned long) / CHAR_BIT];

		int r = ioctl(fd, EVIOCGKEY(sizeof(keys)), keys);
		if (r == -1) {
			fprintf(stderr, "could not retrieve keys from '%s': %s\n", dev, strerror(errno));
			continue;
		}
		printf("[%s]\n", dev);
		size_t j;
		size_t num_longs = r / sizeof(unsigned long);
		for (j = 0; j < num_longs; j++) {
			printf("%lX%c", keys[j], (j + 1) == num_longs ? '\n' : ':');
		}
	}

	return 0;
}
