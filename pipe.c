#include <unistd.h>
#include <stdio.h>

int main(void)
{
	int fd[2];
	char buf[256];
	pipe(fd);
	if (fork()) {
		puts("a");
		puts("a ping");
		write(fd[0], "a", 1);
		read(fd[1], buf, 1);
		puts("a pong, done");
	} else {
		puts("b");
		read(fd[1], buf, 1);
		puts("b pong, ping");
		write(fd[0], "b", 1);
		puts("b done");
	}

	return 0;
}
