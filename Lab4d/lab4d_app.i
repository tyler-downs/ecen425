# 1 "lab4d_app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "lab4d_app.c"






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
# 8 "lab4d_app.c" 2
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



void printTCBs();
void printLists();
# 2 "yakk.h" 2





extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;
extern unsigned int YKTickNum;
extern unsigned int running_flag;
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

void YKFirstDispatcher(void);

void YKTickHandler(void);
# 9 "lab4d_app.c" 2






int AStk[256];
int BStk[256];
int CStk[256];
int DStk[256];

void ATask(void);
void BTask(void);
void CTask(void);
void DTask(void);

void main(void)
{
    YKInitialize();

    printString("Creating tasks...\n");
    YKNewTask(ATask, (void *) &AStk[256], 3);
    YKNewTask(BTask, (void *) &BStk[256], 5);
    YKNewTask(CTask, (void *) &CStk[256], 7);
    YKNewTask(DTask, (void *) &DStk[256], 8);

    printString("Starting kernel...\n");
    YKRun();
}

void ATask(void)
{
    printString("Task A started.\n");
    while (1)
    {
        printString("Task A, delaying 2.\n");
        YKDelayTask(2);
    }
}

void BTask(void)
{
    printString("Task B started.\n");
    while (1)
    {
        printString("Task B, delaying 3.\n");
        YKDelayTask(3);
    }
}

void CTask(void)
{
    printString("Task C started.\n");
    while (1)
    {
        printString("Task C, delaying 5.\n");
        YKDelayTask(5);
    }
}

void DTask(void)
{
    printString("Task D started.\n");
    while (1)
    {
        printString("Task D, delaying 10.\n");
        YKDelayTask(10);
    }
}
