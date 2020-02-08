#include <stdio.h>
#include <inttypes.h>
int main(void)
{
	uint32_t a = 0xfffffffa,
		 b = 0x2;
	printf("sub2: %" PRIx32 "\n", b - a);
	return 0;
}
