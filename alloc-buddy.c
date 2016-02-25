/*
 * Papers:
 *  http://www.cs.au.dk/~gerth/papers/actainformatica05.pdf 
 *  - Fast Allocation and Deallocation with an Improved Buddy System
 *     Erik D. Demaine and J.  Ian Munro
 *
 *  -
 */

typedef size_t block_order_t;
typedef size_t block_num_t;

struct block_info {
	uint8_t allocated:1;

	/*
	 * we probably don't need this many bits
	 * max block size = 2**128
	 */
	uint8_t order:7;
};

/* these are stored in the empty space in non-allocated (free) pages */
struct buddy_free_block {
	struct buddy_free_block *next;

	/* free blocks can have a non power of 2 order, so we need some more space. */
	size_t order;
};

struct buddy {
	void *base;
	size_t block_sz;
	size_t block_ct;

	/*
	 * max_order could be calculated via ilog_zu(block_ct), but right now we
	 * don't do that
	 */
	size_t max_order;

	/*
	 * [0] = order 0 blocks
	 * [1] = order 1 blocks (2^1 * block_sz)
	 * [n] = order n blocks (2^n * block_sz)
	 * ...
	 * [max_order] = ...
	 */
	/* 
	 * this points to an array with max_block_order entries
	 * The index in the array is the order of page stored in that list
	 *
	 * ie: pages double in size each time you move forward.
	 *
	 * This gives us forward scanning on allocation.
	 */
	struct buddy_free_block *(*free_lists)[];
	
	/* 
	 * We need a quick way to determine if a given block is allocated (to
	 * make free() fast).
	 *
	 * Further, to allow the free-er to not need to know the order, it is
	 * useful to be able to look up the order.
	 */
	struct block_info (*info)[];
};

size_t buddy_free_bitmap_len(size_t block_ct)
{
	return block_ct / CHAR_BIT;
}

/*
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
int buddy_init(struct buddy *b, void *base, size_t block_sz, size_t block_ct, size_t max_order)
{
	size_t order_limit ol;
	{
		struct block_info i;
		i.order = -1;
		ol = i.order;
	}

	/* 
	 * we use the last order value (in free blocks) to indicate that one
	 * should read from the free_block info
	 */
	assert(max_order < ol);
	/* TODO: check that base is aligned to block_sz */

	/* block_sz * 2**x == block_sz * block_ct
	 * 2**x == block_ct
	 * x = log2(block_ct)
	 *
	 */
	struct buddy_free_block *(*free_lists)[] = calloc(sizeof(*free_lists), max_order);
	if (!free_lists)
		return -ENOMEM;

	struct block_info (*info)[] = calloc(sizeof(*info), block_ct);
	if (!info) {
		free(free_lists);
		return -ENOMEM;
	}

	*b = (struct buddy) {
		.base = base,
		.block_sz = block_sz,
		.block_ct = block_ct,
		.max_order = max_order,
		.free_lists = free_lists,
		.block_info = info;
	};

	/* TODO: initialize free lists */
	assert(0);

	return 0;
}

size_t block_num(struct buddy *b, void *block)
{
	assert(b->base <= block);
	assert(b->base + (b->block_ct - 1) * b->block_sz => block)
	return (block - b->base) / b->block_sz;
}

/* return the buddy of this block */
size_t block_buddy(struct buddy *b, size_t blk_num, size_t order)
{
	size_t m = 1 << order;
	assert(0 == ~(m - 1) & blk_num);
	/* are we the "upper" block? if so, return the lower. Otherwise, return the
	 * upper */
	return blk_num & m ? blk_num & ~m : blk_num | m;
}

static
void *try_alloc_exact_order(struct buddy *b, size_t order)
{
	struct block_free **x = &b->free_lists[order];

	void *r = *x;
	if (r) {
		*x = (*x)->next;
	}
	return r;
}

static void
mark_allocated(struct buddy *b, void *block, size_t order)
{
	b->info[block_num(b, block)] = (struct block_info) {
		.allocated = true,
		.order = order,
	};
}

static size_t
block_extra_size(struct buddy *b, void *block)
{
	struct block_info *bi = &b->info[block_num(b, block)];
	assert(!bi->allocated);

	if (bi->order == SIZE_IN_BLOCK) {
		/* major cache miss here */
		struct buddy_free_block *fb = block;
		return fb->size;
	} else {
		return 0;
	}
}

static void
return_to_freelist_with_order(struct buddy *b, void *block, size_t order)
{
	struct block_free **x = &b->free_lists[order];
	struct block_free *p = *x;
	struct block_free *m = block;

	b->info[block_num(b, block)] = (struct block_info) {
		.allocated = false,
		.order = order,
	};

	m->next = p;
	*x = m;
}

static void
return_to_freelist_with_size(struct buddy *b, void *block, size_t size)
{
	/* 
	 * TODO: determine the block order (the one that is small enought to
	 * fit within this) */
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
 * special size, re-hook it into the free lists in (block_order - 1),
 * and return our block.
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
	size_t extra_ct = block_extra_ct(b, block);

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
		/* Extra is always in the form of a**2 - b**2 where b < a 
		 *
		 * What does this tell us about splitting it?
		 */

		/* TODO: split extra */
		assert(false);
	} else {
	       	/* extra_size < desired_size */
		if (extra_ct)
			return_to_free_list_with_size(b, extra, extra_ct);

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
	struct block_info *i = b->info[buddy];
	if (!i->allocated && i->order == order) {
		/* MERGE */
		/* remove buddy from free list */

		/* XXX: do we need to attempt to do further merging? */
		assert(false);
	}

	/* TODO: return our merged block to a free list */
	assert(false);
}
