#ifndef PENNY_CIRC_BUF_H_
#define PENNY_CIRC_BUF_H_ 1

/* Tail follows Head */
/* Read from Tail, Write to Head */

/* number of items in circ_buf */
#define CIRC_CNT(head,tail,size) (((head) - (tail)) & ((size)- 1))

/* space remaining in circ_buf */
#define CIRC_SPACE(head,tail,size) CIRC_CNT((tail),((head)+1),(size))

/* is circ_buf full */
#define CIRC_FULL(head,tail,size) (CIRC_NEXT(tail,size) == (head))

/* empty? */
#define CIRC_EMPTY(head,tail,size) ((head) == (tail))

/* next index (head/tail) location */
#define CIRC_NEXT(index,size) CIRC_NEXT_I(index,1,size)
#define CIRC_NEXT_I(index,isz,size) (((index) + (isz)) & ((size) - 1))

/* assign next index (head/tail) location to index */
#define CIRC_NEXT_EQ(index,size) CIRC_NEXT_I_EQ(index,1,size)
#define CIRC_NEXT_I_EQ(index,isz,size) ((index) = (((index) + (isz)) & ((size - 1))))

#define CIRC_CNT_TO_END(head,tail,size) \
	({typeof(head) end = (size) - (tail); \
	  typeof(head) n = ((head) + end) & ((size) - 1); \
	  n < end ? n : end;})

#define CIRC_SPACE_TO_END(head,tail,size) \
	({typeof(head) end = (size) - 1 - (head); \
	  typeof(head) n = (end + (tail)) & ((size)-1); \
	  n <= end ? n : end+1;})


/* the following expect q to be a structure of the form */
#if 0
struct q {
	uint8_t head;
	uint8_t tail;
	uint8_t buf[16];
};
#endif

#define circ_adv(q, ix_var) ( q.ix_var = circ_next(q, ix_var) )
#define circ_adv_head(q) circ_adv(q, head)
#define circ_adv_tail(q) circ_adv(q, tail)

#define circ_next(circ, ix_var) CIRC_NEXT(circ.ix_var, sizeof(circ.buf))
#define circ_next_head(circ) circ_next(circ, head)
#define circ_next_tail(circ) circ_next(circ, tail)

#define circ_empty(circ) CIRC_EMPTY(circ.head, circ.tail, sizeof(circ.buf))

#endif
