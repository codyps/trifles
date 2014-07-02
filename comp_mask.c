/* vim: set noet sts=8 ts=8 sw=8: */
#include <stdio.h>
#include <inttypes.h>
#include <stdint.h>

#define ROUND_UP_POW_OF_2X(_val, _x) 
#define ROUND_DOWN_POW_OF_2X(_val, _x) ((_val) & ((~0LLU) << (_x)))


int main(void)
{
	uint32_t i = UINT32_MAX;
	int mask_shift;
	uint32_t mask;
	do {
		for (mask_shift = 0; mask_shift < 0xf; mask_shift++) {
			mask = (~0) << mask_shift;
			printf ("%#" PRIx32 "-%#" PRIx32 " ", i & mask, i | ((1 << mask_shift) - 1) );
		}
		putchar('\n');
	} while (i--);

	return 0;
}
