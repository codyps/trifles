#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <limits.h>

#define LOG(...) do { fprintf(stderr,__FILE__":%d :: ",__LINE__); \
	fprintf(stderr,__VA_ARGS__); } while(0)


#define _key_ int
#define _CMP(x,y) ((x)-(y))

typedef struct rb_node {
	_key_ data;

	bool red;
	struct rb_node *leaf[2];
} rb_node;

typedef struct rb_tree {
	struct rb_node *root;
} rb_tree;

static bool is_red(rb_node *node) {
	return ( node && node->red );
}

/* Rules:
 *  left data < root data, right data > root data
 *  root is black
 *  black height consistent
 *  reds cannot have red leaves.
 */
size_t assert_h(rb_node *nd) {
	if ( nd == NULL ) return 1; /* Nil leaves are black */

	if ( nd->red && ( is_red(nd->leaf[0]) || is_red(nd->leaf[1]) ) ) {
		LOG("red violation\n");
		return 0;
	}

	size_t lbh = assert_h(nd->leaf[0]);
	size_t rbh = assert_h(nd->leaf[1]);

	if ( ( nd->leaf[0] != NULL && (nd->leaf[0]->data >= nd->data) )
	     || ( nd->leaf[1] != NULL && (nd->leaf[1]->data <= nd->data) ) ) {
		LOG("Not a binary search tree\n");
		return 0;
	}


	if ( lbh && rbh && lbh != rbh ) {
		LOG("black violation. (data = %d, lbh = %d, rbh = %d)\n"
			,(int)nd->data,(int)lbh,(int)rbh);
		return 0;
	}


	/* black height */
	if ( lbh && rbh )
		return !nd->red + lbh;
	else
		return 0;
}

size_t rb_assert(rb_tree *tr)
{
	return	assert_h(tr->root);
}

static _key_ min_h(rb_node *n)
{
	if (n->leaf[0] == 0)
		return n->data;
	else
		return min_h(n->leaf[0]);
}

_key_ rb_min(rb_tree *t)
{
	return min_h(t->root);
}


static rb_node *rotate(rb_node *r, bool dir)
{
	rb_node *piv = r->leaf[!dir];
	r->leaf[!dir] = piv->leaf[dir];
	piv->leaf[dir] = r;

	piv->red = r->red;
	r->red = true;
	return piv;
}

static void colorflip(rb_node *root)
{
	if (!root) {
		LOG("null root\n");
		return;
	}

	if (!root->leaf[0] || !root->leaf[1]) {
		LOG("null leaf\n");
		return;
	}

	root->red = !(root->red);
	root->leaf[0]->red = !(root->leaf[0]->red);
	root->leaf[1]->red = !(root->leaf[1]->red);
}

rb_node *mk_node(_key_ val)
{
	rb_node *n = malloc(sizeof(*n));
	if (n) {
		n->red = true;
		n->leaf[0] = 0;
		n->leaf[1] = 0;
		n->data = val;
	}
	return n;
}

static rb_node *move_red(rb_node *n, bool dir)
{
	colorflip(n);
	if (is_red(n->leaf[!dir]->leaf[0])) {
		if (!dir)
			n->leaf[1] = rotate(n->leaf[1],1);
		n = rotate(n,dir);
		colorflip(n);
	}
	return n;
}

static rb_node *fix_up(rb_node *n)
{
	if (is_red(n->leaf[1]))
		n = rotate(n,0);

	if (is_red(n->leaf[0]) && is_red(n->leaf[0]->leaf[0]))
		n = rotate(n,1);

	if (is_red(n->leaf[0]) && is_red(n->leaf[1]))
		colorflip(n);

	return n;
}

static rb_node *delete_min_h(rb_node *n)
{
	if (n->leaf[0] == 0) return 0;
	if (!is_red(n->leaf[0]) && !is_red(n->leaf[0]->leaf[0]))
		n = move_red(n,0);

	n->leaf[0] = delete_min_h(n->leaf[0]);

	return fix_up(n);
}

void rb_delete_min(rb_tree *t)
{
	t->root = delete_min_h(t->root);
}

static rb_node *delete_h(rb_node *n, _key_ val)
{
	if ( _CMP(n->data,val) < 0 ) {
		if (!is_red(n->leaf[0]) && !is_red(n->leaf[0]->leaf[0]))
			n = move_red(n,0);
		n->leaf[0] = delete_h(n->leaf[0],val);
	} else {
		if (is_red(n->leaf[0]))
			n = rotate(n,1);
		if ( _CMP(n->data,val) == 0  && (n->leaf[1] == 0))
			return 0;
		if (!is_red(n->leaf[1]) && !is_red(n->leaf[1]->leaf[0]))
			n = move_red(n,1);

		if ( _CMP(n->data,val) == 0 ) {
			n->data = min_h(n->leaf[1]);
			n->leaf[1] = delete_min_h(n->leaf[1]);
		} else {
			rb_node* tmp = delete_h(n->leaf[1],val);
			n->leaf[1] = tmp;
		}
	}
	return fix_up(n);
}

int rb_delete(rb_tree *t, _key_ val)
{
	t->root = delete_h(t->root,val);
	if (t->root)
		return 0;
	return 1;
}

static rb_node *insert_h(rb_node *n, int data)
{
	if (!n)
		return mk_node(data);

	if (_CMP(n->data,data)) {
		bool dir = _CMP(n->data,data) > 0 ? 0 : 1;
		//bool dir = data > n->data;
		n->leaf[dir] = insert_h(n->leaf[dir],data);

		if ( is_red(n->leaf[1]) && !is_red(n->leaf[0]))
			n = rotate(n,0);
		if ( is_red(n->leaf[0]) && is_red(n->leaf[0]->leaf[0]))
			n = rotate(n,1);
		if ( is_red(n->leaf[0]) &&  is_red(n->leaf[1]))  colorflip(n);
	}
	return n;
}

int rb_insert(rb_tree *tr, int data)
{
	rb_node *n = insert_h(tr->root,data);
	if (!n)
		return -1;

	if (n != tr->root)
		tr->root = n;

	tr->root->red = false;

	return 0;
}

rb_tree *mk_tree(void)
{
	rb_tree *t = malloc(sizeof(*t));
	if (t)
		t->root = 0;
	return t;
}

void xprint_tree_h(rb_node *n, int depth)
{
	if (!n) return;

	size_t i;
	for( i = 0; i < depth ; i++ ) {
		putc('.',stdout);	
	}

	printf(" %d\n",n->data);
	
	xprint_tree_h(n->leaf[0],depth+1);
	xprint_tree_h(n->leaf[1],depth+1);
}
void xprint_tree(rb_tree *tr)
{
	xprint_tree_h(tr->root,0);
}

void print_tree_h(rb_node *n)
{
	if (!n) return;
	print_tree_h(n->leaf[0]);
	printf("%d\n",n->data);
	print_tree_h(n->leaf[1]);
}

void print_tree(rb_tree *tr)
{
	print_tree_h(tr->root);
}

void gprint_tree_h(rb_node *n, rb_node *parent, FILE *stream)
{
	if (!n) return;
	if (parent) {
		fprintf(stream,"n%d [color=\"%s\"];"
			"\nn%d -- n%d;\n"
			,n->data 
			,n->red ?"red":"black"
			,n->data
			,parent->data);
	} else {
		fprintf(stream,"n%d [color=\"%s\"];\n"
			,n->data
			,n->red ? "red" : "black");
	}
	gprint_tree_h(n->leaf[0],n,stream);
	gprint_tree_h(n->leaf[1],n,stream);
}

void gprint_tree(rb_tree *tr, FILE *stream)
{
	fputs("graph \"\"\n{",stream);
	gprint_tree_h(tr->root, 0, stream);
	fputc('}',stream);
}

//const int tests[] = { 13,112,82,11,94,22,34,55,54,29,192,83,72,38,33,98,77,83 };
const int tests[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};

void rand_test(void)
{
	rb_tree *test = mk_tree();
	unsigned i;
	unsigned i_max = rand() % UINT_MAX;
	for( i = 0; i < i_max; i++ ) {
		int r = rand() % 1000;
		char *file;
		asprintf(&file,"gr-rand-%03u",i);
		FILE *fp = fopen(file,"w");
		fprintf(stderr,"insert: %d",r);
		fprintf(stderr,"  %i\n",rb_insert(test,r));
		gprint_tree(test,fp);
		rb_assert(test);
		fclose(fp);
	}

	unsigned r_max = rand() % UINT_MAX;
	for( i = 0; i < r_max; i++ ) {
		int r = rand() % 1000;
		char *file;
		asprintf(&file,"rr-%04d",i);
		FILE *fp = fopen(file,"w");
		fprintf(stderr,"remove: %d ",r);
		fprintf(stderr,"  %i\n",rb_delete(test,r));
		gprint_tree(test,fp);
		rb_assert(test);
		fclose(fp);
	}
}

void iter_test(void)
{
	rb_tree *test = mk_tree();
	unsigned i;
	for( i = 0; i < 2000; i++ ) {
		char *file;
		asprintf(&file,"gr-iter-%03u",i);
		FILE *fp = fopen(file,"w");
		fprintf(stderr,"insert: %u\n",i);
		rb_insert(test,i);
		gprint_tree(test,fp);
		rb_assert(test);
		fclose(fp);
	}

}

int main(int argc, char **argv)
{
	LOG("start\n");
	//rand_test();
	iter_test();

	return 0;
}
