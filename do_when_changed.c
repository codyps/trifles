#include <stdio.h>
#include <sys/inotify.h>
#include <unistd.h> /* getopt */
#include <penny/list.h>
#include <errno.h>
#include <string.h>

struct ifile {
	struct list_head list;
	const char *name;
	int wd; /* watch descriptor */
}

static void add_file(const char *file_name, struct list_head *head)
{
	struct ifile *f = malloc(sizeof(*f));
	if (!f)
		return;

	f->name = file_name;
	list_add(&f->list, head);
}

static void usage(void)
{
	fprintf(stderr, "usage: %s -f file [-f file ... ] <command>...\n"
			"<command> is all the remaining arguments.\n"
			"<command> may be run more often than when the file[s] change[s]."
			"At least 1 file is required.\n",
			argc?argv[0]:"do-when-changed");
	exit(EXIT_FAILURE);
}

int main(int argc, char **argv)
{
	struct list_head head;
	int opt;
	while ((opt = getopt(argc, argv, "f:")) != -1) {
		switch (opt) {
		case 'f':
			add_file(optarg, &head);
			break;
		default:
			usage();
		}
	}

	if (list_empty(&head))
		usage();

	int ifd = inotify_init();
	if (ifd < 0) {
		fprintf(stderr, "failed to initialize inotify: %s\n", strerror(errno));
		return 2;
	}

	struct ifile *pos;
	unsigned succ = 0;
	unsigned err = 0;
	list_for_each_entry(pos, &head, list) {
		int wd = inotify_add_watch(ifd, pos->name, IN_MODIFY);
		if (wd < 0) {
			fprintf(stderr, "W: failed to add watch on path '%s' : %s\n", pos->name, strerror(errno));
			err++;
		} else {
			succ++;
		}
	}

	for(;;) {
		char buf[4096];
		ssize_t r = read(ifd, buf, sizeof(buf));
		if (r < 0) {
			switch(errno) {
			case EINVAL:
				fprintf(stderr, "F: buffer too small for event, make it bigger.\n");
			default:
				fprintf(stderr, "F: unhandled error %d: %s\n", errno, strerror(errno));
			}
			return 1;
		} else if (r == 0) {
			fprintf(stderr, "F: buffer too small for event, make it bigger. (also, you have an old kernel < 2.6.21)\n");
			return 1;
		}


	}

	return 0;
}
