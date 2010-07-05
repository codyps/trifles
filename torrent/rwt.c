#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "ben.h"

#define NAME "rwt"
static const char usage_str[] =
"usage: %s <torrent> -d <dict_key> -l <list_index>\n";

static void usage(char *name)
{
	fprintf(stderr, usage_str, name);
}

int t_show(struct be_node *tf, int argc, char **argv)
{
	
	if (argc == 2) {
		if (tf->type != BE_DICT) {
			fprintf(stderr,"not dict.\n");
			return 1;
		}
		struct be_dict *d = tf->u.d;

		struct be_str s = { strlen(argv[1]), argv[1] };

		struct be_node *val = be_dict_lookup(d, &s);
		if (val) {
			be_print(val, stdout);
		} else {
			fprintf(stderr, "Not found: %s\n", argv[1]);
		}
	} else {
		be_print(tf, stdout);
	}
	return 0;
}

int main(int argc, char **argv)
{
	if (argc < 3) {
		if (argc < 1)
			usage(NAME);
		else
			usage(argv[0]);
		return 1;
	}

	char *torrent = argv[1];
	FILE *tf = fopen(torrent, "r+b");
	if (!tf) {
		fprintf(stderr, "torrent \"%s\": fopen: %s\n", torrent, 
			strerror(errno));
		return 2;
	}

	/* FIXME: this is generally a Bad Thing.
	 * Should process the FILE * directly. 
	 */
	fseek(tf, 0, SEEK_END);
	long tf_sz = ftell(tf);
	char *tf_t = malloc(tf_sz);
	fseek(tf, 0, SEEK_SET);
	size_t read = fread(tf_t, tf_sz, 1, tf);
	if (read != 1) {
		// die
		fprintf(stderr, "problemz %lu.\n", (unsigned long)read);
	}

	const char *ep;
	struct be_node *tf_be = bdecode(tf_t, tf_sz, &ep);

	//char *spec = argv[2];
	return t_show(tf_be, argc-1, argv+1);
}
