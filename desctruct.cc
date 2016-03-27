#include <functional>

template<typename T>
class custom_free {
    public:
    custom_free(T& v, std::function<void(T &)> destruct)
        : _v(v)
        , _destruct(destruct)
    {}

    ~custom_free()
    {
        _destruct(_v);
    }

    private:
    T &_v;
    std::function<void(T&)> _destruct;
};

template<typename T>
custom_free<T> custom_free_make(T &v, std::function<void(T&)> d)
{
    return custom_free<T>(v, d);
}


int main(void)
{
    auto m = (char *)malloc(4);
    auto x = custom_free(*m, [](v){ free(v) } );

    return 0;
}
