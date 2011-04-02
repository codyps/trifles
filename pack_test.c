#include <stdlib.h>
#include <stdint.h>
#define __packed __attribute__((packed))
#define __aligned __attribute__((aligned))

struct a_s {
	int a;
	uint8_t b;
	int c;
} __packed;

struct a_s b = { 33, 44, 55};

struct b_s {
	uint8_t b;
	struct a_s a;
	int c;
} __packed;

struct b_s a = { 19, {44, 12, 34}, 23};

struct c_s {
	int a;
	uint8_t b;
	int c;
} __packed __aligned;

struct c_s c = { 11, 33, 55 };

typedef struct c_s __packed c_t;
size_t s = sizeof(c_t);

