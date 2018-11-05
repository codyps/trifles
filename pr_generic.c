#include <stdio.h>

#define PR__CHARP(x) fputs((x), stdout)
#define PR__INT(x)   printf("%d", x)

static inline void pr__int(int x)
{
	printf("%d", x);
}

static inline void pr__charp(const char *p)
{
	fputs(p, stdout);
}

// NOTE: cannot use macros in place of function results: not resolved early
// enough (macros will never be substituted due to _Generic happening later).
//
// NOTE: cannot use _evaluated_ macros or direct calls inside _Generic without
// warnings being emitted. In at least `gcc 8.2.1` and clang-7, warnings about
// type incompatibility are eagerly emitted here before discovering that they
// won't be evaluated.
#if 0
#define PR_G(x) _Generic((x), \
    int: pr__int(x), \
    char*: pr__charp(x) \
)
#else
#define PR_G(x) _Generic((x), \
    int: pr__int, \
    char*: pr__charp \
)(x)
#endif

int main(void)
{
    PR_G("hi ");
    PR_G(1);
    putchar('\n');
    return 0;
}
