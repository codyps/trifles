#include <math.h>
#include <inttypes.h>
#include <limits.h>
#include <stdio.h>

#define __u64 uint64_t
#define __u32 uint32_t
#include <xfs/bitops.h> /* fls & fls64 */

static uintmax_t
slow_log2(uintmax_t x)
{
#if 0
	uintmax_t i = 0;
	while (x >>= 1)
		i++;

	return i;
#endif
	if (x == 0)
		return sizeof(uintmax_t) * CHAR_BIT;
	if (x == 1)
		return 0;
	uintmax_t i = 0;
	while (x > 1) {
		x >>= 1;
		i++;
	}

	return i;
}

static uintmax_t
fast_log2(uintmax_t x)
{
	return sizeof(uintmax_t) * CHAR_BIT - (__builtin_clzll(x) + 1);
}

int
main(void)
{
	uintmax_t e = 0;
	uintmax_t i = 0;

	do {
		long double l = log2l(i + 1);
		uintmax_t f1 = ((uintmax_t)floorl(l)) + 1;
		uintmax_t c  = ceill(l);
		uintmax_t il = fast_log2(i);
		uintmax_t ils = slow_log2(i);
		uintmax_t flsx = fls64(i);

		printf("<%5ju> f1=%2ju c=%2ju il=%2ju ils=%2ju flsx=%2ju\n",
				i, f1, c, il, ils, flsx);

		if (f1 != c || il != f1 || f1 != ils) {
			fprintf(stderr, "MISMATCH: %5ju: f1=%2ju c=%2ju il=%2ju ils=%2ju flsx=%2ju\n",
					i, f1, c, il, ils, flsx);
			e++;
			if (e > 10)
				return -1;
		}
	} while (i++ < UINTMAX_MAX);

	return 0;
}
