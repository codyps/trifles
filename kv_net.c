#include <sys/types.h>
#include <sys/socket.h> /* socket */

#include <netdb.h> /* getaddrinfo */




int main(int argc, char **argv)
{
	if (argc < 2) {
		fprintf(stderr, "no args.\n");
		return -1;
	}




	struct addrinfo hints;
	memset(&hints, 0, sizeof(hints));

	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_DGRAM;
	hints.ai_flags = AI_PASSIVE;



	return 0;
}
