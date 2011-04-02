#include <lastlog.h>
#include <stdio.h>

int main(int argc, char **argv)
{
	FILE *f = fopen(argv[1],"rb");

	struct lastlog ll;

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
			printf("%d\t%d\t%s\t%s\n", i, ll.ll_time, ll.ll_line, ll.ll_host);

	}

}
