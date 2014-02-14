#include <stdio.h>
#include <inttypes.h>

typedef uint64_t u64;

struct foo {
	union {
		void *ptr;
		u64 pad;
	};
	u64 junk;
};


#define PA(a, b) printf(#a " = %p\n", (void *)((void *)a - (void *)b))

int main(void)
{
	struct foo foo;
	PA(&foo.ptr, &foo);
	PA(&foo.pad, &foo);
	PA(&foo.junk, &foo);

	foo.ptr = (void *)0x0BADBEEF;

	printf("ptr = %p, pad = 0x%"PRIx64"\n",
			foo.ptr, foo.pad);

	return 0;
}

