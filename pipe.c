#include <unistd.h>
#include <stdio.h>

#define CHK_NON_NEG(x) do {	\
	typeof(x) __r = x;	\
	if (__r < 0) {		\
		printf(" bad value for \"%s\" :  %lld\n", #x, (long long) __r);	\
	}			\
} while(0)

#define C CHK_NON_NEG

int main(void)
{
	int fd[2];
	char buf[1];
	pipe(fd);
	pipe(fd);
	if (fork()) {
		puts("a");
		puts("a ping");
		C(write(fd[0], "a", 1));
		C(read(fd[1], buf, 1));
		printf("a pong (%d), done\n", buf[0]);
	} else {
		puts("b");
		C(read(fd[1], buf, 1));
		printf("b pong (%d), ping\n", buf[0]);
		C(write(fd[0], "b", 1));
		puts("b done");
	}

	return 0;
}
