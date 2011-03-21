#ifndef ADDRESS_SPACE_H_
#define ADDRESS_SPACE_H_ 1

struct addr_space {
	unsigned long region_ct;
	unsigned long region_mem_sz;
	struct mem_region *regions;
};

struct mem_region {
	unsigned long start_addr;
	size_t alloc_len;
	size_t used_len;
	char *mem;
};

int as_init(struct addr_space *as);
void as_destroy(struct addr_space *as);

int mr_init(struct mem_region *mr, unsigned long start_addr);
void mr_destroy(struct mem_region *mr);

int mr_append(struct mem_region *mr, void *data, size_t data_len);

int as_insert_mr(struct addr_space *as, struct mem_region *mr);
int as_insert(struct addr_space *as, unsigned long addr, char *data,
              size_t data_len);
#endif
