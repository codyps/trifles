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
#include "alloc-buddy.h"

#include <stdbool.h>
#include <assert.h>
#include <limits.h>

#if 0
typedef uint8_t block_order_t;
typedef size_t  block_num_t;
/* block_ct */
/* block_size */
#endif

enum {
	// in `buddy_page_info.order`, this is stored when we have a super-block
	//
	// If we change the size of `order` from 7-bits, this should also be adjusted.
	SIZE_IN_BLOCK = 0x7f,
};

/* these are stored in the empty space in non-allocated (free) pages */
struct buddy_free_block {
	struct buddy_free_block *next;

	/*
	 * free blocks can have a non power of 2 order, so we need some more space.
	 *
	 * we note that the "super blocks" always contain 2**b - 2**a bytes,
	 * so we store the info about their size in that more compact form.
	 *
	 * 2**(upper + 1) - 2**lower
	 *
	 * They are always contained in the freelist of order_upper.
	 */
	uint8_t order_upper, order_lower;
};

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

static size_t
block_extra_size_(size_t order_upper, size_t order_lower)
{
	return (1 << (order_upper + 1)) - (1 << order_lower);
}

static size_t
block_extra_size(struct buddy *b, void *block)
{
	struct buddy_block_info *bi = &b->info[block_num(b, block)];
	assert(!bi->allocated);

	if (bi->order == SIZE_IN_BLOCK) {
		/* major cache miss here */
		struct buddy_free_block *fb = block;
		return block_extra_size_(fb->order_upper, fb->order_lower);
	} else {
		return 0;
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

static void
return_to_freelist_with_extra(struct buddy *b, void *block, size_t order_upper, size_t order_lower)
{
	assert(order_upper >= order_lower);
	/* 
	 * TODO: determine the block order (the one that is small enought to
	 * fit within this) */

	struct buddy_free_block *m = block;
	m->order_upper = order_upper;
	m->order_lower = order_lower;

	size_t blk_ct = block_extra_size_(order_upper, order_lower);
	size_t i;
	size_t n = block_num(b, block);
	for (i = 0; i < blk_ct; i++) {
		b->info[n + i] = (struct buddy_block_info) {
			.allocated = false,
			.order = SIZE_IN_BLOCK,
		};
	}

	struct buddy_free_block **x = &b->free_lists[order_upper];
	struct buddy_free_block *p = *x;
	m->next = p;
	*x = m;
}

static void
return_to_freelist_with_size(struct buddy *b, void *block, size_t bytes)
{
	assert(false);
}

static void
return_extra_to_freelists(struct buddy *b, void *block, size_t order)
{
	size_t extra_size = block_extra_size(b, block);
	if (!extra_size)
		return;

	/* TODO: determine largest power of 2 contained in the block, will be
	 * at most (order - 1) */
	assert(false);
}

/* In a classical buddy allocator, we would split off the block in half
 * until it was as small as we wanted.
 *
 * In this impl, however, we just grab our block off the end (or
 * start), mark the block as having a special size, store the new
 * special size, re-hook it into the free lists in (orig_block_order - 1),
 * and return our block.
 *
 * orig_block_order - 1 is always appropriate because the orig block can (at
 * most) be split to half it's size (or entirely consumed, in which case there
 * is no extra to return).
 *
 * Our steps:
 * 1. see if desired_order can be extracted from the "extra" parts of the free block
 * 2. if it can, shink "extra", return @block to free lists, and return "extra"
 *	TODO: consider avoiding removing blocks from free lists until here
 * 3. if "extra" isn't big enough, use part of the main block & return
 * "extra" and the remainder of the main block to the free lists.
 * return the split off part of the main block
 *
 *
 * In #3, we could split into 2 blocks instead of 3:
 *
 * Consider an 8 unit MainBlk (order=3) with 4 unit extra (order=2)
 *
 * |MainBlk|exr|  |
 * 012345678901234
 *
 * If we want to allocate order=2, we can take the extra.
 * If we want to allocate order=3, we take mainblk and return extra.
 * If we want to allocate order=1, we take part of the extra.
 *
 * Consider an 8 unit MainBlk (order=3) with 2 unit extra (order=1)
 *
 * |MainBlk|e|    |
 * 012345678901234
 *
 * order=3 -> alloc mainblk, free extra
 * order=2 -> ????
 * order=1 -> alloc extra, free mainblk
 *
 * In ????, we appear to have a few options:
 * 	A. return some the front of main-block
 * 	B. return the end of main-block
 * 	C. return the end of main-block + some of the extra
 *
 * A: |+++|-----|+++|
 * 	  |...|.|
 *    012345678901234
 * B: |---|+++|-|+++|
 * C: |-----|+++|+++|
 *     ...|.|
 *
 * C looks good, except for the issue with alignment.
 * A has the same issue with aligment, but for free blocks rather than
 * allocated ones. It isn't clear if we could handle missaligned free
 * blocks in the allocator (free blocks do need to turn into allocated
 * blocks to be useful, and misaligned freeblocks tend to generate
 * misaligned allocated blocks), so we should probably avoid this too.
 *
 * B, while looking ugliest, preserves alignment properly.
 */

/*
 * Note: what is the right way to handle alignment? The algorithm above
 * is designed to garuntee that the alignment of the returned block
 * matches the order of the block. However, doing this means we're
 * allocating the end of memory first & we end up splitting blocks into
 * pieces more that strictly necessary. Note that in #3 we generate 3
 * blocks (2 free) from a single split where if we could relax the
 * alignment we could generate 2 blocks (1 free) from the split
 *
 * That said, it might be that we'd have to relax the alignment for all
 * allocations, not just on a per-allocation basis.
 */
static
void *
split_block_to(struct buddy *b, void *block, size_t block_order, size_t desired_order)
{
	assert(block_order > desired_order);
	size_t extra_ct = block_extra(b, block);
	struct buddy_free_block *bfb = block;
	if (extra_ct)
		assert(bfb->order_upper == block_order);
	else
		assert(block_order(b, block) == block_order);

	/*
	 * 1. see if desired_order can be extracted from the "extra" parts of the free block
	 * 2. if it can, shink "extra", return @block to free lists, and return "extra"
	 *	TODO: consider avoiding removing blocks from free lists until here
	 * 3. if "extra" isn't big enough, use part of the main block & return
	 * "extra" and the remainder of the main block to the free lists.
	 * return the split off part of the main block
	 */
	size_t desired_ct = 1 << desired_order;
	size_t bs = b->block_size << block_order;
	void *extra = block + bs;
	if (extra_ct == desired_ct) {
		return_to_free_list_with_order(b, block, block_order);
		return extra;
	} else if (extra_size > desired_size) {
		/* Extra is always in the form of a**2 - b**2 where a > b
		 *
		 * What does this tell us about splitting it?
		 */

		/* TODO: split extra */
		assert(false);
	} else {
	       	/* extra_size < desired_size */
		if (extra_ct)
			return_to_free_list_with_extra(b, extra, block_order, bfb->order_lower);

		/* We need to split the end of the main block off */
		size_t remaining_ct = (1 << block_order) - desired_ct;
		void *r = block - remaining_ct * b->block_size;
		return_to_free_list_with_size(b, block, new_extra_ct);
		return r;
	}
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

		/* no can do, need to allocate a split block */
		if (!r)
			continue;

		if (order != i_order)
			r = split_block_to(b, r, i_order, order);
		else
			/* the block may have an "extra" component that we need
			 * to track */
			return_extra_to_freelists(b, r, order);

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
	size_t order = block_order(b, block_num);

	/* see if we can merge this block */
	size_t buddy = block_buddy(b, block_num, order);

	/* if buddy is free & buddy_order = our_order */
	struct buddy_block_info *i = b->info[buddy];
	if (!i->allocated && i->order == order) {
		/* MERGE */
		/* remove buddy from free list */

		/* XXX: do we need to attempt to do further merging? */
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
		if (next_base > end) {
			/* if we try to create a block past the end, create a
			 * super block, and we're done */
			return_to_freelist_with_size(b, bi, end - bi);
			break;
		}

		return_to_freelist_with_order(b, bi, o);

		if (next_base == end) 
			break;

		bi = next_base;
		o = max_order;
	}

	return 0;
}

