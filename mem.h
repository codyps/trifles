#ifndef PENNY_MEM_H_
#define PENNY_MEM_H_
#include <string.h> /* memcmp (size_t implicit) */
#include <stdbool.h>

static inline void *memmem(const void *haystack, size_t haystacklen,
	     const void *needle, size_t needlelen)
{
	const char *p, *last;
	if (!haystacklen)
		return NULL;

	p = haystack;
	last = p + haystacklen - needlelen;

	do {
		if (memcmp(p, needle, needlelen) == 0)
			return (void *)p;
	} while (p++ <= last);

	return NULL;
}

static inline void *memnchr(void const *data, int c, size_t data_len)
{
	char const *p = data;
	while((size_t)(p - ((char const *)data)) < data_len) {
		if (*p != c)
			return (char *)p;
		p++;
	}

	return NULL;
}

static inline bool memstarts(void const *data, size_t data_len,
		void const *prefix, size_t prefix_len)
{
	if (prefix_len > data_len)
		return false;
	return !memcmp(data, prefix, prefix_len);
}

#define memeq(a, al, b, bl) (al == bl && !memcmp(a, b, bl))

#endif

