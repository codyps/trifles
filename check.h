#ifndef PENNY_CHECK_H_
#define PENNY_CHECK_H_
#include <penny/penny.h>
#include <assert.h>

/* Added in f80e77555daaf6c32840c28b9d94f61ba47aa173, r159459 */
#define GCC_HAVE_STATIC_ASSERT GCC_VERSION_GREATER(4,6,0)

#if defined(static_assert) || (defined(__cplusplus) && __cplusplus >= 201103L)
# define BUILD_ASSERT(cond) static_assert(cond, #cond)
#elif __STDC_VERSION__ >= 201112L || GCC_HAVE_STATIC_ASSERT
# define BUILD_ASSERT(cond) _Static_assert(cond, #cond)
#else
# define BUILD_ASSERT(cond) \
	typedef char CAT2(build_assert_,__LINE__)[1 - 2*!(cond)]
#endif

//#define BUILD_ASSERT_OR_ZERO(cond) (sizeof(struct { int:-!(cond); }))
#define BUILD_ASSERT_OR_ZERO(cond) (sizeof(char[1 - 2*!(cond)]))
#define BUILD_ASSERT_OR_NULL(cond) ((void *)BUILD_ASSERT_OR_ZERO(cond))

#if 0
#define BUILD_ASSERT(cond) \
	struct { int :-!(cond); } CAT2(build_assert,__LINE__) unused
//#define BUILD_ASSERT(cond) do { ((void)BUILD_ASSERT_OR_ZERO(cond)); } while(0)
//#define BUILD_ASSERT(cond)
//	DEFINE_COMPILETIME_ERROR(CAT2(build_assert,__LINE__), #cond)
//	if (cond)
//		CAT2(build_assert,__LINE__)(); // yes, wouldn't that be nice.
#endif

#if 0
/* https://lkml.org/lkml/2012/9/28/1251 */
#define BUILD_BUG_ON_MSG_INTERNAL2(cond, msg, line) \
    do { \
        extern void __build_bug_on_failed_ ## line (void) __attribute__((error(msg))); \
        if (cond) \
            __build_bug_on_failed_ ## line(); \
    } while (0)
#define BUILD_BUG_ON_MSG_INTERNAL(cond, msg, line) BUILD_BUG_ON_MSG_INTERNAL2(cond, msg, line)
#define BUILD_BUG_ON_MSG(cond, msg) BUILD_BUG_ON_MSG_INTERNAL(cond, msg, __LINE__)
#endif


#if 0
/* https://lkml.org/lkml/2012/10/1/548 */
1) if (condition) { __asm__(".error \"Some error message\""); }
2) switch (0) {
    case 0: break;
    case !condition: break;
    }
    (fails to compile if !condition evaluates to 0)
#endif

/*
 * https://lkml.org/lkml/2009/8/18/248
 * Claims gcc doesn't work with the sizeof(char[1 - 2*!(cond)]) variant.
 */

#if 0
BUILD_ASSERT(sizeof(int) > 3);
BUILD_ASSERT(sizeof(char) != 1);
BUILD_ASSERT(1 < 3);
#endif

#define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((long)(e))))
__attribute__((format(printf,1,2)))
static inline void printf_check_fmt(const char *fmt __attribute__((unused)), ...)
{}

/* http://www.pixelbeat.org/programming/gcc/static_assert.html */

#endif /* PENNY_CHECK_H_ */
