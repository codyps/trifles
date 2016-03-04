#include <iostream>

class Foo {
    public:
        static constexpr size_t COUNT = 2;
};

class Bar {
    public:
        static constexpr size_t COUNT = 1;
};


static const size_t m = std::max(Foo::COUNT, Bar::COUNT);

int main(void) {
    std::cout << "max: " << m << std::endl;
    return 0;
}
