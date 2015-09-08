#include "ctti.h"

struct a {
	int boop;
};

static_assert(has_member<a>::value, "A");
