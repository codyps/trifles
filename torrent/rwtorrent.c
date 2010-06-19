#include <stdio.h>
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

t_show(FILE *tf, int argc, char **argv)
{

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
	FILE *tf = fopen(torrent, "a+b");
	if (!tf) {
		fprintf(stderr, "torrent \"%s\": fopen: %s\n", torrent, 
			strerror(errno));
		return 2;
	}
	int ret = fseek(tf, 0, SEEK_SET);
	if (ret == -1) {
		fprintf(stderr, "torrent \"%s\": fseek: %s\n", torrent,
			strerror(errno));
		return 3;
	}


	char *act = argv[2];
	if (!strcmp(act, "rm")) {
		return t_rm(tf, argc - 1, argv + 1) + 5;
	} else if (!strcmp(act, "add")) {
		return t_add(tf, argc - 1, argv + 1) + 5;
	} else if (!strcmp(act, "show")) {
		return t_show(tf, argc - 1, argv + 1) + 5;
	} else {
		fprintf(stderr, "unknown action: \"%s\"\n",act);
		usage(argv[0]);
		return 4;
	}
}
