#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <error.h>
#include <sys/io.h>

typedef unsigned int u32;
static unsigned short pmtmr_ioport;

static int read_pmtmr(void)
{
	u32 v1, v2, v3;
	/* It has been reported that because of various broken
	 * * chipsets (ICH4, PIIX4 and PIIX4E) where the ACPI PM time
	 * * source is not latched, so you must read it multiple
	 * * times to insure a safe value is read.
	 * */
	v1 = inl(pmtmr_ioport);
	v2 = inl(pmtmr_ioport);
	v3 = inl(pmtmr_ioport);

	if ((v1 > v2 && v1 < v3) || (v2 > v3 && v2 < v1)
			|| (v3 > v1 && v3 < v2))
		return -1;
	else
		return 0;
}

int main(int argc, char *argv[])
{
	int i;

	if (argc < 2) {
		fprintf(stderr, "usage: %s <pm timer port>\n",
				argv[0]?argv[0]:"pm_timer_test");
		return -2;
	}

	pmtmr_ioport = strtoul(argv[1], NULL, 0);
	if ((pmtmr_ioport & 0xff) != 0x08)
		error(1, 0, "Invalid port address: 0x%x\n", pmtmr_ioport);

	if (iopl(3) < 0)
		error(1, errno, "iopl");

	for (i = 1; i <= 10000000; i++) {
		if (read_pmtmr() < 0) {
			fprintf(stderr,
				"\nread %d failed, pm-timer bug detected\n",
				i);
			return -1;
		}
		if ((i % 100000) == 0) {
			printf("\rsuccesful reads: %d", i);
			fflush(stdout);
		}
	}
	putchar('\n');
	return 0;
}
