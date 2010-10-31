
struct Node {
	struct Node *next;
};

struct Node *n swap2_loop_api(struct Node *h)
{
	struct Node **hb = &h;
	struct Node *back;
	for(struct Node **n = &h; (*n) && (*n)->next; n = &(back->next)) {
		back = (*n);
		(*n) = (*n)->next;
		(*n)->next = back;
	}
	return (*hb);
}

void swap2_loop(struct Node **h)
{
	struct Node *back;
	for(struct Node **n = h; (*n) && (*n)->next; n = &(back->next)) {
		back = (*n);
		(*n) = (*n)->next;
		(*n)->next = back;
	}
}

void swap2(struct Node **h)
{
	if ((*h) && (*h)->next) {
		struct Node *n = (*h);
		(*h) = (*h)->next;
		(*h)->next = n;
		swap2(&(n->next));
	} else {
		return;
	}
}



