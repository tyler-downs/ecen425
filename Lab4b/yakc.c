#include "yakk.h"
#include "clib.h"

unsigned int YKIdleCount = 0;
static int running_flag = 0; //0 means not running, 1 means running
unsigned int ISRCallDepth = 0;
TCBptr lastRunTask = NULL;
unsigned int YKCtxSwCount = 0;
unsigned int YKTickNum = 0;
unsigned int firstTime = 1;


//ARE THESE THE VALUES WE WANT?
struct context_type initContext = {
	0, //sp //this should be the bottom of the task's stack
	0, //ip //this should be the function pointer value
	//	ready, //ready
	0, //ax
	0, //bx
	0, //cx
	0, //dx
	0, //si
	0, //di
	0, //bp //this should also be the stack
	0, //es
	0, //ds
	0, //cs
	0x0200 //flags
};

void YKInitialize(void)
{
		//DO I NEED TO TURN OFF INTERRUPTS?
	//create YKIdleTask
		//allocate stack space
	YKNewTask(YKIdleTask, (void *) &IdleStk[IDLE_TASK_STACK_SIZE], LOWEST_PRIORITY);
	//set lastRunTask to idle task (the only thing on ready list)
	lastRunTask = YKRdyList;
}

void YKIdleTask(void)
{
	while(1)
	{
		int tmp;
		tmp = YKIdleCount + 1;
		YKIdleCount = tmp;
	}
	//should take 4 instructions. //NEED TO VERIFY
}


void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority)
{
	//register task
		//create TCB
		//init TCB values, including registers, interrupt flag should be 1
		//add to linked list
	//if YKRun has been called, call the scheduler

	TCBptr newTCB;
	newTCB = createTCB(taskStack, priority, initContext);
	//now change the context parts that need changing
	newTCB->context.sp = (int)(taskStack);
	newTCB->context.ip = (int)task;
	newTCB->context.bp = (int)taskStack;
	insertTCBIntoRdyList(newTCB); //do we start all tasks as ready?? //TODO
	//printString("Starting new task.\n\r");
	//printTCBs(); //test
	//printLists(); //test
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
	//printString("Running!!\n");
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
	//grab the running task at the top of the ready list
	//YKRdyList.state = suspended;
	YKRdyList->delay = count;
	removeFirstTCBFromRdyList(); //move to suspended list
	YKScheduler();
}

void YKEnterISR(void)
{
	ISRCallDepth++;
}

void YKExitISR(void)
{
	ISRCallDepth--;
	if (ISRCallDepth == 0)
		YKScheduler();
}

void YKScheduler(void)
{
	//determine highest priority task
	//if highest priority task != lastRunTask
		//call dispatcher
	if (lastRunTask != YKRdyList || firstTime) //if the task has changed
	{
		firstTime = 0;
		//lastRunTask = YKRdyList; //do this inside dispatcher
		//printString("Calling the dispatcher\n");
		YKCtxSwCount++;
		YKDispatcher(); //call the dispatcher.
	}

}

void YKTickHandler(void)
{
	//decrement all tick count globals
	//for all that are 0
		//set that task's state to ready in its TCB
	//++YKTickNum
	//call user tick handler if exists

	TCBptr tmp;
	TCBptr tmp2;
	tmp  = YKSuspList;
	 while(tmp != NULL)
	 {
			if (tmp->delay > 0)
			{
				tmp->delay--;
				if (tmp->delay == 0)
				{
					tmp2 = tmp;
					tmp = tmp->next;
					moveTCBToRdyList(tmp2); //moving lists changes state
				}
				else
					tmp = tmp->next;
			}
			else
				tmp = tmp->next;
	 }
	YKTickNum++;
	//call user tick handler if exists
}
