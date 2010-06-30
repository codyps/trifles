
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
struct list *reverse(struct list *l)
{

	struct list *cl = l;
	struct list *n1 = l->next;
	struct list *n2;
	while(n1) {
		n2 = n1->next;
		n1->next = cl;
		cl = n1;
		n1 = n2;
	}
	return cl;
}


