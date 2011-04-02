
// www.rethinkdb.com/blog/2010/06/will-the-real-programmers-please-stand-up/

struct list;
struct list {
	void *data;
	struct list *next;
};

// modifies lh and returns it.
struct list *l_concat(struct list *lh, struct list *lt)
{
	struct list *l lh_last = lh;
	while( (lh_last = lh_last->next) );
	lh_last->next = lt;
	return lh;
}

// lt, returns new list head.
struct list *l_cons(struct list *lt,  void *data)
{
	struct list *nl = malloc(sizeof(*nl));
	nl->data = data;
	nl->next = lt;
	return nl;
}

// switch fst 2 elems in l.
struct list *flip(struct list *l)
{
	struct list *fst = l;
	struct list *snd = l->next;
	struct list *thr = snd->next;

	snd->next = fst;
	fst->next = thr;

	return snd;
}

// 
struct list *reverse(struct list *in_list)
{
	struct list *cur_list = in_list;
	struct list *n1 = in_list->next;
	struct list *n2;
	while(n1) {
		n2 = n1->next;
		n1->next = cur_list;
		cur_list = n1;
		n1 = n2;
	}
	return cur_list;
}

struct list *reverse2(struct list *in_list)
{
	struct list *temp;
	struct list *prev = NULL;
	while(in_list) {
		temp = in_list->next;
		in_list->next = prev;
		prev = in_list;
		in_list = temp;
	}

	return prev;
}

struct list *reverse3(struct list *in_list)
{
	struct list *new_list = NULL;
	struct list *old_nl; /* the previous version of new_list */
	while(in_list) {
		old_nl = new_list;
		new_list = in_list;
		in_list = in_list->next;
		new_list->next = old_nl;
	}

	return new_list;
}
