#include "yakk.h"
#include "clib.h"

unsigned int YKIdleCount = 0;
unsigned int running_flag = 0; //0 means not running, 1 means running
unsigned int ISRCallDepth = 0;
TCBptr lastRunTask = NULL;
unsigned int YKCtxSwCount = 0;
unsigned int YKTickNum = 0;
unsigned int firstTime = 1;
unsigned int currentNumSemaphores = 0; //globally track the current num of semaphores

YKSEM SemArray[MAX_NUM_SEMAPHORES];

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
	printString("\n************* BEGIN ***************\n\n");
	//Turn off interrupts
	YKEnterMutex();
	//create YKIdleTask
		//allocate stack space
	YKNewTask(YKIdleTask, (void *) &IdleStk[IDLE_TASK_STACK_SIZE], LOWEST_PRIORITY);
	//set lastRunTask to idle task (the only thing on ready list)
	lastRunTask = YKRdyList;
}

void YKIdleTask(void)
{
	printString("Entering idle task\n\r");
	while(1)
	{
		int tmp;
		tmp = YKIdleCount + 1;
		YKIdleCount = tmp;
	//	printString("YKIdleCount = ");
	//	printInt(YKIdleCount);
	//	printString("\n");
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
	//Enable interrupts and call the scheduler
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

	//print the ready list (for debug)
	//printLists();
	YKScheduler();
}

void YKEnterISR(void)
{
	//printString("YK Enter ISR: call depth = ");
	//printInt(ISRCallDepth);
	//printNewLine();
	ISRCallDepth++;
}

void YKExitISR(void)
{
	//printString("YK Exit ISR: call depth =");
	//printInt(ISRCallDepth);
	//printNewLine();
	ISRCallDepth--;
	if (ISRCallDepth == 0)
		YKScheduler();
}

void YKScheduler(void)
{
	//determine highest priority task
	//if highest priority task != lastRunTask
		//call dispatcher
	//printString("Entering scheduler\n\r");
	YKEnterMutex();
	if (firstTime)
	{
		firstTime = 0;
		//printString("Calling the dispatcher\n");
		YKCtxSwCount++;
		//printLists();
		YKFirstDispatcher(); //call the first dispatcher.
	}
	else if (lastRunTask != YKRdyList) //if the task has changed
	{
		//printString("Calling the dispatcher\n");
		YKCtxSwCount++;
		//printLists();
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
	//printString("tmp = YKSusplist: ");
	//printInt((int)tmp);
	//printString("\ntmp->delay: ");
	//printInt(tmp->delay);
	printString("\n");

	 while(tmp != NULL)
	 {
			if (tmp->delay > 0)
			{
				(tmp->delay)--;
				if (tmp->delay == 0)
				{
					tmp2 = tmp;
					tmp = tmp->next;
					//printString("Moved TCB to ready list\n\r");
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

YKSEM* YKSemCreate(int initialValue)
{
	//creates and inits a semaphore, returns ptr to the semaphore that was created
	YKSEM* sem;
	YKEnterMutex(); //disable interrupts
	sem = &(SemArray[currentNumSemaphores]); //set sem to address of current semaphore struct
	sem->value = initialValue; //set the initial value for the semaphore
	//sem->addrWaitingOnSem = 0;
	currentNumSemaphores++; //increment current sem count, enable interrupts and return the pointer
	YKExitMutex();
	return sem;
}

//Tests the value of the semaphore passed in, then decrements it
//called only from task code
void YKSemPend(YKSEM *semaphore)
{
	YKEnterMutex();
	//printString("pending semaphore at address ");
	//printInt((int)semaphore);
	//printNewLine();
	//printLists();
	//if semaphore->value > 0
	if (semaphore->value > 0)
	{
		//decrement semaphore value and we're done
		(semaphore->value)--;
	//	printString("Decremented semaphore during pend\n\r");
	}
	else
	{
		//(semaphore->addrWaitingOnSem) = YKRdyList;
		(semaphore->value)--;
		YKRdyList->pendingSem = semaphore; //set the pending sem of this task equal to the address of this semaphore
		//the calling task is suspended by the kernel until the sem is available
		removeFirstTCBFromRdyList();
		//call the scheduler
		YKScheduler();
	}
	YKExitMutex();
}

//Can be called from task code OR interrupt handlers
void YKSemPost(YKSEM *semaphore)
{
	TCBptr tmp;
	TCBptr tmp2;
	YKEnterMutex();
	//printString("posting semaphore at address ");
	//printInt((int)semaphore);
	//printNewLine();
	//printLists();
	//increment the value of semaphore
	(semaphore->value)++;
	//if any suspended tasks are waiting on this semaphoire
		//highest priority waiting task is made ready
	/*if(semaphore->addrWaitingOnSem != 0)
	{
		moveTCBToRdyList((TCBptr) (semaphore->addrWaitingOnSem));
		semaphore->addrWaitingOnSem = 0;
	}*/

	//now iterate through the suspend list
	//check the semaphore we are posting against the pendingSem addresses of each task in the susp list
		//if they match, put that task back into the ready list
	tmp = YKSuspList;
	while(tmp != NULL)
	{
		//printString("Iterating through the YKSuspList\n\r");
		if (tmp->pendingSem == semaphore){
			tmp->pendingSem = 0;
		//	printString("Moving a task in post to the ready list: priority = ");
		//	printInt(tmp->priority);
		//	printNewLine();
		tmp2 = tmp;
		tmp = tmp->next;
			moveTCBToRdyList(tmp2);
		}
		else
		{
			tmp = tmp->next;
		}
	}
//	printString("ISRCallDepth = ");
//	printInt(ISRCallDepth);
//	printNewLine();
	if (ISRCallDepth <= 0)
	{
		//printString("Calling the scheduler\n\r");
		//call the scheduler bc this was called from task code
		YKScheduler();
	}
	else
	{
		//printString("called semPost inside an interrupt");
	}
	//else dont worry about it, it was called from an ISR and sched will be called in YKExitISR
	YKExitMutex();
}
