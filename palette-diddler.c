#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <linux/kd.h>

int main(int argc, char **argv)
{
	int fd;
	char palette[16][3];
	int idx, r, g, b;

	if ((fd = open("/dev/tty0", O_RDWR)) < 0) {
		perror("open");
		exit(1);
	}
	if (ioctl(fd, GIO_CMAP, &palette) < 0) {
		perror("ioctl");
		exit(1);
	}
	
	for(idx = 0; idx < 16; idx++) {
		printf("%02x%02x%02x\n", palette[idx][0] & 0xFF,
				palette[idx][1] & 0xFF,
				palette[idx][2] & 0xFF);
	}
	/*
	while(fscanf(stdin, "%d %02x%02x%02x\n", &idx, &r, &g, &b) == 4) {
		if ((idx < 0) && (idx > 15)) {
			fprintf(stderr, "value out of range\n");
			exit(1);
		}
		palette[idx][0] = r;
		palette[idx][1] = g;
		palette[idx][2] = b;
	}
	if (ioctl(fd, PIO_CMAP, &palette) < 0) {
		perror("ioctl");
		exit(1);
	}
	*/
	exit(0);
}
