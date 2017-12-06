# 1 "interruptHandlers.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "interruptHandlers.c"
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
# 2 "interruptHandlers.c" 2
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
# 3 "interruptHandlers.c" 2
# 1 "lab7defs.h" 1
# 15 "lab7defs.h"
extern YKEVENT *charEvent;
extern YKEVENT *numEvent;
# 4 "interruptHandlers.c" 2

extern int KeyBuffer;

static int tickCount = 0;

extern YKQ *MsgQPtr;
extern struct msg MsgArray[];
extern int GlobalFlag;

void resetInterruptHandler()
{
 exit(0);
}

void tickInterruptHandler()
{
# 52 "interruptHandlers.c"
 YKTickHandler();
}

void keyboardInterruptHandler(void)
{
    char c;
    c = KeyBuffer;

    if(c == 'a') YKEventSet(charEvent, 0x1);
    else if(c == 'b') YKEventSet(charEvent, 0x2);
    else if(c == 'c') YKEventSet(charEvent, 0x4);
    else if(c == 'd') YKEventSet(charEvent, 0x1 | 0x2 | 0x4);
    else if(c == '1') YKEventSet(numEvent, 0x1);
    else if(c == '2') YKEventSet(numEvent, 0x2);
    else if(c == '3') YKEventSet(numEvent, 0x4);
    else {
        print("\nKEYPRESS (", 11);
        printChar(c);
        print(") IGNORED\n", 10);
    }
}
