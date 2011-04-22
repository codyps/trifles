#include <address_space.h>

struct ibctx {
	struct addr_space *as;
	size_t line_num;
	char  *file_name;
	int    line_pos;

	char *start;
	char *end;
};

static int tohex(int c)
{
	c = tolower(c);
	if (c > '9')
		return c - 'a';
	return c - '0';
}

static ssize_t get_line_addr(struct ibctx *ctx)
{
	size_t line_addr = 0;
	unsigned addr_len = 0;

	char cur;
	while((cur = *(ctx->start)) != ' ') {
		if (!isxdigit(cur)) {
			WARN_LINE(ctx, "address contains non-hex digit."
					" assuming address is done.");
			break;
		}

		line_addr <<= 4;
		line_addr |= tohex(cur);

		addr_len ++;
		ctx->start ++;
		ctx->line_pos ++;

		if (ctx->start >= ctx->end) {
			WARN_LINE(ctx, "no more file to parse.");
			return -1;
		}

		if (addr_len > (sizeof(line_addr) * CHAR_BIT / 4 - 1)) {
			WARN_LINE(ctx, "bits in address exceeded allowed "
				"amount");
			return -1;
		}
	}

	return line_addr;
}


int ifibin_read(struct addr_space *as, char *start, char *end)
{
	struct ibctx c;
	struct ibctx *ctx = &c;

	c.as = as;
	c.line_num = 1;
	c.file_name = "unknown_file";
	c.line_pos = 1;
	c.start = start;
	c.end = end;

	/* for each line */
	for (;;) {
		ssize_t addr = get_line_addr(ctx);
		if (addr < 0) {
			return -1;
		}

		if (*c.start != ' ') {
			WARN(ctx, "could not eat space.");
		} else {
			c.start ++;
		}

		if (c.start >= c.end) {
			WARN(ctx, "out of parsable data.");
			return -1;
		}

		/* for each byte pair */
		while(*(c.start) != '\n') {
			int b = 0;

			if (!isxdigit(c))

		}
	}

}

/* tightly bound reader for ifibin.
 * currenly uses their fixed address length (6)
 * and fixed byte grouping (1)
 */
int ifibin_read(struct addr_space *as, char *start, char *end)
{
	char *line = NULL;
	size_t line_sz = 0;

	for(;;) {
		struct mem_region mr;
		/* per line processing */
		unsigned line_addr = 0;
		ssize_t line_len = getline(&line, &line_sz, in);
		size_t line_pos = 0;

		/* getline returns -1 on errors & eof */
		if (line_len == -1) {
			if (feof(in)) {
				return 0;
			} else {
				WARN("getline: read error");
				return -1;
			}
		}

		int ret = sscanf(line + line_pos, "%06X ", &line_addr);
		if (ret != 1) {
			WARN("addr not found: '%s'\n", line);
			continue; /* next line */
		}

		ret = mr_init(&mr, line_addr);
		if (ret < 0) {
			WARN("mr init failed");
			return -1;
		}

		/* 6 hex chars + a space */
		line_pos += 7;

		while(line_pos < line_len) {
			/* per data byte processing */
			unsigned data;
			ret = sscanf(line + line_pos, "%02X ", &data);
			if (ret != 1) {
				WARN("byte not read... '%s'\n", line);
				break; /* next line */
			}

			/* 2 hex chars + a space */
			line_pos += 3;
			uint8_t sdata = data;
			ret = mr_append(&mr, &sdata, 1);
			if (ret < 0) {
				WARN("mr_append failed.");
				return -1;
			}
		}

		ret = as_insert_mr(as, &mr);
		if (ret < 0) {
			WARN("as_insert failed");
			return -1;
		}
	}
}
