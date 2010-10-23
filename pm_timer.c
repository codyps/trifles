#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <error.h>
#include <sys/io.h>

typedef unsigned int u32;
static unsigned short pmtmr_ioport;
static int cnt;

#define ACPI_PM_MASK 0xFFFFFF /* limit it to 24 bits */

static u32 read_pmtmr(void)
{
	u32 v1=0,v2=0,v3=0;
	/* It has been reported that because of various broken
	 * * chipsets (ICH4, PIIX4 and PIIX4E) where the ACPI PM time
	 * * source is not latched, so you must read it multiple
	 * * times to insure a safe value is read.
	 * */
	cnt = 0;
	do {
		v1 = inl(pmtmr_ioport);
		v2 = inl(pmtmr_ioport);
		v3 = inl(pmtmr_ioport);
		cnt++;
	} while ((v1 > v2 && v1 < v3) || (v2 > v3 && v2 < v1)
			|| (v3 > v1 && v3 < v2));

	/* mask the output to 24 bits */
	return v2 & ACPI_PM_MASK;
}

int main(int argc, char *argv[])
{
	int i;

	if (argc < 2)
		error(1, 0, "Usage: %s pmtmr_port\n", argv[0]);

	pmtmr_ioport = strtoul(argv[1], NULL, 0);
	if ((pmtmr_ioport & 0xff) != 0x08)
		error(1, 0, "Invalid port address: 0x%x\n", pmtmr_ioport);

	if (iopl(3) < 0)
		error(1, errno, "iopl");

	for (i = 0; i < 10000000; i++) {
		read_pmtmr();
		if (cnt > 1)
			error(1, 0, "Detect PM-Timer Bug\n");
		if ((i % 100000) == 0)
			printf("%d\n", i);
	}
	return 0;
}
