
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

int tcp_bind(struct addrinfo const *ai)
{
	struct addrinfo const *rp;
	for (rp = ai; rp != NULL; rp = rp->ai_next) {
		int sfd = socket(ai->ai_family, ai->ai_socktype,
				ai->ai_protocol);

		if (sfd == -1)
			continue;

		if (bind(sfd, rp->ai_addr, rp->ai_addrlen) == 0)
			return sfd;
		else
			close(sfd);
	}

	return -1;
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

#if 0
int tcpw_resolve_as_client(char const *nick, char const *addr, char const *port,
		struct addrinfo **ai)
{
	int r = tcp_resolve_as_client(addr, port, ai);
	if (r) {
		w_prt("could not resolve %s [%s]:%s : %s\n",
				nick, addr, port,
				tcp_resolve_strerror(r));
		return r;
	}

	return 0;
}

int tcpw_listen(char const *addr, char const *port)
{
	struct addrinfo *res;
	int r = tcp_resolve_listen(addr, port, &res);
	if (r) {
		/* error resolving. */
		w_prt("listen addr resolve [%s]:%s failed: %s\n",
				addr, port,
				tcp_resolve_strerror(r));
		return -1;
	}

	int tl = tcp_bind(res);
	freeaddrinfo(res);
	if (tl == -1) {
		w_prt("could create listener [%s]:%s : %s\n",
				addr, port, strerror(errno));
		return -1;
	}

	r = listen(tl, 128);
	if (r == -1) {
		w_prt("failed to start listening: %s\n", strerror(errno));
		return -1;
	}

	return tl;
}

int tcpw_connect(char const *nick, char const *addr, char const *port,
		struct addrinfo const *ai)
{
	int fd = tcp_connect(ai);
	if (fd == -1) {
		w_prt("connect to %s [%s]:%s failed: %s\n",
				nick, addr, port,
				strerror(errno));
		return -1;
	}

	return fd;
}

int tcpw_resolve_and_connect(char const *nick, char const *addr, char const *port)
{
	struct addrinfo *ai;
	int r = tcpw_resolve_as_client(nick, addr, port, &ai);
	if (r) {
		return -1;
	}

	int fd = tcpw_connect(nick, addr, port, ai);
	freeaddrinfo(ai);
	if (fd < 0) {
		return -1;
	}

	return fd;
}
#endif
