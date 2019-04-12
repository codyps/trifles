#include "threads.h"
#include <stdlib.h>
#include <stdint.h>

struct thrd_pthread_func_stub_ctx {
	thrd_start_t func;
	void *arg;
};

static void *thrd_pthread_func_stub(void *arg)
{
	struct thrd_pthread_func_stub_ctx *ctx = arg;
	struct thrd_pthread_func_stub_ctx lctx = *ctx;
	free(ctx);
	return (void *)(uintptr_t)lctx.func(lctx.arg);
}

int thrd_create(thrd_t *thr, thrd_start_t func, void *arg)
{
	struct thrd_pthread_func_stub_ctx *ctx = malloc(sizeof(*ctx));
	if (!ctx)
		return thrd_nomem;

	*ctx = (struct thrd_pthread_func_stub_ctx){
		.func = func,
		.arg = arg,
	};

	int r = pthread_create(&thr->it, NULL, thrd_pthread_func_stub, ctx);
	if (r < 0)
		return thrd_error;

	return thrd_success;
}

int thrd_join(thrd_t thr, int *res)
{
	void *res_v;
	int r = pthread_join(thr.it, &res_v);
	if (r < 0)
		return thrd_error;

	*res = (int)(uintptr_t)res_v;
	return thrd_success;
}
