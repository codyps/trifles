/* vim: set noet sts=8 ts=8 sw=8: */
#include <stdio.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdbool.h>
#include <strings.h>
#include <limits.h>
#include <penny/print.h>

#define TEST 1
#include <penny/test.h>

/* assert(bits < (sizeof(1ull) * CHAR_BIT))
 * nf = "not full" */
#define bit_mask_nf(bits) ((UINTMAX_C(1) << (bits)) - 1)
/* assert(bits > 0) */
#define bit_mask_nz(bits) ((UINTMAX_C(1) << ((bits) - 1) << 1) - 1)

static inline uintmax_t bit_mask(unsigned bits)
{
	return bits ? bit_mask_nz(bits) : 0;
}

#if 0
#define bit_mask(bits) ({			\
	__typeof__(bits) __bm_bits = (bits);	\
	__bm_bits ? bit_mask_nz(__bm_bits) : 0;	\
})
#endif

#define ROUND_UP_POW_OF_2X_M1(_val, _x)   ((_val) | bit_width_max(_x))
#define ROUND_DOWN_POW_OF_2X(_val, _x) (((_val) >> (_x)) << (_x))

/* from https://graphics.stanford.edu/~seander/bithacks.html */
unsigned ctz_32(uint32_t v)
{
#ifdef builtin_ctz
	return builtin_ctz(v);
#else
	unsigned c;
	if (!v)
		return 32;
	if (v & 0x1)
		return 0;
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
	return c;
#endif
}

unsigned clz_32(uint32_t v)
{
#ifdef builtin_clz
	return builtin_clz(v);
#else
	unsigned c = 0;
	if (!v)
		return 32;
	if ((v & 0xffff0000) == 0) {
		c += 16;
		v <<= 16;
	}
	if ((v & 0xff000000) == 0) {
		c += 8;
		v <<= 8;
	}
	if ((v & 0xf0000000) == 0) {
		c += 4;
		v <<= 4;
	}
	if ((v & 0xc0000000) == 0) {
		c += 2;
		v <<= 2;
	}
	if ((v & 0x80000000) == 0) {
		c += 1;
	}
	return c;
#endif
}

unsigned fls_32(uint32_t v)
{
	return ((CHAR_BIT * sizeof(v)) - clz_32(v));
}

static unsigned ilog_32(uint32_t v)
{
	return fls_32(v) - 1;
}

#define ALIGN_OF(x) ctz_32(x)

struct base_mask {
	uint32_t base, mask;
};

static struct base_mask match_range_fix_low(uint32_t base, uint32_t max)
{
	unsigned base_tz = ctz_32(base);
	uint32_t mask_1 = bit_mask(base_tz);
	uint32_t masked_max = max & mask_1;
	unsigned log_of_max_masked = ilog_32(masked_max + 1);
	uint32_t final_mask = bit_mask(log_of_max_masked);

	return (struct base_mask){ base, final_mask };
}

static struct base_mask match_range_fix_high(uint32_t base, uint32_t min)
{
	unsigned base_ones = ctz_32(~base);
	uint32_t diff = base - min;
	uint32_t masked_diff = diff & bit_mask(base_ones);
	unsigned mask_bits = ilog_32(masked_diff + 1);
	uint32_t mask = bit_mask(mask_bits);
	uint32_t final_base = base & ~mask;

	return (struct base_mask){ final_base, mask};
}

#define test_bm(a, b) test_eq_fmt_exp(a, b, BM_FMT, BM_EXP, BM_EQ)
#define BM(_b, _m) ((struct base_mask){ (_b), (_m) })
#define BM_FMT "%04" PRIx32 " & %04" PRIx32 ""
#define BM_EXP(a) (a).base, (a).mask
#define BM_EQ(a, b) (((a).base == (b).base) && ((a).mask == (b).mask))

static inline bool matches(struct base_mask bm, uint32_t v)
{
	return (v & ~bm.mask) == bm.base;
}

static inline uint32_t matcher_max(struct base_mask bm)
{
	return bm.base | bm.mask;
}

int main(void)
{
	test_bm(BM(0xfff1, 0x0),  match_range_fix_low(0xfff1, 0xfff1));
	ok_eq(matcher_max(match_range_fix_low(0xfff1, 0xfff1)), 0xfff1);
	ok1(matches(match_range_fix_low(0xfff0, 0xfff1), 0xfff1));
	ok1(!matches(match_range_fix_low(0xfff0, 0xfff1), 0xfff2));
	ok1(!matches(match_range_fix_low(0xfff1, 0xfff1), 0xfff2));
	ok1(!matches(match_range_fix_low(0xfff1, 0xfff1), 0xfff0));

	test_bm(BM(0xffe0, 0x0f),  match_range_fix_low(0xffe0, 0xfff0));
	ok_eq(matcher_max(match_range_fix_low(0xffe0, 0xfff1)), (uint32_t)0xffef);

	test_bm(BM(0xffe0, 0x1f), match_range_fix_low(0xffe0, 0xffff));
	test_bm(BM(0xffe0, 0x1),  match_range_fix_low(0xffe0, 0xffe1));

	test_bm(BM(0, 0xffff),		match_range_fix_high(0xffff, 0));
	test_bm(BM(0x8000, 0x7fff),	match_range_fix_high(0xffff, 1));
	test_bm(BM(0xfffe, 0),	match_range_fix_high(0xfffe, 1));
	ok_cmp(matcher_max(match_range_fix_high(0xfffe, 1)), <=,  0xfffeu);

	test_done();

	return 0;
}
