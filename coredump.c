/*
 * Provide a storage and retreval mechanism for system coredumps similar to systemd-coredump, but without the requirement on using systemd
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* getopt */
#include <unistd.h>

/* mkdir */
#include <sys/stat.h>
#include <sys/types.h>

/* opendir */
#include <dirent.h>

#include <errno.h>

#define STR_(x) #x
#define STR(x) STR_(x)

#ifndef CFG_COREDUMP_PATH
# define CFG_COREDUMP_PATH "/var/lib/systemd/coredump"
#endif
const char *default_path = CFG_COREDUMP_PATH;

const char *opts = ":d:";
#define PRGMNAME "coredump"

static
void usage_(const char *prgmname, int e)
{
	FILE *f;
	if (e != EXIT_SUCCESS)
		f = stderr;
	else
		f = stdout;
	fprintf(f,
"Usage: %s [options] <action-and-args...>\n"
"       %s [options] store <global-pid> <uid> <gid> <signal-number> <unix-timestamp> <-%%c?-> <executable-filename> <exe-path>\n"
"	%s [options] setup\n"
"	%s [options] list\n"
"	%s [options] info\n"
"	%s [options] gdb\n"
"\n"
"Use me to handle your coredumps:\n"
"    # echo '|%s store %%P %%u %%g %%s %%t %%c %%e %%E' | /proc/sys/kernel/core_pattern\n"
"Or, run:\n"
"    # %s store-setup\n"
"\n"
"Options: -[%s]\n"
"  -d <directory>     store the coredumps in this directory\n"
"                     default = '%s'\n"
		, prgmname, prgmname, prgmname, prgmname, prgmname, prgmname, prgmname, opts, default_path);

	exit(e);
}
#define usage(e) usage_(argc?argv[0]:PRGMNAME, e)

enum act {
	ACT_NONE,
	ACT_SETUP,
	ACT_STORE,
	ACT_INFO,
	ACT_GDB,
	ACT_LIST,
};

static enum act parse_act(const char *action)
{
	switch (action[0]) {
	case 's':
		switch (action[1]) {
		case 'e':
			return ACT_SETUP;
		case 't':
			return ACT_STORE;
		default:
			return ACT_NONE;
		}
		break;
	case 'g':
		return ACT_GDB;
	case 'l':
		return ACT_LIST;
	case 'i':
		return ACT_INFO;
	default:
		return ACT_NONE;
	}
}

int main(int argc, char *argv[])
{
	char *dir = strdup(default_path);
	
	int err = 0;
	int opt;

	while ((opt = getopt(argc, argv, opts)) != -1) {
		switch (opt) {
		case 'd':
			free(dir);
			dir = strdup(optarg);
			break;
		case 'h':
			usage(EXIT_SUCCESS);
			break;
		case '?':
			err++;
			break;
		default:
			fprintf(stderr, "Error: programmer screwed up argument -%c\n", opt);
			err++;
			break;
		}
	}


	if (argc == optind) {
		err++;
		fprintf(stderr, "Error: an action is required but none was found\n");
	}

	const char *action = argv[optind];
	enum act act = parse_act(action);
	if (act == ACT_NONE) {
		err++;
		fprintf(stderr, "Error: unknown action '%s'\n", action);
	}

	if (err)
		usage(EXIT_FAILURE);

	switch (act) {
	case ACT_STORE:
		int ct = argc - optind;
		if (ct != 7 && ct != 8) {
			fprintf(stderr, "Error: store requires 7 arguments\n");
			err++;
		}

		/* for store, we require an absolute path */
		if (dir[0] != '/') {
			fprintf(stderr, "Error: store requires an absolute path, but got '%s'\n", dir);
			err++;
		}

		if (err)
			exit(EXIT_FAILURE);

		/* create our storage area if it does not exist */
		/* for each component in path, mkdir() */
		char *p = dir + 1;
		for (;;) {
			p = strchr(p, '/');
			if (p)
				*p = '\0';

			int r = mkdir(dir, 0777);
			if (r == -1) {
				if (errno != EEXIST) {
					fprintf(stderr, "Error: could not create path '%s', mkdir failed: %s\n",
							dir, strerror(errno));
					exit(EXIT_FAILURE);
				}
			}

			if (!p)
				break;
			*p = '/';
			p = p + 1;
		}

		DIR *d = opendir(dir);
		if (!d) {
			fprintf(stderr, "Error: failed to open storage dir '%s', opendir failed: %s\n",
					dir, strerror(errno));
			exit(EXIT_FAILURE);
		}

		/* select a name for this coredump */

		/* try to use 'YYYY-MM-DD-' */

	default:
		;
	}

	return 0;		
}
