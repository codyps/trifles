


struct node {
	struct node *next;
	int data;
};

struct q {
	struct node *head;
	struct node **tail;
};


void q_init(struct q *q) {
	q->tail = &q->head;
}

void q_enqueue(struct q *q, struct node *n) {
	/* mov 8(%esp), %eax # eax = n
	 * mov 4(%esp), %ecx # ecx = q
	 * mov 4(%ecx), %ecx # ecx = q->tail
	 * # ATOMIC:
	 * mov %eax, (%ecx)
	 * # END ATOMIC
	 * # tail = &(n->next);
	 */
	struct n **loc = q->tail;

	/* ATOMIC */
	*(loc) = n;
	/* END ATOMIC */

	tail = &(n->next);
}

struct node *q_dequeue(struct q *q) {
	if (*tail != head) {
		struct node *n = q->head;
		q->head = n->next;
		return n;
	} else {
		return 0;
	}
}
