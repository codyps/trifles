#ifndef RBTREE_H_
#define RBTREE_H_
#include <stdbool.h>

struct rb_node {
	int data;
	bool red;
	struct rb_node *leaf[2];
};

struct rb_tree {
	struct rb_node *root;
};

struct rb_node *rb_search(struct rb_node *root, int sdata);
void rb_insert(struct rb_tree *tree, int data);
void rb_print(struct rb_tree *tree, FILE *out);

bool rb_assert(struct rb_tree *t);
struct rb_tree *rb_mktree(void);
struct rb_node *rb_mknode(int data);
#endif
