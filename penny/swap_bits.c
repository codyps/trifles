#include <stdint.h>
#include <stdbool.h>

#define _BV(x) (1 << (x))

static inline bool bit_is_set(uint8_t byte, uint8_t i)
{
	return byte & (1 << i);
}

// daqq
// http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=252949#252949
uint8_t rev_byte_0(uint8_t old_byte) {
	uint8_t new_byte = 0;
	if(bit_is_set(old_byte,7))new_byte = new_byte|_BV(0);
	if(bit_is_set(old_byte,6))new_byte = new_byte|_BV(1);
	if(bit_is_set(old_byte,5))new_byte = new_byte|_BV(2);
	if(bit_is_set(old_byte,4))new_byte = new_byte|_BV(3);
	if(bit_is_set(old_byte,3))new_byte = new_byte|_BV(4);
	if(bit_is_set(old_byte,2))new_byte = new_byte|_BV(5);
	if(bit_is_set(old_byte,1))new_byte = new_byte|_BV(6);
	if(bit_is_set(old_byte,0))new_byte = new_byte|_BV(7);
	return new_byte;
}

// ciroque
// http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=252999#252999
// "Per bit shift, mask and or"
uint8_t rev_byte_1(uint8_t old) {
   return (old >> 7 & 0x1 )
	| (old >> 5 & 0x2 )
        | (old >> 3 & 0x4 )
        | (old >> 1 & 0x8 )
        | (old << 1 & 0x10)
        | (old << 3 & 0x20)
        | (old << 5 & 0x40)
        | (old << 7 & 0x80);
}

// N.Winterbottom
// http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=253467#253467
// "Shift grouped bits"
unsigned char rev_byte_2( unsigned char x )
{
    x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa);
    x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc);
    x = ((x >> 4) & 0x0f) | ((x << 4) & 0xf0);
    return x;
}

unsigned char rev_byte_2c( unsigned char x )
{
    x = ((x & 0xaa) >> 1) | ((x & 0x55) << 1);
    x = ((x & 0xcc) >> 2) | ((x & 0x33) << 2);
    x = ((x & 0xf0) >> 4) | ((x & 0x0f) << 4);
    return x;
}

#ifdef AVR
// peter.sager
// http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=253613#253613
// "Shift grouped bits + use inline asm"
uint8_t rev_byte_2b(uint8_t a)
{                                         \
  a=((a>>1)&0x55)|((a<<1)&0xaa);          \
  a=((a>>2)&0x33)|((a<<2)&0xcc);          \
  asm volatile("swap %0":"=r"(a):"0"(a)); \
  return a;
}
#endif

// peter.sager
// http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=253032#253032
// "4 bit lookup + swap"
static const uint8_t table[16] = {
  0x00,0x08,0x04,0x0C,0x02,0x0A,0x06,0x0E,0x01,0x09,0x05,0x0D,0x03,0x0B,0x07,0x0F
};
uint8_t rev_byte_3(uint8_t var)
{
  //------------------------------------------------
  //constants as u08 vars will force the optimizer
  //to use registers for the masks
  //------------------------------------------------
  uint8_t lo = 0x0F;  // lo-mask in working register
  uint8_t hi = 0xF0;  // hi-mask in working register
  uint8_t result;
  result  = table[(var & lo)] << 4;
  result |= table[((var & hi) >> 4)];
  return result;
}

// edwin76
// http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=253616#253616
// "Loop per bit, shift along result"
uint8_t rev_byte_4(uint8_t inputNumber)
{
   uint8_t i;
   uint8_t temp = 0;
   for (i = 0; i < 8; i++)
   {
      temp >>= 1;
      temp |= (inputNumber & (1 << (8 - 1)));
      inputNumber <<= 1;
   }
   return temp;
}

// MikeRJ
// http://www.avrfreaks.net/index.php?name=PNphpBB2&file=viewtopic&p=253644#253644
// "Conditional mask and XOR"
uint8_t rev_byte_5( uint8_t val) {
	uint8_t mask = 0;

	if( val & _BV(0) ) {
		mask ^= 0x81;
	}
	if( val & _BV(7) ) {
		mask ^= 0x81;
	}

	if( val & _BV(1) ) {
		mask ^= 0x42;
	}
	if( val & _BV(6) ) {
		mask ^= 0x42;
	}

	if( val & _BV(2) ) {
		mask ^= 0x24;
	}
	if( val & _BV(5) ) {
		mask ^= 0x24;
	}

	if( val & _BV(3) ) {
		mask ^= 0x18;
	}
	if( val & _BV(4) ) {
		mask ^= 0x18;
	}

	return val ^ mask;
}

uint8_t rev_byte_6(uint8_t x)
{
  uint8_t i;
  uint8_t r = 0;
  for (i = 0; i < 8; i++) {
    r |= (x & (1 << i)) >> (7 - i);
  }
  return r;
}

// 76543210
// 01234567
uint8_t rev_byte_7(uint8_t x)
{
  uint8_t r = (x & (1 << 7)) >> 7;
  r |= (x & (1 << 6)) >> 5;
  r |= (x & (1 << 5)) >> 3;
  r |= (x & (1 << 4)) >> 1;
  r |= (x & (1 << 3)) << 1;
  r |= (x & (1 << 2)) << 3;
  r |= (x & (1 << 1)) << 5;
  r |= (x & (1 << 0)) << 7;
  return r;
}

#ifdef AVR
uint8_t rev_byte_8(uint8_t x)
{
  return __builtin_avr_insert_bits(0x01234567, x, 0);
}
#endif

// pippo
// http://www.avrfreaks.net/index.php?name=PNphpBB2&file=printview&t=31724&start=0
unsigned char rev_byte_9(unsigned char val)
{
   unsigned char tmp = 0;
   unsigned char i;
   for ( i = 0; i < 8; i++)
      if ( val & ( 1 << ( 7 - i ) ) )
         tmp |= 1 << i;
   return (tmp);
}
