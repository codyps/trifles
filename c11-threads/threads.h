#pragma once
#include <pthread.h>

typedef struct thrd_s {
	pthread_t it;
} thrd_t;

typedef int (*thrd_start_t)(void *);

enum thrd_return {
	thrd_success = 0,
	thrd_error = -1,
	thrd_nomem = -2,
};

int thrd_create(thrd_t *thr, thrd_start_t func, void *arg);
int thrd_join(thrd_t thr, int *res);
