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
# 1 "lab8defs.h" 1
# 38 "lab8defs.h"
struct newPiece
{
    int id;
    int orientation;
    int type;
    int column;
};

struct move
{
  int pieceID;
  int moveType;
  int direction;
};
# 4 "interruptHandlers.c" 2

extern int KeyBuffer;
extern int NewPieceID;
extern int NewPieceType;
extern int NewPieceOrientation;
extern int NewPieceColumn;
extern int ScreenBitMap0;
extern int ScreenBitMap1;
extern int ScreenBitMap2;
extern int ScreenBitMap3;
extern int ScreenBitMap4;
extern int ScreenBitMap5;


extern YKSEM* CmdRcvdSemPtr;
static int tickCount = 0;

extern YKQ *newPieceQPtr;
extern struct newPiece newPieceArray[];
extern int GlobalFlag;

extern unsigned binLHighestRow;
extern unsigned binRHighestRow;

void resetInterruptHandler()
{
 exit(0);
}

void tickInterruptHandler()
{

 YKTickHandler();
}

void keyboardInterruptHandler(void)
{

}

void gameOverInterruptHandler()
{
 printString("Game over!!!!\n\n\n\n\n");
 exit(0);
}

void newPieceInterruptHandler()
{
 static int next = 0;

 newPieceArray[next].id = NewPieceID;
 newPieceArray[next].orientation = NewPieceOrientation;
 newPieceArray[next].type = NewPieceType;
 newPieceArray[next].column = NewPieceColumn;

 if (YKQPost(newPieceQPtr, (void*) &(newPieceArray[next])) == 0)
  printString("\n*****new piece made queue overflow!!*****\n");
 else if (++next >= 5)
  next = 0;
}

void receivedInterruptHandler()
{

 YKSemPost(CmdRcvdSemPtr);
}






void clearInterruptHandler()
{


 binLHighestRow--;
 binRHighestRow--;
}
