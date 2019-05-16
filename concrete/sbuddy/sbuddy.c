/*
 * Papers:
 *  http://www.cs.au.dk/~gerth/papers/actainformatica05.pdf 
 *  - Fast Allocation and Deallocation with an Improved Buddy System
 *     Erik D. Demaine and J.  Ian Munro
 *
 *  - http://bitsquid.blogspot.com/2015/08/allocation-adventures-3-buddy-allocator.html
 *    - only need split markers
 *    - use tree depth to determin order instead of storing explicitly
 */
#include "sbuddy.h"

#include <stdbool.h>
#include <assert.h>
#include <limits.h>

#define bit_mask(bit_count) ((bit_count) ? ((UINTMAX_C(1) << ((bit_count) - 1) << 1) - 1) : 0)

static inline
bool is_power_of_2(unsigned long n)
{
	return (n != 0 && ((n & (n - 1)) == 0));
}

static size_t align_of(void *addr)
{
	uintptr_t a = (uintptr_t)addr;
	size_t i;
	for (i = 0; i < sizeof(addr) * CHAR_BIT; i++) {
		if (a & ((1 << i) - 1))
			return i - 1;
	}

	return SIZE_MAX;
}

size_t
buddy_block_count(size_t size_bytes, size_t block_bytes_order)
{
	// are we ok with just losing some bytes? or should we complain?
	assert((size_bytes % (1 << block_bytes_order)) == 0);
	return size_bytes / (1 << block_bytes_order);
}

static size_t
block_num(struct buddy *b, void *block)
{
	assert(b->base <= block);
	assert((uintptr_t)b->base + ((b->block_ct - 1) << b->block_bytes_order) >= (uintptr_t)block);
	return ((uintptr_t)block - (uintptr_t)b->base) >> b->block_bytes_order;
}

/* return the buddy of this block */
static
size_t
block_buddy(struct buddy *b, size_t blk_num, size_t order)
{
	(void)b;

	size_t m = 1 << order;
	assert(0 == (~(m - 1) & blk_num));
	/* are we the "upper" block? if so, return the lower. Otherwise, return the
	 * upper */
	return blk_num & m ? blk_num & ~m : blk_num | m;
}

// remove a page from the free lists, but don't do anything else
static void *
try_alloc_exact_order(struct buddy *b, size_t order)
{
	struct buddy_free_block **x = &b->free_lists[order];

	void *r = *x;
	if (r)
		*x = (*x)->next;
	return r;
}

// for every basic block composing our higher-order block, mark the order &
// allocated status in the block info.
//
// XXX: consider if we can avoid doing so much work on allocation here. This
// data is used for merging blocks together when freed. Could plausibly do more
// work on free to avoid this.
static void
mark_allocated(struct buddy *b, void *block, uint8_t order)
{
	size_t n = block_num(b, block);
	size_t blk_ct = 1 << order;
	for (size_t i = 0; i < blk_ct; i++) {
		b->info[n + i] = (struct buddy_block_info) {
			.allocated = true,
			.order = order,
		};
	}
}

static void
return_to_freelist_with_order(struct buddy *b, void *block, uint8_t order)
{
	struct buddy_free_block **x = &b->free_lists[order];
	struct buddy_free_block *p = *x;
	struct buddy_free_block *m = block;

	size_t n = block_num(b, block);
	size_t i;
	size_t blk_ct = 1 << order;
	for (i = 0; i < blk_ct; i++) {
		b->info[n + i] = (struct buddy_block_info) {
			.allocated = false,
			.order = order,
		};
	}

	m->next = p;
	*x = m;
}

static
void *
split_block_to(struct buddy *b, void *block, uint8_t block_order, uint8_t desired_order)
{
	assert(block_order > desired_order);
	struct buddy_free_block *bfb = block;

	while (block_order > desired_order) {
		// split, work with first half
		uint8_t next_order = block_order - 1;
		return_to_freelist_with_order(b, block + 1 << next_order, next_order);
		block_order = next_order;
	}

	// we currently always choose to allocate the earlier block, but could
	// change this.
	//
	// In particular, in extended page allocators with "super blocks", it
	// might be useful to allocate from the end.
	return block;
}

void *
buddy_alloc(struct buddy *b, size_t order)
{
	/* find a block with:
	 *  - with the given order
	 *  - or if no such block exists, split a larger order block
	 */

	/*
	 * Iterate over top-level blocks, then follow them down.
	 * If things get too small before finding a free block of the appropriate size, go up a level
	 * If the first free block found is too large, split it
	 *
	 * This means:
	 *  - we pick the first free block (instead of the "best" or "highest"), which might cause fragmentation.
	 *  - could search in reverse to lower fragmentation
	 */
	size_t mo = b->max_order;
	void *r;
	size_t i_order;
	for (i_order = order; i_order < mo; i_order++) {
		r = try_alloc_exact_order(b, i_order);

		/* none avaliable in this order, try a bigger one */
		if (!r)
			continue;

		if (order != i_order)
			r = split_block_to(b, r, i_order, order);

		mark_allocated(b, r, order);
		return r;
	}

	/* allocation failed, no larger blocks to split */
	return NULL;
}

/*
 * Unclear:
 *  - block count might not be required, but probably is
 */
void
buddy_free(struct buddy *b, void *block)
{
	size_t block_num = block_num(b, block)
	uint8_t order = block_order(b, block_num);

	/* see if we can merge this block */
	size_t buddy = block_buddy(b, block_num, order);

	/* if buddy is free & buddy_order = our_order */
	struct buddy_block_info *i = b->info[buddy];
	if (!i->allocated && i->order == order) {
		/* MERGE */
		/* remove buddy from free list */
		/* O(1) only if using a doubly linked list */

		assert(false);
	}

	/* TODO: return our merged block to a free list */
	assert(false);
}

/*
 * If we have @block_ct, then we probably have calculated the block size (using
 * the order or otherwise) prior to calling this function.
 *
 * Probably want something that allows providing a length in bytes so the user
 * is freed from doing pre-calculation using our parameters.
 *
 * Assume:
 *  - a contiguous region (we can't pair blocks between split regions anyhow)
 *
 * TODO:
 *  - provide an initializer that takes it's free_bitmap from the memory supplied
 *  - provide an initializer that can put struct buddy in the memory supplied
 *
 * XXX:
 *  - common designs use a set of lists, one for each order
 */
int buddy_init(struct buddy *b, void *base, size_t size_order, size_t block_bytes_order, size_t max_blocks_order,
		// an array of pointers to `struct buddy_free_block`, array size is `max_blocks_order`.
		struct buddy_free_block *(*free_lists)[],
		// `buddy_block_count(size_bytes, block_bytes_order)`
		struct buddy_block_info (*info)[])
{
	size_t order_limit;
	{
		struct buddy_block_info i;
		i.order = -1;
		order_limit = i.order;
	}
	/*
	 * is max_order small enough to fit in our storage? Use less than (not
	 * equals) because we need the high value to mark super blocks.
	 */
	assert(max_blocks_order < order_limit);

	/*
	 * ensure we have enough space in blocks given the minimum order 
	 */
	size_t block_sz = 1 << block_bytes_order;
	assert(block_sz >= sizeof(struct buddy_free_block));

	/* is base aligned to block_sz? */
	// we could allow this, but we'd need code to handle the offset.
	assert(((uintptr_t)base & (block_sz - 1)) == 0);

	/* 
	 * block_sz * 2**x == block_sz * block_ct
	 * 2**x == block_ct
	 * x = log2(block_ct)
	 *
	 */
	size_t size_bytes = 1 << size_order;
	size_t block_ct = buddy_block_count(size_bytes, block_bytes_order);

	*b = (struct buddy) {
		.base = base,
		.block_bytes_order = block_bytes_order,
		.block_ct = block_ct,
		.max_blocks_order = max_blocks_order,
		.free_lists = free_lists,
		.info = info,
	};

	// FIXME: address alignment of `base` could be pretty bad, and it would
	// be good to align our blocks based on address alignment here by
	// generating lower order blocks first to get to an appropriate
	// alignment.
	//
	// Right now, we just chose the largest block order until we can't,
	// then shrink.
	size_t o = align_of(base >> block_bytes_order);
	void *bi = base;
	void *end = size_bytes + (char *)base;
	for (;;) {
		/* iterate over block_ct in max_order chunks. If max_order goes
		 * past block_ct, create a super block & we're done */
		void *next_base = bi + 1 << o;

		return_to_freelist_with_order(b, bi, o);

		if (next_base == end) 
			break;

		bi = next_base;
		o = max_order;
	}

	return 0;
}

