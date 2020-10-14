#ifndef PENNY_MATH_H_
#define PENNY_MATH_H_

#include <stdint.h>
#include <limits.h>
#include <stdint.h>
#include <assert.h>
#include <stdbool.h>

/*
 * per https://en.wikipedia.org/wiki/Find_first_set
 */
#define ctz_via_lg(x, lg)  (lg((x) & -(x)))
#define ctz_via_ffs(x, ffs) (ffs(x) - 1)
#define lg_via_clz(x, clz)  (sizeof(x) * CHAR_BIT - 1 - clz(x))
#define ffs_via_clz(x, clz) (sizeof(x) * CHAR_BIT - clz((x) & -(x)))

#include <penny/penny.h> /* llu */

/* potential for overflow when doing (n + d - 1) */
#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
#if 0
/* If n == 0, does not result in 0 like it should.  */
#define DIV_ROUND_UP(n,d) (((n) - 1)/(d) + 1)
#define DIV_ROUND_UP(n,d) ((n) / (d) + ((n)%(d) ? 1 : 0))
#endif

#if 0
/* @d is assumed to be positive.
 * If @n is negative, this results in 0.
 * Otherwise, DIV_ROUND_UP is used normally
 */
#define DIV_ROUND_UP_POS_OR_ZERO(n,d)
#endif

/*
 * Divide positive or negative dividend by positive divisor and round
 * to closest integer. Result is undefined for negative divisors and
 * for negative dividends if the divisor variable type is unsigned.
 */
#define DIV_ROUND_CLOSEST(x, divisor)(			\
{							\
	typeof(x) __x = x;				\
	typeof(divisor) __d = divisor;			\
	(((typeof(x))-1) > 0 ||				\
	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
		(((__x) + ((__d) / 2)) / (__d)) :	\
		(((__x) - ((__d) / 2)) / (__d));	\
}							\
)

static inline uint16_t linear_interp_u16(uint16_t x1, uint16_t y1, uint16_t x2, uint16_t y2, uint16_t x)
{
	/* potential for multiplication overflow */
	return (x - x1) * (y2 - y1) / (x2 - x1) + y1;
}

#define LINEAR_INTERPOLATE(x1, y1, x2, y2, x) \
	(((x)-(x1)) * ((y2) - (y1)) / ((x2)-(x1)) + (y1))

#define DIV_OR_ZERO(n, d) ((n <= 0)?0:(n)/(d))

/* Saturating unsigned subtraction
 * Assumes that 'a' and 'b' are also unsigned.
 */
#define SAT_U_SUB(a,b) ({				\
		typeof(a) __sub_sat_a = (a);		\
		typeof(b) __sub_sat_b = (b);		\
		(__sub_sat_a > __sub_sat_b)		\
			? __sub_sat_a - __sub_sat_b	\
			: 0;				\
	})

//#define pow4(x) (2ull << (2*(x)-1))
#define pow4(x) (2ULL << (2*(x)-1))

#define clamp_below(val, max) ({		\
		typeof(val) __val = val;\
		if (__val > max)	\
			__val = max;	\
		__val; })

/* WARNING: widens to 'int' if a smaller sized type is used */
#define PROMOTE(v, expr_constraint) \
	(1 ? (v) : (expr_constraint))

#define EXPR_IS_SIGNED(e) (PROMOTE(-1, e) < PROMOTE(1, e))
#define TYPE_IS_SIGNED(t) ((t)-1 < (t) 1)

#if 0
#define EXPR_UMAX(expr) (~((TYPE_OF_UNSIGNED(expr))0))
#define EXPR_MAX(expr)  

#define TYPE_UMAX(t)
#define TYPE_MAX(t)

#define SAT_ADD(x, y) ({						\
		check_types_match(x, y);				\
		typeof(x) __sat_add_x = x;				\
		typeof(y) __sat_add_y = y;				\
		TYPE_UNION(x, y) __sat_add_r;				\
		if (EXPR_MAX(x) - __sat_add_x < __sat_add_y)		\
			r = EXPR_MAX(x);				\
		else if (EXPR_MIN(x) + __sat_add_x < __sat_add_y)	\
			r = EXPR_MIN(x);				\
		else							\
			r = x + y;					\
		r;							\
		})
#endif

#define MEGA(x) ((x) * 1000000)
#define KILO(x) ((x) *    1000)

#define ABS(x) ((x) < 0?(-(x)) : (x))

#define max(x, y) ({		\
	typeof(x) __x = x;	\
	typeof(y) __y = y;	\
	(void)(&__y == &__x);	\
	__x > __y ? __x : __y;	\
	})

#define MAX(x, y) ((x) > (y)?(x):(y))
#define MAX3(x, y, z) MAX(MAX(x, y), z)
#define MAX4(a, b, c, d) MAX(MAX(a,b),MAX(c,d))
#define MAX6(a,b,c,d,e,f) MAX(MAX4(a,b,c,d),MAX(e,f))
#define MAX8(a,b,c,d,e,f,g,h) MAX(MAX4(a,b,c,d),MAX4(e,f,g,h))

#define MIN(x,y) ((x) < (y)?(x):(y))
#define MIN3(a, b, c) MIN(MIN(a,b),c)
#define MIN4(a, b, c, d) MIN(MIN(a,b),MIN(c,d))
#define MIN6(a,b,c,d,e,f) MIN(MIN4(a,b,c,d),MIN(e,f))
#define MIN8(a,b,c,d,e,f,g,h) MIN(MIN4(a,b,c,d),MIN4(e,f,g,h))

/*
 * @thing: something sizeof operates on (typically a type or a variable)
 *
 * Returns the number of bits represented by @thing
 */
#define BITS_IN(thing) (CHAR_BIT * sizeof(thing))

/**
 * fls_next(num, bit_idx) - find the next set bit, searching from the left
 * "find last set next"
 *
 * num: number to search for bits
 * bit_idx: The highest 1-indexed bit to examine (or the highest 0-indexed bit
 *          + 1)
 */
static inline uint8_t next_set_bit(llu num, uint8_t bit_idx)
{
	for (;;) {
		if (bit_idx == 0)
			return 0;
		if (num & (1llu << (bit_idx - 1llu)))
			return bit_idx;
		bit_idx --;
	}
}

static inline uint8_t next_set_bit_nz(llu num, uint8_t bit_idx)
{
	for (;;) {
		if (num & (1llu << (bit_idx - 1llu)))
			return bit_idx;
		bit_idx --;
	}
}

/**
 * fls(num) - find the last (most significant) set bit
 *
 * Returns (the left shift of the found set bit) + 1
 *     If no set bit is found, returns 0.
 */
static inline uint8_t p_fls(llu num)
{
	return next_set_bit(num, BITS_IN(num));
}

#if 0
static inline unsigned fls(unsigned x)
{
	unsigned i;
	for (i = sizeof(x) * CHAR_BIT + 1; i > 0; i--) {
		if (x & (1 << (i - 1)))
			return i;
	}
	return i;
}
#endif

static inline uint8_t fls_nz(llu num)
{
	assert(num);
	return next_set_bit_nz(num, BITS_IN(num));
}

/*
 * @bits: number of bits to have set, starting from the lsb.
 */
/* assert(bits > 0) */
#define bit_mask_nz(bits) ((UINTMAX_C(1) << ((bits) - 1) << 1) - 1)

static inline uintmax_t bit_mask(unsigned bits)
{
	return bits ? bit_mask_nz(bits) : 0;
}

static inline
bool is_power_of_2(unsigned long n)
{
	return (n != 0 && ((n & (n -1)) == 0));
}


/* assert(bits < (sizeof(1ull) * CHAR_BIT))
 * nf = "not full" */
#define bit_mask_nf(bits) ((UINTMAX_C(1) << (bits)) - 1)

#define ROUND_UP_POW_OF_2X_M1(_val, _x)   ((_val) | bit_width_max(_x))
#define ROUND_DOWN_POW_OF_2X(_val, _x) (((_val) >> (_x)) << (_x))

#endif
