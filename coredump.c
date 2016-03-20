/*
 * Provide a storage and retreval mechanism for system coredumps similar to systemd-coredump, but without the requirement on using systemd
 */
#include <stdio.h>
#include <stdlib.h>

#define STR_(x) #x
#define STR(x) STR_(x)

#ifndef CFG_COREDUMP_PATH
# define CFG_COREDUMP_PATH "/var/lib/systemd/coredump"
#endif
const char *default_path = CFG_COREDUMP_PATH;

const char *opts;
#define PRGMNAME "coredump"

static
void usage_(const char *prgmname, int e)
{
	FILE *f;
	if (e)
		f = stderr;
	else
		f = stdout;
	fprintf(f,
"Usage: %s [options] <action-and-args...>\n"
"       %s [options] store <global-pid> <uid> <gid> <signal-number> <unix-timestamp> <-%%c?-> <executable-filename>\n"
"\n"
"Use me to handle your coredumps:\n"
"    echo '|%s store %%P %%u %%g %%s %%t %%c %%e' | /proc/sys/kernel/core_pattern\n"
"\n"
"	%s [options] list\n"
"	%s [options] gdb\n"
"\n"
"Options:\n"
"  -d <directory>     store the coredumps in this directory\n"
"                     default = '%s'\n"
		, prgmname, prgmname, prgmname, prgmname, prgmname, default_path);

	exit(e);
}
#define usage(e) usage_(argc?argv[0]:PRGMNAME, e)

int main(int argc, char *argv[])
{
	usage(EXIT_SUCCESS);
	return 0;		
}
