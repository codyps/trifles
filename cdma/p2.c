#include "config.h"

#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#define __unused __attribute__((__unused__))

#define ARRAY_SIZE(A) (sizeof(A) / sizeof((A)[0]))
#define BIT_N(A, N) (((A) & (1ull << (N))) >> (N))
#define MASK_N(N)   ((1ull << ((unsigned long long)(N))) - 1)

static uint32_t update_pn(uint32_t cur)
{
	return ((cur << 1) |
		(BIT_N(cur, 27) ^ BIT_N(cur, 30))) & MASK_N(31);
}

struct sr {
	uint32_t pn;
	uint8_t  codeword[256/8];
};

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

static void update_sr(struct sr *s)
{
	uint32_t new_pn = update_pn(s->pn);
	bool     out_bit = BIT_N(s->pn, 30);

	shift_in_bit(s->codeword, ARRAY_SIZE(s->codeword), out_bit);

	s->pn = new_pn;
}

static void next_codeword(struct sr *s)
{
	size_t i;
	for(i = 0; i < 256; i++) {
		update_sr(s);
	}
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



static bool bit_in_array(uint8_t *ar, size_t bit)
{
	return BIT_N(ar[bit / 8], bit % 8);
}

#define type_ptr(t) ((t *) NULL)
#define sizeof_field(s, f) sizeof(((s *)(NULL))->f)



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

		long long r_k   = a[i];

		sum += s_m_k * r_k;
	}

	return sum;
}

#define print_array(a, elems, fmt, out) do {	\
	size_t i;			\
	for (i = 0; i < elems; i++) {	\
		fprintf(out, fmt, a[i]);	\
	}				\
	fputc('\n', out);		\
} while(0)

int main(int argc, char **argv)
{
	CHECK_ARGS("./p2", ((char *[]){"data file", "initial"}) );

	FILE *in = fopen(argv[1], "r");

	unsigned long long pi = arg_ull(argv[2]);

	struct sr sr = { pi , {0} };

	long long r[256] = {};

	char b = 0;

	size_t i = 0;
	size_t j = 0;

	while(!feof(in)) {
		/* r_k = sum(m=1, M, a_m_k * b_m_k * s_m_k)
		 * b_m_k = 1 | r_k s_m_k > 0, otherwise -1
		 */
		long long r_k = next_rk(in);
#if RK_FLIP
		r[256 - j - 1] = r_k;
#else
		r[j] = r_k;
#endif

		j++;
		if ((j % 256) == 0) {
			j = 0;
			next_codeword(&sr);
			//print_array(sr.codeword, ARRAY_SIZE(sr.codeword), "%x", stderr);

			long long b_m_k = array_mult_by_bit(r, sr.codeword, 256);

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
		}
	}

	return 0;
}
