#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <errno.h>

#include "ihex.h"
#include "ifibin.h"

int debug = 0;

int main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "usage: %s <ifi_bin_input.bin>\n",
		        argc>0?argv[0]:"ifibin_to_ihex");
		return -1;
	}

	char *file_name = argv[1];
	FILE *in = fopen(file_name,"r");
	if (!in) {
		fprintf(stderr, "file \"%s\" open failed\n", file_name);
		return -1;
	}
	struct addr_space as;
	int ret = as_init(&as);
	if (ret < 0) {
		WARN("as init faild");
		return -1;
	}

	ret = ifibin_read(&as, in);
	if (ret < 0) {
		WARN("ifibin_read failed");
		return -1;
	}

	ret = ihex_write(&as, stdout);
	if (ret < 0) {
		WARN("ihex_write failed");
		return -1;
	}

	return 0;
}
