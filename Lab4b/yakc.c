#include "yakk.h"


int YKIdleCount = 0;
int running_flag = 0; //0 means not running, 1 means running
unsigned ISRCallDepth = 0;

void YKInitialize(void)
{
		//DO I NEED TO TURN OFF INTERRUPTS?
	//initialize delayTimes.
	int i;
	for (i = 0; i < MAX_NUM_TASKS; i++ )
	{
		delayTimes[i] = 0;
	}
	//create YKIdleTask
		//allocate stack space
	YKNewTask(IdleTask, (void *) &IdleStk(IDLE_TASK_STACK_SIZE), LOWEST_PRIORITY);
}

void YKIdleTask(void)
{
	while(1)
	{
		YKIdleCount++
	}
	//should take 4 instructions. //NEED TO VERIFY
}

//ARE THESE THE VALUES WE WANT?
context_type initContext = {
	sp = 0;
	ip = 0;
	state = ready;
	ax = 0;
	bx = 0;
	cx = 0;
	dx = 0;
	si = 0;
	di = 0;
	bp = 0;
	es = 0;
	ds = 0;
	IF = 1;
}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority)
{
	//register task
		//create TCB
		//init TCB values, including registers, interrupt flag should be 1
		//add to linked list
	//if YKRun has been called, call the scheduler

	TCBptr newTCB = createTCB(taskStack, priority, initContext);
	insertTCBIntoRdyList(newTCB); //do we start all tasks as ready?? //TODO
	printTCBs(); //test
	printLists(); //test
	if (running_flag)
	{
		YKScheduler();
	}
}

void YKRun(void)
{
	//set the running flag
	//run scheduler
	running_flag = 1;
	//ENABLE INTERRUPTS?
	YKScheduler();
}

void YKDelayTask(unsigned count)
{
	//if count == 0, return
	//set task state to blocked
	//set global variable to count
	//call scheduler
	if (count == 0)
		return;


}

void YKEnterISR(void)
{
	ISRCallDepth++
}

YKExitISR(void)
{
	ISRCallDepth--
	if (ISRCallDepth == 0)
		YKScheduler();
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
