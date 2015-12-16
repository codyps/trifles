#pragma once
#include <stddef.h>

struct pool {
	/* fixed */
	void *base;
	size_t block_size;
	size_t block_count;

	/* accounting */
	size_t head,
	       num_free,
	       num_init;
};

void pool_init(struct pool *p, void *base, size_t block_sz, size_t block_count);


size_t pool_index(struct pool *p, void *addr);
void *pool_alloc(struct pool *p);
void pool_free(struct pool *p, void *addr);
