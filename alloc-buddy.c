/*
 */

struct buddy {
	void *base;
	size_t block_sz;
	size_t block_ct;

	/* we need a quick way to determine if a given block is allocated (to
	 * make free() fast)*/

	/* we need a quick way to find the "best" free blocks to select when the
	 * allocator asks for N blocks (to make alloc() fast)
	 */
};


/*
 * Assume:
 *  - a contiguous region (we can't pair blocks between split regions anyhow)
 */
int buddy_init(struct buddy *b, void *base, size_t block_sz, size_t block_ct)
{

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
