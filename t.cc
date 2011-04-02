#include <stdint.h>

struct Header {
	uint8_t type;
	uint8_t length;
};

struct Data {
	uint8_t buff[16];
};

class InCtx {
	Data data;
	Header &head = data;
}

int main(void) {
	InCtx c;

	return 0;
}
