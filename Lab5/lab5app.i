# 1 "lab5app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "lab5app.c"






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
# 8 "lab5app.c" 2
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

typedef struct {
 int value;
} YKSEM;

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
# 20 "yakk.h"
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
# 9 "lab5app.c" 2



int TaskWStk[512];
int TaskSStk[512];
int TaskPStk[512];
int TaskStatStk[512];
int TaskPRMStk[512];

YKSEM *PSemPtr;
YKSEM *SSemPtr;
YKSEM *WSemPtr;
YKSEM *NSemPtr;

void TaskWord(void)
{
    while (1)
    {
        YKSemPend(WSemPtr);
        printString("Hey");
        YKSemPost(PSemPtr);

        YKSemPend(WSemPtr);
        printString("it");
        YKSemPost(SSemPtr);

        YKSemPend(WSemPtr);
        printString("works");
        YKSemPost(PSemPtr);
    }
}

void TaskSpace(void)
{
    while (1)
    {
        YKSemPend(SSemPtr);
        printChar(' ');
        YKSemPost(WSemPtr);
    }
}

void TaskPunc(void)
{
    while (1)
    {
        YKSemPend(PSemPtr);
        printChar('"');
        YKSemPost(WSemPtr);

        YKSemPend(PSemPtr);
        printChar(',');
        YKSemPost(SSemPtr);

        YKSemPend(PSemPtr);
        printString("!\"\r\n");
        YKSemPost(PSemPtr);

        YKDelayTask(6);
    }
}

void TaskPrime(void)
{
    int curval = 1001;
    int j,flag,lncnt;
    int endval;

    while (1)
    {
        YKSemPend(NSemPtr);


        lncnt = 0;
        endval = curval + 500;
        for ( ; curval < endval; curval += 2)
        {
            flag = 0;
            for (j = 3; (j*j) < curval; j += 2)
            {
                if (curval % j == 0)
                {
                    flag = 1;
                    break;
                }
            }
            if (!flag)
            {
                printChar(' ');
                printInt(curval);
                lncnt++;
                if (lncnt > 9)
                {
                    printNewLine();
                    lncnt = 0;
                }
            }
        }
        printNewLine();
    }
}

void TaskStat(void)
{
    unsigned max, switchCount, idleCount;
    int tmp;

    YKDelayTask(1);
    printString("Welcome to the YAK kernel\r\n");
    printString("Determining CPU capacity\r\n");
    YKDelayTask(1);
    YKIdleCount = 0;
    YKDelayTask(5);
    max = YKIdleCount / 25;
    YKIdleCount = 0;

    YKNewTask(TaskPrime, (void *) &TaskPRMStk[512], 32);
    YKNewTask(TaskWord, (void *) &TaskWStk[512], 10);
    YKNewTask(TaskSpace, (void *) &TaskSStk[512], 11);
    YKNewTask(TaskPunc, (void *) &TaskPStk[512], 12);

    while (1)
    {
        YKDelayTask(20);

        YKEnterMutex();
        switchCount = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKExitMutex();

        printString ("<<<<< Context switches: ");
        printInt((int)switchCount);
        printString(", CPU usage: ");
        tmp = (int) (idleCount/max);
        printInt(100-tmp);
        printString("% >>>>>\r\n");

        YKEnterMutex();
        YKCtxSwCount = 0;
        YKIdleCount = 0;
        YKExitMutex();
    }
}

void main(void)
{
    YKInitialize();


    PSemPtr = YKSemCreate(1);
    SSemPtr = YKSemCreate(0);
    WSemPtr = YKSemCreate(0);
    NSemPtr = YKSemCreate(0);
    YKNewTask(TaskStat, (void *) &TaskStatStk[512], 30);

    YKRun();
}
