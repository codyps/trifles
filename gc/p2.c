#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <limits.h>
#include <ctype.h>

#include "list.h"

#define CASE_DATA_INIT(name) { .invokes = LIST_HEAD_INIT(name.invokes), \
	.combos = {{}}, .clears = {{}} }
#define CASE_DATA(name) struct case_data name = CASE_DATA_INIT(name)

struct invoke {
	int elem;
	struct list_head list;
};

struct case_data {
	struct list_head invokes;

	int combos [26][26];
	bool clears [26][26];
};


int hash_elem(int c)
{
	if (!isalpha(c) || !isupper(c))
		return -1;

	return c - 'A';
}

int unhash_elem(int h)
{
	return h + 'A';
}

int eat_combos(FILE *in, struct case_data *cd)
{
	unsigned combos;
	int ret = fscanf(in, "%u ", &combos);
	if (ret != 1) {
		perror("bleh");
		return -2;
	}

	//fprintf(stderr, "combos: %u\n", combos);

	unsigned i;
	char cc[3];
	for (i = 0; i < combos; i ++) {
		ret = fscanf(in, "%3c ", cc);
		if (ret != 1) {
			return -23;
		}

		int j = hash_elem(cc[0]);
		if (j < 0)
			return -4;
		int k = hash_elem(cc[1]);
		if (k < 0)
			return -8;

		int x = hash_elem(cc[2]);
		if (x < 0) {
			printf("what is %c?\n", cc[2]);
			return -9;
		}

		cd->combos[j][k] = x;
		cd->combos[k][j] = x;
	}

	return 0;
}

int eat_clears(FILE *in, struct case_data *cd)
{
	unsigned c;
	int ret = fscanf(in, "%u ", &c);
	if (ret != 1) {
		perror("bleh");
		return -2;
	}

	//fprintf(stderr, "clears: %u\n", c);


	unsigned i;
	char cc[2];
	for (i = 0; i < c; i ++) {
		ret = fscanf(in, "%2c ", cc);
		if (ret != 1) {
			return -23;
		}

		int j = hash_elem(cc[0]);
		if (j < 0)
			return -4;
		int k = hash_elem(cc[1]);
		if (k < 0)
			return -8;

		cd->clears[j][k] = true;
	}

	return 0;
}

int check_combo(struct case_data *cd)
{
	struct list_head *lh = &cd->invokes;
	if (list_empty(lh))
		return 0;

	if (list_is_singular(lh))
		return 0;

	struct invoke *cur = list_entry(lh->prev, typeof(*cur), list);
	struct invoke *prev = list_entry(lh->prev->prev, typeof(*prev), list);

	int repl = cd->combos[cur->elem][prev->elem];

	if (repl) {
		list_del(&prev->list);
		free(prev);

		cur->elem = repl;
	}

	return 0;
}

void clear_list(struct list_head *lh)
{
	struct invoke *i, *n;
	list_for_each_entry_safe(i, n, lh, list) {
		list_del(&i->list);
		free(i);
	}
}

int check_clear(struct case_data *cd)
{
	struct invoke *i;
	list_for_each_entry(i, &cd->invokes, list) {
		struct invoke *j;
		list_for_each_entry(j, &cd->invokes, list) {
			if (cd->clears[i->elem][j->elem]) {
				clear_list(&cd->invokes);
				return 0;
			}
		}
	}

	return 0;
}

void print_invokes(struct case_data *cd, FILE *out)
{
	fputs("[", out);
	struct invoke *i, *n;
	list_for_each_entry_safe(i, n, &cd->invokes, list) {
		list_del(&i->list);
		int c = unhash_elem(i->elem);
		//printf(" -- %d -- ", c);
		if (list_empty(&cd->invokes)) {
			fprintf(out, "%c", c);
		} else {
			fprintf(out, "%c, ", c);
		}

		free(i);
	}

	fputs("]\n", out);
}


int eat_invoke(FILE *in, struct case_data *cd)
{
	unsigned c;
	int ret = fscanf(in, "%u ", &c);
	if (ret != 1)
		return -5;

	unsigned i;
	for (i = 0; i < c; i ++) {
		int c = fgetc(in);

		struct invoke *ik = malloc(sizeof(*ik));

		ik->elem = hash_elem(c);

		list_add_tail(&ik->list, &cd->invokes);

		check_combo(cd);
		check_clear(cd);
	}

	return 0;
}

int parse_line(FILE *in, struct case_data *cd)
{
	int ret;

	if ((ret = eat_combos(in, cd)))
		return ret;

	if ((ret = eat_clears(in, cd)))
		return ret;

	if ((ret = eat_invoke(in, cd)))
		return ret;

	return 0;
}

int main(int argc, char **argv)
{
	unsigned cases;
	int ret = scanf("%u\n", &cases);
	if (ret != 1)
		return -1;

	unsigned i;
	for (i = 0; i < cases; i ++) {
		CASE_DATA(cd);

		ret = parse_line(stdin, &cd);
		if (ret < 0) {
			fprintf(stderr, "parse fail %d\n", ret);
			return ret;
		}

		printf("Case #%d: ", i+1);
		print_invokes(&cd, stdout);

	}

	return 0;
}
