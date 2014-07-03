#include <boost/signals2.hpp>
#include <boost/bind.hpp>
#include <iostream>

struct HelloWorld {
    void operator()() const {
        std::cout << "Hello, World!" << std::endl;
    }
};

int main(void)
{
    boost::signals2::signal<void ()> sig;

    HelloWorld hello;
    sig.connect(hello);
    sig();

    return 0;
}
