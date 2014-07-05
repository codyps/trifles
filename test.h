#ifndef PENNY_TEST_H_
#define PENNY_TEST_H_

#include <stdlib.h>

# if TEST
#  ifndef TEST_FILE
#   define TEST_FILE stderr
#  endif
static unsigned long test__error_ct = 0;
#  define NUM_FMT "%#jx"
#  define NUM_EXP(a) ((uintmax_t)(a))
#  define NUM_EQ(a, b) ((uintmax_t)(a) == (uintmax_t)(b))
#  define ok_eq(a, b) test_eq_fmt_exp((a), (b), NUM_FMT, NUM_EXP, NUM_EQ)
#  define test_eq_xp(a, b) test_eq_fmt_exp((a), (b), LLU_FMT, LLU_PAIR_EXP, LLU_EQ)
#  define test_eq_x(a, b) test_eq_fmt_exp((a), (b), "0x%llx", LLU, EQ)
#  define test_eq_fmt(a, b, fmt) test_eq_fmt_exp(a, b, fmt, UNIT, EQ)
#  define test_eq_fmt_exp(a, b, fmt, exp, eq) do {			\
	typeof(a) __test_eq_a = (a);						\
	typeof(b) __test_eq_b = (b);						\
	if (!eq((__test_eq_a), (__test_eq_b))) {				\
		fprintf(TEST_FILE, "%s:%d - TEST FAILURE: %s ("fmt") != %s ("fmt")\n",	\
				__FILE__, __LINE__, #a, exp(__test_eq_a), #b, exp(__test_eq_b));	\
		test__error_ct ++;						\
	}									\
} while(0)
#  define ok1(a) do {						\
	if (!(a)) {						\
		fprintf(TEST_FILE, "%s:%d - TEST FAILURE: %s\n", __FILE__, __LINE__, #a);	\
		test__error_ct++;				\
	}							\
} while(0)

#  define test_done() do {							\
	if (test__error_ct > 0)	{						\
		fprintf(TEST_FILE, "TESTS FAILED: %lu, exiting\n", test__error_ct);	\
		exit(1);							\
	}									\
} while(0)
# else /* if !TEST */
#  define ok_eq(a, b) do {		\
	BUILD_BUG_ON_INVALID(a);	\
	BUILD_BUG_ON_INVALID(b);	\
} while (0)
#  define test_eq_x(a, b) BUILD_BUG_ON_INVALID((a) == (b))
#  define test_eq_fmt(a, a_fmt, b, b_fmt) do {	\
	BUILD_BUG_ON_INVALID((a) == (b));	\
	printf_check_fmt(a_fmt b_fmt, a, b);	\
} while(0)
#  define ok1(x) BUILD_BUG_ON_INVALID(e)
#  define test_done() do {} while(0)
# endif /* !TEST */

#endif
