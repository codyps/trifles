#ifndef PENNY_PRINT_H_
#define PENNY_PRINT_H_

#include <stdio.h>
#include <stdint.h>
#include <ctype.h>
#include <limits.h>
#include <string.h>
#include <penny/math.h>
#include <penny/penny.h>

static inline void print_byte_bits(unsigned char byte, FILE *f)
{
	unsigned bit = CHAR_BIT;
	char buf[CHAR_BIT + 1];
	while (bit--)
		buf[CHAR_BIT - bit - 1] = (byte & (1 << bit)) ? '1' : '0';

	buf[sizeof(buf) - 1] = '\0';
	fputs(buf, f);
}

static inline void print_byte_bits_lsb_first(unsigned char byte, FILE *f)
{
	unsigned bit = CHAR_BIT;
	char buf[CHAR_BIT + 1];
	while (bit--)
		buf[bit] = (byte & (1 << bit)) ? '1' : '0';

	buf[sizeof(buf) - 1] = '\0';
	fputs(buf, f);
}

static inline void print_bits(const void *data, size_t data_len, FILE *f)
{
	const unsigned char *d = data;
	while (data_len--) {
		print_byte_bits(*d, f);
		d++;
	}
}

static inline void print_bits_lsb_first(const void *data, size_t data_len, FILE *f)
{
	const unsigned char *d = data;
	while (data_len--) {
		print_byte_bits_lsb_first(*d, f);
		d++;
	}
}

static inline void print_num_bits(uintmax_t num, FILE *f)
{
	unsigned i;
	unsigned shift = (sizeof(num) - 1) * CHAR_BIT;
	__typeof__(num) mask = (~0) << shift;
	for (i = 0; i < sizeof(num); i++) {
		print_byte_bits((num & mask) >> shift, f);
		num = num << CHAR_BIT;
	}
}

#define PV(n) do {			\
	print_num_bits_t(n, stdout);	\
	printf(" /* %s */", #n);	\
	putchar('\n');			\
} while (0)
#define print_num_bits_t(v, f) do {				\
	unsigned __pnb_i;					\
	__typeof__(v) __pnb_num = (v);				\
	unsigned __pnb_shift = (sizeof(v) - 1) * CHAR_BIT;	\
	__typeof__(v) __pnb_mask = (~0) << __pnb_shift;		\
	for (__pnb_i = 0; __pnb_i < sizeof(v); __pnb_i++) {	\
		print_byte_bits((__pnb_num & __pnb_mask) >> __pnb_shift, f);	\
		__pnb_num = __pnb_num << CHAR_BIT;				\
	}							\
} while (0)

#define print_bits_t(v, f) print_bits(&(v), sizeof(v), f)

static inline void print_bits_llu(llu d, FILE *f)
{
	d = htonll(d);
	print_bits(&d, sizeof(d), f);
}

static inline void print_hex_byte(char byte, FILE *f)
{
	static const char hex_lookup[] = "0123456789abcdef";
	putc(hex_lookup[(byte >> 4) & 0x0f], f);
	putc(hex_lookup[byte & 0x0f], f);
}

#if 0
/* converts non-printable & control characters to their escaped represenation,
 * if on exsists, otherwise converts to hex */
static inline void print_bytes_as_sh_dollar_quote_string(void *data, size_t data_len, FILE *f)
{

}
#endif

static inline void print_bytes_as_sh_double_quote_string(void *data, size_t data_len, FILE *f)
{
	char *p = data;
	size_t i;
	putc('"', f);
	for (i = 0; i < data_len; i++) {
		char c = p[i];
		switch (c) {
		case '"':
		case '\\':
		case '$':
		case '`':
			putc('\\', f);
		}
	}
	putc('"', f);
}

/* not good for control & nonprintable characters */
static inline void print_bytes_as_sh_single_quote_string(void *data, size_t data_len, FILE *f)
{
	char *p = data;
	size_t i;
	putc('\'', f);
	for (i = 0; i < data_len; i++) {
		char c = p[i];
		if (c == '\'') {
			fputs("'\\''", f);
		} else {
			putc(c, f);
		}
	}
	putc('\'', f);
}

/* Prints a string such that it can be pasted into sh. Does not use quotes
 * - does not work well with non-printable and control characters. */
static inline void print_bytes_as_sh_no_quote_string(void *data, size_t data_len, FILE *f)
{
	char *p = data;
	size_t i;
	for (i = 0; i < data_len; i++) {
		char c = p[i];
		switch (c) {
			/* metacharacters */
			case '|':
			case '&':
			case ';':
			case '(':
			case ')':
			case '<':
			case '>':
			case ' ':
			case '\t':

			/* history expansion */
			case '!':

			/* others */
			case '\'':
			case '"':
			case '`':
			case '$':
			case '\\':
			case '\n':
				putc('\\', f);
		}
		putc(c, f);
	}
}

static inline void print_cstring_char(int c, FILE *f)
{
	if (iscntrl(c) || !isprint(c)) {
		switch (c) {
		case '\0':
			putc('\\', f);
			putc('0', f);
			break;
		case '\n':
			putc('\\', f);
			putc('n', f);
			break;
		case '\r':
			putc('\\', f);
			putc('r', f);
			break;
		default:
			putc('\\', f);
			putc('x', f);
			print_hex_byte(c, f);
		}
	} else  {
		switch (c) {
		case '"':
		case '\\':
			putc('\\', f);
		default:
			putc(c, f);
		}
	}
}

static inline void print_string_as_cstring_(const void *data, size_t data_len, FILE *f)
{
	const char *p = data;
	size_t i;
	for (i = 0; i < data_len; i++) {
		char c = p[i];
		if (c == '\0')
			break;
		print_cstring_char(c, f);
	}
}

static inline void print_bytes_as_cstring_(const void *data, size_t data_len, FILE *f)
{
	const char *p = data;
	size_t i;
	for (i = 0; i < data_len; i++) {
		char c = p[i];
		print_cstring_char(c, f);
	}
}

static inline void print_bytes_as_cstring(const void *data, size_t data_len, FILE *f)
{
	putc('"', f);
	print_bytes_as_cstring_(data, data_len, f);
	putc('"', f);
}

static inline void print_hex_dump(void *vbuf, size_t buf_len, FILE *f) {
	size_t i;
	uint8_t *buf = vbuf;
	for (i = 0; i < buf_len; i++) {
		fprintf(f, "%02X ", buf[i]);
	}
}

static inline void print_hex_dump_fmt(void *vbuf, size_t buf_len, FILE *f) {
	size_t i;
	uint8_t *buf = vbuf;
	int off_width = DIV_ROUND_UP(p_fls(buf_len), 4);

	for (i = 0; (int)i < off_width + 1; i++)
		putc(' ', f);
	for (i = 0; i < 0x10; i++) {
		fprintf(f, "  %zX", i);
	}

	putc('\n', f);

	for (i = 0; i < buf_len; i++) {
		if (i % 0x10 == 0)
			fprintf(f, "%0*zX:", off_width, i);
		fprintf(f, " %02X", buf[i]);
		if ((i + 1) % 0x10 == 0)
			putc('\n', f);
	}

	if (i % 0x10 != 0)
		putc('\n', f);
}

static inline void print_char_dump(void *vbuf, size_t buf_len, FILE *f) {
	size_t i;
	uint8_t *buf = vbuf;
	for (i = 0; i < buf_len; i++) {
		if (!iscntrl(buf[i]) && isprint(buf[i])) {
			fprintf(f, " %c ", (char)buf[i]);
		} else {
			fprintf(f, "%02X ", buf[i]);
		}
	}
}



#endif
