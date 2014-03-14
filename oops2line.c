#define _GNU_SOURCE /* memrchr() */

#include <stdio.h>
#include <stdarg.h>
#include <unistd.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/wait.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof(x[0]))


#ifdef DEBUG
#define dbg_run_cmd(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
#else
#define dbg_run_cmd(fmt, ...) do { } while (0)
#endif

static void run_cmd(const char *cmd, ...)
{
	const char *args[256];
	va_list va;
	size_t i;
	bool too_many_args = false;
	va_start(va, cmd);
	args[0] = cmd;
	dbg_run_cmd("# %s ", cmd);
	for (i = 1; ; i++) {
		const char *arg = va_arg(va, const char *);
		if (!arg)
			break;
		if (i > ARRAY_SIZE(args)) {
			too_many_args = true;
			continue;
		}

		dbg_run_cmd("%s ", arg);

		args[i] = arg;
	}

	dbg_run_cmd("\n");

	if (too_many_args) {
		fprintf(stderr, "too many args: got %zu\n", i);
		exit(1);
	}

	va_end(va);

	pid_t p = vfork();
	if (p == 0) {
		int r = execvp(cmd, (char *const*)args);
		fprintf(stderr, "exec %s failed: %d %d %s\n", cmd, r, errno, strerror(errno));
		exit(-127);
	} else {
		int stat;
		waitpid(p, &stat, 0);
		if (WIFEXITED(stat)) {
			int s = WEXITSTATUS(stat);
			if (s)
				fprintf(stderr, "non-zero exit: %d\n", s);
		} else if (WIFSIGNALED(stat)) {
			int s = WTERMSIG(stat);
			fprintf(stderr, "killed by signal: %d\n", s);
		} else if (WIFSTOPPED(stat)) {
			int s = WSTOPSIG(stat);
			fprintf(stderr, "stopped by signal: %d\n", s);
		} else if (WIFCONTINUED(stat)) {
			fprintf(stderr, "continued\n");
		} else {
			fprintf(stderr, "unknown status\n");
		}
	}
}

int main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "usage: %s <executable>\n"
				"Reads the oops from stdin and writes a modified version to stdout\n",
				argv[0]);
		return -1;
	}

	char *line = NULL;
	size_t len = 0;
	ssize_t r;

	while ((r = getline(&line, &len, stdin)) != -1) {
		char *end_of_addr = memrchr(line, ']', r);
		fputs(line, stdout);

		if (!end_of_addr)
			continue;

		size_t r2 = end_of_addr - line;
		char *start_of_addr = memrchr(line, '[', r2);
		if (!start_of_addr)
			continue;

		/* skip over the '[ timestamp]' */
		if (start_of_addr == line)
			continue;

		/* skip over
		 * [    2.267318] ---[ end trace 61a0f452a5c86036 ]---
		 */
		if (*(start_of_addr - 1) == '-')
			continue;

		/* skip over
		 * [    2.267186] Oops: Kernel access of bad area, sig: 11 [#1]
		 */
		if (*(start_of_addr + 1) == '#')
			continue;

		if (*(start_of_addr + 1) == '<' && *(end_of_addr - 1) == '>') {
			start_of_addr++;
			end_of_addr--;
		}



		*end_of_addr = '\0';
		run_cmd("addr2line", "-fipe", argv[1], start_of_addr + 1, NULL);
	}

#ifdef DEBUG
	free(line);
#endif
	return 0;
}
