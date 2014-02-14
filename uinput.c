#include <linux/input.h>
#include <linux/uinput.h>

#include <sys/stat.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
	int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
	if (fd < 0)
		errx(1, "could not open uinput device.");

	return 0;
}
