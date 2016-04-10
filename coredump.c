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

/* strftime */
#include <time.h>

/* uintmax_t, strtoumax() */
#include <inttypes.h>

/* openat */
#include <fcntl.h>

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

static
uintmax_t parse_unum(const char *n, const char *name)
{
	char *end;
	errno = 0;
	uintmax_t v = strtoumax(n, &end, 0);
	if (v == UINTMAX_MAX && errno) {
		fprintf(stderr, "Error: failure parsing %s, '%s': %s\n", name, n, strerror(errno));
		exit(EXIT_FAILURE);
	}

	if (*end != '\0') {
		fprintf(stderr, "Error: trailing characters in %s, '%s'\n", name, n);
		exit(EXIT_FAILURE);
	}

	return v;
}

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

static int act_store(const char *dir, int argc, char *argv[])
{
	int err = 0;
	int ct = argc - optind;
	if (ct != 7 && ct != 8) {
		fprintf(stderr, "Error: store requires 7 or 8 arguments\n");
		err++;
	}

	/* for store, we require an absolute path */
	if (dir[0] != '/') {
		fprintf(stderr, "Error: store requires an absolute path, but got '%s'\n", dir);
		err++;
	}

	if (err)
		exit(EXIT_FAILURE);

	/* FIXME: allow these to be non-fatal errors */
	uintmax_t pid = parse_unum(argv[optind + 1], "pid"),
		  uid = parse_unum(argv[optind + 2], "uid"),
		  gid = parse_unum(argv[optind + 3], "gid"),
		  sig = parse_unum(argv[optind + 4], "signal"),
		  ts  = parse_unum(argv[optind + 5], "timestamp");

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
	struct tm tm;
	/* FIXME: check overflow */
	time_t ts_time = ts;
	gmtime_r(&ts_time, &tm);

	/* try to use 'YYYY-MM-DD_HH:MM:SS.pid=PID.uid=UID' */

	char path_buf[PATH_MAX];
	size_t b = strftime(path_buf, sizeof(path_buf), "%F_%H:%M:%S", &tm);
	if (b == 0) {
		fprintf(stderr, "Error: strftime failed\n");
		exit(EXIT_FAILURE);
	}

	p = path_buf + b;
	int r = snprintf(p, sizeof(path_buf) - b, ".pid=%ju.uid=%ju", pid, uid);
	if (r < 0) {
		fprintf(stderr, "Error: could not format storage path\n");
		exit(EXIT_FAILURE);
	}

	if ((size_t)r > (sizeof(path_buf) - b - 1)) {
		fprintf(stderr, "Error: formatted storage path too long (needed %u bytes)\n", r);
		exit(EXIT_FAILURE);
	}

	int fd = openat(dirfd(d), path_buf, O_CREAT | O_DIRECTORY | O_RDWR);
	if (fd == -1) {
		fprintf(stderr, "Error: could not open storage dir '%s', %s\n", path_buf, strerror(errno));
		exit(EXIT_FAILURE);
	}

	/* store some data! */

	return 0;
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
		return act_store(dir, argc - optind - 1, argv + optind + 1);
	default:
		;
	}

	return 0;		
}
