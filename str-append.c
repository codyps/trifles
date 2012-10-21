#include <stdio.h>
#include <string.h>

int main(void)
{
	char p[5] = "hi";
	memmove(p, p+1, strlen(p));
	p[0] = '1';
	puts(p);
	return 0;
}
