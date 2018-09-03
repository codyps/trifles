#include <iostream>

struct Formatter {
	Formatter()
	{}

	void write(std::string const& in)
	{
		std::cout << in;
	}
};

struct show_T {

};

template<typename T>
struct show_t {
	static void show(T const& self, Formatter &fmt)
	{
		show_t::show(self);
	}
};

namespace show {
	template<typename T>
	void show(T const &self)
	{
		Formatter f{};
		show_t<T>::show(self, f);
	}
}

template<>
struct show_t<std::string> {
	static void show(std::string const &self, Formatter &fmt)
	{
		fmt.write(self);
	}
};

struct foo {
	std::string name;
	int f;
	double y;
};

template<>
struct show_t<foo> {
	static void show(foo const &self, Formatter &fmt)
	{
		fmt.write(
	}
}


int main()
{
	std::string it = "hello world";
	show::show(it);
	show::show("reddit");
	return 0;
}
