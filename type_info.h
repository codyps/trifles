#ifndef PENNY_TYPE_INFO_H_
#define PENNY_TYPE_INFO_H_

/*
 * @bits: number of bits in the number
 *
 * assert(bits < (sizeof(1ull) * CHAR_BIT))
 */
#define bit_width_max(bits) \
		((1ull << ((bits) - 1) << 1) - 1)

#define byte_width_max(bytes) bit_width_max((bytes) * 8)
#define max_of_u(t) byte_width_max(sizeof(t))

/* assumes 2s compliment form */
#define max_of_s(t) max_of_2c(t)

#define byte_width_min_2c(bytes) -bit_width_min_2c_pos(bytes)
#define byte_width_min_2c_pos(bytes) bit_width_max((bytes) * 8)
#define byte_width_max_2c(bytes) bit_width_max((bytes) * 8 - 1)
#define max_of_2c(t) byte_width_max_2c(sizeof(t))

#endif
