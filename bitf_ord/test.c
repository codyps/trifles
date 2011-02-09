#include <stdio.h>
#include <stdint.h>

union stuff_s {
	struct {
		uint8_t n1 : 1;
		uint8_t n2 : 1;
		uint8_t n3 : 1;
		uint8_t n4 : 3;
		uint8_t n5 : 1;
	};
	struct {
		uint8_t b1 : 1;
		uint8_t b2 : 1;
		uint8_t b3 : 1;
		uint8_t b4 : 1;
		uint8_t b5 : 1;
		uint8_t b6 : 1;
		uint8_t b7 : 1;
		uint8_t b8 : 1;
	};
	struct {
		uint8_t e1;
		uint8_t e2;
	};
	uint8_t a[2];
	uint16_t c;
} __attribute__((packed)) us;

int main(int argc, char **argv)
{

	us.e1 = 1;

	printf("%d\n", us.c);
	return 0;
}
