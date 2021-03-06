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
} TCB;

extern TCBptr YKRdyList;
extern TCBptr YKSuspList;

TCBptr createTCB(void *stackptr, int priority, struct context_type context);

void insertTCBIntoRdyList(TCBptr tcb);

void removeFirstTCBFromRdyList();





void moveTCBToRdyList(TCBptr tmp);
# 2 "yakk.h" 2





extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;
extern unsigned int YKTickNum;
extern TCBptr lastRunningTask;

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

void YKTickHandler(void);
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
static int running_flag = 0;
unsigned int ISRCallDepth = 0;
TCBptr lastRunTask = 0;
unsigned int YKCtxSwCount = 0;
unsigned int YKTickNum = 0;
unsigned int firstTime = 1;



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



 YKNewTask(YKIdleTask, (void *) &IdleStk[256], 100);

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


 YKRdyList->delay = count;
 removeFirstTCBFromRdyList();
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



 if (lastRunTask != YKRdyList || firstTime)
 {
  firstTime = 0;


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
    tmp->delay--;
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
