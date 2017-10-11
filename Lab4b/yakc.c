#include "yakk.h"



int YKIdleCount = 0;


void YKInitialize(void)
{
	//create YKIdleTask
		//allocate stack space
	YKNewTask(IdleTask, (void *) &IdleStk(IDLE_TASK_STACK_SIZE), LOWEST_PRIORITY);
}

YKIdleTask(void)
{
	while(1)
	{
		YKIdleCount++
	}
	//should take 4 instructions. //NEED TO VERIFY
}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority)
{
	//register task
		//create TCB
		//init TCB values, including registers, interrupt flag should be 1
		//add to linked list
}

void YKRun(void)
{
	//run scheduler
}

void YKDelayTask(unsigned count)
{
	//if count == 0, return
	//set task state to blocked
	//set global variable to count
	//call scheduler
}

void YKEnterISR(void)
{
	//ISRCallDepth++
}

YKExitISR(void)
{
	//ISRCallDepth--
	//if ISRCallDepth == 0
		//call scheduler
}

YKScheduler(void)
{
	//determine highest priority task
	//if highest priority task != lastRunTask
		//call dispatcher
}

void YKTickHandler(void
{
	//decrement all tick count globals
	//for all that are 0
		//set that task's state to ready in its TCB
	//++YKTickNum
	//call user tick handler if exists
}
