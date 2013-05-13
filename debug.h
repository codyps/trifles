#ifndef PENNY_DEBUG_H_
#define PENNY_DEBUG_H_

#include <stdbool.h>
#include <ccan/compiler/compiler.h>

#ifdef NDEBUG
static inline bool debug_is(UNUSED int lvl) { return false; }
static inline int debug_level(void) { return 0; }
#else
bool debug_is(int lvl);
int debug_level(void);
void pr_debug(int level, char const *fmt, ...);
#endif

#endif
