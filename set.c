#include <stdio.h>
#include <string.h>

#define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
#define SET_SIZE 10

struct set_qf {
	int id[SET_SIZE];
};

struct set_qu {
	int id[SET_SIZE];
	int sz[SET_SIZE];
};

union set {
	int id[SET_SIZE];
	struct set_qf qf;
	struct set_qu qu;
};

static void set_qf_init(struct set_qf *s)
{
	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
		s->id[i] = (int)i;
	}
}

static void set_qu_init(struct set_qu *s)
{
	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
		s->id[i] = (int)i;
		s->sz[i] = 1;
	}
}

#define set_init(s) _Generic(s,				\
		struct set_qf *: set_qf_init(s),	\
		struct set_qu *: set_qu_init(s))

static int set_root(union set *s, int elem)
{
	while (s->id[elem] != elem) {
		elem = s->id[elem];
	}
	return elem;
}
#define set_root(s, elem) set_root((union set *)s, elem)

static void set_qu_union(struct set_qu *s, int p, int q)
{
	p = set_root(s, p);
	q = set_root(s, q);

	if (s->sz[p] >= s->sz[q]) {
		s->id[q] = p;
		s->sz[p] += s->sz[q];
	} else {
		s->id[p] = q;
		s->sz[q] += s->sz[p];
	}
}

static void set_qf_union(struct set_qf *s, int p, int q)
{
	p = set_root(s, p);
	q = set_root(s, q);

	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
		if (s->id[i] == p)
			s->id[i] = q;
	}
}

#define set_union(s) _Generic(s,			\
		struct set_qf *: set_qf_union(s),	\
		struct set_qu *: set_qu_union(s))

static void set_print(union set *s, FILE *f)
{
	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
		fprintf(f, "%d ", s->id[i]);
	}
	putc('\n', f);
}

