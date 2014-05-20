
#include <stdio.h>

#define __stringify_1(x) #x
#define __stringify(x) __stringify_1(x)

/* Need to setup all macros that contain others here */
#define A_(m, ...) __##m(__VA_ARGS__)
#define BASE(b_name, b_value, entries) BASE_(A_, b_name, b_value, entries)

/* Override the <macro>_ version instead */
#define BASE_(A, b_name, b_value, entries)	\
entries
#define __entry(e_name, e_value) \
	printf(__stringify(b_name) " " __stringify(b_value) ":" #e_name " " #e_value "\n") ;


#define __TEST(x, y) #x #y
#define U(x) x
#define O(A, ...) __VA_ARGS__

#define CC ##


int main(void)
{
	#include "magic-def.h"
	puts(A_(TEST, foo, bar));
	puts(U(A_(TEST, foo, bar)));
	put CC s("HA");
	return 0;
}
