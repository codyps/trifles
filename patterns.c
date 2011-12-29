/* Packet socket */
#include <sys/socket.h>
#include <netpacket/packet.h>
#include <net/ethernet.h>

/* BPF filter */
#include <net/bpf.h>


/*
 * Need some way of doing the minimal number of comparisons to cut down to the exact magic number.
 * Seems to be some type of tree structure, but determining the byte comparisons to do is tricky
 *
 * Radix tree.
 *
 * A tree for each comparison unit. The largest tree gets to go first. Next largest and so on.
 *
 * Issue: after one comparison unit is determined, doen't lead to the items with only that comparison unit.
 */

int magic_seq_filter(uint8_t *magic, size_t magic_len, int sock_fd)
{
	struct sock_filter filt[] = {
		BPF_STMT(BPF_LD | BPF_
	};

	struct bpf_program bp = {
		.bf_len = ARRAY_SIZE(filt),
		.bf_insns = filt
	};

	setsockopt(sock_fd, SOL_SOCKET, SO_ATTACH_FILTER, &bp, sizeof(bp));
}


int main(int argc, char **argv)
{
	/* SOCK_DGRAM is alt */
	int ps = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_IP));
}
