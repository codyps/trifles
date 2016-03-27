#pragma once
#ifndef SHARED_CPP_EMBOS_FOR_POSIX_RTOS_H_
#define SHARED_CPP_EMBOS_FOR_POSIX_RTOS_H_

#include <pthread.h>

/* If needed, sem_t can be replaced by pthread_mutex_t and an int */
#include <semaphore.h>

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif


/* config { */

#define RTOS_BITS 32
#define RTOS_XR 0

/* } */

#define DEFINE_OS_UINT__(bits) typedef uint##bits##_t OS_UINT;
#define DEFINE_OS_UINT_(bits) DEFINE_OS_UINT__(bits)
DEFINE_OS_UINT_(RTOS_BITS);

typedef uint8_t OS_U8;
typedef uint16_t OS_U16;
typedef uint32_t OS_STACKPTR;
typedef uint32_t U32;
typedef uint32_t OS_U32;
typedef int32_t OS_I32;

/*
 * Task Managment {
 */
typedef struct OS_TASK_s {
	pthread_t thread;
} OS_TASK;

#if !RTOS_XR
typedef struct OS_EXTEND_TASK_CONTEXT_s {
	void (*save)(void *stack);
	void (*restore)(void *stack);
} OS_EXTEND_TASK_CONTEXT;
#endif

typedef int OS_TASKID;

/* used to annotate stack arrays. We may want to have this provide alignment garuntees */
#define OS_STACKPTR

/* void OS_CREATETASK(OS_TASK *task, char *name, void *routine, unsigned char prio, void *stack); */
/* PITFALL: OS_CREATETASK() and OS_CreateTask() reorder @func and @prio */
/* FIXME: time_slice needs a real value */
#define OS_CREATETASK(__task, __name, __func, __prio, __stack)	\
	OS_CreateTask(__task, __name, __prio, __func, __stack, sizeof(__stack), 0)

void OS_CreateTask(OS_TASK *task, char *name, unsigned char prio, void *func,
		void *stack, unsigned stack_size, unsigned char time_slice);

/* void OS_CREATETASK_EX(OS_TASK *task, char *name, void *func, unsigned char prio, void *stack, void *ctx) */
/* PITFALL: OS_CREATETASK_EX() and OS_CreateTaskEx() reorder @func and @prio */
/* FIXME: time_slice needs a real value */
#define OS_CREATETASK_EX(__task, __name, __func, __prio, __stack, __ctx)	\
	OS_CreateTaskEx(__task, __name, __prio, __func, __stack, sizeof(__stack), 0, __ctx)

void OS_CreateTaskEx(OS_TASK *task, char *name, unsigned char prio, void *func,
		void *stack, unsigned stack_size, unsigned char time_slice, void *ctx);

void OS_Delay(int ms);

void OS_DelayUntil(int time);

#if !RTOS_XR
void OS_ExtendTaskContext(const OS_EXTEND_TASK_CONTEXT *extend_ctx);
#endif

OS_TASK *OS_GetpCurrentTask(void);

/* !not-allowed-in-isr */
unsigned char OS_GetPriority(OS_TASK *task);

unsigned char OS_GetSuspendCnt(OS_TASK *task);

OS_TASKID OS_GetTaskID(void);

char OS_IsTask(OS_TASK *task);

void OS_Resume(OS_TASK *task);

void OS_SetPriority(OS_TASK *task, unsigned char prio);

void OS_SetTaskName(OS_TASK *task, const char *s);

void OS_SetTimeSlice(OS_TASK *task, unsigned char time_slice);

void OS_Suspend(OS_TASK *task);

void OS_Terminate(OS_TASK *task);

void OS_WakeTask(OS_TASK *task);

void OS_Yield(void);

/*
 * } // Task Managment
 */

/*
 * Software Timers {
 */

typedef struct OS_TIMER_s OS_TIMER;
typedef int OS_TIME;
typedef void OS_TIMERROUTINE(void);

/* void OS_CREATETIMER(OS_TIMER *timer, OS_TIMERROUTINE *callback, OS_TIME timeout); */
#define OS_CREATETIMER(__timer, __callback, __timeout) do {	\
	OS_CreateTimer(__timer, __callback, __timeout);		\
	OS_StartTimer(__timer);					\
} while (0)

void OS_CreateTimer(OS_TIMER *timer, OS_TIMERROUTINE *callback, OS_TIME time);
void OS_StartTimer(OS_TIMER *timer);
void OS_StopTimer(OS_TIMER *timer);
void OS_RetriggerTimer(OS_TIMER *timer);
void OS_SetTImerPeriod(OS_TIMER *timer, OS_TIME period);
void OS_DeleteTimer(OS_TIMER *timer);
OS_TIME OS_GetTimerPeriod(OS_TIMER *timer);
OS_TIME OS_GetTimerValue(OS_TIMER *timer);
unsigned char OS_GetTimerStatus(OS_TIMER *timer);
OS_TIMER *OS_GetpCurrentTimer(void);

/* void OS_CREATETIMER_EX(OS_TIMER_EX *timer_ex, OS_TIMER_EX_ROUTINE *cb, OS_TIME timeout, void *data); */
#define OS_CREATETIMER_EX(__timer, __callback, __timeout, __data) do {	\
	OS_CreateTimerEx(__timer, __callback, __timeout, __data);	\
	OS_StartTimerEx(__timer);					\
} while (0)

typedef struct OS_TIMER_EX_s OS_TIMER_EX;
typedef void OS_TIMER_EX_ROUTINE(void *data);

void OS_CreateTimerEx(OS_TIMER_EX *timer, OS_TIMER_EX_ROUTINE *cb, OS_TIME timeout, void *data);
void OS_StartTimerEx(OS_TIMER_EX *timer);
void OS_StopTimerEx(OS_TIMER_EX *timer);
void OS_RetriggerTimerEx(OS_TIMER_EX *timer);
void OS_SetTImerPeriodEx(OS_TIMER_EX *timer, OS_TIME period);
void OS_DeleteTimerEx(OS_TIMER_EX *timer);
OS_TIME OS_GetTimerPeriodEx(OS_TIMER_EX *timer);
OS_TIME OS_GetTImerValueEx(OS_TIMER_EX *timer);
unsigned char OS_GetTimerStatusEx(OS_TIMER_EX *timer);
OS_TIMER_EX *OS_GetpCurrentTimerEx(void);

/*
 * } // Software Timers
 */

/*
 * Resource semaphores {
 */

typedef struct OS_RSEMA_s {
	sem_t sem;
} OS_RSEMA;

/* void OS_CREATERSEMA(OS_RSEMA *rsema); */
#define OS_CREATERSEMA(rsema) assert(0)
int OS_Use(OS_RSEMA *sema);
void OS_Unuse(OS_RSEMA *sema);
char OS_Request(OS_RSEMA *sema);
int OS_GetSemaValue(OS_RSEMA *sema);
OS_TASK *OS_GetResourceOwner(OS_RSEMA *sema);
void OS_DEleteRSema(OS_RSEMA *sema);

/*
 * } // Resource semaphores
 */

/*
 * Counting Semaphores (6) {
 */

typedef struct OS_CSEMA_s {
	sem_t sem;
} OS_CSEMA;

typedef struct OS_CSEMA_s OS_SEMA;

/* void OS_CREATECSEMA(OS_CSEMA *csema) */
#define OS_CREATECSEMA(csema) assert(0)

void OS_CreateCSema(OS_CSEMA *sema, OS_UINT init_val);
void OS_SignalCSema(OS_CSEMA *sema);
void OS_SignalCSemaMax(OS_CSEMA *sema, OS_UINT max_value);
void OS_WaitCSema(OS_CSEMA *sema);
int OS_WaitCSemaTimed(OS_CSEMA *sema, OS_TIME timeout);
char OS_CSemaRequest(OS_CSEMA *sema);
int OS_GetCSemaValue(OS_SEMA *sema); /* doc-error: OS_CSEMA? */
OS_U8 OS_SetCSemaValue(OS_SEMA *sema, OS_UINT value); /* doc-error: OS_CSEMA? */
void OS_DeleteCSema(OS_CSEMA *sema);

/*
 * } // Counting Semaphores (6)
 */

/*
 * Mailboxes (7) {
 */
typedef struct OS_MAILBOX_s {
	char foo;
} OS_MAILBOX;

void OS_CREATEMB(OS_MAILBOX *mb, unsigned char msg_sz, unsigned int msg_ct, void *buf);
void OS_PutMail(OS_MAILBOX *mb, void *msg);
void OS_PutMail1(OS_MAILBOX *mb, const char *msg);
void OS_PutMailCond(OS_MAILBOX *mb, void *msg);
void OS_PutMailCond1(OS_MAILBOX *mb, const char *msg);
void OS_PutMailFront(OS_MAILBOX *mb, void *msg);
void OS_PutMailFront1(OS_MAILBOX *mb, const char *msg);
void OS_PutMailFrontCond(OS_MAILBOX *mb, void *msg);
void OS_PutMailFrontCond1(OS_MAILBOX *mb, const char *msg);
void OS_GetMail(OS_MAILBOX *mb, void *dst);
void OS_GetMail1(OS_MAILBOX *mb, char *dst);
char OS_GetMailCond(OS_MAILBOX *mb, void *dst);
char OS_GetMailCond1(OS_MAILBOX *mb, char *dst);
char OS_GetMailTimed(OS_MAILBOX *mb, void *dst, OS_TIME timeout);
void OS_WaitMail(OS_MAILBOX *mb);
void OS_ClearMB(OS_MAILBOX *mb);
unsigned int OS_GetMessageCnt(OS_MAILBOX *mb);
void OS_DeleteMB(OS_MAILBOX *mb);

/*
 * } // Mailboxes (7)
 */

/*
 * Queues (8) {
 */

typedef struct OS_Q_s {
	int foo;
} OS_Q;

void OS_Q_Create(OS_Q *q, void *data, OS_UINT size);
int OS_Q_Put(OS_Q *q, const void *src, OS_UINT sz);
int OS_Q_GetPtr(OS_Q *q, void **p);
int OS_Q_GetPtrCond(OS_Q *q, void **p);
int OS_Q_GetPtrTimed(OS_Q *q, void **p, OS_TIME timeout);
void OS_Q_Purge(OS_Q *q);
void OS_Q_Clear(OS_Q *q);
int OS_Q_GetMessageCnt(OS_Q *q);

/*
 * } // Queues (8)
 */

/*
 * Task Events (9) {
 */
char OS_WaitEvent(char event_mask);
char OS_WaitSingleEvent(char event);
char OS_WaitEventTimed(char event_mask, OS_TIME timeout);
char OS_WaitSingleEventTimed(char event_mask, OS_TIME timeout);
void OS_SignalEvent(char event, OS_TASK *task);
char OS_GetEventsOccured(OS_TASK *task);
char OS_ClearEvents(OS_TASK *task);

/*
 * } // Task Events (9)
 */

/*
 * Event Objects (10) {
 */
typedef struct OS_EVENT_s {
	char foo;
} OS_EVENT;

void OS_EVENT_Create(OS_EVENT *event);
void OS_EVENT_Wait(OS_EVENT *event);
char OS_EVENT_WaitTimed(OS_EVENT *event, OS_TIME timeout);
void OS_EVENT_Set(OS_EVENT *event);
void OS_EVENT_Reset(OS_EVENT *event);
void OS_EVENT_Pulse(OS_EVENT *event);
unsigned char OS_EVENT_Get(OS_EVENT *event);
void OS_EVENT_Delete(OS_EVENT *event);

/*
 * } // Event Objects (10)
 */

/*
 * Heap type memory management (11) {
 */

/* ??? */

/*
 * } // Heap type memory management (11)
 */

/*
 * Fixed block size memory pools (12) {
 */
typedef struct OS_MEMF_s {
	char foo;
} OS_MEMF;

void OS_MEMF_Create(OS_MEMF *m, void *pool, OS_U16 block_cnt, OS_U16 block_sz);
void OS_MEMF_Delete(OS_MEMF *m);
void *OS_MEMF_Alloc(OS_MEMF *m, int purpose);
void *OS_MEMF_AllocTimed(OS_MEMF *m, int timeout, int purpose);
void *OS_MEMF_Request(OS_MEMF *m, int purpose);
void OS_MEMF_Release(OS_MEMF *m, void *mem_block);
void OS_MEMF_FreeBlock(void *mem_block);
int OS_MEMF_GetNumBlocks(OS_MEMF *m);
int OS_MEMF_GetBlockSize(OS_MEMF *m);
int OS_MEMF_GetNumFreeBlocks(OS_MEMF *m);
int OS_MEMF_GetMaxUsed(OS_MEMF *m);
char OS_MEMF_IsInPool(OS_MEMF *m, void *mem_block);

/*
 * } // Fixed block size memory pools (12)
 */

/*
 * Stacks (13) {
 */
#if RTOS_IS_DEBUG || RTOS_IS_STACK_CHECK
OS_STACKPTR *OS_GetStackBase(OS_TASK *task);
int OS_GetStackSize(OS_TASK *task);
#endif

int OS_GetStackSpace(OS_TASK *task);
int OS_GetStackUsed(OS_TASK *task);

/*
 * } // Stacks (13)
 */

/*
 * Interrupts (14) {
 */
void OS_CallISR(void (*routine)(void));
void OS_CallNestableISR(void (*func)(void));
void OS_EnterInterrupt(void);
void OS_LeaveInterrupt(void);
void OS_LeaveInterruptNoSwitch(void);
#define OS_IncDI() os_incdi
#define OS_DecRI() os_decri
#define OS_DI() os_di
#define OS_EI() os_ei
#define OS_RestoreI() os_restorei
void OS_EnterNestableInterrupt(void);
void OS_LeaveNestableInterrupt(void);
void OS_LeaveNestableInterruptNoSwitch(void);

/*
 * } // Interrupts (14)
 */

/*
 * Critical Regions (15) {
 */
void OS_EnterRegion(void);
void OS_LeaveRegion(void);
/*
 * } // Critical Regions (15)
 */

/*
 * Time Measurment (16) {
 */
int OS_GetTime(void);
U32 OS_GetTime32(void);

typedef struct OS_TIMING_s {
	char foo;
} OS_TIMING;

void OS_Timing_Start(OS_TIMING *cycle);
void OS_Timing_End(OS_TIMING *cycle);
OS_U32 OS_Timing_Getus(OS_TIMING *cycle);
OS_U32 OS_Timing_GetCycles(OS_TIMING *cycle);
/*
 * } // Time Measurment (16)
 */

/*
 * Time Variables (17) {
 */
extern volatile OS_I32 OS_Time;
extern volatile OS_I32 OS_TimeDex; /* IUO */
/*
 * } // Time Variables (17)
 */

/*
 * System tick (18) {
 */
extern OS_U32 OS_IntMSInc;
void OS_HandleTick(void);
void OS_HandleTick_Ex(void);

typedef struct OS_TICK_HOOK_s {
	char foo;
} OS_TICK_HOOK;

typedef void OS_TICK_HOOK_ROUTINE(void);

void OS_AddTickHook(OS_TICK_HOOK *hook, OS_TICK_HOOK_ROUTINE *func);
void OS_RemoveTickHook(OS_TICK_HOOK *hook);
/*
 * } // System tick (18)
 */

/*
 * Configuration of taget system (BSP) (19) {
 */
void OS_InitHW(void);
void OS_Idle(void);
void OS_GetTime_Cycles(void);
void OS_CovertCycles2us(void);
void OS_ISR_Tick(void);

#if RTOS_HAVE_EMBOSVIEW
void OS_COM_Init(void);
void OS_ISR_rx(void);
void OS_ISR_tx(void);
void OS_COM_Send1(void);
#endif

//#define OS_FSYS
//#define OS_UART
//#define OS_BAUDRATE

/*
 * } BSP (19)
 */

/*
 * System Variables (20.3) {
 */
extern OS_U32 OS_VERSION;
extern OS_U32 CPU;
/* OS_Time */
extern OS_U32 OS_NUM_TASKS;
extern OS_U32 OS_Status;

/* SP, D, DP, DT */
extern OS_U32 OS_pActiveTask;
extern OS_U32 OS_pCurrentTask;
/* SP, DP, DT */
extern OS_U32 SysStack;
extern OS_U32 IntStack;

#if RTOS_HAVE_TRACE
extern OS_U32 TraceBuffer;
#endif

/*
 * }
 */

/*
 * Shared SIO (20.4) {
 */

/*
 * }
 */

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif
