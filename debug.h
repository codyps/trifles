#ifndef PENNY_DEBUG_H_
#define PENNY_DEBUG_H_

#include <stdbool.h>
#include <ccan/compiler/compiler.h>

#ifdef NDEBUG
static PRINTF_FMT(2,3) inline void pr_debug(int level, char const *fmt, ...);
static inline bool debug_is(UNUSED int lvl) { return false; }
static inline int debug_level(void) { return 0; }
#else
void PRINTF_FMT(2,3) pr_debug(int level, char const *fmt, ...);
bool debug_is(int lvl);
int debug_level(void);
#endif

#endif
