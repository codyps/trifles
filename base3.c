#include <assert.h>
#include <stdio.h>
#include <stdint.h>

struct zn {
	uint32_t o, z;
};

// internally pulled:   up down
// pull  -up external = 1  1    = 2
// pull-down external = 0  0    = 0
// floating           = 1  0    = 1
uint32_t
from_base3(uint32_t o, uint32_t z)
{
	assert(!(o & ~z));

	uint32_t v = 0;
	uint32_t m = 1;

	while (o || z) {
		uint8_t b = (o & 1) + (z & 1);
		v += b * m;
		m *= 3;
		o >>= 1;
		z >>= 1;
	}

	return v;
}

struct zn
to_base3(uint32_t v)
{
	struct zn ret = {};

	while (v) {
		uint32_t rem = v % 3;
		v /= 3;
		if ((v * 3) != v)
			rem = 3;

		switch (rem) {
		case 0:
			// no value
		case 1:
			// 10
		case 2:
		case 3:
			break;
		}
	}

	return ret;
}

int main(void)
{
	return 0;
}
