#ifndef TREE_H_
#define TREE_H_

#define __TR_NODE(name) \
	typedef struct {
		_CONTENTS_ contents;
		struct tnode_s *leaf[2]; /* the leaves (0==left) */
	} tnode_##_NAME_##_t;

#define __TR_TREE(name) \
	typedef struct { \
		tnode_t *root;	   /* first node of the tree (NULL is empty) */ \
	} tree_##_NAME_##_t; 

/* initializes a new tree. NULL on error. */
#define __TR_INIT(name) \
	tree_t *tree_##_NAME_##_init(void) { \
		
	}

/* frees all memory allocated for the given tree */
void tree_##_NAME_##_free(tree_t *t);

/* 
 * does a binary search for the string 'str'
 * if found, incriments count
 * if not found, allocates memory for a leaf, and a copy of 'str' then
 *  copies 'str' and initializes the leaf. 
 * 
 * returns a value less than 0 on error, 0 on success.
 */
int tree_insert(tree_t *t, char *str, size_t strlen);

/* print the contents of the tree, left first */
void tree_print(tree_t *t);



#endif
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

static void tree_##_NAME_##_free_h(tnode_##_NAME_##_t *t) {
	if (t==NULL) return;
	tree_##_NAME_##_free_h(t->leaf[0]);
	tree_##_NAME_##_free_h(t->leaf[1]);
	free(t->word);
	free(t);
}

void tree_##_NAME_##_free(tree_##_NAME_##_t *t) {
	tree_free_h(t->root);
	free(t);
}

tree_t *tree_##_NAME_##_init(void) {
	tree_##_NAME_##_t *t = malloc( sizeof(*t) );
	if (t) {
		t->root = NULL;
	}
	return t;
}

static tnode_t *tree_##_NAME_##_insert_h(tnode_t *nd, _CONTENTS_ contents) {
	if (nd == NULL) {
		nd = malloc(sizeof(*nd));
		if (nd == NULL) return NULL;
		nd->word = memdup(str, len+1);
		nd->contents = contents
		if (nd->contents == NULL) return NULL;
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
	tnode_t *nt = tree_insert_h(t->root,str,len);
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
