#include <math.h>
#include <inttypes.h>
#include <stdio.h>

int main(void)
{

	uintmax_t i = 0;

	do {
		long double l = logl(i + 1);
		long double f1 = floorl(l) + 1;
		long double c = ceill(l);

		if (f1 != c) {
			fprintf(stderr, "MISMATCH: %ju: f1=%Lf , c=%Lf\n",
					i, f1, c);
		}
	} while (i++ < UINTMAX_MAX);

	return 0;
}
