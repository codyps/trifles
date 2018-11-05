#include <stdio.h>

#define PR__CHARP(x) fputs((x), stdout)
#define PR__INT(x)   printf("%d", x)

#define PR_G(x) _Generic((x), \
    int: printf("%d", (x)), \
    const char*: fputs((x), stdout), \
)


int main(void)
{
    PR_G("hi ");
    PR_G((int)1);
    putchar('\n');
    return 0;
}
