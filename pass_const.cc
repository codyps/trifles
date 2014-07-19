#include <iostream>

struct Bar {
    int a, b;
};

struct Foo {
    const Bar &bar;
};

extern "C" void recv_const(struct Foo *f);


int main(void)
{
    struct Bar b(1, 6);
    struct Foo foo(b);

    recv_const(&foo);
    std::cout << "Hi";
    return 0;
}
