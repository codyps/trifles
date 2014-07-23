
#include <stdio.h>


void foo(void);
void bar(void);

__attribute__((externally_visible))
void (*vect[])(void) = {
	foo,
	bar
};

int main(void)
{
	size_t i;
	for (i = 0; i < sizeof(vect) / sizeof(vect[0]); i++)
		vect[i]();

	return 0;
}
