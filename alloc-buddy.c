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

/* these are stored in the empty space in non-allocated (free) pages */
struct block_free_data {
	struct block_free_data *next;
};

struct buddy {
	void *base;
	size_t block_sz;
	size_t block_ct;
	size_t max_block_order;

	/* we need a quick way to find the "best" free blocks to select when the
	 * allocator asks for N blocks (to make alloc() fast)
	 */
	/* 
	 * this points to an array with max_block_order entries
	 * The index in the array is the order of page stored in that list
	 *
	 * ie: pages double in size each time you move forward.
	 *
	 * This gives us forward scanning on allocation.
	 */
	struct block_free_data *free_blocks;
	
	/* we need a quick way to determine if a given block is allocated (to
	 * make free() fast)
	 */
	struct block_info *info;
};

struct buddy_free_block_data {
	size_t order;
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
		.max_block_order = 
	};
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
