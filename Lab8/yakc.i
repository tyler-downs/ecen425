# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakc.c"
# 1 "yakk.h" 1
# 1 "linkedList.h" 1
# 1 "yaku.h" 1
# 2 "linkedList.h" 2
# 1 "queue.h" 1


typedef struct
{
 void** qStart;
 void** qEnd;
 void** qArray;
 int qMaxSize;

} YKQ;

int qIsEmpty(YKQ* queue);
int qIsFull(YKQ* queue);
void** qNextInsertSpot(YKQ* queue);
void** qNextRemoveSpot(YKQ* queue);
void qInsert(YKQ* queue, void* elementPtr);
void* qRemove(YKQ* queue);
# 3 "linkedList.h" 2






struct context_type
{
 unsigned sp;
 unsigned int ip;

 unsigned int ax;
 unsigned int bx;
 unsigned int cx;
 unsigned int dx;
 unsigned int si;
 unsigned int di;
 unsigned int bp;
 unsigned int es;
 unsigned int ds;
 unsigned int cs;
 unsigned int flags;
};

typedef struct {
 int value;
} YKSEM;

typedef unsigned YKEVENT;


typedef struct taskblock *TCBptr;

typedef struct taskblock
{
 struct context_type context;
 void *stackptr;
 unsigned priority;
 int delay;
 TCBptr next;
 TCBptr prev;
 unsigned ID;
 YKSEM* pendingSem;
 YKQ* pendingQueue;
 YKEVENT* pendingEventGroup;
 unsigned pendingEventFlags;
 int eventWaitMode;
} TCB;


extern TCBptr YKRdyList;
extern TCBptr YKSuspList;

TCBptr createTCB(void *stackptr, int priority, struct context_type context);

void insertTCBIntoRdyList(TCBptr tcb);

void removeFirstTCBFromRdyList();





void moveTCBToRdyList(TCBptr tmp);



void printTCBs();
void printLists();
# 2 "yakk.h" 2
# 17 "yakk.h"
extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;
extern unsigned int YKTickNum;
extern unsigned int running_flag;
extern TCBptr lastRunningTask;
# 30 "yakk.h"
void YKIdleTask();
static int IdleStk[256];


void YKInitialize(void);

void YKEnterMutex(void);

void YKExitMutex(void);

void YKIdleTask(void);

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority);

void YKRun(void);

void YKDelayTask(unsigned count);

void YKEnterISR(void);

void YKExitISR(void);

void YKScheduler(void);

void YKDispatcher(void);

void YKFirstDispatcher(void);

void YKTickHandler(void);

YKSEM* YKSemCreate(int initialValue);

void YKSemPend(YKSEM *semaphore);

void YKSemPost(YKSEM *semaphore);

YKQ* YKQCreate(void **start, unsigned size);

void *YKQPend(YKQ *queue);

int YKQPost(YKQ *queue, void *msg);

YKEVENT *YKEventCreate(unsigned initialValue);

unsigned YKEventPend(YKEVENT* event, unsigned eventMask, int waitMode);

void YKEventSet(YKEVENT* event, unsigned eventMask);

void YKEventReset(YKEVENT* event, unsigned eventMask);
# 2 "yakc.c" 2
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 3 "yakc.c" 2

unsigned int YKIdleCount = 0;
unsigned int running_flag = 0;
unsigned int ISRCallDepth = 0;
TCBptr lastRunTask = 0;
unsigned int YKCtxSwCount = 0;
unsigned int YKTickNum = 0;
unsigned int firstTime = 1;
unsigned int currentNumSemaphores = 0;
unsigned int currentNumQueues = 0;
unsigned int currentNumEvents = 0;

YKSEM SemArray[6];
YKQ QueueArray[3];
YKEVENT EventArray[2];


struct context_type initContext = {
 0,
 0,

 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0x0200
};

void YKInitialize(void)
{
 printString("\n************* BEGIN ***************\n\n");

 YKEnterMutex();


 YKNewTask(YKIdleTask, (void *) &IdleStk[256], 100);

 lastRunTask = YKRdyList;
}

void YKIdleTask(void)
{
 printString("Entering idle task\n\r");
 while(1)
 {
  int tmp;
  YKEnterMutex();
  tmp = YKIdleCount + 1;

  YKIdleCount = tmp;
  YKExitMutex();



 }

}


void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority)
{






 TCBptr newTCB;
 newTCB = createTCB(taskStack, priority, initContext);

 newTCB->context.sp = (int)(taskStack);
 newTCB->context.ip = (int)task;
 newTCB->context.bp = (int)taskStack;
 insertTCBIntoRdyList(newTCB);



 if (running_flag)
 {
  YKScheduler();
 }
}

void YKRun(void)
{


 running_flag = 1;


 YKScheduler();
}

void YKDelayTask(unsigned count)
{




 if (count == 0)
  return;




 YKEnterMutex();
 YKRdyList->delay = count;
 removeFirstTCBFromRdyList();
 YKExitMutex();


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




 YKEnterMutex();
 if (firstTime)
 {
  firstTime = 0;

  YKCtxSwCount++;

  YKFirstDispatcher();
 }
 else if (lastRunTask != YKRdyList)
 {

  YKCtxSwCount++;

  YKDispatcher();
 }

}

void YKTickHandler(void)
{






 TCBptr tmp;
 TCBptr tmp2;
 tmp = YKSuspList;

 while(tmp != 0)
 {
   if (tmp->delay > 0)
   {
    (tmp->delay)--;
    if (tmp->delay == 0)
    {
     tmp2 = tmp;
     tmp = tmp->next;

     moveTCBToRdyList(tmp2);
    }
    else
     tmp = tmp->next;
   }
   else
    tmp = tmp->next;
 }
 YKTickNum++;

}

YKSEM* YKSemCreate(int initialValue)
{

 YKSEM* sem;
 YKEnterMutex();
 sem = &(SemArray[currentNumSemaphores]);
 sem->value = initialValue;

 currentNumSemaphores++;
 YKExitMutex();
 return sem;
}



void YKSemPend(YKSEM *semaphore)
{
 YKEnterMutex();





 if (semaphore->value > 0)
 {

  (semaphore->value)--;

 }
 else
 {

  (semaphore->value)--;
  YKRdyList->pendingSem = semaphore;

  removeFirstTCBFromRdyList();

  YKScheduler();
 }
 YKExitMutex();
}


void YKSemPost(YKSEM *semaphore)
{
 TCBptr tmp;
 TCBptr tmp2;
 YKEnterMutex();

 (semaphore->value)++;





 tmp = YKSuspList;
 while(tmp != 0)
 {

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

  YKScheduler();
 }
 else
 {

 }

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


void *YKQPend(YKQ *queue)
{
  void* returnVal;
  struct msg* stuff;


  YKEnterMutex();
  if (qIsEmpty(queue))
  {

    YKRdyList->pendingQueue = queue;
    removeFirstTCBFromRdyList();
    YKScheduler();
  }



  returnVal = qRemove(queue);





  YKExitMutex();
  return returnVal;
}

int YKQPost(YKQ *queue, void *msg)
{
  TCBptr tmp;
  TCBptr tmp2;
  struct msg* message;


  YKEnterMutex();
  if (qIsFull(queue))
  {
    YKExitMutex();
    return 0;
  }
  else
  {






    qInsert(queue, msg);

    tmp = YKSuspList;
    while(tmp != 0)
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

     YKScheduler();
    }
    YKExitMutex();
    return 1;
  }
}

YKEVENT *YKEventCreate(unsigned initialValue)
{
 YKEVENT* event;

 if (currentNumEvents > 2)
 {
  printString("ERROR: MAXIMUM NUMBER OF EVENTS EXCEEDED");
  return 0;
 }

 YKEnterMutex();
 event = &(EventArray[currentNumEvents]);
 *event = initialValue;
 currentNumEvents++;
 YKExitMutex();
 return event;
}

unsigned YKEventPend(YKEVENT* event, unsigned eventMask, int waitMode)
{
 TCBptr tmp;

 YKEnterMutex();
 switch (waitMode) {
  case 1:
   if ((*event & eventMask) != eventMask)
   {


    tmp = YKRdyList;
    tmp->pendingEventGroup = event;
    tmp->pendingEventFlags = eventMask;
    tmp->eventWaitMode = waitMode;

    removeFirstTCBFromRdyList();
    YKScheduler();
    YKExitMutex();



    return *event;
   }
   else
   {





    return *event;
   }
   break;
  case 0:
   if ((*event & eventMask) == 0)
   {


    tmp = YKRdyList;
    tmp->pendingEventGroup = event;
    tmp->pendingEventFlags = eventMask;
    tmp->eventWaitMode = waitMode;
    removeFirstTCBFromRdyList();
    YKScheduler();
    YKExitMutex();



    return *event;
   }
   else
   {





    return *event;
   }
   break;
  default:
   printString("\n\rERROR: INVALID WAIT MODE\n\r");
   return 0;
   break;
 }

 YKExitMutex();
}

void YKEventSet(YKEVENT* event, unsigned eventMask)
{

 int taskMadeReady;
 unsigned curFlags;
 unsigned newFlags;
 TCBptr tmp;
 TCBptr tmp2;

 taskMadeReady = 0;
# 481 "yakc.c"
 YKEnterMutex();

 curFlags = *event;
 newFlags = (curFlags & ~eventMask) | (eventMask);
 *event = newFlags;







 tmp = YKSuspList;
 while(tmp != 0)
 {
  if ((tmp->pendingEventGroup == event) && (tmp->pendingEventGroup != 0))
  {
    if (tmp->eventWaitMode == 1)
    {
      if ((*event & (tmp->pendingEventFlags)) == (tmp->pendingEventFlags))
      {
        tmp->pendingEventGroup = 0;
        tmp->pendingEventFlags = 0;
        tmp->eventWaitMode = -1;
        tmp2 = tmp;
        tmp = tmp->next;


        printNewLine();
        moveTCBToRdyList(tmp2);
        taskMadeReady = 1;
      }
      else
      {
        tmp = tmp->next;
      }
    }
    else
    {
      if ((*event & (tmp->pendingEventFlags)) != 0)
      {
        tmp->pendingEventGroup = 0;
        tmp->pendingEventFlags = 0;
        tmp->eventWaitMode = -1;
        tmp2 = tmp;
        tmp = tmp->next;


        printNewLine();
        moveTCBToRdyList(tmp2);
        taskMadeReady = 1;
      }
      else
      {
        tmp = tmp->next;
      }
    }
  }
  else
   tmp = tmp->next;
 }

 if (taskMadeReady && (ISRCallDepth <= 0))
 {
  printString("\n\r----Calling Scheduler from YKEVentSet------\n\r");
  YKScheduler();
 }
 YKExitMutex();
}

void YKEventReset(YKEVENT* event, unsigned eventMask)
{
 unsigned curVal;
 unsigned newVal;






 YKEnterMutex();
 curVal = *event;
 newVal = (curVal & ~eventMask) | (0 & eventMask);



 *event = newVal;
 YKExitMutex();
}
