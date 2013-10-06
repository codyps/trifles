#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))

struct set {
	int id[10];
};

static void set_init(struct set *s)
{
	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
		s->id[i] = (int)i;
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

	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
		if (s->id[i] == p)
			s->id[i] = q;
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
