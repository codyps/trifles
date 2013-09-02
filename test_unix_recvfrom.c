#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <stdio.h>
#include <unistd.h>

int main(void)
{
	int s[2] = {
		socket(AF_UNIX, SOCK_DGRAM, 0),
		socket(AF_UNIX, SOCK_DGRAM, 0),
	};

	if (s[0] == -1)
		return 1;
	if (s[1] == -1)
		return 2;

	struct sockaddr_un usa = {
		.sun_family = AF_UNIX,
		.sun_path = "/tmp/test-it-out"
	};

	unlink("/tmp/test-it-out");
	int e = bind(s[0], (struct sockaddr *)&usa, sizeof(usa));
	if (e)
		return 3;

	for (;;) {
		char buf[256];
		struct sockaddr_storage st;
		memset(&st, 0xa5, sizeof(st)); /* poison */
		socklen_t sz = sizeof(st);
		ssize_t r = recvfrom(s[0], buf, sizeof(buf), 0, (struct sockaddr *)&st, &sz);
		if (r > 0)
			printf("> %d\n", st.ss_family);
	}

	return 0;
}
