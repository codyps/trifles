#ifndef PENNY_PENNY_H_
#define PENNY_PENNY_H_

#include <arpa/inet.h> /* htonl */

typedef unsigned long long ull;

#define FIELD_SIZE(s,f) (sizeof((s *)0->f))
#define typeof_field(s, f) typeof((s *)0->f)

#define ACCESS_ONCE(x)  (*(volatile typeof(x) *) &(x))
#define barrier() __asm__ __volatile__ ("":::"memory")

#define IS_ALIGNED(x, a) (((x) & ((typeof(x))(a) - 1)) == 0)

#define __ALIGN_KERNEL(x, a)		__ALIGN_KERNEL_MASK(x, (typeof(x))(a) - 1)
#define __ALIGN_KERNEL_MASK(x, mask)	(((x) + (mask)) & ~(mask))
#define ALIGN(x, a)		__ALIGN_KERNEL((x), (a))
#define __ALIGN_MASK(x, mask)	__ALIGN_KERNEL_MASK((x), (mask))
#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((uintptr_t)(p), (a)))

/* prefetch for reading */
#define prefetch(x)  __builtin_prefetch(x)

/* prefetch for writing */
#define prefetchw(x) __builtin_prefetch(x,1)

#define _STR(x) #x
#define STR(x) _STR(x)
#define LINE_STR STR(__LINE__)

#if defined(__GNUC__)
#define GCC_VERSION_GREATER(a, b, c)	\
	((__GNUC__ > a) || ((__GNUC__ == a) && \
		((__GNUC_MINOR__ > b) || ((__GNUC_MINOR__ == b) && \
			(__GNUC_PATCHLEVEL__ >= c)))))
#else
#define GCC_VERSION_GREATER(a,b,c) 0
#endif

/* to use, call the defined function is a condition that should never be true.
 * If the call is optimized out, no warning will be omitted.
 * Otherwise, it will be unhappy with you & create a nasty multiline
 * warning/error.
 *
 * Notes: marking this as noinline is required. So is the barrier. My guess is
 *        that the "inlining" discards the warning message.
 *
 * Warning: The use of 'barrier()' will (potentially) create less efficient code
 *        if the warning is emitted (not a concern for the error, as code won't
 *        be emitted in that case).
 */
#ifndef CONFIG_COMPILETIME_LONG_MSG
#define DEFINE_COMPILETIME_WARNING(name, msg) __attribute__((warning(msg),noinline)) static void name(void) { barrier(); }
#define DEFINE_COMPILETIME_ERROR(name, msg) __attribute__((error(msg),noinline)) static void name(void) { barrier(); }
#else
#define DEFINE_COMPILETIME_WARNING(name, msg) __attribute__((warning("\n"__FILE__ ":" LINE_STR ": " msg),noinline)) static void name(void) { barrier(); }
#define DEFINE_COMPILETIME_ERROR(name, msg) __attribute__((error("\n" __FILE__ ":" LINE_STR ": " msg),noinline)) static void name(void) { barrier(); }
#endif

/* useful in combination with the compiletime errors/warnings above. */
#define is_constant(expr)      __builtin_constant_p(expr)
#define constant_or_zero(expr) __builtin_choose_expr(__builtin_constant_p(expr), expr, 0)

#ifndef htonll
# ifdef _BIG_ENDIAN
#  define htonll(x)   (x)
#  define ntohll(x)   (x)
# else
#  define htonll(x)   ((((uint64_t)htonl(x)) << 32) + htonl(x >> 32))
#  define ntohll(x)   ((((uint64_t)ntohl(x)) << 32) + ntohl(x >> 32))
# endif
#endif

#define EXPORT(sym) __attribute__((externally_visible)) sym
#define expect_eq(x, y) __builtin_expect(x, y)
#define likely(x)   expect_eq(!!(x),1)
#define unlikely(x) expect_eq(x,0)
#define must_check  __attribute__((warn_unused_result))
#define unused      __attribute__((unused))
#define noreturn    __attribute__((__noreturn__))

#define _CAT2(a, b) a##b
#define CAT2(a, b) _CAT2(a,b)
#define _CAT3(a, b, c) a##b##c
#define CAT3(a, b, c) _CAT3(a,b,c)

typedef unsigned long long llu;
#define UNIT(x) x
#define EQ(a, b) ((a) == (b))

#endif
