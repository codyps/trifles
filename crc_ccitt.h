#ifndef CRC_H_
#define CRC_H_

#include <stdint.h>

#if 1
static inline
uint8_t lo8(uint16_t val)
{
	return val & 0xff;
}

static inline
uint8_t hi8(uint16_t val)
{
	return val >> 8;
}

static inline
uint16_t crc_ccitt_update(uint16_t crc, uint8_t data)
{
	data ^= lo8(crc);
	data ^= data << 4;

	return ((((uint16_t) data << 8) | hi8(crc)) ^ (uint8_t) (data >> 4)
		^ ((uint16_t) data << 3));
}
#else

static inline
uint16_t crc_ccitt_update(uint16_t crc, uint8_t data)
{
	crc  = (uint8_t)(crc >> 8) | (crc << 8);
	crc ^= data;
	crc ^= (uint8_t)(crc & 0xff) >> 4;
	crc ^= (crc << 8) << 4;
	crc ^= ((crc & 0xff) << 4) << 1;
	return crc;
}
#endif

#endif
