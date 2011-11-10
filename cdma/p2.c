
/*
 * 1. Assuming x0 indicates the initial value of the PN Shift register, the output will be 0 continually.
 *
 * 2. 0
 *
 */
#define _BSD_SOURCE /* for endian.h */

/* R: "Finally, your messages will be coded in 7-bit ASCII format (MSB first, left to right)." */
/* 256 % 7 != 0, so 8 makes sense here despite the above statement */
#define ACSII_CHAR_BITS 8
#define ACSII_RECV_MSB_FIRST 1

/* R: "That is, using seed Sm , the first 256
   bits (ordered LSB to MSB) output by the shift register will comprise sm1 ,
   the next sm2 and so on."
 *
 * What does it mean for the bits to be orderd "[from] LSB to MSB"?
 * Is the LSB the first emitted? Or the MSB?
 */
#define SHIFT_REG_LSB_EMIT_FIRST 1

/* This should do the same thing as changing the above */
#define FLIP_RK 0

/* R: During bit interval k, user m has codeword smk composed of ±1s.
 *
 * binary = {1, 0} instead. */
#define CODEWORD_IS_BINARY 0

#define RAND_INIT_FLIP  0
#define RAND_INIT_BYTESWAP 0
#define RAND_INIT_SHIFT 0

/* Enable the use of discrete stepping */
#define STEP_BY_256 1

#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#include <arpa/inet.h> /* htonl */
#include <endian.h> /* htole32, be32toh */
#define swap32(x) htole32(be32toh(x))

#define __unused __attribute__((__unused__))

#define ARRAY_SIZE(A) (sizeof(A) / sizeof((A)[0]))
#define BIT_N(A, N) (((A) & (1ull << (N))) >> (N))
#define MASK_N(N)   ((1ull << ((unsigned long long)(N))) - 1)

/* from http://graphics.stanford.edu/~seander/bithacks.html */
__unused static uint32_t flip_bits32(uint32_t v)
{
	// swap odd and even bits
	v = ((v >> 1) & 0x55555555) | ((v & 0x55555555) << 1);
	// swap consecutive pairs
	v = ((v >> 2) & 0x33333333) | ((v & 0x33333333) << 2);
	// swap nibbles ... 
	v = ((v >> 4) & 0x0F0F0F0F) | ((v & 0x0F0F0F0F) << 4);
	// swap bytes
	v = ((v >> 8) & 0x00FF00FF) | ((v & 0x00FF00FF) << 8);
	// swap 2-byte long pairs
	v = ( v >> 16             ) | ( v               << 16);
	return v;
}

static uint32_t update_pn(uint32_t cur)
{
	return cur << 1 |
		(BIT_N(cur, 27) ^ BIT_N(cur, 30));
}


static unsigned long long arg_ull(char *arg)
{
	unsigned long long n = 0;
	if (arg[0] == '0' && arg[1] == 'x') {
		sscanf(arg, "%llx", &n);
	} else {
		sscanf(arg, "%llu", &n);
	}
	return n;
}

#define CHECK_ARGS(name, args) check_args(argc, argv, name, ARRAY_SIZE(args), args)
static void check_args(int argc, char **argv, char *name, size_t arg_ct, char **args)
{
	if ((size_t)argc < (arg_ct + 1)) {
		fprintf(stderr, "usage: %s", argc?argv[0]:name);

		size_t i;
		for(i = 0; i < arg_ct; i++)
			fprintf(stderr, " <%s>", args[i]);
		fputc('\n', stderr);

		exit(EXIT_FAILURE);
	}
}

static long long next_rk(FILE *f)
{
	long long ret;
	if (fscanf(f, "%lld ", &ret) != 1) {
		fprintf(stderr, "your input file is broken\n");
		exit(EXIT_FAILURE);
	}
	return ret;
}


struct sr {
	uint32_t pn;
	uint8_t  codeword[256/8];
	unsigned long long i;
};

static bool bit_in_array(uint8_t *ar, size_t bit)
{
	return BIT_N(ar[bit / 8], bit % 8);
}

#define type_ptr(t) ((t *) NULL)
#define sizeof_field(s, f) sizeof(((s *)(NULL))->f)

static bool shift_in_bit(uint8_t *ar, size_t len, bool in)
{
	size_t i = len;
	if (!len)
		return false;

	bool ret = BIT_N(ar[len - 1], 7);

	for(; i > 1; i--) {
		ar[i - 1] = ar[i - 1] << 1 | (ar[i - 2] >> 7);
	}

	ar[0] = ar[0] << 1 | in;

	return ret;
}

__unused static long long shift_in_ll(long long *ar, size_t len, long long in)
{
	size_t i = len;
	if (!len)
		return 0;

	long ret = ar[len - 1];

	for(; i > 1; i--) {
		ar[i - 1] = ar[i - 2];
	}

	ar[0] = in;

	return ret;
}

static void update_sr(struct sr *s)
{
	s->pn = update_pn(s->pn);
	bool out = BIT_N(s->pn, 31);
	s->pn = s->pn & MASK_N(31);

	shift_in_bit(s->codeword, ARRAY_SIZE(s->codeword), out);
}

static void step_sr(struct sr *s)
{
	size_t i;
	for(i = 0; i < 256; i++) {
		update_sr(s);
	}
	s->i ++;
}

static long long array_mult_by_bit(long long *a, uint8_t *b, size_t elems)
{
	/* for a: elems = number of long longs.
	 * for b: elems = number of bits.
	 */
	long long sum = 0;

	size_t i;
	for(i = 0; i < elems; i++) {
#if SHIFT_REG_LSB_EMIT_FIRST
		size_t bit_ix = i;
#else
		size_t bit_ix = elems - i - 1;
#endif
		bool bit = bit_in_array(b, bit_ix);

		long long s_m_k = bit ? 1 : -1;
#if CODEWORD_IS_BINARY
		s_m_k = bit ? 1 : 0;
#endif

		size_t r_ix = i;
#if FLIP_RK
		r_ix = elems - i - 1;
#endif
		long long r_k   = a[r_ix];

		sum += s_m_k * r_k;
	}

	return sum;
}

void print_array(long long *a, size_t elems, FILE *out)
{
	size_t i;
	for (i = 0; i < elems; i++) {
		fprintf(out, "%lld ", a[i]);
	}

	fputc('\n', out);
}

int main(__unused int argc, __unused char **argv)
{
	CHECK_ARGS("./p2", ((char *[]){"data file", "initial"}) );

	FILE *in = fopen(argv[1], "r");

	unsigned long long pi = arg_ull(argv[2]);
#if RAND_INIT_BYTESWAP
	pi = htonl(pi);
#endif

#if RAND_INIT_FLIP
	pi = flip_bits32(pi);
#endif

	/* allows correcting for the previous flip */
	pi >>= RAND_INIT_SHIFT;

	fprintf(stderr, "pi = %llx\n", 0xffffffffllu);
	fprintf(stderr, "pi = %llx\n", pi);

	struct sr sr = { pi , {0}, 0 };

	long long r[256] = {};

	char b = 0;

	size_t i = 0;
#if STEP_BY_256
	size_t j = 0;
#endif

#if !STEP_BY_256
	step_sr(&sr);
#endif

	while(!feof(in)) {
		/* r_k = sum(m=1, M, a_m_k * b_m_k * s_m_k)
		 * b_m_k = 1 | r_k s_m_k > 0, otherwise -1
		 */
		long long r_k   = next_rk(in);

#if STEP_BY_256
		r[j] = r_k;
#else
		shift_in_ll(r, ARRAY_SIZE(r), r_k);
#endif

#if STEP_BY_256
		j++;
		if ((j % 256) == 0) {
			j = 0;
			step_sr(&sr);
#endif

			long long b_m_k = array_mult_by_bit(r, sr.codeword, 256);

			//print_array(r, ARRAY_SIZE(r), stderr);
#if ACSII_RECV_MSB_FIRST
			size_t ix = ACSII_CHAR_BITS - i - 1;
#else
			size_t ix = i;
#endif

			b |= (b_m_k > 0) << ix;

			i ++;

			if ((i % ACSII_CHAR_BITS) == 0) {
				printf("%c", b);
				b = 0;
				i = 0;
			}
#if STEP_BY_256
		}
#endif

#if !STEP_BY_256
		update_sr(&sr);
#endif

	}

	return 0;
}
