#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

#define PS 4096
static uint32_t blah;

//static uint8_t foo[2] __attribute__((aligned(PS)))[4096]; // attribute ignored
static uint8_t foo[3][4096] __attribute__((aligned(PS))); // attribute ignored
static uint32_t bar;

static size_t align_of(void *addr)
{
	uintptr_t a = (uintptr_t)addr;
	int i;
	for (i = 0; i < sizeof(addr) * CHAR_BIT; i++) {
		if (a & ((1 << i) - 1))
			return i - 1;
	}

	return SIZE_MAX;
}

static void pr(void *addr)
{
	printf("%p : %d\n", addr, 1 << align_of(addr));
}

int main(void)
{
	pr(&foo[0]);
	pr(&foo[1]);
	pr(&foo[1][1]);
	pr(&foo[1][PS-1]);
	return 0;
}
