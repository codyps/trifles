#ifndef PENNY_CHECK_H_
#define PENNY_CHECK_H_
#include <penny/penny.h>
#include <assert.h>

/* Added in f80e77555daaf6c32840c28b9d94f61ba47aa173, r159459 */
#define GCC_HAVE_STATIC_ASSERT GCC_VERSION_GREATER(4,6,0)

#if __STDC_VERSION__ >= 201112L || defined(static_assert) || GCC_HAVE_STATIC_ASSERT
#define BUILD_ASSERT(cond) _Static_assert(cond, #cond)
#else
#if 1
#define BUILD_ASSERT(cond) \
	typedef char CAT2(build_assert_,__LINE__)[1 - 2*!(cond)]
#else
#define BUILD_ASSERT(cond) \
	struct { int :-!(cond); } CAT2(build_assert,__LINE__) unused
//#define BUILD_ASSERT(cond) do { ((void)BUILD_ASSERT_OR_ZERO(cond)); } while(0)
//#define BUILD_ASSERT(cond)
//	DEFINE_COMPILETIME_ERROR(CAT2(build_assert,__LINE__), #cond)
//	if (cond)
//		CAT2(build_assert,__LINE__-2)(); // yes, wouldn't that be nice.
#endif
#endif

//#define BUILD_ASSERT_OR_ZERO(cond) (sizeof(struct { int:-!(cond); }))
#define BUILD_ASSERT_OR_ZERO(cond) (sizeof(char[1 - 2*!(cond)]))
#define BUILD_ASSERT_OR_NULL(cond) ((void *)BUILD_ASSERT_OR_ZERO(cond)

#if 0
BUILD_ASSERT(sizeof(int) > 3);
BUILD_ASSERT(sizeof(char) != 1);
BUILD_ASSERT(1 < 3);
#endif

#endif /* PENNY_CHECK_H_ */
