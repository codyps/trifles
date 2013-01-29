#ifndef PENNY_FD_H_
#define PENNY_FD_H_ 1

#include <unistd.h>
#include <fcntl.h>

static inline int fd_set_nonblock(int fd)
{
	int r;
	int flags = fcntl(fd, F_GETFL, 0);
	if (flags == -1) {
		return -1;
	}

	r = fcntl(fd, F_SETFL, flags | O_NONBLOCK);
	if (r == -1) {
		return -2;
	}
	return 0;
}

#endif
