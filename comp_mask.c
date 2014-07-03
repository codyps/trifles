/* vim: set noet sts=8 ts=8 sw=8: */
#include <stdio.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdbool.h>

#define bit_width_max(bits) \
		((1ull << ((bits) - 1) << 1) - 1)

#define ROUND_UP_POW_OF_2X_M1(_val, _x)   ((_val) | bit_width_max(_x))
#define ROUND_DOWN_POW_OF_2X(_val, _x) (((_val) >> (_x)) << (_x))


/* from https://graphics.stanford.edu/~seander/bithacks.html */
__attribute__((__unused__))
static inline uint32_t ctz_32(uint32_t v)
{
	unsigned c;     // c will be the number of zero bits on the right,
	// so if v is 1101000 (base 2), then c will be 3
	// NOTE: if 0 == v, then c = 31.
	if (v & 0x1)
		c = 0;
	else {
		c = 1;
		if ((v & 0xffff) == 0) {
			v >>= 16;
			c += 16;
		}
		if ((v & 0xff) == 0) {
			v >>= 8;
			c += 8;
		}
		if ((v & 0xf) == 0) {
			v >>= 4;
			c += 4;
		}
		if ((v & 0x3) == 0) {
			v >>= 2;
			c += 2;
		}
		c -= v & 0x1;
	}

	return c;
}

#define ALIGN_OF(x) ctz_32(x)

void match_range(unsigned edge, unsigned max, unsigned fudge)
{
	if (edge < max) {
		/* Find fence such that: */
		/* edge < fence < MIN(edge + fudge, max)
		 * edge < fence_right < max
		 */
		ALIGN_OF(start)


	} else {


	}
}


int main(void)
{
	uint32_t i = UINT32_MAX >> 16;
	int mask_shift;
	uint32_t mask;
	do {
		for (mask_shift = 0; mask_shift <= 0xf; mask_shift++) {
			mask = (~0) << mask_shift;
			printf ("%04" PRIx32 "-%04" PRIx32 " ", i & mask, i | ((1 << mask_shift) - 1) );
		}
		putchar('\n');
	} while (i--);

	return 0;
}
