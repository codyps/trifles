
static struct rb_node  *
rb_first_preorder_(struct rb_tree *rbt, int *black_depth)
{
	/* black level is always 1 at the top node */
	if (rbt->top)
		*black_depth = 1;
	else
		*black_depth = 0;
	return rbt->top;
}

static struct rb_node *
rb_next_preorder_(struct rb_node *rbn, int *black_depth)
{
	if (rbn->c[0]) {
		if (!rb_is_red(rbn->c[0]))
			*black_depth++;
		return rbn->c[0];
	} else if (rbn->c[1]) {
		if (!rb_is_red(rbn->c[1]))
			*black_depth++;
		return rbn->c[1];
	} else {
		int l = *black_depth;
		/* go up to the next right child we missed */
		for (;;) {
			if (!rb_is_red(rbn))
				l--;
			struct rb_node *p = rb_parent(rbn);
			if (!p) {
				*black_depth = l;
				return NULL;
			}

			if (p->c[1]) {
				if (!rb_is_red(p->c[1]))
					*black_depth = l;
				return p->c[1];
			}
		}
	}
}

