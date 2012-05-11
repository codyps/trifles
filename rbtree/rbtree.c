#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

#include "rbtree.h"

#define lt 0
#define rt 1

static struct rb_node *rot_dir(struct rb_node *root, bool dir)
{
	struct rb_node *save = root->leaf[!dir];
	root->leaf[!dir] = save->leaf[dir];
	save->leaf[dir] = root;
	save->red = root->red;
	root->red = true;
	return save;
}

static void flip_color(struct rb_node *n)
{
	n->red = !n->red;
	n->leaf[0]->red = !n->leaf[0]->red;
	n->leaf[1]->red = !n->leaf[1]->red;
}

static bool is_red(struct rb_node *n) {
	return n && n->red;
}

struct rb_node *rb_mknode(int data)
{
	struct rb_node *n = malloc(sizeof(*n));
	if (n) {
		n->data = data;
		n->leaf[0] = 0;
		n->leaf[1] = 0;
		n->red = true;
	}
	return n;
}

struct rb_node *rb_search(struct rb_node *root, int sdata)
{
	if (root) {
		int data = root->data;
		if (data == sdata) {
			return root;
		} else {
			return rb_search(root->leaf[sdata > data], sdata);
		}
	} else {
		return 0;
	}
}

static struct rb_node *rb_insert_r(struct rb_node *root, int data)
{
	if (root == 0)
		return rb_mknode(data);

	if (is_red(root->leaf[0]) && is_red(root->leaf[1]))
		flip_color(root);

	bool dir = data > root->data;
	struct rb_node *next_root = root->leaf[dir];
	next_root = rb_insert_r(next_root, data);
	if (next_root != 0)
		root->leaf[dir] = next_root;

	if (is_red(root->leaf[1]) && !is_red(root->leaf[0]))
		root = rot_dir(root, 0);

	if (is_red(root->leaf[0]) && !is_red(root->leaf[1]))
		root = rot_dir(root, 1);

	return root;
}

void rb_insert(struct rb_tree *tree, int data)
{
	tree->root = rb_insert_r(tree->root, data);
	tree->root->red = false;
}

static void dot_print_edge(struct rb_node *parent, struct rb_node *child, FILE *out)
{
	if (child)
		fprintf(out, "\tP_%d -> P_%d;\n", parent->data, child->data);
}

static void rb_print_r(struct rb_node *n, FILE *out)
{
	if (!n)
		return;

	/* node */
	char *shape, *color;
	if (n->red) {
		shape = "box";
		color = "red";
	} else {
		shape = "box";
		color = "black";
	}

	fprintf(out, "\tP_%d [shape=%s color=%s];\n", n->data, shape, color);

	/* edges */
	dot_print_edge(n, n->leaf[0], out);
	dot_print_edge(n, n->leaf[1], out);

	rb_print_r(n->leaf[0], out);
	rb_print_r(n->leaf[1], out);
}

void rb_print(struct rb_tree *tree, FILE *out)
{
	fprintf(out, "digraph g {\n");
	rb_print_r(tree->root, out);
	fprintf(out, "}\n");
}

static size_t rb_assert_r(struct rb_node *root)
{
	if (!root) {
		return 1;
	}

	struct rb_node *ln = root->leaf[0];
	struct rb_node *rn = root->leaf[1];

	/* consecutive red links */
	if (is_red(root) &&
	    (is_red(ln) || is_red(rn))) {
		fprintf(stderr, "red violation\n");
		return 0;
	}

	size_t lh = rb_assert_r(ln);
	size_t rh = rb_assert_r(rn);

	/* invalid binary search tree */
	if ((ln && ln->data >= root->data)
	    || (rn && rn->data <= root->data)) {
		fprintf(stderr, "binary tree violation\n");
		return 0;
	}

	/* black height messup */
	if (lh && rh && lh != rh) {
		fprintf(stderr, "black violation: %zu != %zu\n", lh, rh);
		return 0;
	}

	/* count blacks */
	if (lh && rh)
		return is_red(root) ? lh : (lh + 1);
	else
		return 0;
}

bool rb_assert(struct rb_tree *t)
{
	return rb_assert_r(t->root);
}

struct rb_tree *rb_mktree(void)
{
	struct rb_tree *t = malloc(sizeof(*t));
	if (t) {
		t->root = 0;
	}
	return t;
}

