#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

typedef struct rb_node rbnode_t;
struct rb_node {
	int data;
	bool red;
	struct rb_node *leaf[2];
};

struct rb_tree {
	struct rb_node *root;
};

#define lt 0
#define rt 1

#if 0
rbnode_t *rot_left(rbnode_t *n)
{
	rbnode_t *x = n->leaf[1];
	n->leaf[1] = x->leaf[0];
	x->leaf[0] = n;
	x->red = n->red;
	n->red = true;
	return x;
}

rbnode_t *rot_right(rbnode_t *n)
{
	rbnode_t *x = n->leaf[0];
	n->leaf[0] = x->leaf[1];
	x->leaf[1] = n;
	x->red = n->red;
	n->red = true;
	return x;
}
#endif

static struct rb_node *rot_dir(struct rb_node *root, bool dir)
{
	struct rb_node *save = root->leaf[!dir];
	root->leaf[!dir] = save->leaf[dir];
	save->leaf[dir] = root;
	root->red = true;
	save->red = false;
	return save;
}

static void flip_color(struct rb_node *n)
{
	n->red = !n->red;
	n->leaf[0]->red = !n->leaf[0]->red;
	n->leaf[1]->red = !n->leaf[1]->red;
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

static bool is_red(struct rb_node *n) {
	return n && n->red;
}

struct rb_node *rb_insert_r(struct rb_node *root, int data)
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

void dot_print_edge(struct rb_node *parent, struct rb_node *child, FILE *out)
{
	if (child)
		fprintf(out, "\tP_%d -> P_%d;\n", parent->data, child->data);
}

void rb_print_r(struct rb_node *n, FILE *out)
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


struct rb_tree *rb_mktree(void)
{
	struct rb_tree *t = malloc(sizeof(*t));
	if (t) {
		t->root = 0;
	}
	return t;
}

struct rb_tree *rb_gentree(size_t len, int *datas)
{
	struct rb_tree *t = rb_mktree();
	while(++datas, --len) {
		rb_print(t, stderr);
		rb_insert(t, *datas);
	}
	return t;
}

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

#define ALEN(A) (sizeof(A)/sizeof(*A))
int d [] = { 10, 12, 13, 14, 15, 16, 17, 18, 19 }; 

int main(int argc, char **argv)
{	
	struct rb_tree *t = rand_tree(100);
	rb_print(t, stderr);
	return 0;
}
