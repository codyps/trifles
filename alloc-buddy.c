/*
 */

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
	struct list_head free[/* ilog_zu(block_ct) */];
};

/*
 * Assume:
 *  - a contiguous region (we can't pair blocks between split regions anyhow)
 */
int buddy_init(struct buddy *b, void *base, size_t block_sz, size_t block_ct)
{

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

void *buddy_alloc(struct buddy *b, size_t blocks)
{

}

/*
 * Unclear:
 *  - block count might not be required, but probably is
 */
void *buddy_free(struct buddy *b, size_t blocks)
{

}
