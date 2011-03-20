#ifndef PENNY_PENNY_H_
#define PENNY_PENNY_H_

#include <stddef.h>

#define ARRAY_SIZE(x) (sizeof(x)/sizeof((x)[0]))

#define FIELD_SIZE(s,f) (sizeof((s *)0->f))

/* offsetof is defined in stddef.h */
#define container_of(item, type, member) \
		(((type) *)((item) - offsetof(type, member)))

#define barrier() __asm__ __volatile__ ("":::"memory")


#ifndef htonll
# ifdef _BIG_ENDIAN
#  define htonll(x)   (x)
#  define ntohll(x)   (x)
# else
#  define htonll(x)   ((((uint64_t)htonl(x)) << 32) + htonl(x >> 32))
#  define ntohll(x)   ((((uint64_t)ntohl(x)) << 32) + ntohl(x >> 32))
# endif
#endif

#define MAX(x, y) ((x) > (y)?(x):(y))
#define MAX4(a, b, c, d) MAX(MAX(a,b),MAX(c,d))
#define MAX6(a,b,c,d,e,f) MAX(MAX4(a,b,c,d),MAX(e,f))
#define MAX8(a,b,c,d,e,f,g,h) MAX(MAX4(a,b,c,d),MAX4(e,f,g,h))

#define MIN(x,y) ((x) < (y)?(x):(y))
#define MIN4(a, b, c, d) MIN(MIN(a,b),MIN(c,d))
#define MIN6(a,b,c,d,e,f) MIN(MIN4(a,b,c,d),MIN(e,f))
#define MIN8(a,b,c,d,e,f,g,h) MIN(MIN4(a,b,c,d),MIN4(e,f,g,h))

#define EXPORT(sym) __attribute__((externally_visible)) sym
#define likely(x)   __builtin_expect(x,1)
#define unlikely(x) __builtin_expect(x,0)
#define must_check  __attribute__((warn_unused_result))

#endif
