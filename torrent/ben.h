#ifndef BEN_H_
#define BEN_H_
#include <stdlib.h> /* size_t */

enum be_type {
	BE_STR,
	BE_DICT,
	BE_INT,
	BE_LIST
};

struct be_str {
	size_t len;
	char *str;
};

struct be_node;
struct be_dict {
	struct be_str **key;
	struct be_node **val;
	size_t len;
};

struct be_list {
	size_t len;
	struct be_node **nodes;
};

struct be_node {
	enum be_type type;
	union {
		long long i;
		struct be_list *l;
		struct be_dict *d;
		struct be_str *s;
	} u;
};

struct be_node *bdecode(const char *estr, size_t len, const char **ep);
void be_print(struct be_node *be, FILE *out);

#endif /* BEN_H_ */
