
#include "tcp.h"

#include <string.h>
#include <sys/types.h>  /* socket, getaddrinfo */
#include <sys/socket.h> /* socket, getaddrinfo */
#include <netdb.h>      /* getaddrinfo */
#include <unistd.h>
#include <errno.h>

int tcp_resolve_listen(
		char const *node,
		char const *service,
		struct addrinfo **res)
{
	if (node && !strcmp(node, "0.0.0.0")) {
		node = NULL;
	}

	struct addrinfo hints;

	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_INET;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_PASSIVE;
	hints.ai_protocol = 0;
	hints.ai_canonname = NULL;
	hints.ai_addr = NULL;
	hints.ai_next = NULL;

	return getaddrinfo(node, service, &hints, res);
}

int tcp_resolve_as_client(
		char const *node,
		char const *service,
		struct addrinfo **res)
{
	struct addrinfo hints;

	memset(&hints, 0, sizeof(hints));
	hints.ai_family = AF_INET;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = 0;
	hints.ai_protocol = 0;
	hints.ai_canonname = NULL;
	hints.ai_addr = NULL;
	hints.ai_next = NULL;

	return getaddrinfo(node, service, &hints, res);
}

int tcp_connect(struct addrinfo const *ai)
{
	struct addrinfo const *rp;
	for (rp = ai; rp != NULL; rp = rp->ai_next) {
		int sfd = socket(ai->ai_family, ai->ai_socktype,
				ai->ai_protocol);

		if (sfd == -1)
			continue;

		if (connect(sfd, rp->ai_addr, rp->ai_addrlen) == 0)
			return sfd;
		else
			close(sfd);
	}

	return -1;
}
