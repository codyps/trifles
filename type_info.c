#include "penny/type_info.h"
#include <stdio.h>

int main(void)
{
	unsigned i;
	for (i = 0; i < sizeof(0ull); i++) {
		unsigned long long m = byte_width_max(i);
		unsigned long long s1 = byte_width_max_2c(i);
		unsigned long long s2 = byte_width_max_2c_2(i);
		printf("%u : %llu %llu %llu\n", i, m, s1, s2);
	}
	return 0;
}
