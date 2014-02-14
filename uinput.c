#include <linux/input.h>
#include <linux/uinput.h>

#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <string.h>
#include <errno.h>

#include <err.h>

int main(int argc, char **argv)
{
	int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
	if (fd < 0)
		errx(1, "could not open uinput device: %s", strerror(errno));

	int ret = ioctl(fd, UI_SET_KEYBIT, EV_KEY);
	if (ret)
		errx(1, "UI_SET_KEYBIT EV_KEY failed");

	ret = ioctl(fd, UI_SET_KEYBIT, EV_SYN);
	if (ret)
		errx(1, "UI_SET_KEYBIT EV_SYN failed");

	ret = ioctl(fd, UI_SET_KEYBIT, KEY_D);
	if (ret)
		errx(1, "UI_SET_KEYBIT KEY_D failed");

	struct uinput_user_dev uidev = {
		.name = "uinput-test",
		.id = {
			.bustype = BUS_USB,
			.vendor = 0x1243,
			.product = 0xfedc,
			.version = 1,
		},
	};

	ssize_t r = write(fd, &uidev, sizeof(uidev));
	if (r < 0)
		errx(1, "write of uidev failed");

	ret = ioctl(fd, UI_DEV_CREATE);
	if (ret < 0)
		errx(1, "UI_DEV_CREATE failed");

	struct input_event ev = {
		.type = EV_KEY,
		.code = KEY_D,
		.value = 1,
	};

	r = write(fd, &ev, sizeof(ev));
	if (r < 0)
		errx(1, "write of ev failed");

	sleep(10);

	return 0;
}
