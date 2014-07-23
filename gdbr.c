#define _GNU_SOURCE
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>
#include <stdarg.h>

#include <errno.h>
#include <unistd.h>
#include <fcntl.h>

#include <ev.h>

#include <ccan/net/net.h>

#include "penny/read.h"
#include "penny/fd.h"
#include "penny/socket.h"
#include "penny/print.h"
#include "penny/sprint.h"

#define peer_err(peer, fmt, ...) fprintf(stderr, fmt ##, __VA_ARGS__)

struct peer {
	ev_io w; /* I'm lazy & require this to be the first member */
	struct sockaddr_storage addr;
	socklen_t addr_len;
	uint8_t buf[128];
	size_t pos;
};

#define DEFAULT_PORT "3333"
#define MSG_BYTE_START '$'
#define MSG_BYTE_CHECK '#'
#define MSG_BYTE_ACK   '+'
#define MSG_BYTE_NACK  '-'

static int sum(const char *buf, size_t sz)
{
	size_t i;
	int s = 0;
	for (i = 0; i < sz; i++)
		s += (unsigned char)buf[i];
	return s;
}

static void msg_send(int fd, const char *buf, size_t sz)
{
	char buf_[1 + sz + 1 + 2 + 1];
	unsigned s = sum(buf, sz) & 0xff;
	buf_[0] = '$';
	memcpy(buf_ + 1, buf, sz);
	buf_[sz] = '#';
	sprint_hex_byte(s, &buf_[sz + 1]);
	fprintf(stderr, "\tsending: ");
	print_bytes_as_cstring(buf_, sizeof(buf_), stderr);
	putc('\n', stderr);
	write(fd, buf_, sizeof(buf_));
}

static void msg_send_fmt(int fd, const char *fmt, ...)
{
	va_list va;
	char *str;
	int l;
	va_start(va, fmt);
	l = vasprintf(&str, fmt, va);
	va_end(va);
	msg_send(fd, str, l);
	free(str);
}

static int peer_parse_msg(struct peer *peer)
{
	fprintf(stderr, "\tparse buffer is: ");
	print_bytes_as_cstring(peer->buf, peer->pos, stderr);
	putc('\n', stderr);
	size_t i;
	uint_least8_t csum;

	switch (peer->buf[0]) {
	case '$':
		puts("message!");
		/* scan for end */
		csum = 0;
		for (i = 1; i < peer->pos; i++) {
			if (peer->buf[i] == '#') {
				if (peer->pos - i <  2) {
					puts("truncated csum");
					break;
				} else {
					goto valid_msg;
				}
			}

			csum += peer->buf[i];
		}
		puts("no csum");
		return 0;
valid_msg:
		csum &= 0xff;
		int rcsum = read_hex_byte((char *)peer->buf + i +  1);
		printf("[+] %x %x\n", csum, rcsum);
		if (csum == rcsum) {
			dprintf(peer->w.fd, "+");
			msg_send_fmt(peer->w.fd, "");
		} else
			dprintf(peer->w.fd, "-");
		return i + 3;
	case '+':
		puts("ack!");
		return 1;
	case '-':
		puts("nack!");
		return 1;
	default:
		puts("CORRUPTION\n");
		/* advance by 1 byte to attempt fixing */
		return 1;
	}
}

static int peer_ct;
static void peer_shutdown(EV_P_ struct peer *p)
{
	peer_ct --;
	ev_io_stop(EV_A_ &p->w);
	close(p->w.fd);
	free(p);
}

static void peer_cb(EV_P_ ev_io *w, int revents);
static void peer_startup(EV_P_ struct peer *p, int fd)
{
	peer_ct ++;
	ev_io_init(&p->w, peer_cb, fd, EV_READ);
	ev_io_start(EV_A_ &p->w);
}

static void peer_cb(EV_P_ ev_io *w, int revents)
{
	(void)revents;
	fprintf(stderr, "PEER EVENT\n");
	struct peer *peer = (struct peer *)w;
	ssize_t r = read(w->fd, peer->buf + peer->pos, sizeof(peer->buf) - peer->pos);
	if (r == 0) {
		fprintf(stderr, "\tdisconnected.\n");
		goto close_con;
	} else if (r < 0) {
		fprintf(stderr, "\tunknown error in read: %zd %s\n", r, strerror(errno));
		goto close_con;
	}

	fprintf(stderr,   "\treceived      : ");
	print_bytes_as_cstring(peer->buf + peer->pos, r, stderr);
	peer->pos += r;
	fprintf(stderr, "\n\tpeer buffer is: ");
	print_bytes_as_cstring(peer->buf, peer->pos, stderr);
	putc('\n', stderr);

	do {
		r = peer_parse_msg(peer);
		if (r < 0)
			goto close_con;
		else {
			/* advance the message buffer */
			memmove(peer->buf, peer->buf + r, peer->pos - r);
			peer->pos -= r;
		}
	} while (r && peer->pos);

	if (sizeof(peer->buf) == peer->pos) {
		fprintf(stderr, "\tran out of buffer space.\n");
		goto close_con;
	}
	return;

close_con:
	peer_shutdown(EV_A_ peer);
}

static struct peer *accept_peer;
static void accept_cb(EV_P_ ev_io *w, int revents)
{
	for(;;) {
		if (!accept_peer) {
			accept_peer = malloc(sizeof(*accept_peer));
			memset(accept_peer, 0, sizeof(*accept_peer));
			accept_peer->addr_len = sizeof(accept_peer->addr);
		}

		int fd = accept(w->fd, (struct sockaddr *)&accept_peer->addr,
				&accept_peer->addr_len);
		if (fd == -1) {
			switch (errno) {
			case EBADF:
			case ENOTSOCK:
			case EINVAL:
			case EMFILE:
			case ENFILE:
			case ENOBUFS:
			case ENOMEM:
			case EPROTO:
			default:
				/* DIE A HORRIBLE DEATH */
				fprintf(stderr, "listener recieved error, exiting: %s\n", strerror(errno));
				ev_break(EV_A_ EVBREAK_ONE);
				return;
			case ECONNABORTED:
			case EINTR:
				continue;
			case EAGAIN:
				return;
			}
		}

		if (peer_ct == 0) {
			peer_startup(EV_A_ accept_peer, fd);
			accept_peer = NULL;
		} else
			close(fd);
	}
}

static void stdio_cb(EV_P_ ev_io *w, int revents)
{
	/* parse input and send commands to remote */
	puts("HI");
}

int main(int argc, char **argv)
{
	const char *bind_addr = NULL, *port = DEFAULT_PORT;
	int opt;

	while ((opt = getopt(argc, argv, "a:p:")) != -1) {
		switch (opt) {
		case 'a':
			bind_addr = optarg;
			break;
		case 'p':
			port = optarg;
			break;
		default: /* '?' */
			fprintf(stderr, "usage: %s [-a bind_addr] [-p bind_port]\n",
					argv[0]);
			return 1;
		}
	}

	struct addrinfo *addr = net_server_lookup_(bind_addr, port, AF_UNSPEC, SOCK_STREAM);
	if (!addr) {
		fprintf(stderr, "could not resolve %s\n", bind_addr);
		return 1;
	}

	int fds[2];
	int num_fds = net_bind(addr, fds);
	if (num_fds < 0) {
		fprintf(stderr, "could not bind to addr %s, port %s: %s\n", bind_addr, port, strerror(errno));
		return 1;
	}

	freeaddrinfo(addr);

	int i;
	ev_io accept_listener[2];
	for (i = 0; i < num_fds; i++) {
		int r = listen(fds[i], 128);
		if (r == -1) {
			fprintf(stderr, "could not listen.\n");
			return 1;
		}

		r = fd_set_nonblock(fds[i]);
		if (r < 0) {
			fprintf(stderr, "could not set socket non-blocking.\n");
			return 1;
		}

		ev_io_init(&accept_listener[i], accept_cb, fds[i], EV_READ);
		ev_io_start(EV_DEFAULT_ &accept_listener[i]);
	}

	struct ev_io stdio_listener;
	ev_io_init(&stdio_listener, stdio_cb, STDIN_FILENO, EV_READ);

	ev_run(EV_DEFAULT_ 0);

	return 0;
}
