#define _GNU_SOURCE 1
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

int main(void) {
	int fd = open("tmp.bin", O_RDWR|O_CREAT);
	if (fd < 0) {
		fprintf(stderr, "E: could not open tmp.bin: %s\n", strerror(errno));
		return -1;
	}

	off_t soffs = lseek(fd, 10ull * 1024 * 1024 * 1024, SEEK_SET);
	if (soffs < 0) {
		fprintf(stderr, "E: could not seek 1: %s\n", strerror(errno));
		return -1;
	}

	unsigned char buf[1] = { 0 };
	ssize_t rs = write(fd, buf, sizeof(buf));
	if (rs < 0) {
		fprintf(stderr, "E: could not write 1 byte (0): %s\n", strerror(errno));
		return -1;
	}

	soffs = lseek(fd, 0, SEEK_SET);
	if (soffs < 0) {
		fprintf(stderr, "E: could not seek to start: %s\n", strerror(errno));
		return -1;
	}

	off_t c_offs = 0;
	for (;;) {
		soffs = lseek(fd, c_offs, SEEK_DATA);
		if (soffs < 0) {
			if (errno == ENXIO) {
				printf("ENXIO\n");
				soffs = lseek(fd, 0, SEEK_END);
				if (soffs < 0) {
					fprintf(stderr, "E: could not find end after ENXIO: %s\n", strerror(errno));
					return -1;
				}
				printf("END: %ju\n", (uintmax_t)soffs);
				return 0;
			} else {
				fprintf(stderr, "E: seek data at offs %ju failed: %s\n", (uintmax_t)c_offs, strerror(errno));
				return -1;
			}
		}

		printf("DATA: %ju to %ju\n", (uintmax_t)c_offs, (uintmax_t)soffs);
		c_offs = soffs;

		soffs = lseek(fd, c_offs, SEEK_HOLE);
		if (soffs < 0) {
			fprintf(stderr, "E: seek hole at %ju failed: %s\n", (uintmax_t)c_offs, strerror(errno));
			return -1;
		}

		printf("HOLE: %ju to %ju\n", (uintmax_t)c_offs, (uintmax_t)soffs);
		c_offs = soffs;
		if (soffs == 0) {
			printf("I: zero size hole, done\n");
			break;
		}
	}

	return 0;
}
