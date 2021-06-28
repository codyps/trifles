#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <inttypes.h>

struct flag {
	const char *name;
	uint64_t mask;
};


#define F(n) { #n, n }
struct flag cflag[] = {
	F(CBAUD),
	F(CBAUDEX),
	F(CSIZE),
	F(CSTOPB),
	F(CREAD),
	F(PARENB),
	F(PARODD),
	F(HUPCL),
	F(CLOCAL),
#ifdef LOBLK
	F(LOBLK),
#endif
	F(CIBAUD),
	F(CMSPAR),
	F(CRTSCTS),
	{},
};

struct flag iflag[] = {
	F(IGNBRK),
	F(BRKINT),
	F(IGNPAR),
	F(PARMRK),
	F(INPCK),
	F(ISTRIP),
	F(INLCR),
	F(IGNCR),
	F(ICRNL),
	F(IUCLC),
	F(IXON),
	F(IXANY),
	F(IXOFF),
	F(IMAXBEL),
	F(IUTF8),
	{},
};

static void print_flags_(const char *name, struct flag *f, uint64_t val) {
	printf("%s (0x%" PRIx64 ") =", name, val);

	for (;;) {
		if (!f->name)
			break;

		uint64_t fv = val & f->mask;
		if (fv) {
			printf("|%s[0x%" PRIx64 "]", f->name, fv);
			val &= ~fv;
		}

		f++;
	}

	printf("|0x%" PRIx64 "\n", val);
}
#define print_flags(f, v) print_flags_(#f, f, v)

int main(int argc, const char *argv[]) {

	print_flags(cflag, 0x18B2);
	print_flags(cflag, 0x1CB2);

	print_flags(iflag, 0);
	print_flags(iflag, 0x100);

	return 0;
}
