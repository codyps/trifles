/* ex: set sts=8 sw=8 ts=8 noet: */

/* getaddrinfo */
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>

/* getopt */
#include <unistd.h>

#include <stdio.h>
#include <stdlib.h>

#include <string.h>
#include <errno.h>

const char *opt_str = ":a:p:";

int main(int argc, char *argv[])
{
	const char *addr = "localhost";
	const char *port = "445";
	int c;
	int err = 0;
	while ((c = getopt(argc, argv, opt_str)) != -1) {
		switch (c) {
		case 'a':
			addr = optarg;
			break;
		case 'p':
			port = optarg;
			break;
		default:
			fprintf(stderr, "Error: unknown arg -%c\n", optopt);
			err++;
		}
	}


	if (err)
		exit(EXIT_FAILURE);

	struct addrinfo hints = { .ai_family = AF_INET, .ai_socktype = SOCK_STREAM };
	struct addrinfo *res;
	int r = getaddrinfo(addr, port, &hints, &res);
	if (r) {
		fprintf(stderr, "Error: could not find host %s port %s: %s", addr, port,
				gai_strerror(r));
		exit(EXIT_FAILURE);
	}

	int s = socket(res->ai_family, res->ai_socktype, res->ai_protocol);
	if (s == -1) {
		fprintf(stderr, "Error: could not create socket: %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	r = connect(s, res->ai_addr, res->ai_addrlen);
	if (r == -1) {
		fprintf(stderr, "Error: connect %s [%s] failed: %s\n",
				addr, port, strerror(errno));
		exit(EXIT_FAILURE);
	}

	char buf[4096];
	size_t buf_pos = 0;
	for (;;) {
		ssize_t r = read(s, buf + buf_pos, sizeof(buf) - buf_pos);
		if (r == -1) {
			fprintf(stderr, "Error: read failed: %s\n", strerror(errno));
			exit(EXIT_FAILURE);
		}

		buf_pos += r;
		if (buf_pos > sizeof(buf)) {
			fprintf(stderr, "Error: too many bytes\n");
			exit(EXIT_FAILURE);
		}

		for (;;) {
			char *eol = memchr(buf, '\n', buf_pos);
			if (!eol)
				break;

			size_t line_len = eol - buf;
			printf("CLIENT: %.*s\n", (int)line_len, buf);
			memmove(buf, eol, buf_pos - line_len);
		}
	}

	return 0;
}
