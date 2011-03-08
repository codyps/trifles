#include <stdio.h>

int main(void)
{
	int i;
	for(i = 0; i <= 100; i++) {
		int fizz = !(i % 3);
		int buzz = !(i % 5);

		if (fizz && buzz) {
			puts("FizzBuzz");
		} else if (fizz) {
			puts("Fizz");
		} else if (buzz) {
			puts("Buzz");
		} else {
			printf("%d\n", i);
		}
	}
	return 0;
}
