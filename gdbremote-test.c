#include <stdio.h>

#include <ccan/net/net.h>
#include <ccan/err/err.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netdb.h>

int main(void)
{
	char *host = "localhost";
	char *serv = "3333";

	struct addrinfo *a = net_server_lookup_(host, serv, AF_INET, SOCK_STREAM);
	if (!a)
		errx(1, "Failed to lookup %s:%s\n", host, serv);

	int fds[2];
	int s = net_bind(a, fds);
	if (s == -1)
		errx(1, "Failed to bind to %s:%s\n", host, serv);

	int r = listen(s, 1);
	if (!r)
		errx(1, "Failed to listen\n");

	struct sockaddr addr;
	socklen_t addr_len
	int fd = accept(s, &addr, &addr_len);


}
