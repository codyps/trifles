#define _GNU_SOURCE 1 /* for getdate_r. */
#include <time.h>

char *getdate_errstr[] = {


int main(int argc, char **argv)
{
	if (argc != 4) {
		fprintf(stderr, "usage: %s <date 1> <op> <date 2>\n"
				" ops: lt (<), lte (<=), gt (>), gte (>=), eq (==,=)\n"
				, argc ? argv[0] : "date-cmp");
		return EINVAL;
	}

	struct tm d1, d2;
	int r = getdate(argv[1], &d1);
	if (r) {




	return 0;
}
