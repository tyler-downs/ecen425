#include "yakk.h"
#include "clib.h"
#include "lab6defs.h"


unsigned int YKIdleCount = 0;
unsigned int running_flag = 0; //0 means not running, 1 means running
unsigned int ISRCallDepth = 0;
TCBptr lastRunTask = NULL;
unsigned int YKCtxSwCount = 0;
unsigned int YKTickNum = 0;
unsigned int firstTime = 1;
unsigned int currentNumSemaphores = 0; //globally track the current num of semaphores
unsigned int currentNumQueues = 0;

YKSEM SemArray[MAX_NUM_SEMAPHORES];

YKQ QueueArray[MAX_NUM_QUEUES];

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
	YKEnterMutex();
	YKRdyList->delay = count;
	removeFirstTCBFromRdyList(); //move to suspended list
	YKExitMutex();
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
	//increment the value of semaphore
	(semaphore->value)++;
	//if any suspended tasks are waiting on this semaphoire
		//highest priority waiting task is made ready
	//now iterate through the suspend list
	//check the semaphore we are posting against the pendingSem addresses of each task in the susp list
		//if they match, put that task back into the ready list
	tmp = YKSuspList;
	while(tmp != NULL)
	{
		//printString("Iterating through the YKSuspList\n\r");
		if (tmp->pendingSem == semaphore){
			tmp->pendingSem = 0;
		tmp2 = tmp;
		tmp = tmp->next;
			moveTCBToRdyList(tmp2);
		}
		else
		{
			tmp = tmp->next;
		}
	}
	if (ISRCallDepth <= 0)
	{
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

YKQ* YKQCreate(void **start, unsigned size)
{
		YKQ* queue;
		YKEnterMutex();
		queue = &(QueueArray[currentNumQueues]);
		currentNumQueues++;
		queue->qArray = start;
		queue->qStart = start;
		queue->qEnd = start;
		queue->qMaxSize = size;
		YKExitMutex();
		return queue;
}

//This function removes the oldest message from the indicated message queue if it is non-empty.
void *YKQPend(YKQ *queue)
{
		void* returnVal;
		struct msg* stuff;
		//if queue is empty, suspend the task until a message becomes available
		//if not, just return the oldest element in the queue
		YKEnterMutex();
		if (qIsEmpty(queue))
		{
			//	printString("Delaying task in pend until queue has message\n\r");
				YKRdyList->pendingQueue = queue;
				removeFirstTCBFromRdyList();
				YKScheduler();
		}


		//printString("Removing element from queue in pend: ");
		returnVal = qRemove(queue);
		//stuff = (struct msg*) returnVal;
		//printInt(stuff->tick);
		//printString(", ");
		//printInt(stuff->data);
		//printNewLine();
		YKExitMutex();
		return returnVal;
}

int YKQPost(YKQ *queue, void *msg)
{
		TCBptr tmp;
		TCBptr tmp2;
		struct msg* message;
		//places the message into the queue
		//check if the queue is full, if it is, return 0, if not, put message in queue and return 1
		YKEnterMutex();
		if (qIsFull(queue))
		{
				YKExitMutex();
				return 0;
		}
		else
		{
				//printString("Posting message to queue: ");
				//message = (struct msg*) msg;
				//printInt(message->tick);
				//printString(", ");
				//printInt(message->data);
				//printNewLine();
				qInsert(queue, msg);
				//now go through the susp list and put the tasks that were waiting back into the ready list
				tmp = YKSuspList;
				while(tmp != NULL)
				{
					if (tmp->pendingQueue == queue)
					{
							tmp->pendingQueue = 0;
							tmp2 = tmp;
							tmp = tmp->next;
							moveTCBToRdyList(tmp2);
					}
					else
					{
						tmp = tmp->next;
					}
				}
				if (ISRCallDepth <= 0)
				{
					//call the scheduler bc this was called from task code
					YKScheduler();
				}
				YKExitMutex();
				return 1;
		}
}
