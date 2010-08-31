#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "rbtree.h"

struct rb_tree *rand_tree(int ct)
{
	int i;
	struct rb_tree *t = rb_mktree();
	for(i = 0; i < ct; i++) {
		rb_insert(t, rand());
	}
	return t;
}

struct rb_tree *inc_tree(int max)
{
	int i;
	struct rb_tree *t = rb_mktree();
	for(i = 0; i < max; i++) {
		rb_insert(t, i);
	}
	return t;
}

int main(int argc, char **argv)
{
	srand(time(0));
	struct rb_tree *t = rand_tree(100);
	rb_assert(t);
	rb_print(t, stdout);
	return 0;
}
