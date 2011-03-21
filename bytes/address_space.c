#include <address_space.h>

int as_init(struct addr_space *as)
{
	as->regions = NULL;
	as->region_ct = 0;
	return 0;
}

void mr_destroy(struct mem_region *mr)
{
	free(mr->mem);
	mr->mem = NULL;
	mr->alloc_len = 0;
	mr->used_len = 0;
}

void as_destroy(struct addr_space *as)
{
	size_t i;
	for(i = 0; i < as->region_ct; i++) {
		mr_destroy(as->regions + i);
	}

	free(as->regions);
}

#define MR_INITIAL_ALLOC 16
int mr_init(struct mem_region *mr, unsigned long start_addr)
{
	mr->start_addr = start_addr;
	mr->alloc_len = MR_INITIAL_ALLOC;
	mr->used_len = 0;
	mr->mem = malloc(mr->alloc_len);
	if (!mr->mem)
		return -1;

	return 0;
}

int mr_append(struct mem_region *mr, void *data, size_t data_len)
{
	while (mr->alloc_len < (mr->used_len + data_len)) {
		size_t new_alloc_len = mr->alloc_len * 2 + MR_INITIAL_ALLOC;
		mr->mem = realloc(mr->mem, new_alloc_len);
		if (!mr->mem)
			return -1;
	}

	memcpy(mr->mem + mr->used_len, data, data_len);

	return 0;
}

int as_insert(struct addr_space *as, unsigned long addr, char *data,
              size_t data_len)
{
#warning "unimplimended"

	/* Find a memory region containing the data we want to add
	 * or abutting our region */
	unsigned long addr_end = addr + data_len;
	size_t i = 0;
	for(i = 0; i < as->region_ct; i++) {
		struct mem_region *mr = as->regions + i;
		unsigned long mr_addr = mr->addr;
		size_t mr_len = mr->used_len;
		unsigned long mr_addr_end = mr_addr + mr_len;

		/* the added data is below exsisting data */
		bool abut_low  = (addr < mr_addr)
		                 && (addr_end > mr_addr);

		/* the added data is above exsisting data */
		bool abut_high = (mr_addr < addr)
		                 && (mr_addr_end > addr);

		if ( abut_high || abut_low ) {
			/* collision */

		}
	}

	/* no collision, append */

	return -1;
}

int as_insert_mr(struct addr_space *as, struct mem_region *mr)
{
	return as_insert(as, mr->start_addr, mr->mem, mr->used_len);
}

