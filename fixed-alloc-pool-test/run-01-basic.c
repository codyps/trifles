#include "../fixed-alloc-pool.h"
#include "../fixed-alloc-pool.c"

#define ARRAY_SZ(x) (sizeof(x)/(sizeof((x)[0])))

int main(void)
{
	struct pool p;

	unsigned char b[8 * 8];
	pool_init(&p, b, 8, 8);

	void *a[8];
	size_t i;
	for (i = 0; i < ARRAY_SZ(a); i ++) {
		a[i] = pool_alloc(&p);
		assert(a[i]);
	}

	void *x = pool_alloc(&p);
	assert(!x);

	for (i = 0; i < ARRAY_SZ(a); i ++)
		pool_free(&p, a[i]);

	for (i = 0; i < ARRAY_SZ(a); i ++) {
		a[i] = pool_alloc(&p);
		assert(a[i]);
	}

	return 0;
}
