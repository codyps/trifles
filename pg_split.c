
static void split_page_left(unsigned long pfn, unsigned long page_ct,
		int order, struct zone *zone, int migratetype)
{
	struct page *page = pfn_to_page(pfn);
	struct free_area *area = &(zone->free_area[order]);
	int size = 1 << order;
	while (page_ct) {
		size >>= 1;
		order --;
		area  --;

		/* This is required for following case (and similar):
		 * |x|x|x|x|x|x|x|x|x|x|x|x|x|x|x|x| - an order 4 page
		 *           |
		 *           split here.
		 *  2 2 2 2 0 0 1 1 3 3 3 3 3 3 3 3
		 * order 2 + order 0 page on left, order 0, 1,3 pages on right.
		 */
		if (size > page_ct)
			continue;

		list_add(&page->lru, &area->free_list[migratetype]);
		area->nr_free++;
		set_page_order(page, order);

		page_ct -= size;
		page += size;
	}
}

static void split_page_right(unsigned long pfn_split, unsigned long page_ct,
		int order, struct zone *zone, int migratetype)
{
	struct page *page = pfn_to_page(pfn_split);
	unsigned long pfn_end = pfn_split + page_ct; /* 1 past the end of the page */
	int size = 1 << order;
	struct free_area *area = &(zone->free_area[order]);
	while (page_ct) {
		size >>= 1;
		order --;
		area  --;

		/* See reasoning in split_page_left() */
		if (size > page_ct)
			continue;

		list_add(&page[pfn_end - size].lru, &area->free_list[migratetype]);
		area->nr_free++;
		set_page_order(page, order);

		page_ct -= size;
		pfn_end -= size;
	}
}

/* XXX: only designed for 2 zones. */
static void split_page(unsigned long pfn, unsigned long pfn_split, int order,
		struct zone *z1, struct zone *z2, int migratetype)
{
	int l_ct = pfn_split - pfn; /* pfn_split is 1 past the last pfn in the
				       left portion of the split page */
	int l_order = order_base_2(l_ct);

	/* lock z1 */

	split_page_left(pfn, l_ct, l_order, z1, migratetype);

	/* unlock z1, lock z2 */

	int r_ct = (1 << order) - l_ct;
	int r_order = order - l_order;
	split_page_right(pfn, r_ct, r_order, z2, migratetype);
}
