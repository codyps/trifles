
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <limits.h>
typedef uint16_t num;
#define NUM_FMT "u"

static inline uintmax_t bit_mask_nz(unsigned bits)
{
	return (UINTMAX_C(1) << ((bits) - 1) << 1) - 1;
}

static inline uintmax_t bit_mask(unsigned bits)
{
	return bits ? bit_mask_nz(bits) : 0;
}


/*
 * Round closest
 */

/* http://stackoverflow.com/questions/2422712/c-rounding-integer-division-instead-of-truncating */
static
num div_round_closest1(num dividend, num divisor)
{
	dividend += divisor / 2;
	dividend /= divisor;
	return dividend;
}

static
num div_round_closest2(num dividend, num divisor)
{
	return (double)dividend / (double)divisor + 0.5;
}

static 
num div_round_closest3(num n, num d)
{
	return (n - 1) / d + 1;
}

static 
num div_round_closest4(num n, num d)
{
	return ((n < 0) ^ (d < 0)) ? ((n - d / 2) / d) : ((n + d / 2) / d);
}

static 
num div_round_closest5(num n, num d)
{
	return round((double)n / d);
}

static 
num div_round_closest6(num n, num d)
{
	return (n / d) + ((n % d)  > 0 ? 1 : 0);
}

#define DIV_ROUND_CLOSEST(x, divisor) ({		\
	typeof(x) __x = x;				\
	typeof(divisor) __d = divisor;			\
	(((typeof(x))-1) > 0 ||				\
	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
		(((__x) + ((__d) / 2)) / (__d)) :	\
		(((__x) - ((__d) / 2)) / (__d));	\
})

#define DIV_ROUND_CLOSEST_T(x, divisor, t) ({		\
	t __x = x;				\
	t __d = divisor;			\
	(((t)-1) > 0 || (__x) > 0) ?	\
		(t)((t)((__x) + ((__d) / 2)) / (__d)) :	\
		(t)((t)((__x) - ((__d) / 2)) / (__d));	\
})

#define ADD_WOULD_OVERFLOW(a, b, bit_constraint) ((bit_mask(bit_constraint) - (a)) < (b))

static 
num div_round_closest7(num n, num d)
{
	return DIV_ROUND_CLOSEST_T(n, d, num) + ADD_WOULD_OVERFLOW(n, d, sizeof(num) * CHAR_BIT);
}


/*
 * Round "up" (towards positive infinity? or away from zero?)
 */

/* http://ericlippert.com/2013/01/28/integer-division-that-rounds-up/ */

/*
 * Round towards negative infinity
 */

/* http://www.microhowto.info/howto/round_towards_minus_infinity_when_dividing_integers_in_c_or_c++.html */

int main(void)
{
	num n = 0, d = 1;
	do {
		do {
			num d1 = div_round_closest5(n, d);
			num d2 = div_round_closest7(n, d);
			intmax_t diff = d1 - d2;
			if (diff)
				fprintf(stderr, "error: %"NUM_FMT "/ %" NUM_FMT " = %" NUM_FMT " != %" NUM_FMT "\n",
						n, d, d1, d2);
		} while (++d);
		d = 1;
	} while (++n);
	return 0;
}
