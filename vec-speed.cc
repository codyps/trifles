#include <cstddef>
#include <vector>
#include <chrono>
#include <iostream>


namespace std {
	inline namespace literals {
		inline namespace support_literals {
			constexpr size_t operator "" _z(unsigned long long x)
			{
				return static_cast<size_t>(x);
			}
			constexpr ptrdiff_t operator "" _t(unsigned long long x)
			{
				return static_cast<ptrdiff_t>(x);
			}
		}
	}
}

using namespace std::support_literals;

#include <boost/random/uniform_int_distribution.hpp>
#include <boost/random/mersenne_twister.hpp>

template<typename T>
std::vector<T> some_vec(size_t len) {
	boost::random::mt19937 gen;
	boost::random::uniform_int_distribution<uint8_t> dist(1, 6);

	std::vector<uint8_t> x;
	for (size_t i = 0; i < len; i++) {
		x.emplace_back(dist(gen));	
	}

	return x;
}

std::vector<uint8_t> x, y, z;
int main(void)
{
	x = some_vec<uint8_t>(1000_z);
	std::cout << "foo" << std::endl;
	y = x;
	std::cout << "bar" << std::endl;
	return 0;
}
