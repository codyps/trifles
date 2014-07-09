#ifndef PENNY_TEST_H_
#define PENNY_TEST_H_

#include <stdlib.h>

#ifndef TEST_FILE
# define TEST_FILE stderr
#endif
static unsigned long test__error_ct = 0;

#define ok_(a, file, line, ...) do {							\
	if (!(a)) {									\
		fprintf(TEST_FILE, "[x] Failure at " file ":" #line" - " __VA_ARGS__);	\
		test__error_ct++;							\
	}										\
} while (0)
#define ok(a, ...) ok_(a, __FILE__, __LINE__, __VA_ARGS__)
#define ok1(a) ok(a, #a)

#define exit_status() test__error_ct


#endif
