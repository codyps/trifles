#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <stdarg.h>
#include <errno.h>

int debug = 0;

#define DEBUG(...) do { \
	if (debug > 0)  \
		error_at_line(0, errno, __FILE__, __LINE__, __VA_ARGS);\
} while(0)
#define WARN(...) error_at_line(0, errno, __FILE__, __LINE__, __VA_ARGS__)
#define ERROR(status, ...) error_at_line(status, errno, __FILE__, __LINE__, __VA_ARGS__)

__attribute__((format(printf,5,6)))
void error_at_line(int status, int errnum, const char *filename,
                   unsigned int linenum, const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	fflush(stdout);

	fprintf(stderr, "%s:%u :", filename, linenum);

	if (errnum)
		fprintf(stderr, "%s : ", strerror(errnum));

	vfprintf(stderr, format, ap);

	fputc('\n',stderr);

	fflush(stderr);

	va_end(ap);
	if (status)
		exit(status);
}

struct addr_space {
	unsigned long region_ct;
	unsigned long region_mem_sz;
	struct mem_region *regions;
};

struct mem_region {
	unsigned long start_addr;
	size_t alloc_len;
	size_t used_len;
	char *mem;
};

int as_init(struct addr_space *as)
{
	as->regions = NULL;
	as->region_ct = 0;
	return 0;
}

void mr_destroy(struct mem_region *mr)
{
	free(mr->mem);
	mr->mem = NULL;
	mr->alloc_len = 0;
	mr->used_len = 0;
}

void as_destroy(struct addr_space *as)
{
	size_t i;
	for(i = 0; i < as->region_ct; i++) {
		mr_destroy(as->regions + i);
	}

	free(as->regions);
}

#define MR_INITIAL_ALLOC 16
int mr_init(struct mem_region *mr, unsigned long start_addr)
{
	mr->start_addr = start_addr;
	mr->alloc_len = MR_INITIAL_ALLOC;
	mr->used_len = 0;
	mr->mem = malloc(mr->alloc_len);
	if (!mr->mem)
		return -1;

	return 0;
}

int mr_append(struct mem_region *mr, void *data, size_t data_len)
{
	while (mr->alloc_len < (mr->used_len + data_len)) {
		size_t new_alloc_len = mr->alloc_len * 2 + MR_INITIAL_ALLOC;
		mr->mem = realloc(mr->mem, new_alloc_len);
		if (!mr->mem)
			return -1;
	}

	memcpy(mr->mem + mr->used_len, data, data_len);

	return 0;
}

int as_insert(struct addr_space *as, unsigned long addr, char *data,
              size_t data_len)
{
#warning "unimplimended"

	/* Find a memory region containing the data we want to add
	 * or abutting our region */
	unsigned long addr_end = addr + data_len;
	size_t i = 0;
	for(i = 0; i < as->region_ct; i++) {
		struct mem_region *mr = as->regions + i;
		unsigned long mr_addr = mr->addr;
		size_t mr_len = mr->used_len;
		unsigned long mr_addr_end = mr_addr + mr_len;

		/* the added data is below exsisting data */
		bool abut_low  = (addr < mr_addr)
		                 && (addr_end > mr_addr);

		/* the added data is above exsisting data */
		bool abut_high = (mr_addr < addr)
		                 && (mr_addr_end > addr);

		if ( abut_high || abut_low ) {
			/* collision */

		}
	}

	/* no collision, append */

	return -1;
}

int as_insert_mr(struct addr_space *as, struct mem_region *mr)
{
	return as_insert(as, mr->start_addr, mr->mem, mr->used_len);
}

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

int ihex_write(struct addr_space *as, FILE *out)
{
#warning "unimplimended"
	return -1;
}

int main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "usage: %s <ifi_bin_input.bin>\n",
		        argc>0?argv[0]:"ifibin_to_ihex");
		return -1;
	}

	char *file_name = argv[1];
	FILE *in = fopen(file_name,"r");
	if (!in) {
		fprintf(stderr, "file \"%s\" open failed\n", file_name);
		return -1;
	}
	struct addr_space as;
	int ret = as_init(&as);
	if (ret < 0) {
		WARN("as init faild");
		return -1;
	}

	ret = ifibin_read(&as, in);
	if (ret < 0) {
		WARN("ifibin_read failed");
		return -1;
	}

	ret = ihex_write(&as, stdout);
	if (ret < 0) {
		WARN("ihex_write failed");
		return -1;
	}

	return 0;
}
