#include <stdio.h>

#define P99_SIGN_PROMOTE(A, B) (1 ? (A) : (B))
#define P99_PROMOTE_1(EXPR)    P99_SIGN_PROMOTE(1, (EXPR))
#define P99_PROMOTE_M1(EXPR)   P99_SIGN_PROMOTE(-1, (EXPR))
#define P99_SIGNED(EXPR) (P99_PROMOTE_M1(EXPR) < P99_PROMOTE_1(EXPR))

#define P99_SIGN_PROMOTE(A, B) (1 ? (A) : (B))


int main(void)
{
        unsigned int ui;
        long l;

        printf("ui %zu l %zu\n", sizeof(ui), sizeof(l));

        l = 0;
        ui = 1;

        l += -ui;

        printf("l %ld (%lx)  s? %d %d\n", l, l, P99_SIGNED(-ui), P99_SIGNED(l));

        return 0;
}
