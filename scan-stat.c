#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
	if (argc != 2) {
		printf("usage: %s <process id>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	const char *proc = getenv("PROC_PATH");
	if (!proc)
		proc = "/proc";

	char path[strlen(proc) + 1 + strlen(argv[1]) + 1 + strlen("stat") + 1];

	sprintf(path, "%s/%s/stat", proc, argv[1]);

	FILE *f = fopen(path, "r");
	if (!f) {
		fprintf(stderr, "could not open '%s'\n",
				path);
		exit(EXIT_FAILURE);
	}

	{
		int pid;
		char comm[32];
		char state;
		int ppid;
		int pgrp;
		int r = fscanf(f, "%d %s %c %d %d",
				&pid,
				comm,
				&state,
				&ppid,
				&pgrp);
		if (r != 5) {
			fprintf(stderr, "could not read from '%s'\n", path);
			exit(EXIT_FAILURE);
		}

		printf("got info: %d %s %c %d %d\n",
				pid, comm, state, ppid, pgrp);
	}

	return 0;
}
