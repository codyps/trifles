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
#define pr_g(x) _Generic((x), \
    int: pr__int, \
    char*: pr__charp \
)(x)
#endif

// apply on each arg structure (for up to 5 args)
#define map_0(m, ...)
#define map_1(m, a) m(a)
#define map_2(m, a, ...) m(a) map_1(m, __VA_ARGS__)
#define map_3(m, a, ...) m(a) map_2(m, __VA_ARGS__)
#define map_4(m, a, ...) m(a) map_3(m, __VA_ARGS__)
#define map_5(m, a, ...) m(a) map_4(m, __VA_ARGS__)
#define MAP__(n, m, ...) map_##n(m, __VA_ARGS__)
#define MAP_(...) MAP__(__VA_ARGS__)

#define ARG(_1,_2,_3,_4,_5,N,...) N
#define ARGN(...) ARG(__VA_ARGS__,5,4,3,2,1,0)

#define MAP(m, ...) MAP_(ARGN(__VA_ARGS__),m,  __VA_ARGS__)

#define pr_g_(x) pr_g(x);
#define pr(...) do { \
	MAP(pr_g_, __VA_ARGS__); \
} while (0)

int main(void)
{
    pr_g("hi ");
    pr_g(1);
    pr(" bye ", 2);
    putchar('\n');
    return 0;
}
