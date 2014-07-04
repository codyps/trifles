/* vim: set noet sts=8 ts=8 sw=8: */
#include <stdio.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdbool.h>
#include <strings.h>
#include <limits.h>

#define TEST 1
#include <penny/test.h>

#define bit_width_max(bits) \
		((1ull << ((bits) - 1) << 1) - 1)

#define ROUND_UP_POW_OF_2X_M1(_val, _x)   ((_val) | bit_width_max(_x))
#define ROUND_DOWN_POW_OF_2X(_val, _x) (((_val) >> (_x)) << (_x))


/* from https://graphics.stanford.edu/~seander/bithacks.html */
__attribute__((__unused__))
static inline unsigned ctz_32(uint32_t v)
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

static unsigned fls_32(uint32_t v)
{
	if (!v)
	       return 0;
	return (CHAR_BIT * sizeof(unsigned) - __builtin_clz(v));
}

#define ALIGN_OF(x) ctz_32(x)
#define MIN(x, y) ((x) < (y) ? (x) : (y))

struct base_mask {
	uint32_t base, mask;
};

static struct base_mask match_range_fix_low(uint32_t edge, uint32_t max)
{
	uint32_t diff = max - edge;
	uint32_t diff_ls = fls_32(diff);
	uint32_t diff_tz = ctz_32(diff);
	uint32_t edge_tz = ctz_32(edge);
	uint32_t mask_shift = MIN(diff_ls, edge_tz);
	if (diff_tz)
		mask_shift --;
	uint32_t comp = edge;

	printf("%" PRIx32 " to %" PRIx32 " = %" PRIx32 " & %" PRIx32 "\n",
			edge, max, comp, (uint32_t)bit_width_max(mask_shift));

	return (struct base_mask){ comp, (uint32_t) bit_width_max(mask_shift) };
}

#define test_bm(a, b) test_eq_fmt_exp(a, b, BM_FMT, BM_EXP, BM_EQ)
#define BM(_b, _m) ((struct base_mask){ (_b), (_m) })
#define BM_FMT "%04" PRIx32 " & %04" PRIx32 ""
#define BM_EXP(a) (a).base, (a).mask
#define BM_EQ(a, b) (((a).base == (b).base) && ((a).mask == (b).mask))

#define test_match(_v, _mr) test(matches(_mr, _v))

static inline bool matches(struct base_mask bm, uint32_t v)
{
	return (v & ~bm.mask) == bm.base;
}

static inline uint32_t matcher_max(struct base_mask bm)
{
	printf("%" PRIx32" | %" PRIx32" = %" PRIx32"\n",
			bm.base, bm.mask, bm.base | bm.mask);
	return bm.base | bm.mask;
}

int main(void)
{
#if 0
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
#endif

	test_bm(BM(0xfff1, 0x0),  match_range_fix_low(0xfff1, 0xfff1));
	ok_eq(matcher_max(match_range_fix_low(0xfff1, 0xfff1)), 0xfff1);
	ok1(matches(match_range_fix_low(0xfff0, 0xfff1), 0xfff1));
	ok1(!matches(match_range_fix_low(0xfff0, 0xfff1), 0xfff2));
	ok1(!matches(match_range_fix_low(0xfff1, 0xfff1), 0xfff2));
	ok1(!matches(match_range_fix_low(0xfff1, 0xfff1), 0xfff0));
	test_bm(BM(0xffe0, 0xf),  match_range_fix_low(0xffe0, 0xfff0));
	ok_eq(matcher_max(match_range_fix_low(0xffe0, 0xfff1)), (uint32_t)0xfff1);
	test_bm(BM(0xffe0, 0x1f), match_range_fix_low(0xffe0, 0xffff));
	test_bm(BM(0xffe0, 0x1),  match_range_fix_low(0xffe0, 0xffe1));
	test_done();

	return 0;
}
