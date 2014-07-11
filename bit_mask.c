#include <stdint.h>
#include <limits.h>

static uintmax_t bit_mask_nz(unsigned bits)
{
	return (UINTMAX_C(1) << ((bits) - 1) << 1) - 1;
}

/**
 * bit_mask - given a number of bits, returns a left justified bit mask with
 *            that many bits set
 *
 * Note that the number of bits must be less than or equal to CHAR_BIT *
 * sizeof(uintmax_t), ie: the number of bits in a uintmax_t.
 */
uintmax_t bit_mask(unsigned bits)
{
	return bits ? bit_mask_nz(bits) : 0;
}

uintmax_t bit_mask2(unsigned bits)
{
	if (bits >= CHAR_BIT * sizeof(uintmax_t))
		return UINTMAX_C(-1);
	else
		return ~(UINTMAX_MAX << bits);
}

int main(void)
{
	return 0;
}
