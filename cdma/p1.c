
/*
 * 1. Assuming x0 indicates the initial value of the PN Shift register, the output will be 0 continually.
 *
 * 2. 0
 *
 */


#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#define __unused __attribute__((__unused__))

#define BIT_N(A, N) (((A) & (1 << (N))) >> (N))
#define MASK_N(N)   ((1ull << ((unsigned long long)(N))) - 1)

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

/* mod 31 */

int main(__unused int argc, __unused char **argv)
{
	unsigned long long iter = 0;
	uint32_t pn_sr = 0;

	if (argc < 2) {
		fprintf(stderr, "usage: %s <iterations>\n",
				argc?argv[0]:"./p1");
		return -1;
	}

	iter = arg_ull(argv[1]);

	unsigned long long i;
	for(i = 0; i < iter; i++) {
		pn_sr = update_pn(pn_sr);
		bool out = BIT_N(pn_sr, 31);
		pn_sr = pn_sr & MASK_N(31);

		printf("%llx: %lx -> %x\n",
				i,
				(unsigned long)pn_sr,
				out);
	}

	return 0;
}
