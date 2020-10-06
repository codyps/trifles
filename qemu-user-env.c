#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

#include "grab_file.c"
#include "print-str-array.c"

static int load_nl_args_file(const char *filename, int *argc, char ***argv) {
	char buf[4096];

	size_t buf_sz;
	char *buf = grab_file(filename, &buf_sz);
	if (!buf) {
		if (errno == ENOENT)
			return 0;
		fprintf(stderr, "qemu-user-env: failed to grab cfg file '%s': %s\n", filename, strerror(errno));
		return -1;
	}
	
	// TODO: load new-line seperated args
	// when editing files, newlines get added all the time. strip it out
	if (buf[l - 1] == '\n') {
		buf[l - 1] = '\0';
	}
}

int main(int argc, char **argv, char **envp) {
	char *newargv[argc + 3];

	fprintf(stderr, "m: ");
	print_str_array(argc, argv, stderr);
	fprintf(stderr, "\n");

	size_t arg_offs = 1;
	newargv[0] = argv[0];

	char buf[1024];
	int cfg_fd = open("/etc/qemu-user-cpu", O_RDONLY);
	if (cfg_fd < 0) {
		if (errno == ENOENT)
			goto do_exec;
		fprintf(stderr, "qemu-user-env: failed to open cfg file: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	ssize_t l = read(cfg_fd, buf, sizeof(buf));
	if (l < 0) {
		fprintf(stderr, "qemu-user-env: reading cfg file failed: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	close(cfg_fd);

	// TODO: load new-line seperated args
	// when editing files, newlines get added all the time. strip it out
	if (buf[l - 1] == '\n') {
		buf[l - 1] = '\0';
	}

	newargv[1] = "-cpu";
	newargv[2] = buf;
	arg_offs += 2;

do_exec:
	memcpy(&newargv[arg_offs], &argv[1], sizeof(*argv) * (argc -1));
	newargv[argc + arg_offs - 1] = NULL;
	int r = execve("/usr/bin/qemu-ppc-static.real", newargv, envp);
	if (r < 0) {
		fprintf(stderr, "qemu-user-env: execve failed: %s\n", strerror(errno));
	}
	return r;
}
