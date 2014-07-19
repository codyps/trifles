#ifndef C_ILZ_H_
#define C_ILZ_H_

#include <stdlib.h>
#include <tommyds/tommyhashlin.h>

enum c_ilz_elem_type {
	C_IZL_INVALID,
	C_IZL_STRUCT,
	C_IZL_UINT,
	C_IZL_ARRAY,
};

struct c_ilz_elem_struct {
	tommy_hashlin children;
};

struct c_ilz_elem_array {
	size_t len;
	const char data[];
};

struct c_ilz_elem {
	enum c_ilz_elem_type type;
	struct c_ilz_elem *parent;
	tommy_node node;

	const char *member;
	size_t member_len;

	union {
		struct c_ilz_elem_struct struct_;
		uintmax_t uint;
		struct c_ilz_elem_array array;
	};
};

struct c_ilz_elem *c_ilz_find(struct c_ilz_elem *root, char *path);
int c_ilz_read(struct c_ilz_elem *ilz, const char *data, size_t data_len);

#endif
