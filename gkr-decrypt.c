/* Gnome keyring decrypt */

#include <stdio.h>
#include <errno.h>
#include <error.h>
#include <stdint.h>
#include <string.h>
#include <stddef.h>
#include <stdlib.h>

#define warn(...) do {			\
	fprintf(stderr, __VA_ARGS__);	\
	putc('\n', stderr);		\
} while(0)

#define ERROR(status, fmt, ...) error_at_line(status, errno, __FILE__, __LINE__, fmt, ## __VA_ARGS__)

#define MAGIC "GnomeKeyring\n\r\0\n"

#define __packed __attribute__((packed))
#define __unused __attribute__((unused))

#if 0
struct header {
	uint8_t major_version; /* 0 */
	uint8_t minor_version; /* 0 */
	uint8_t crypto;  /* 0 = AES */
	uint8_t hash;    /* 0 = MD5 */
};
#endif

#if 0
gcry_md_hash_buffer (GCRY_MD_MD5, (void*)digest,
			     (guchar*)to_encrypt.buf + 16, to_encrypt.len - 16);
#endif


static int check_magic(FILE *in)
{
	size_t m_sz = sizeof(MAGIC) - 1;
	char buf[m_sz];
	size_t r = fread(buf, 1, m_sz, in);
	int err = 0;

	if (r == 0) {
		ERROR(1, "failed to read");
	}

	if (r != m_sz) {
		warn("magic is %zu bytes and should be %zu bytes.", r, m_sz);
		err ++;
	}

	if (memcmp(buf, MAGIC, r)) {
		fprintf(stderr, "expected magic but got \"");
		__unused size_t a = fwrite(buf, 1, r, stderr);
		fputs("\"\n", stderr);
		err ++;
	}

	return -err;
}

static int header_check(FILE *in)
{
	char buf[4];
	size_t r = fread(buf, 1, sizeof(buf), in);

	if (r != sizeof(buf)) {
		warn("could not read header");
		return -1;
	}


	uint8_t major, minor, crypto, hash;
	major = buf[0];
	minor = buf[1];
	crypto = buf[2];
	hash = buf[3];

	if (major != 0 || minor != 0 || crypto != 0 || hash != 0) {
		warn("Header had non-zero value? What?");
		warn("major: %d, minor: %d, crypto: %d, hash: %d\n",
				major, minor, crypto, hash);
		return -1;
	}

	return 0;
}

struct string {
	uint32_t l;
	char data[];
};

static int decode_guint32(FILE *in, uint32_t *i)
{
	char buf[sizeof(uint32_t)];
	size_t r = fread(buf, 1, sizeof(buf), in);

	if (r != sizeof(buf)) {
		warn("could not read all of guint32, got %zu bytes of %zu bytes.",
				r, sizeof(buf));
		return -1;
	}

	*i = buf[0] << 24 | buf[1] << 16 | buf[2] << 8 | buf[3];
	return 0;
}

static int decode_string(FILE *in, struct string **sr)
{
	uint32_t l;
	if (decode_guint32(in, &l) < 0) {
		warn("could not decode string len");
		return -1;
	}

	size_t msz = offsetof(struct string, data[l]);
	struct string *s = malloc(msz);
	if (!s) {
		ERROR(1, "allocation of %zu failed", msz);
	}

	s->l = l;

	size_t rl = fread(s->data, 1, s->l, in);

	if (rl != l) {
		warn("could not read enough data (wanted %zu bytes, got %zu).",
				(size_t)l, rl);
		return -2;
	}


	*sr = s;
	return 0;
}

static size_t print_string(struct string *s, FILE *o)
{
	return fwrite(s->data, 1, s->l, o);
}

int main(int argc, char *argv[])
{
	if (argc < 2) {
		warn("usage: %s <filename>", argc?argv[0]:"gkr-decrypt");
		return 1;
	}
 
	const char *fname = argv[1];

	FILE *f = fopen(fname, "rb");

	if (!f) {
		ERROR(1, "on fopen of \"%s\"", fname);
	}

	if (check_magic(f) < 0)
		return 1;

	if (header_check(f) < 0)
		return 1;

	struct string *keyring_name;

	if (decode_string(f, &keyring_name) < 0)
		ERROR(1, "failed to decode keyring name");


	fputs("keyring name: ", stdout);
	print_string(keyring_name, stdout);
	putchar('\n');

	return 0;
}
