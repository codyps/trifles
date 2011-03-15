#ifndef STDPARAM_H_
#define STDPARAM_H_

#define bsearch_fn(name) bsearch_##name

#define DEF_BSEARCH(name, type, cmp)				\
	type *bsearch_##name(type const *key, type const *base,	\
			size_t nmemb) {				\
		size_t l, u, idx;				\
		type const *p;					\
		int comparison;					\
								\
		l = 0;						\
		u = nmemb;					\
		while (l < u) {					\
			idx = (l + u) / 2;			\
			p = base + idx;				\
			comparison = cmp(key, p);		\
			if (comparison < 0)			\
				u = idx;			\
			else if (comparison > 0)		\
				l = idx + 1;			\
			else					\
				return (type *)p;		\
		}						\
		return NULL;					\
	}

#endif
