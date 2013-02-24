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

	struct addrinfo hints = {
		.ai_family = AF_INET,
		.ai_socktype = SOCK_DGRAM,
		.ai_flags = AI_PASSIVE,
	};

	return getaddrinfo(node, service, &hints, res);
}

static inline int udp_resolve_as_client(
		char const *node,
		char const *service,
		struct addrinfo **res)
{
	struct addrinfo hints = {
		.ai_family = AF_INET,
		.ai_socktype = SOCK_DGRAM,
	};

	return getaddrinfo(node, service, &hints, res);
}

#endif
