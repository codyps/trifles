#include <stdio.h>

/* Return count in buffer.  */
#define CIRC_CNT(head,tail,size) (((head) - (tail)) & ((size)-1))

/* Return space available, 0..size-1.  We always leave one free char
   as a completely full buffer has head == tail, which is the same as
   empty.  */
#define CIRC_SPACE(head,tail,size) CIRC_CNT((tail),((head)+1),(size))

/* Return count up to the end of the buffer.  Carefully avoid
   accessing head and tail more than once, so they can change
   underneath us without returning inconsistent results.  */
#define CIRC_CNT_TO_END(head,tail,size) \
	({int end = (size) - (tail); \
	  int n = ((head) + end) & ((size)-1); \
	  n < end ? n : end;})

/* Return space available up to the end of the buffer.  */
#define CIRC_SPACE_TO_END(head,tail,size) \
	({int end = (size) - 1 - (head); \
	  int n = (end + (tail)) & ((size)-1); \
	  n <= end ? n : end+1;})

int main(int argc, char **argv)
{
	if (argc != 4) {
		char *name;
		if (argc)
			name = argv[0];
		else
			name = "circ_calc";

		fprintf(stderr, "usage: %s head tail size\n", name);
		return 1;
	}

	int head, tail, size;
	if (sscanf(argv[1],"%d",&head) != 1)
		return -1;
	if (sscanf(argv[2],"%d",&tail) != 1)
		return -2;
	if (sscanf(argv[3],"%d",&size) != 1)
		return -3;

	printf("CIRC_CNT(%d,%d,%d) == %d\n", head, tail, size, CIRC_CNT(head,tail,size));
	printf("CIRC_SPACE(%d,%d,%d) == %d\n", head, tail, size, CIRC_SPACE(head,tail,size));

	return 0;
}
