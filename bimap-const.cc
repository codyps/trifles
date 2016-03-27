#include <boost/bimap.hpp>

template <typename L, typename R>
boost::bimap<L, R>
make_bimap(std::initializer_list<typename boost::bimap<L, R>::value_type> list)
{
    return boost::bimap<L, R>(list.begin(), list.end());
}

const static auto foo = make_bimap<std::string, int>({
    { "hi" , 1 },
    { "bye", 2 }
});

int main(void)
{
    return 0;
}
