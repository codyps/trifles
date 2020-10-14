#ifndef PENNY_IP_H_
#define PENNY_IP_H_

#include <sys/socket.h>
#include <netinet/in.h>
#include <stdbool.h>

static inline int set_df(int fd, bool df)
{
#if defined(IP_DONTFRAG)
	int optval = 1;
	return setsockopt(fd, IPPROTO_IP, IP_DONTFRAG,
			(const void *) &optval, sizeof(optval));
#elif defined(IP_MTU_DISCOVER)
	int optval = IP_PMTUDISC_DO;
	return setsockopt(fd, IPPROTO_IP, IP_MTU_DISCOVER,
			(const void *) &optval, sizeof(optval));
#endif
}

static inline int get_df(int fd)
{
	int optval = 0;
	socklen_t optlen = sizeof(optval);
	int r = getsockopt(fd, IPPROTO_IP, IP_MTU_DISCOVER, &optval, &optlen);
	if (r == -1)
		return -1;

	return optval;
}

#endif
