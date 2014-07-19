#include <stdio.h>

struct S {
	int y [30];
};
int main(void)
{
	struct S s;
	s.y = (int[]) { 1, 3, 4};
	return 0;
}
