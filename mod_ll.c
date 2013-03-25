#include <lastlog.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "usage: %s <lastlog>\n", argv[0]);
		return 0;
	}

	FILE *f = fopen(argv[1],"rb");
	if (!f) {
		fprintf(stderr, "failed to open \"%s\"\n", argv[1]);
		return 1;
	}

	struct lastlog ll = (typeof(ll)){};

	int i;
	printf("uid\ttime\t\tline\thost\n");
	for (i = 0;;i++) {
		ssize_t l = fread(&ll, 1, sizeof(ll), f);
		if (l == 0) {
			return 0;
		} else if (l != sizeof(ll)) {
			fprintf(stderr, "invalid entry %zd\n", l);
			return -1;
		}
		if (ll.ll_time)
			printf("%d\t%ld\t%s\t%s\n", i, (long)ll.ll_time, ll.ll_line, ll.ll_host);

	}
	return 0;
}
