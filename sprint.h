#ifndef PENNY_SPRINT_H_
#define PENNY_SPRINT_H_

static inline void sprint_hex_byte(char byte, char buf[static 2])
{
	static const char hex_lookup[] = "0123456789abcdef";
	buf[0] = hex_lookup[(byte >> 4) & 0x0f];
	buf[1] = hex_lookup[byte & 0x0f];
}

static inline int sprint_cstring_char(int c, char buf[static 4], size_t len)
{
	if (iscntrl(c) || !isprint(c)) {
		if (len > 0)
			buf[0] = '\\';
		switch (c) {
		case '\0':
			if (len > 1)
				buf[1] = '0';
			return 2;
		case '\n':
			if (len > 1)
				buf[1] = 'n';
			return 2;
		case '\r':
			if (len > 1)
				buf[1] = 'r';
			return 2;
		default:
			if (len > 1)
				buf[1] = 'x';
			if (len > 3)
				sprint_hex_byte(c, buf + 2);
			return 4;
		}
	} else  {
		switch (c) {
		case '"':
		case '\\':
			if (len > 1) {
				buf[0] = '\\';
				buf[1] = c;
			}
			return 2;
		default:
			if (len > 0)
				buf[0] = c;
			return 1;
		}
	}
}

static inline size_t sprint_bytes_as_cstring(char *obuf, size_t o_len, const void *data, size_t i_len)
{
	const char *p = data;
	size_t i;
	size_t o;
	for (i = 0, o = 0; i < i_len; i++) {
		char c = p[i];
		o += sprint_cstring_char(c, obuf + o, o_len - o);
	}

	return o;
}

static inline size_t sprint_cstring(char *obuf, size_t o_len, const char *str)
{
	return sprint_bytes_as_cstring(obuf, o_len, str, strlen(str));
}

#endif
