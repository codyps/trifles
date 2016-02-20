#include "RTOS.h"

#include <pthread.h>
#include <assert.h>

#include <time.h> /* nanosleep */

void OS_CreateTask(OS_TASK *task, char *name, unsigned char prio, void *func,
		void *stack, unsigned stack_size, unsigned char time_slice)
{
	(void)name;
	(void)prio;
	(void)stack;
	(void)stack_size;
	(void)time_slice;
	pthread_create(&task->thread, NULL, func, NULL);
}

void OS_CreateTaskEx(OS_TASK *task, char *name, unsigned char prio, void *func,
		void *stack, unsigned stack_size, unsigned char time_slice, void *ctx)
{
	(void)name;
	(void)prio;
	(void)stack;
	(void)stack_size;
	(void)time_slice;
	pthread_create(&task->thread, NULL, func, ctx);
}

void OS_Delay(int ms)
{
	struct timespec ts;
	ts.tv_sec = ms / 1000;
	ts.tv_nsec = (ms % 1000) * 1000;
	while (ts.tv_sec || ts.tv_nsec)
		nanosleep(&ts, &ts);
}

void OS_DelayUntil(int t)
{
	int c = OS_Time();
	if (RTOS_BITS == 32) {
		assert(1 <= (t - c) && (t - c) <= 0x7FFFFFFF);
	} else { /* RTOS_BITS == 8 or 16 */
		assert(1 <= (t - c) && (t - c) <= 0x7FFF);
	}
}
