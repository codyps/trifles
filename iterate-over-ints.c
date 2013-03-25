#include <stdio.h>
#include <limits.h>

#define TYPE_IS_SIGNED(T) (((T)-1) < 0)
#define IS_SIGNED(x) TYPE_IS_SIGNED(typeof(x))

#define SIGNED_TYPE_MAX(T)   ((1 << (sizeof(T) * 8 - 1)) - 1)
#define UNSIGNED_TYPE_MAX(T) (~(T)0)

#define umaxof(t) (((0x1ULL << ((sizeof(t) * 8ULL) - 1ULL)) - 1ULL) | \
                    (0xFULL << ((sizeof(t) * 8ULL) - 4ULL)))

#define smaxof(t) (((0x1ULL << ((sizeof(t) * 8ULL) - 1ULL)) - 1ULL) | \
                    (0x7ULL << ((sizeof(t) * 8ULL) - 4ULL)))


#define TYPE_MAX(T) (TYPE_IS_SIGNED(T) ? SIGNED_TYPE_MAX(T) : UNSIGNED_TYPE_MAX(T))
#define VAR_MAX(x)  TYPE_MAX(typeof(x))

int main(int argc, char **argv)
{
	int start = 0, last = VAR_MAX(last), count = last - start;


	/* Iteration */

	/* start + count */
	/* start + inclusive last */
	/* start + exclusive last ("end") */

	return 0;
}
