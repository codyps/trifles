#include <stdio.h>
#include <stdlib.h>


int main(int argc, char **argv)
{
	if (argc < 2) {
		fprintf(stderr,"usage: %s [number [number ...] ]\n", argc?argv[0]:"mask");
		return -1;
	}

	int i;

	unsigned long *m = malloc((argc - 1) * sizeof(*m));
	int num_ct = argc - 1;

	for(i = 1; i < argc; i++) {
		char *num_s = argv[i];
		unsigned long num = 0;
		int ret = sscanf(num_s, "%lx", &num);
		if (ret != 1) {
			fprintf(stderr, "a number, please. not '%s'\n", num_s);
			return -1;
		}


		m[i - 1] = num;
	}

	unsigned long diff = 0;
	for (i = 0; i < num_ct; i++) {
		int j;
		for (j = 0; j < num_ct; j++) {
			diff |= m[i] ^ m[j];
		}
	}

	printf("diff: 0x%lx , mask: 0x%lx , base: 0x%lx \n", diff, ~diff, m[0] & ~diff);

	return 0;
}
