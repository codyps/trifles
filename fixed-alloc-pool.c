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

#define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

static
void pool_init_(struct pool *p, void *base, size_t block_size, size_t block_count, size_t pre_alloc)
{
	/* 
	 * Confirm that a block is minimally large enough to contain our book-keeping
	 */
	assert(block_count > 0);
	assert(block_size >= sizeof(struct unused_block));

	*p = (struct pool) {
		.base = base,
		.block_size = block_size,
		.block_count = block_count,
		
		.head = pre_alloc,
		.num_init = pre_alloc,
	};
}

/*
 * Initialize and allocate a pool within itself
 * Depending on the block size, this could have a lot of overhead (and use a lot of space in the pool memory).
 * If at all possible, the normal pool_init() mechanism should be used.
 */
struct pool *pool_init_in(void *base, size_t block_size, size_t block_count)
{

	size_t min_blocks = DIV_ROUND_UP(sizeof(struct pool), block_size);
	if (min_blocks < block_count)
		return NULL;

	struct pool *p = base;
	pool_init_(p, base, block_size, block_count, min_blocks);
	return p;
}

void pool_init(struct pool *p, void *base, size_t block_size, size_t block_count)
{
	pool_init_(p, base, block_size, block_count, 0);
}

size_t pool_index(struct pool *p, void *addr)
{
	assert(p->base <= addr);

	size_t i = addr - p->base;
	assert(!(i % p->block_size));
	i /= p->block_size;
	assert(i < p->block_count);
	return i;
}

void *pool_alloc(struct pool *p)
{
	size_t h = p->head;

	/* internal rather than usage check */
	assert(h <= p->block_count);

	if (h == p->block_count) {
		/* no memory, sorry */
		return NULL;
	}

	void *r = p->base + h * p->block_size;
	if (h >= p->num_init) {
		/* allocate uninitialized block */
		p->num_init++;
		p->head++;
	} else {
		/* allocate initialized block */
		p->head = ((struct unused_block *)r)->next;
	}
	return r;
}

void pool_free(struct pool *p, void *addr)
{
	size_t i = pool_index(p, addr);

	/* if we give out a block, it is considered "initialized" */
	assert(i < p->num_init);

	/*
	 * TODO: when debug is enabled, scan list of free blocks to confirm
	 * this is not already a free block
	 */

	size_t h = p->head;
	p->head = i;
	((struct unused_block *)addr)->next = h;
}
