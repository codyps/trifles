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

	/* we probably don't need this many bits
	 * max block size = 2**128
	 */
	uint8_t order:7;
};

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
	struct buddy_free_block *(*free_lists)[];

	/* provides some of the same functionality as linux's page bits */
	/* TODO: consider if we need/should store "order" here */
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
	/* TODO: check that base is aligned to block_sz */

	/* block_sz * 2**x == block_sz * block_ct
	 * 2**x == block_ct
	 * x = log2(block_ct)
	 *
	 */
	struct buddy_free_block *(*free_lists)[] = sizeof(*free_lists) * max_order;
	if (!free_lists)
		return -ENOMEM;

	struct block_info (*info)[] = malloc(*info) * block_ct;
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

	return 0;
}

size_t buddy_size(size_t block_ct)
{
	return offsetof(struct buddy, free[ilog_zu(block_ct)]);
}

size_t block_order(struct buddy *b, size_t blk_num)
{
	assert(0);
	/*
	 * assert(order <= max_order)
	 */
}

bool block_is_free(struct buddy *b, size_t blk_num)
{
	assert(0);
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
mark_info_as_allocated(struct buddy *b, void *block, size_t order)
{
	/* TODO: figure out how much of info we need to mark for this allocation */
	b->info[block_num(b, block)]
}

static
void *
split_block_to(struct buddy *b, void *block, size_t block_order, size_t desired_order)
{

}

void *buddy_alloc(struct buddy *b, size_t order)
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

		mark_info_as_allocated(b, r, order);
		return r;
	}

	/* allocation failed, no larger blocks to split */
	return NULL;
}

/*
 * Unclear:
 *  - block count might not be required, but probably is
 */
void buddy_free(struct buddy *b, void *block)
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
	}

	/* TODO: return our merged block to a free list */
}
