#ifndef PENNY_TEST_H_
#define PENNY_TEST_H_

#include <stdlib.h>

#ifndef TEST_FILE
# define TEST_FILE stderr
#endif
static unsigned long test__error_ct = 0;

#define ok_(a, file, line, fmt, ...) do {							 \
	if (!(a)) {										 \
		fprintf(TEST_FILE, "[x] Failure at " file ":" #line" - " fmt "\n", ## __VA_ARGS__); \
		test__error_ct++;							\
	}										\
} while (0)
#define ok(a, ...) ok_(a, __FILE__, __LINE__, __VA_ARGS__)
#define ok1(a) ok(a, #a)

#define exit_status() test__error_ct


/* Extentions */
#define test_eq_x(a, b) ok((a) == (b), "%llu != %llu", (long long unsigned)a, (long long unsigned)b)
#define test_eq_xp(_a, _b) ok((_a).a == (_b).a && (_a).b == (_b).a, "%llu, %llu != %llu, %llu", \
		(_a).a, (_a).b, (_b).a, (_b).b)

#define test_done() do {						\
	if (test__error_ct > 0) {					\
		fprintf(TEST_FILE, "[!] Failed %lu times, exiting\n", test__error_ct);	\
		exit(exit_status());					\
	}								\
} while (0)

#endif
