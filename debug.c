#include <penny/debug.h>
#include <stdarg.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

#define DEBUG_NEED_INIT INT_MIN
static int debug = DEBUG_NEED_INIT;

bool debug_is(int lvl)
{
	return lvl <= debug_level();
}

int debug_level(void)
{
	if (debug != DEBUG_NEED_INIT)
		return debug;
	char *c = getenv("DEBUG");
	if (!c) {
		debug = 0;
		return 0;
	}

	debug = atoi(c);
	return debug;
}

void pr_debug(int level, char const *fmt, ...)
{
	if (!debug_is(level))
		return;

	va_list va;
	va_start(va, fmt);
	vfprintf(stderr, fmt, va);
	va_end(va);
	putc('\n', stderr);
}
