#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#define __unused __attribute__((__unused__))

#define ARRAY_SIZE(A) (sizeof(A) / sizeof((A)[0]))
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

#define CHECK_ARGS(name, args) \
	check_args(argc, argv, name, ARRAY_SIZE(args),args)
static void check_args(int argc, char **argv, char *name,
		size_t arg_ct, char **args)
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

int main(int argc, char **argv)
{
	unsigned long long iter = 0, show_every = 0;
	uint32_t pn_sr = 0, pn_sr_orig = 0;

	CHECK_ARGS("./p1",
		((char *[]){"initial", "iterations", "show_every"}) );
	pn_sr = arg_ull(argv[1]);
	iter  = arg_ull(argv[2]);
	show_every = arg_ull(argv[3]);

	pn_sr_orig = pn_sr;
	unsigned long long i;
	for(i = 0; i < iter; i++) {
		pn_sr = update_pn(pn_sr);
		bool out = BIT_N(pn_sr, 31);
		pn_sr = pn_sr & MASK_N(31);

		bool match = pn_sr == pn_sr_orig;
		bool show  = ((i + 1) % show_every) == 0;

		if (show || match) {
			printf("%llx: %lx -> %x\n",
					i,
					(unsigned long)pn_sr,
					out);
		}

		if (match) {
			printf("match\n");
			return 0;
		}
	}

	return 0;
}
