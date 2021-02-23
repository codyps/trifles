#include <random>
#include <iostream>

struct sseq_notify {
	typedef uint32_t result_type;

	template<typename T, typename S>
	uint32_t generate(T &&, S &&) {
		std::cout << "\nANOTHER ONE" << std::endl;
		return 0;
	}

	size_t size() const {
		return 1;
	}

};

int main() {

	sseq_notify device;
	std::mt19937 generator(device);
	std::uniform_int_distribution<int> dist(1,6);

	for (size_t i = 0; i < 10000; i++) {
		std::cout << dist(generator);
	}

	std::cout << std::endl;
	return 0;
}
