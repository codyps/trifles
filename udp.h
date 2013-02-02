#ifndef PENNY_UDP_H_
#define PENNY_UDP_H_

#include <sys/types.h>  /* socket, getaddrinfo */
#include <sys/socket.h> /* socket, getaddrinfo */
#include <netdb.h>      /* getaddrinfo */

#include <string.h>

static inline int udp_resolve_listen(
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
	hints.ai_socktype = SOCK_DGRAM;
	hints.ai_flags = AI_PASSIVE;
	hints.ai_protocol = 0;
	hints.ai_canonname = NULL;
	hints.ai_addr = NULL;
	hints.ai_next = NULL;

	return getaddrinfo(node, service, &hints, res);
}

#endif
