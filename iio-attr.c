#include <iio.h>
#include <stdio.h>
#include <unistd.h>

int main(void) {
	struct iio_context *ctx = iio_create_default_context();
	if (!ctx) {
		fprintf(stderr, "iio_create_default_context() failed\n");
		abort();
	}

	struct iio_device *dev = iio_context_find_device(ctx, "deck_angl");
	if (!dev) {
		fprintf(stderr, "iio_context_find_device(ctx, \"deck_angl\") failed\n");
		abort();
	}

	struct iio_channel *chan = iio_device_find_channel(dev, "angl", false);
	if (!chan)
		abort();
	
	unsigned long delay = 10 * 1;

	long long in;
	for (size_t i = 0; i < 20; i++) {
		int r = iio_channel_attr_read_longlong(chan, "raw", &in);
		if (r < 0) {
			printf("read error: %d\n", r);
		} else {
			printf("value: %lld\n", in);
		}
		usleep(delay);
	}

	int r = iio_channel_attr_write_bool(chan, "set_zero", true);
	if (r < 0) {
		printf("zero error: %d\n", r);
	}

	size_t ect = 0;
	for (size_t i = 0; i < (20000 / delay); i++) {
		int r = iio_channel_attr_read_longlong(chan, "raw", &in);
		if (r < 0) {
			ect++;
		} else {
			printf("value: %lld\n", in);
		}
		usleep(delay);
	}

	printf("read error count: %zu\n", ect);
}
