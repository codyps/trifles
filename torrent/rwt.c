#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include "ben.h"

#define NAME "rwtorrent"
static const char usage_str[] =
"usage: %s <torrent> <action> [options]\n"
"\n"
"actions: rm <regex>        - remove trackers that \n"
"                               match the given regex\n"
"         add <tracker url> - add the given tracker\n"
"         show              - show current trackers\n"
;
static void usage(char *name)
{
	fprintf(stderr, usage_str, name);
}

int t_show(struct be_node *tf, int argc, char **argv)
{
	be_print(tf, stdout);
}

int t_rm(struct be_node *tf, int argc, char **argv)
{
	return -1;
}

int t_add(struct be_node *tf, int argc, char **argv)
{
	return -1;
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

	char *act = argv[2];
	if (!strcmp(act, "rm")) {
		return t_rm(tf_be, argc - 1, argv + 1) + 5;
	} else if (!strcmp(act, "add")) {
		return t_add(tf_be, argc - 1, argv + 1) + 5;
	} else if (!strcmp(act, "show")) {
		return t_show(tf_be, argc - 1, argv + 1) + 5;
	} else {
		fprintf(stderr, "unknown action: \"%s\"\n",act);
		usage(argv[0]);
		return 4;
	}
}
