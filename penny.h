#ifndef PENNY_PENNY_H_
#define PENNY_PENNY_H_

#include <stddef.h>

#define pow4(x) (2 << (2*(x)-1))

#define MEGA(x) ((x) * 1000000)
#define KILO(x) ((x) *    1000)

#define ARRAY_SIZE(x)   (sizeof(x)/sizeof((x)[0]))
#define FIELD_SIZE(s,f) (sizeof((s *)0->f))
#define typeof_field(s, f) typeof((s *)0->f)

/* offsetof is defined in stddef.h */
#define container_of(item, type, member) \
		(((type) *)((char *)(item) - offsetof(type, member)))

#define ACCESS_ONCE(x)  (*(volatile typeof(x) *) &(x))
#define barrier() __asm__ __volatile__ ("":::"memory")

/* prefetch for reading */
#define prefetch(x)  __builtin_prefetch(x)

/* prefetch for writing */
#define prefetchw(x) __builtin_prefetch(x,1)

/* to use, call the defined function is a condition that should never be true.
 * If the call is optimized out, no warning will be omitted.
 * Otherwise, it will be unhappy with you.
 * BUGS: On avr-gcc 4.7.2 from MHV: Appears to produce the wrong line number in
 *       the warning message durring link time optimization when LTO is turned. If
 *       you also have optimization turned on for the normal compile steps, the
 *       warning will also be emitted there and will indicate the proper location.
 *
 * Notes: marking this as noinline is required. So is the barrier. My guess is
 *        that the "inlining" discards the warning message.
 */
#define DEFINE_COMPILETIME_WARNING(name, msg) __attribute__((warning("\n"__FILE__ ":" msg),noinline)) static void name(void) { barrier(); }
#define DEFINE_COMPILETIME_ERROR(name, msg) __attribute__((error("\n" __FILE__ ":" msg),noinline)) static void name(void) { barrier(); }

#ifndef htonll
# ifdef _BIG_ENDIAN
#  define htonll(x)   (x)
#  define ntohll(x)   (x)
# else
#  define htonll(x)   ((((uint64_t)htonl(x)) << 32) + htonl(x >> 32))
#  define ntohll(x)   ((((uint64_t)ntohl(x)) << 32) + ntohl(x >> 32))
# endif
#endif

#define ABS(x) ((x) < 0?(-(x)) : (x))

#define MAX(x, y) ((x) > (y)?(x):(y))
#define MAX4(a, b, c, d) MAX(MAX(a,b),MAX(c,d))
#define MAX6(a,b,c,d,e,f) MAX(MAX4(a,b,c,d),MAX(e,f))
#define MAX8(a,b,c,d,e,f,g,h) MAX(MAX4(a,b,c,d),MAX4(e,f,g,h))

#define MIN(x,y) ((x) < (y)?(x):(y))
#define MIN4(a, b, c, d) MIN(MIN(a,b),MIN(c,d))
#define MIN6(a,b,c,d,e,f) MIN(MIN4(a,b,c,d),MIN(e,f))
#define MIN8(a,b,c,d,e,f,g,h) MIN(MIN4(a,b,c,d),MIN4(e,f,g,h))

#define EXPORT(sym) __attribute__((externally_visible)) sym
#define expect_eq(x, y) __builtin_expect(x, y)
#define likely(x)   __builtin_expect(!!(x),1)
#define unlikely(x) __builtin_expect(x,0)
#define must_check  __attribute__((warn_unused_result))
#define unused      __attribute__((unused))
#define noreturn    __attribute__((__noreturn__))

#define CAT2(a, b) a##b
#define CAT3(a, b, c) a##b##c

#endif
