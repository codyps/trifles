#include <stdio.h>
#include <p99/p99_map.h>

static inline void pr__int(int x)
{
	printf("%d", x);
}

static inline void pr__charp(const char *p)
{
	fputs(p, stdout);
}

#define pr_g(x) _Generic((x), \
    int: pr__int, \
    char*: pr__charp \
)(x)

#define pr_g_(x) pr_g(x)
#define pr(...) do { \
	P99_SEP(pr_g_, __VA_ARGS__); \
} while (0)

int main(void)
{
    pr_g("hi ");
    pr_g(1);
    pr(" bye ", 2);
    putchar('\n');
    return 0;
}
