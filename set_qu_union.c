#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))
#define field_size(t,f) sizeof(((t *)NULL)->f)

struct set {
	int id[10];
	int sz[10];
};

_Static_assert(field_size(struct set,id) == field_size(struct set,sz),
		"id and sz must be the same length");

static void set_init(struct set *s)
{
	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
		s->id[i] = (int)i;
		s->sz[i] = 1;
	}
}

static int set_root(struct set *s, int elem)
{
	while (s->id[elem] != elem) {
		elem = s->id[elem];
	}
	return elem;
}

static void set_union(struct set *s, int p, int q)
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

static void set_print(struct set *s, FILE *f)
{
	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
		fprintf(f, "%d ", s->id[i]);
	}
	putc('\n', f);
}

int main(int argc, char **argv)
{
	if (argc != 2)
		return 1;

	struct set s;
	set_init(&s);
	char *u = strtok(argv[1], " ");
	printf("     ");
	set_print(&s, stdout);

	while (u) {
		if (strlen(u) != 3)
			return 2;

		if (u[1] != '-')
			return 3;

		if (!isdigit(u[0]))
			return 4;

		if (!isdigit(u[2]))
			return 5;

		set_union(&s, u[0] - '0', u[2] - '0');

		printf("%s: ", u);
		set_print(&s, stdout);
		u = strtok(NULL, " ");
	}

	printf("\n");
	set_print(&s, stdout);

	return 0;
}
