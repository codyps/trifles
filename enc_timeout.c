#include <stdio.h>
#include <inttypes.h>
#include <limits.h>

static
uint16_t VL53L0X_encode_timeout(uint32_t timeout_macro_clks)
{
	/*!
	 * Encode timeout in macro periods in (LSByte * 2^MSByte) + 1 format
	 */

	uint16_t encoded_timeout = 0;
	uint32_t ls_byte = 0;
	uint16_t ms_byte = 0;

	if (timeout_macro_clks > 0) {
		ls_byte = timeout_macro_clks - 1;

		while ((ls_byte & 0xFFFFFF00) > 0) {
			ls_byte = ls_byte >> 1;
			ms_byte++;
		}

		encoded_timeout = (ms_byte << 8)
				+ (uint16_t) (ls_byte & 0x000000FF);
	}

	return encoded_timeout;

}

static
uint16_t clz_timeout_encode(uint32_t tmc)
{
	if (!tmc)
		return 0;

	tmc -= 1;
	int log2 = (sizeof(unsigned long) * CHAR_BIT) - __builtin_clzl(tmc);
	uint8_t exp = 0;
	if (log2 >= 8) {
		exp = log2 -= 8;
	}

	uint8_t mts = tmc >> exp;

	return exp << 8 | mts;
}

static
uint32_t timeout_decode(uint16_t t)
{
	uint8_t pow = t >> 8;
	uint8_t base_mult = t & 0xff;
	uint32_t mult = 1 << pow;
	return base_mult * mult + 1;
}

static
void show(uint32_t tmc)
{
	uint16_t enc = VL53L0X_encode_timeout(tmc);
	uint16_t enc2 = clz_timeout_encode(tmc);
	uint32_t dec = timeout_decode(enc);
	printf("%04" PRIx32 " => %04" PRIx16 " => %04" PRIx16 " => %04" PRIx32 "\n", tmc, enc, enc2, dec);
}

int main(void)
{
	show(0xabcd);
	show(0xab01);
	show(0xab00);
	return 0;
}
