#ifndef PENNY_CHECK_H_
#define PENNY_CHECK_H_
#include <penny/penny.h>

#if __STDC_VERSION__ >= 201112L
#define BUILD_ASSERT(cond) _Static_assert(cond, #cond)
#else
#define __BUILD_ASSERT(cond, line) typedef char build_assert_##line[1 - 2*!(cond)]
#define _BUILD_ASSERT(cond, line) __BUILD_ASSERT(cond, line)
#define BUILD_ASSERT(cond) _BUILD_ASSERT(cond, __LINE__)
#endif

#define BUILD_ASSERT_OR_ZERO(cond) (sizeof(char[1 - 2*!(cond)]))
#define BUILD_ASSERT_OR_NULL(cond) ((void *)BUILD_ASSERT_OR_ZERO(cond)

//#define BUILD_ASSERT_OR_ZERO(cond) (sizeof(struct { int:-!(cond); }))
//#define BUILD_ASSERT(cond) do { ((void)BUILD_ASSERT_OR_ZERO(cond)); } while(0)

#endif /* PENNY_CHECK_H_ */
