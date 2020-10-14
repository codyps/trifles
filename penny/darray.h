#ifndef DARRAY_H_
#define DARRAY_H_

#define DA_DEF_TYPE(name, type)    \
	struct da_##name {   \
		size_t ct;   \
		size_t mem;  \
		type *items; \
	}

#define DA_INIT_MEM 8

#define da_t(name) struct da_##name

#define da_init(name) da_init_##name


#define DA_INITIALIZER { .ct = 0, .mem = 0, .items = NULL }

#define DA_INIT(dap, init_sz)					\
	({	bool fail;					\
		(dap)->ct = 0;					\
		(dap)->mem = (init_sz);				\
		(dap)->items = malloc(sizeof(*(dap)->items) *	\
					(dap)->mem);		\
		if (!(dap)->items)				\
			fail = 1;				\
		else						\
			fail = 0;				\
		fail;						\
	})

#define DA_DESTROY(dap)			\
	do {				\
		free((dap)->items);	\
		(dap)->ct = 0;		\
		(dap)->mem = 0;		\
		(dap)->items = NULL;	\
	} while(0)

#define da_append(d, item) DA_ADD_TO_END(d, item)
#define DA_ADD_TO_END(dap, item)				\
	({	bool fail;					\
		if (DA_CHECK_AND_REALLOC((dap)->items,	\
			(dap)->mem, (dap)->ct + 1)) {	\
			fail = true;				\
		} else {					\
			(dap)->items[(dap)->ct] = item;	\
			(dap)->ct++;				\
			fail = false;				\
		}						\
		fail;						\
	})

#define DA_CHECK_AND_REALLOC(mem_base, mem_sz, new_elem_ct)       \
	({ bool fail;                                             \
	if ((new_elem_ct) > (mem_sz)) {                           \
		typeof(mem_sz) attempt_sz = 2 * (mem_sz) + 8;     \
		typeof(mem_base) new_mem_base = realloc(mem_base, \
			sizeof(*(mem_base)) * attempt_sz);        \
		if (!new_mem_base) {                              \
			fail = true;                              \
		} else {                                          \
			mem_base = new_mem_base;                  \
			mem_sz = attempt_sz;                      \
			fail = false;                             \
		}                                                 \
	} else {                                                  \
		fail = false;                                     \
	}                                                         \
	fail; })

#define DA_REMOVE(base_p, ct, rem_p) do {                                     \
	(ct) --;                                                              \
	size_t ct_ahead = (rem_p) - (base_p);                                 \
	size_t ct_to_end = (ct) - ct_ahead;                                   \
	memmove((rem_p), (rem_p)+1, ct_to_end * sizeof(*(base_p)));           \
} while (0)

#endif
