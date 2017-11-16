#include "linkedList.h"

#define LOWEST_PRIORITY 100 //the lowest possible task priority (idle task)

//extern declaratoins for things defined in yakc.c
extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;
extern unsigned int YKTickNum;
extern unsigned int running_flag;
extern TCBptr lastRunningTask;

/*
typedef struct {
	int value;
	//void* addrWaitingOnSem;
}YKSEM;
*/

void YKIdleTask(); //function prototype for idle task
static int IdleStk[IDLE_TASK_STACK_SIZE]; //idle task stack

//prototypes of all kernel functions
void YKInitialize(void);

void YKEnterMutex(void); //written in assembly

void YKExitMutex(void); //written in assembly

void YKIdleTask(void);

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority);

void YKRun(void);

void YKDelayTask(unsigned count);

void YKEnterISR(void);

void YKExitISR(void);

void YKScheduler(void);

void YKDispatcher(void); //written in assembly

void YKFirstDispatcher(void); //written in assembly

void YKTickHandler(void);

YKSEM* YKSemCreate(int initialValue);

void YKSemPend(YKSEM *semaphore);

void YKSemPost(YKSEM *semaphore);

YKQ* YKQCreate(void **start, unsigned size);

void *YKQPend(YKQ *queue);

int YKQPost(YKQ *queue, void *msg);
