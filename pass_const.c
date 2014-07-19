#include <stdio.h>

struct Bar {
    int a, b;
};

struct Foo {
    const struct Bar *bar;
};

void recv_const(struct Foo *f)
{
  printf("Got %d %d\n", f->bar->a, f->bar->b);
}
