#pragma once
/*
 * alloc-buddy is a general buddy allocator capable of using arbitrary (power of 2) block sizes
 *
 * Only designed to handle contiguous memory regions.
 *
 */

struct buddy;

int buddy_init(struct buddy *b, void *base, size_t block_ct, size_t block_bytes_order, size_t max_blocks_order);
void *buddy_alloc_block(struct buddy *b, size_t block_order);
void buddy_free(struct buddy *b, void *block);

/* internal, please don't access the fields directly */
struct buddy_free_block;
struct buddy_block_info;
struct buddy {
	/*
	 * first block
	 */
	void *base;
	
	/*
	 * Size of each block, given as a power of 2
	 *
	 * block_size_in_bytes = 1 << block_bytes_order;
	 */
	size_t block_bytes_order;

	/*
	 * number of blocks, each containing @block_size_in_bytes bytes
	 */
	size_t block_ct;

	/*
	 * Largest pairing of blocks together, limits size of maximum allocation.
	 * Power of 2
	 *
	 * max_allocation_in_blocks = 1 << max_blocks_order;
	 * max_allocation_in_bytes = block_size_in_bytes * max_allocation_in_blocks;
	 */
	size_t max_blocks_order;

	/*
	 * [0] = order 0 blocks
	 * [1] = order 1 blocks (2^1 * block_sz)
	 * [n] = order n blocks (2^n * block_sz)
	 * ...
	 * [max_blocks_order] = ...
	 *
	 * this points to an array with max_block_order entries
	 * The index in the array is the order of page stored in that list
	 *
	 * ie: pages double in size each time you move forward.
	 *
	 * This gives us forward scanning on allocation.
	 */
	struct buddy_free_block *(*free_lists)[static max_blocks_order];
	
	/* 
	 * We need a quick way to determine if a given block is allocated (to
	 * make free() fast).
	 *
	 * Further, to allow the free-er to not need to know the order, it is
	 * useful to be able to look up the order.
	 */
	struct block_info (*info)[static block_ct];
};

