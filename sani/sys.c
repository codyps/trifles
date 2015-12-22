#include <stddef.h>

void _exit(int i)
{
	(void)i;
	for (;;)
		;
}

int _getpid(void)
{
	return 0;
}

int _kill(int pid, int sig)
{
	(void)pid;
	(void)sig;
	return -1;
}

void *_sbrk(size_t incr)
{
	(void)incr;
	return NULL;
}
