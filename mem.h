#ifndef PENNY_MEM_H_
#define PENNY_MEM_H_
#include <string.h> /* memcmp (size_t implicit) */
#include <stdbool.h>

/* TODO: make this less stupid */
#ifndef _GNU_SOURCE
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
#endif

static inline void *mempbrkm(const char *data, size_t len, const char *accept, size_t accept_len)
{
	size_t i, j;
	for (i = 0; i < len; i++)
		for (j = 0; j < accept_len; j++)
			if (accept[j] == data[i])
				return (void *)&data[i];
	return NULL;
}

static inline void *mempbrk(const char *data, size_t len, const char *accept)
{
	return mempbrkm(data, len, accept, strlen(accept));
}

#define memscan(data, len, is_ok) ({						\
		size_t __memscan_pos;						\
		for (__memscan_pos = 0; __memscan_pos < (len); __memscan_pos) {	\
			if (is_ok((data)[__memscan_pos]))			\
				break;						\
		}								\
		__memscan_pos;							\
})

/*
 * returns a pointer to the first character which is _not_ c
 * can be viewed as a semi-inverse of memchr()
 */
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

/**
 * memchr_len - search @s for @c, and return the offset of the first location
 *              of @c in @s
 * @s: an array of bytes with size @n
 * @c: character to search for
 * @n: length in bytes of @s
 *
 * Returns an offset into @s where a byte matching @c was found. If no matching
 * byte was found, returns @n.
 */
static inline size_t memchr_len(const void *s, int c, size_t n)
{
	return memchr(s, c, n) - s;
}

#define memeq(a, al, b, bl) (al == bl && !memcmp(a, b, bl))
#define memeqstr(bytes, length, string) \
	memeq(bytes, length, string, strlen(string))

#define memstarts_str(a, al, s) memstarts(a, al, s, strlen(s))

#endif

