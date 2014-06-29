
#include <stdio.h>

extern char __start_foosec[];
extern char __stop_foosec[];
int foo __attribute__((section("foosec")));


extern char __start_test_align[];
extern char __stop_test_align[];
int main(void)
{
#define P(n) printf("%p to %p, size = %zu\n", __start_##n, __stop_##n, __stop_##n - __start_##n)
	P(foosec);
	P(test_align);
	return 0;
}
