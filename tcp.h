#ifndef TCP_H_
#define TCP_H_

#include <sys/types.h>  /* socket, getaddrinfo */
#include <sys/socket.h> /* socket, getaddrinfo */
#include <netdb.h>      /* getaddrinfo */

int tcp_resolve_listen(
		char const *node,
		char const *service,
		struct addrinfo **res);

#define tcp_resolve_strerror(e) gai_strerror(e)

int tcp_bind(struct addrinfo const *ai);

int tcp_resolve_as_client(
		char const *node,
		char const *service,
		struct addrinfo **res);

int tcp_connect(struct addrinfo const *ai);

#if 0
/* helper functions which print warnings */
int tcpw_resolve_as_client(char const *nick,
		char const *addr, char const *port,
		struct addrinfo **ai);
int tcpw_connect(char const *nick,
		char const *addr,
		char const *port,
		struct addrinfo const *ai);
int tcpw_resolve_and_connect(char const *nick,
		char const *addr,
		char const *port);
int tcpw_listen(char const *addr, char const *port);
#endif
#endif
