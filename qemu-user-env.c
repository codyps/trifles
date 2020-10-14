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

static size_t to_next_line(char *b, size_t l) {
	char *p = memchr(b, '\n', l);
	if (!p) {
		return l + 1;
	}
	return p - b + 1;
}

static int load_nl_args_buf(char *buf, size_t buf_sz, int *argc, char ***argv) {
	int a = *argc;
	char **v = *argv;

	for (size_t i = 0; i < buf_sz;) {
		char c = buf[i];
		size_t n = to_next_line(&buf[i], buf_sz - i);

		if (c != '#') {
			int na = a + 1;
			char **vn = realloc(v, sizeof(*v) * na);
			if (!vn) {
				fprintf(stderr, "realloc for args intermediate failed\n");
				free(v);
				return -1;
			}

			v = vn;
			buf[i + n - 1] = '\0';
			v[a] = &buf[i];
			a = na;
		}

		i += n;
	}

	*argc = a;
	*argv = v;

	return 1;
}

static void test(void) {
	char b[] = "hello\ngoodbye";
	int argc = 0;
	char **argv = NULL;
	load_nl_args_buf(b, strlen(b), &argc, &argv);

	if (argc != 2) {
		abort();
	}

	if (strcmp(argv[0], "hello")) {
		abort();
	}

	if (strcmp(argv[1], "goodbye")) {
		abort();
	}
}

static int load_nl_args_file(const char *filename, int *argc, char ***argv, char **buf) {
	size_t buf_sz;
	*buf = grab_file(filename, &buf_sz);
	if (!*buf) {
		if (errno == ENOENT)
			return 0;
		fprintf(stderr, "qemu-user-env: failed to grab cfg file '%s': %s\n", filename, strerror(errno));
		return -1;
	}

	return load_nl_args_buf(*buf, buf_sz, argc, argv);
}

int main(int argc, char **argv, char **envp) {
	test();

	fprintf(stderr, "m: ");
	print_str_array(argc, argv, stderr);
	fprintf(stderr, "\n");

	char **newargv = malloc(sizeof(*newargv) * 1);
	int arg_offs = 1;
	char *buf;
	int r = load_nl_args_file("/etc/qemu-user-env", &arg_offs, &newargv, &buf);
	if (r < 0) {
		exit(EXIT_FAILURE);
	}

	newargv[0] = argv[0];

	fprintf(stderr, "e: ");
	print_str_array(arg_offs, newargv, stderr);
	fprintf(stderr, "\n");

	char **nnargv= realloc(newargv, sizeof(*newargv) * (arg_offs + argc));
	if (!nnargv) {
		fprintf(stderr, "realloc for args failed\n");
		exit(EXIT_FAILURE);
	}
	newargv = nnargv;

	memcpy(&newargv[arg_offs], &argv[1], sizeof(*argv) * (argc -1));
	newargv[argc + arg_offs - 1] = NULL;
	r = execve("/usr/bin/qemu-ppc-static.real", newargv, envp);
	if (r < 0) {
		fprintf(stderr, "qemu-user-env: execve failed: %s\n", strerror(errno));
	}
	return r;
}
