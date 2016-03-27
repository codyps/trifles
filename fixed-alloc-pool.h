#pragma once
#include <stddef.h>

struct pool {
	/* only set on init, const */
	void *base;
	size_t block_size;
	size_t block_count;

	/* accounting */
	size_t head,
	       num_init;
};

void pool_init(struct pool *p, void *base, size_t block_sz, size_t block_count);
struct pool *pool_init_in(void *base, size_t block_size, size_t block_count);

size_t pool_index(struct pool *p, void *addr);
void *pool_alloc(struct pool *p);
void pool_free(struct pool *p, void *addr);
