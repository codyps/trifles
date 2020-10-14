/*
 * Based on ccan/grab_file, which is:
 *
 * Licensed under LGPLv2+ - see LICENSE file for details
 */
#include "grab_file.h"
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>

void *grab_fd(int fd, size_t *size)
{
	int ret;
	size_t max, s;
	char *buffer;
	struct stat st;

	if (!size)
		size = &s;
	*size = 0;

	if (fstat(fd, &st) != 0 && S_ISREG(st.st_mode))
		max = st.st_size;
	else
		max = 16384;

	buffer = malloc(max+1);
	while ((ret = read(fd, buffer + *size, max - *size)) > 0) {
		*size += ret;
		if (*size == max) {
			void *nb = realloc(buffer, max*2+1);
			if (!nb) {
				nb = realloc(buffer, max + 1024*1024 + 1);
				if (!nb) {
					free(buffer);
					return NULL;
				}
				max += 1024*1024;
			} else
				max *= 2;
			buffer = nb;
		}
	}
	if (ret < 0) {
		free(buffer);
		buffer = NULL;
	} else
		buffer[*size] = '\0';

	return buffer;
}

void *grab_file(const char *filename, size_t *size)
{
	int fd;
	void *buffer;

	if (!filename)
		fd = dup(STDIN_FILENO);
	else
		fd = open(filename, O_RDONLY, 0);

	if (fd < 0)
		return NULL;

	buffer = grab_fd(fd, size);
	close(fd);
	return buffer;
}
