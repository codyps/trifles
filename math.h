#ifndef PENNY_MATH_H_
#define PENNY_MATH_H_

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

#define SUB_SAT(a,b) ({					\
		typeof(a) __sub_sat_a = (a);		\
		typeof(b) __sub_sat_b = (b);		\
		(__sub_sat_a > __sub_sat_b)		\
			? __sub_sat_a - __sub_sat_b	\
			: 0;				\
	})

//#define pow4(x) (2ull << (2*(x)-1))
#define pow4(x) (2ULL << (2*(x)-1))

#define SAT_CEIL(val, max) ({		\
		typeof(val) __val = val;\
		if (__val > max)	\
			__val = max;	\
		__val; })

#define MEGA(x) ((x) * 1000000)
#define KILO(x) ((x) *    1000)

#define ABS(x) ((x) < 0?(-(x)) : (x))

#define MAX(x, y) ((x) > (y)?(x):(y))
#define MAX4(a, b, c, d) MAX(MAX(a,b),MAX(c,d))
#define MAX6(a,b,c,d,e,f) MAX(MAX4(a,b,c,d),MAX(e,f))
#define MAX8(a,b,c,d,e,f,g,h) MAX(MAX4(a,b,c,d),MAX4(e,f,g,h))

#define MIN(x,y) ((x) < (y)?(x):(y))
#define MIN4(a, b, c, d) MIN(MIN(a,b),MIN(c,d))
#define MIN6(a,b,c,d,e,f) MIN(MIN4(a,b,c,d),MIN(e,f))
#define MIN8(a,b,c,d,e,f,g,h) MIN(MIN4(a,b,c,d),MIN4(e,f,g,h))

#endif
