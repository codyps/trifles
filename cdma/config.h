
/* R: "Finally, your messages will be coded in 7-bit ASCII format (MSB first, left to right)." */
#define ACSII_CHAR_BITS 7
#define ACSII_RECV_MSB_FIRST 0

/* R: "That is, using seed Sm , the first 256
   bits (ordered LSB to MSB) output by the shift register will comprise sm1 ,
   the next sm2 and so on."
 *
 * What does it mean for the bits to be orderd "[from] LSB to MSB"?
 * Is the LSB the first emitted? Or the MSB?
 */
#define SHIFT_REG_LSB_EMIT_FIRST 0

/* This should do the same thing as changing the above */
#define FLIP_RK 0

/* R: During bit interval k, user m has codeword smk composed of ±1s.
 *
 * binary = {1, 0} instead. */
#define CODEWORD_IS_BINARY 0
