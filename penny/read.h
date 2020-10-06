/* ex: set sts=8 noet ts=8 sw=8 */
#ifndef PENNY_READ_H_
#define PENNY_READ_H_
#include <ctype.h>
#include <limits.h>
static inline int read_hex_nible(char *s)
{
	char c = *s;
	if (isdigit(c)) {
		return c - '0';
	} else if (isalpha(c)) {
		if ('A' <= c && c <= 'F')
			return c - 'A' + 10;
		else if ('a' <= c && c <= 'f')
			return c - 'a' + 10;
	}

	return -1;
}

static inline int read_hex_byte(char *s)
{
	int a = read_hex_nible(s), b = read_hex_nible(s + 1);
	if (a < 0 || b < 0)
		return -1;
	return a << 4 | b;
}

#endif
