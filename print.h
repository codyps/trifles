#ifndef PENNY_PRINT_H_
#define PENNY_PRINT_H_

#include <stdio.h>
#include <ctype.h>

static const char hex_lookup[] = "0123456789abcdef";
static inline void print_hex_byte(char byte, FILE *f)
{
	putc(hex_lookup[(byte >> 4) & 0x0f], f);
	putc(hex_lookup[byte & 0x0f], f);
}

static inline void print_bytes_as_cstring(void *data, size_t data_len, FILE *f)
{
	putc('"', f);
	char *p = data;
	size_t i;
	for (i = 0; i < data_len; i++) {
		char c = p[i];
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
	putc('"', f);
}

static inline void print_hex_dump(void *vbuf, size_t buf_len, FILE *f) {
	int i;
	uint8_t *buf = vbuf;
	for (i = 0; i < buf_len; i++) {
		fprintf(f, "%02X ", buf[i]);
	}
}

static inline void print_char_dump(void *vbuf, size_t buf_len, FILE *f) {
	int i;
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
