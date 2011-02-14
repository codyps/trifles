#include <sys/types.h>
#include <sys/socket.h> /* socket */

#include <netdb.h> /* getaddrinfo */


int get_serv_addrs(char const *node, char const *service,
		struct addrinfo **res)
{

	struct addrinfo hints;
	memset(&hints, 0, sizeof(hints));

	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_DGRAM;
	hints.ai_flags = AI_PASSIVE;

	struct addrinfo *res;

	int ret = getaddrinfo(node, service, &hints, res);
	return ret;
}


int main(int argc, char **argv)
{
	if (argc < 3) {
		fprintf(stderr, "usage: x <addr> <port> <kv_dir>\n");
		return -1;
	}

	struct addrinfo *res;

	int x = get_serv_addrs(argv[1], argv[2], &res);

	if (x != 0) {
		fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(s));
		exit(EXIT_FAILURE);
	}

	struct addrinfo *rp;
	int s;
	for (rp = res;; rp = rp->ai_next) {
		if (!rp) {
			fprintf(stderr, "Could not bind\n");
			exit(EXIT_FAILURE);
		}

		s = socket(rp->ai_family, rp->ai_socktype,
				rp->ai_protocol);

		if (s == -1)
			continue;

		if (bind(s, rp->ai_addr, rp->ai_addrlen) == 0)
			break;

		close(s);
	}

	for (;;) {
		
	}

	return 0;
}
