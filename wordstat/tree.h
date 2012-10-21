#ifndef TREE_H_
#define TREE_H_

typedef struct tnode_s {
	char *word;	/* heap allocated, allocation is controlled by the tree ONLY */
	size_t ct;  /* number of times a word is encountered */
	struct tnode_s *leaf[2]; /* the leaves (0==left) */
} tnode_t;

/* Tree. */
typedef struct tree_s {
	size_t ct_max;     /* the max ct found */
	size_t strlen_max; /* the max strlen found (for pretty printing) */
	tnode_t *root;	   /* first node of the tree (NULL is empty) */
} tree_t;

/* initializes a new tree. NULL on error. */
tree_t *tree_init(void);

/* frees all memory allocated for the given tree */
void tree_free(tree_t *t);

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
