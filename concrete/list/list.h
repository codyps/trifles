#pragma once

struct list_node {
	struct list_node *next, *prev;
}

struct list_head {
	struct list_node head;
}

inline
void list_init_(struct list_head *l)
{
	l->head.prev = &l->head;
	l->head.next = &l->head;
}

inline
void list_append_(struct list_head *l, struct list_node *n)
{
	n->next = &l->head;
	n->prev = l->head.prev->next;
	l->head.prev->next = n;
}

inline
void list_node_poison_(struct list_node *n)
{
	n->next = (void *)0xdeadbeef;
	n->prev = (void *)0xbeefdead;
}

inline
void list_remove_(struct list_node *n)
{
	n->prev->next = n->next;
	n->next->prev = n->prev;

	list_node_poison_(n);
}
