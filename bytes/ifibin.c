
/* tightly bound reader for ifibin.
 * currenly uses their fixed address length (6)
 * and fixed byte grouping (1)
 */
int ifibin_read(struct addr_space *as, FILE *in)
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
