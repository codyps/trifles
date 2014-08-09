#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include <penny/print.h>
#include <penny/math.h>

typedef unsigned Ix;
typedef uint32_t V;
static uint8_t backing[13] = {};

#define BITS_PREP					\
	assert(start_bit < end_bit);			\
	Ix bit_ct = end_bit - start_bit + 1;		\
	assert(sizeof(V) * 8 > bit_ct);			\
	Ix start_byte = start_bit / 8;			\
	Ix end_byte   = DIV_ROUND_UP(end_bit, 8);	\
	Ix byte_ct = end_byte - start_byte + 1


#define P(x) printf("%s = %#jx;\n", #x, (uintmax_t)x)

static uint8_t byte_modify(uint8_t orig, uint8_t start_bit, uint8_t end_bit, uint8_t val)
{
	assert(start_bit < 8);
	assert(end_bit   < 8);
	assert(start_bit < end_bit);

	uint8_t bits_in_this_byte = end_bit - start_bit;
	uint8_t mask = ((1 << bits_in_this_byte) - 1) << start_bit;
	return (orig & ~mask) | ((val << start_bit) & mask);
}

static void bits_write(Ix start_bit, Ix end_bit, const uint8_t *in)
{
	BITS_PREP;

	Ix first_full_byte = DIV_ROUND_UP(start_bit, 8);
	Ix last_full_byte  = end_bit / 8;
	Ix ct_full_bytes   = last_full_byte - first_full_byte;

	P(start_bit);
	P(end_bit);

	P(start_byte);
	P(end_byte);
	P(first_full_byte);
	P(last_full_byte);
	P(ct_full_bytes);

	uint8_t c_in = *in;
	uint8_t bit_shift = start_bit % 8;
	uint8_t bits_in_this_byte = MIN(8 - bit_shift, bit_ct);
	uint8_t mask = (1 << bits_in_this_byte) - 1;

	P(bits_in_this_byte);
	P(bit_shift);
	P(mask);

	uint8_t tmp = backing[start_byte];
	tmp = (tmp & ~(mask << bit_shift)) | (c_in & mask) << bit_shift;
	backing[start_byte] = tmp;

	/* Did we consume all of our bits? */
	bit_ct -= bits_in_this_byte;
	if (!bit_ct)
		return;

	/* c_in has remaining bits from the previous read */
	c_in &= ~mask;
	c_in >>= bits_in_this_byte;

	/* Have we consumed all of our bytes? */
	if (!(bit_ct / 8)) {
		/* XXX: c_in contains all relevent data, we end after it's
		 * written out in the next byte */
	}

	/* read the next byte */
	in++;
	uint8_t c_next = *in;
	c_in |= c_next << bits_in_this_byte;

	/* c_in now has all the data to write next */

	/* check if this byte is partial */
	if (

	/* We might have */

	/* W remaining bytes except the last */

	/* RWM last byte IFF not a full byte */

	/* W last byte otherwise */
}

#define B do {						\
	print_bits_lsb_first(backing, sizeof(backing), stdout);	\
	putchar('\n');					\
} while (0)
#define X(a, b) do {				\
	memset(backing, 0, sizeof(backing));	\
	bits_write(a, b, (uint8_t *)&foo);	\
	B;					\
} while (0)
int main(void)
{
	uint8_t foo[] = { 0xff, 0xff };
	B;

	X(0, 7);
	X(0, 8);
	X(1, 8);
	X(1, 7);
	X(2, 16);
	return 0;
}
