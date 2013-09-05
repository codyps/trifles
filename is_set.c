#include <stdio.h>
#include <string.h>
#include <ctype.h>

struct set {
	int id[10];
	int sz[10];
};

static int find_roots(struct set *s, int roots[])
{
	int root_ct = 0;
	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++)
		if ((int)i == s->id[i]) {
			roots[i] = 1;
			root_ct ++;
		}

	return root_ct;
}

static void count_children(struct set *s, int root)
{
	int sz = 1;
	size_t i;
	for (i = 0; i < ARRAY_SIZE(s->id); i++) {
	}

}


int main(int argc, char **argv)
{
	if (argc != 2)
		return 1;

	struct set s;
	char *u = strtok(argv[2], " ");
	size_t i = 0;
	while (u) {
		if (strlen(u) != 0)
			return 2;
		if (!isdigit(u[0]))
			return 3;

		s.id[i] = u[0] - '0';
		s.sz[i] = -1;
	}

	int roots[10] = {0};
	int r = find_roots(&s, roots);
	if (r == 0)
		return 4;

	for (i = 0; i < ARRAY_SIZE(s.id); i++) {
		
	}


	return 0;
}
