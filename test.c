#include <avr/io.h>


#define bswap16_1(s) (((0xFF00 & (s)) >> 8) | ((0x00FF &(s)) << 8))
static inline uint16_t bswap16_2(uint16_t s) {
	union u {
		struct s {
			uint8_t a, b;
		} s;
		uint16_t x;
	} u;

	u.x = s;
	uint8_t tmp = u.s.a;
	u.s.a = u.s.b;
	u.s.b = tmp;
	return u.x;
}

volatile uint16_t res;

__attribute__((noreturn))
void main(void)
{
	uint16_t x = res;
	res = bswap16_1(x);
	res = bswap16_2(x);
	for(;;)
		;
}
