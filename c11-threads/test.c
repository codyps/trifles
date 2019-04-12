#include <threads.h>
#include <ccan/tap/tap.h>


struct ctx {
	int v1;
	int v2;
};

static
int
ret_1(void *n)
{
	struct ctx *c = n;
	return c->v1;
}

static
int
ret_2(void *n)
{
	struct ctx *c = n;
	return c->v2;
}

int
main(void)
{
	plan_tests(6);


	struct ctx ctx = {
		.v1 = 1,
		.v2 = 2,
	};

	thrd_t r1, r2;

	ok1(thrd_success == thrd_create(&r1, ret_1, &ctx));
	ok1(thrd_success == thrd_create(&r2, ret_2, &ctx));

	int rr1, rr2;
	if (ok1(thrd_success == thrd_join(r2, &rr2))) {
		ok1(rr2 == 2);
	} else {
		skip(1, "join r2 failed");
	}

	if (ok1(thrd_success == thrd_join(r1, &rr1))) {
		ok1(rr1 == 1);
	} else {
		skip(1, "join r1 failed");
	}


	return exit_status();
}
