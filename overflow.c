
#include <limits.h>

unsigned long long max_1(unsigned bit_start, unsigned bit_end)
{
	return (0x1ULL << ((bit_end) - (bit_start) + 1)) - 1ULL;
}

unsigned long long max_2(unsigned bit_start, unsigned bit_end)
{
	int bits = (bit_end) - (bit_start) + 1;
	return ((0x1ULL << (bits - 1ULL)) - 1ULL) |
		(0xFULL << (bits - 4ULL));
}

unsigned long long max_3(unsigned bit_start, unsigned bit_end)
{
	unsigned bits = (bit_end) - (bit_start) + 1;
	return (bits < (sizeof(0ULL) * CHAR_BIT))
			? ((1ULL << bits) - 1ULL)
			: ~0ULL;
}

#if 0
unsigned long long max_4(unsigned bit_start, unsigned bit_end)
{
	unsigned bits = (bit_end) - (bit_start) + 1;
	return (1ULL << (bits - 1)) * ((bits & 1) << 1) - 1;
}
#endif

/*
 * Derivation:
 * 2**(N) - 1
 * 2**(N - 1 + 1) - 1
 * 2**(N - 1) * 2 - 1
 * 2**(N - 1) * 2 - 2 + 1
 * 2 * (2**(N-1) - 1) + 1
 *
 */
unsigned long long max_4(unsigned bit_start, unsigned bit_end)
{
	unsigned bits = (bit_end) - (bit_start) + 1;
	return (((1ull << (bits - 1)) - 1) << 1) + 1;

	#if 0
	typedef unsigned long long ull;
	ull a = bits - 1; /* 63 */
	ull b = 1 << a;   /* 0x8000000000000000 */
	ull c = b - 1;    /* 0x7fffffffffffffff */
	ull d = b << 1;   /* 0xfffffffffffffffe */
	ull e = d + 1;    /* 0xffffffffffffffff */
	return e;
	#endif
}

#include <stdio.h>
int main (void)
{
	unsigned i, j;
	for (i = 0; i < 64; i++)
		for (j = i; j < 64; j++) {
			unsigned bits = j - i + 1;
			unsigned long long m1, m2, m3, m4;
			m1 = max_1(i, j);
			m2 = max_2(i, j);
			m3 = max_3(i, j);
			m4 = max_4(i, j);
			if (m3 != m4)
				printf("%u-%u (%u): %18llu %18llu %18llu %18llu\n", i, j, bits, m1, m2, m3, m4);
		}

	return 0;
}
