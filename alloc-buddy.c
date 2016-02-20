/*
 * Papers:
 *  http://www.cs.au.dk/~gerth/papers/actainformatica05.pdf 
 *  - Fast Allocation and Deallocation with an Improved Buddy System
 *     Erik D. Demaine and J.  Ian Munro
 *
 *  -
 */

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
	 * per-block need:
	 * uint8_t free:1;
	 * uint8_t order:7; // 2**128 max blocks
	 */

	/*
	 * [0] = order 0 blocks
	 * [1] = order 1 blocks (2^1 * block_sz)
	 * [n] = order n blocks (2^n * block_sz)
	 */
	struct buddy_free_block *free_lists[/* ilog_zu(block_ct) */];
	
	/* provides some of the same functionality as linux's page bits */
	/* TODO: consider if we need/should store "order" here */
	struct block_info *info;
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
int buddy_init(struct buddy *b, void *free_bitmap, void *base, size_t block_sz, size_t block_ct)
{
	/* TODO: check that base is aligned to block_sz */

	/* block_sz * 2**x == block_sz * block_ct
	 * 2**x == block_ct
	 * x = log2(block_ct)
	 *
	 */
	size_t high_order = 

	*b = (struct buddy) {
		.base = base,
		.block_sz = block_sz,
		.block_ct = block_ct,
		.free_bitmap = free_bitmap
		.high_order = 
	};
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
size_t block_buddy(struct buddy *b, size_t blk_num)
{
	size_t m = 1 << block_order(b, blk_num);
	assert(0 == ~(m - 1) & blk_num);
	return blk_num & m ? blk_num & ~m : blk_num | m;
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
	size_t i_order = 
	for (;;) {
		
	}
}

/*
 * Unclear:
 *  - block count might not be required, but probably is
 */
void *buddy_free(struct buddy *b, size_t order)
{

}
