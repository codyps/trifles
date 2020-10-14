#ifndef PENNY_BITS_H_
#define PENNY_BITS_H_

#pragma once

#include <assert.h>
#include <stdint.h>
#include <penny/math.h>

/* based on the second algorithm given here:
 * https://graphics.stanford.edu/~seander/bithacks.html#ReverseParallel
 *
 * Also see:
 *  - http://corner.squareup.com/2013/07/reversing-bits-on-arm.html
 */
static inline
uintmax_t reverse_bits_v(uintmax_t v, int_least8_t s)
{
	// bit size; must be power of 2
	assert(is_power_of_2(s));
	uintmax_t mask = ~INTMAX_C(0);
	while ((s >>= 1) > 0)  {
		mask ^= (mask << s);
		v = ((v >> s) & mask) | ((v << s) & ~mask);
	}

	return v;
}

#define reverse_bits(v) reverse_bits_v(v, sizeof(v) * CHAR_BIT)



#endif
