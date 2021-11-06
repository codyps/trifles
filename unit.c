#include <systemd/sd-login.h>
#include <unistd.h>
#include <sys/types.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
	pid_t pid = getpid();
	int r;

	char *slice;
	r = sd_pid_get_slice(pid, &slice);
	if (r < 0) {
		fprintf(stderr, "get_slice failed: %s\n", strerror(-r));
	} else {
		printf("slice: %s\n", slice);
	}

	char *unit;
	r = sd_pid_get_unit(pid, &unit);
	if (r < 0) {
		fprintf(stderr, "get_unit failed: %s\n", strerror(-r));
	} else {
		printf("unit: %s\n", unit);
	}

	char *session;
	r = sd_pid_get_session(pid, &session);
	if (r < 0) {
		fprintf(stderr, "get_session failed: %s\n", strerror(-r));
	} else {
		printf("session: %s\n", session);
	}

	char *journal_stream = getenv("JOURNAL_STREAM");
	if (!journal_stream) {
		fprintf(stderr, "no journal_stream\n");
	} else {
		printf("journal_stream: %s\n", journal_stream);
	}

	return 0;
}
