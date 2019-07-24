#include <stdio.h>
#include <inttypes.h>

uint8_t z(uint32_t x)
{
	uint16_t y = x;
	uint8_t  z = x >> 4;
	uint8_t z2 = { x >> 4 };
	uint8_t z4 = 2.2;

	printf("%" PRIx16 "\n", z2 + y + z4);
	return z;
}
