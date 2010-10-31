#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h> /* getaddrinfo */

#include <stdio.h> /* fprintf, stderr */

#include <unistd.h> /* getopt */

#include <stdlib.h> /* realloc */
#include <string.h> /* memset */

#include <errno.h>

#define DEFAULT_PORT_STR "9004"

int main(int argc, char **argv)
{
	char *listen_port = DEFAULT_PORT_STR;
	int opt;
	while ((opt = getopt(argc, argv, "l:")) != -1) {
		switch (opt) {
		case 'l':
			listen_port = optarg;
			break;

		default: /* '?' */
			fprintf(stderr, "usage: %s [-l listen_port]\n",
					argv[0]?argv[0]:"nc_listen");
			return -1;
		}
	}

	struct addrinfo hints;
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_INET;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_NUMERICSERV | AI_PASSIVE;

	struct addrinfo *ai_bind;
	int r = getaddrinfo(NULL, listen_port, &hints,
			&ai_bind);
	if (r) {
		fprintf(stderr, "getaddrinfo: %s \n",
				gai_strerror(r));
		return -1;
	}

	int sock = socket(ai_bind->ai_family, ai_bind->ai_socktype,
			ai_bind->ai_protocol);

	if (sock < 0) {
		fprintf(stderr, "socket: %s\n", strerror(errno));
		return -1;
	}

	int bret = bind(sock, ai_bind->ai_addr, ai_bind->ai_addrlen);
	if (bret < 0) {
		fprintf(stderr, "bind: %d %s\n", bret, strerror(errno));
		return -1;
	}

	if (listen(sock, 0xF) < 0) {
		fprintf(stderr, "listen: %s\n", strerror(errno));
		return -1;
	}

	for(;;) {
		struct sockaddr_storage addr;
		socklen_t addr_len = sizeof(addr);
		int con = accept(sock, (struct sockaddr *)&addr, &addr_len);

		if (con < 0) {
			if (errno == ECONNABORTED || errno == EINTR) {
				errno = 0;
				continue;
			} else {
				fprintf(stderr, "accept: %s\n",
						strerror(errno));
			}
		}

		printf("got connection.\n");
		close(con);
	}

	return 0;
}

