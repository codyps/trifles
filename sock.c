#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h> /* getaddrinfo */

#include <stdio.h> /* fprintf, stderr */

#include <unistd.h> /* getopt */

#include <stdlib.h> /* realloc */
#include <string.h> /* memset */
struct peer_data {
	char *name;
	struct addrinfo *res;
};

int main(int argc, char **argv)
{
	struct peer_data *peers = 0;
	size_t peer_ct = 0;
	int opt;
	while ((opt = getopt(argc, argv, "p:")) != -1) {
		switch (opt) {
		case 'p':
			peer_ct ++;
			peers = realloc(peers, sizeof(*peers) * peer_ct);
			memset(peers + peer_ct - 1, 0, sizeof(*peers));
			peers[peer_ct - 1].name = optarg;
			break;

		default: /* '?' */
			fprintf(stderr, "usage: %s [-l listen_port]"
					" [-p peer]... \n",
					argv[0]);
			exit(EXIT_FAILURE);
		}
	}

	fprintf(stderr, "we have %zu peers:\n", peer_ct);
	size_t i;
	for (i = 0; i < peer_ct; i++) {
		fprintf(stderr, " name: %s\n", peers[i].name);
	}

	//getaddrinfo
	struct addrinfo hints;
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;

	for (i = 0; i < peer_ct; i++) {
		int r = getaddrinfo(peers[i].name, NULL, &hints,
				&peers[i].res);
		if (r) {
			fprintf(stderr, "whoops: %s: %d %s\n",
					peers[i].name,
					r, gai_strerror(r));
		}
	}

	return 0;
}

