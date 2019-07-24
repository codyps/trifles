#include <threads.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdio.h>

struct mbox_int {
	mtx_t m;
	cnd_t c;
	bool have_v;
	int v;
};

int
mbox_get(struct mbox_int *mbx, int *v)
{
	int r = mtx_lock(&mbx->m);
	if (r != thrd_success)
		abort();

	while (!mbx->have_v) {
		r = cnd_wait(&mbx->c, &mbx->m);
		if (r != thrd_success)
			abort();
	}

	*v = mbx->v;
	mbx->have_v = false;

	r = mtx_unlock(&mbx->m);
	if (r != thrd_success)
		abort();

	return thrd_success;
}

int
mbox_put(struct mbox_int *mbx, int v)
{
	int r = mtx_lock(&mbx->m);
	if (r != thrd_success)
		return r;

	mbx->v = v;
	mbx->have_v = true;
	cnd_signal(&mbx->c);

	r = mtx_unlock(&mbx->m);
	if (r != thrd_success)
		abort();

	return thrd_success;
}

int mbox_init(struct mbox_int *mbx)
{
	*mbx = (struct mbox_int){
		.v = 0,
	};
	int r = mtx_init(&mbx->m, mtx_plain);
	if (r != thrd_success)
		return r;
	r = cnd_init(&mbx->c);
	if (r != thrd_success) {
		mtx_destroy(&mbx->m);
		return r;
	}
	return thrd_success;
}

int
produce_thrd(void *arg)
{
	struct mbox_int *x = arg;
	int i = 0;
	for (;;) {
		struct timespec ts = {
			.tv_sec = 1,
		};
		// note: sleep time is not exact due to our handling here.
		thrd_sleep(&ts, NULL);

		mbox_put(x, i);
		i++;
	}
}


int
consume_thrd(void *arg)
{
	struct mbox_int *x = arg;
	for (;;) {
		int v;
		int r = mbox_get(x, &v);
		if (r != thrd_success)
			abort();

		printf("got: %d\n", v);
	}
}

int main(void)
{
	thrd_t ct, pt;
	struct mbox_int mbx;
	mbox_init(&mbx);
	int r = thrd_create(&pt, produce_thrd, &mbx);
	if (r != thrd_success)
		abort();

	r = thrd_create(&ct, consume_thrd, &mbx);
	if (r != thrd_success)
		abort();

	thrd_join(ct, NULL);
	thrd_join(pt, NULL);
	return 0;
}
