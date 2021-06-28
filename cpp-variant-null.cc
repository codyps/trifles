#include <iostream>
#include <optional>

int main() {
	std::optional<double> a = 0;

	if (a) {
		std::cout << "have value: " << *a << std::endl;
	} else {
		std::cout << "don't have value" << std::endl;
	}
}
