
/* circular secondary allocator */

struct cpa_ctx {
	void *page;
};

static int cpa_init(struct cpa *cpa)
{
	cpa->page = NULL;
}

#define cpa_alloc(cpa, type) cpa_alloc_(cpa, sizeof(type), __alignof__(type))
static void *cpa_alloc_with_align(struct cpa_ctx *cpa, unsigned size, unsigned align)
{
	void *offs = cpa->offset
	if (!offs) {
		offs = alloc_page();
		if (!offs)
			return NULL;
	}
}
