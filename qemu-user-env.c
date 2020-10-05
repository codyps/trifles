#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <errno.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>

static char hmap[] = {
	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
};

static void puth2(unsigned char c, FILE *f) {
	putc(hmap[c], f);
}

static void puth(unsigned char c, FILE *f) {
	puth2((c & 0xf0) >> 4, f);
	puth2(c & 0x0f, f);
}

static void show_args(int argc, char **argv) {
	FILE *f = stderr;
	int i = 0;
	for (;;) {
		putc('\'', f);
		char *arg = argv[i];
		char c;
		while ((c = *arg++)) {
			if (c == '\'') {
				fputs("'\''", f);
			} else if (isprint(c)) {
				fputc(c, f);
			} else {
				fputc('\\', f);
				puth(c, f);
			}
		}
		putc('\'', f);

		i++;
		if (i == argc)
			break;

		putc(' ', f);
	}
}

int main(int argc, char **argv, char **envp) {
	char *newargv[argc + 3];

	fprintf(stderr, "m: ");
	show_args(argc, argv);
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
