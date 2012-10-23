#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tree.h"

/* Memory Duplicate. allocate and copy memory */
static char *memdup(const char *old, size_t len) {
	char *new = malloc(len);
	if (new)
		memcpy(new,old,len);
	return new;
}

static void tree_free_h(tnode_t *t) {
	if (t==NULL) return;
	tree_free_h(t->leaf[0]);
	tree_free_h(t->leaf[1]);
	free(t->word);
	free(t);
}

void tree_free(tree_t *t) {
	tree_free_h(t->root);
	free(t);
}

tree_t *tree_init(void) {
	tree_t *t = malloc( sizeof(*t) );
	if (t) {
		t->ct_max = 1;
		t->strlen_max = 0;
		t->root = NULL;
	}
	return t;
}

static tnode_t *tree_insert_h(tree_t *tr, tnode_t *nd, char *str, size_t len) {
	if (nd == NULL) {
		nd = malloc(sizeof(*nd));
		if (nd == NULL) return NULL;
		nd->word = memdup(str, len+1);
		if (nd->word == NULL) return NULL;
		if (len > tr->strlen_max) tr->strlen_max = len;
		nd->ct   = 1;
		nd->leaf[0] = NULL;
		nd->leaf[1] = NULL;
	} else {
		int cmp = strcmp(nd->word,str);
		if( cmp == 0 ) {
			nd->ct++;
			if (nd->ct > tr->ct_max) tr->ct_max = nd->ct;
		} else {
			/* cmp = 0 when 'str' is greater than t->word (the string in the
			    current leaf) */
			cmp = cmp < 0;
			nd->leaf[cmp] = tree_insert_h(tr,nd->leaf[cmp],str,len);
			if (nd->leaf[cmp] == NULL) return NULL;
		}
	}
	return nd;
}

int tree_insert(tree_t *t, char *str, size_t len) {
	tnode_t *nt = tree_insert_h(t, t->root,str,len);
	if (nt == NULL) return -1;
	t->root = nt;
	return 0;
}

/* static const char *const tp_s_base = "%%-%ds%%%d\n"; */

static void tree_print_h(tnode_t *n, size_t field_width) {
	if (n == NULL) return;
	tree_print_h(n->leaf[0], field_width);
	printf("%-10s%5d\n",n->word,n->ct);
	tree_print_h(n->leaf[1], field_width);
}

void tree_print(tree_t *t) {
	tree_print_h(t->root, t->strlen_max + 2);
}
