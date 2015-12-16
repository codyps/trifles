/*
 * Based on the paper: 
 * "Fast Efficient Fixed-Size Memory Pool: No Loops and No Overhead"
 * computation_tools_2012_1_10_80006.pdf
 * ISBN: 978-1-61208-222-6
 *
 *
 * Limitations:
 *  - allocations must be a fixed size (block size)
 *  - we can have lower per-pool overhead in exchange for higher minimum block
 *    size
 *
 */
#include <assert.h>
#include "fixed-alloc-pool.h"

struct unused_block {
	size_t next;
};

void pool_init(struct pool *p, void *base, size_t block_size, size_t block_count)
{
	/* confirm that a block is minimally large enough to contain our book-keeping
	 * In the future, it might be possible to use a group of free blocks to store the free list
	 */

	assert(block_count > 0);
	assert(block_size >= sizeof(struct unused_block));

	*p = (struct pool) {
		.base = base,
		.block_size = block_size,
		.block_count = block_count,
		
		.head = 0,
		.num_free = block_count,
		.num_init = 0,
	};
}

size_t pool_index(struct pool *p, void *addr)
{
	assert(p->base <= addr);

	size_t i = addr - p->base;
	if (i) {
		assert(!(i % p->block_size));
		i /= p->block_size;
	}

	assert(i < p->block_count);
	return i;
}

void *pool_alloc(struct pool *p)
{
	size_t h = p->head;
	void *r = p->base + h * p->block_size;

	/* internal rather than usage check */
	assert(h <= p->block_count);

	if (h == p->block_count) {
		/* no memory, sorry */
		return NULL;
	}

	p->num_free--;
	if (h >= p->num_init) {
		/* allocate uninitialized block */
		p->num_init++;
		p->head++;
		return r;
	} else {
		/* allocate initialized block */
		p->head = ((struct unused_block *)r)->next;
		return r;
	}
}

void pool_free(struct pool *p, void *addr)
{
	size_t i = pool_index(p, addr);

	/* if we give out a block, it is considered "initialized" */
	assert(i < p->num_init);

	size_t h = p->head;
	p->head = i;
	((struct unused_block *)addr)->next = h;

	/* unclear if we need to track this */
	p->num_free ++;
}
