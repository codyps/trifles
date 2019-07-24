#include "list.h"

extern
inline
void list_init_(struct list_head *l);

extern
inline
void list_append_(struct list_head *l, struct list_node *n);

extern
inline
void list_node_poison_(struct list_node *n);

extern
inline
void list_remove_(struct list_node *n);
