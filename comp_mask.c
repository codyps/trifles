/* vim: set noet sts=8 ts=8 sw=8: */
#include <stdio.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdbool.h>
#include <strings.h>
#include <limits.h>
#include <penny/print.h>
#include <assert.h>

#define TEST 1
#include <penny/test.h>

#if 0
#if defined(__GNUC__)
/* gcc's __builtin_{clz,ctz}() are undefined if v == 0 */
# define builtin_clz(v) (v ? __builtin_clz(v) : (sizeof(v) * CHAR_BIT))
# define builtin_ctz(v) (v ? __builtin_ctz(v) : (sizeof(v) * CHAR_BIT))
#elif defined(__ICCARM__)
# include <intrinsics.h>
/* emits the ARM instruction, which returns 32 if no bits are set */
# define builtin_clz(v) __CLZ(v)
# define builtin_ctz(v) __CLZ(__RBIT(v))
#else
# warning "Unrecognized compiler"
#endif
#endif

/* assert(bits < (sizeof(1ull) * CHAR_BIT))
 * nf = "not full" */
#define bit_mask_nf(bits) ((UINTMAX_C(1) << (bits)) - 1)
/* assert(bits > 0) */
//#define bit_mask_nz(bits) ((UINTMAX_C(1) << ((bits) - 1) << 1) - 1)
static inline uintmax_t bit_mask_nz(unsigned bits)
{
	return (UINTMAX_C(1) << ((bits) - 1) << 1) - 1;
}

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

unsigned ffs_32(uint32_t v)
{
	return (CHAR_BIT * sizeof(v)) - clz_32(v);
}

unsigned ffs_r1_32(uint32_t v)
{
	if (!v)
		return 32;
	return ffs_32(v) - 1;
}

static bool do_print = false;
#define ALIGN_OF(x) ctz_32(x)
#define CPV(x) do {		\
	if (do_print)		\
		PV(x);		\
} while (0)

static unsigned maskn_from_range_low(uint32_t base, uint32_t max)
{
	assert(base <= max);
	unsigned base_tz = ctz_32(base);
	uint32_t mask_1 = bit_mask(base_tz);
	uint32_t masked_max = max & mask_1;
	unsigned log_of_max_masked = ffs_r1_32(masked_max + 1);

	return log_of_max_masked;
}

static unsigned maskn_from_range_high(uint32_t base, uint32_t min)
{
	assert(base >= min);
	unsigned base_ones = ctz_32(~base);
	uint32_t diff = base - min;
	uint32_t masked_diff = diff & bit_mask(base_ones);
	unsigned mask_bits = ffs_r1_32(masked_diff + 1);
	return mask_bits;
}

static unsigned maskn_from_range(uint32_t base, uint32_t limit)
{
	if (base < limit)
		return maskn_from_range_low(base, limit);
	else
		return maskn_from_range_high(base, limit);
}

static inline bool maskn_matches(uint32_t base, unsigned mask_bits, uint32_t v)
{
	uint32_t m = ~bit_mask(mask_bits);
	return (v & m) == (base & m);
}

static inline uint32_t maskn_max(uint32_t base, unsigned mask_bits)
{
	return base | bit_mask(mask_bits);
}

static inline uint32_t maskn_min(uint32_t base, unsigned mask_bits)
{
	return base & ~bit_mask(mask_bits);
}

int main(void)
{
	ok_eq(0, maskn_from_range_low(0xfff1, 0xfff1));

#define MFRL(base, max) maskn_min(base, maskn_from_range_low(base, max)), maskn_from_range_low(base, max)
	ok1( maskn_matches(MFRL(0xfff0, 0xfff1), 0xfff1));
	ok1(!maskn_matches(MFRL(0xfff0, 0xfff1), 0xfff2));
	ok1(!maskn_matches(MFRL(0xfff1, 0xfff1), 0xfff2));
	ok1(!maskn_matches(MFRL(0xfff1, 0xfff1), 0xfff0));

	ok_eq(4,	maskn_from_range_low(0xffe0, 0xfff0));

	ok_eq(5,	maskn_from_range_low(0xffe0, 0xffff));
	ok_eq(1,	maskn_from_range_low(0xffe0, 0xffe1));

	ok_eq(16,	maskn_from_range_high(0xffff, 0));
	ok_eq(15,	maskn_from_range_high(0xffff, 1));
	ok_eq(0,	maskn_from_range_high(0xfffe, 1));

	do_print = true;
	ok_eq(32,	maskn_from_range_low(0, UINT32_MAX));
	do_print = false;

	ok_eq(0,	maskn_from_range(0, 0));
	ok_eq(32,	maskn_from_range(0, UINT32_MAX));
	ok_eq(32,	maskn_from_range(UINT32_MAX, 0));

	ok_eq(0,	maskn_from_range(UINT32_MAX & ~INT32_C(1), 0));
	ok_eq(31,	maskn_from_range(UINT32_MAX >> 1, 0));


	ok_eq(ctz_32(0), 32);
	ok_eq(ctz_32(1), 0);
	ok_eq(ctz_32(2), 1);
	ok_eq(ctz_32(UINT32_MAX - 1), 1);
	ok_eq(ctz_32(UINT32_MAX >> 1), 0);

	ok_eq(clz_32(0), 32);
	ok_eq(clz_32(1), 31);
	ok_eq(clz_32(2), 30);
	ok_eq(clz_32(UINT32_MAX - 1), 0);
	ok_eq(clz_32(UINT32_MAX >> 1), 1);

	ok_eq(bit_mask(0), 0);
	ok_eq(bit_mask(1), 1);
	ok_eq(bit_mask(32), UINT32_MAX);

	ok_eq(ffs_r1_32(0), 32);
	ok_eq(ffs_r1_32(1), 0);
	ok_eq(ffs_r1_32(UINT32_MAX), 31);
	ok_eq(ffs_r1_32(UINT32_MAX >> 1), 30);

	test_done();
	return 0;
}
