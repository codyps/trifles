#ifndef PENNY_TEST_H_
#define PENNY_TEST_H_

#include <stdlib.h>

# if TEST
#  ifndef TEST_FILE
#   define TEST_FILE stderr
#  endif
static unsigned long test__error_ct = 0;
#  define test_eq_xp(a, b) test_eq_fmt_exp((a), (b), LLU_FMT, LLU_PAIR_EXP, LLU_EQ)
#  define test_eq_x(a, b) test_eq_fmt_exp((a), (b), "0x%llx", LLU, EQ)
#  define test_eq_fmt(a, b, fmt) test_eq_fmt_exp(a, b, fmt, UNIT, EQ)
#  define test_eq_fmt_exp(a, b, fmt, exp, eq) do {			\
	typeof(a) __test_eq_a = (a);						\
	typeof(b) __test_eq_b = (b);						\
	if (!eq((__test_eq_a), (__test_eq_b))) {				\
		fprintf(TEST_FILE, "TEST FAILURE: %s ("fmt") != %s ("fmt")\n",	\
				#a, exp(__test_eq_a), #b, exp(__test_eq_b));	\
		test__error_ct ++;						\
	}									\
} while(0)
#  define test_done() do {							\
	if (test__error_ct > 0)	{						\
		fprintf(TEST_FILE, "TESTS FAILED: %lu, exiting\n", test__error_ct);	\
		exit(1);							\
	}									\
} while(0)
# else /* if !TEST */
#  define test_eq_x(a, b) BUILD_BUG_ON_INVALID((a) == (b))
#  define test_eq_fmt(a, a_fmt, b, b_fmt) do {	\
	BUILD_BUG_ON_INVALID((a) == (b));	\
	printf_check_fmt(a_fmt b_fmt, a, b);	\
} while(0)
#  define test(x) BUILD_BUG_ON_INVALID(e)
#  define test_done() do {} while(0)
# endif /* !TEST */

#endif
