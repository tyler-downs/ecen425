# 1 "linkedList.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "linkedList.c"
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
# 2 "linkedList.c" 2
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
# 3 "linkedList.c" 2

static unsigned currentListSize = 0;
TCBptr YKRdyList;
TCBptr YKSuspList;

struct taskblock TCBarray[5 + 1];


TCBptr runningTask;

TCBptr createTCB(void *stackptr, int priority, struct context_type context)
{
 TCBarray[currentListSize].stackptr = stackptr;
 TCBarray[currentListSize].priority = priority;
 TCBarray[currentListSize].context = context;
 TCBarray[currentListSize].ID = currentListSize;
 TCBarray[currentListSize].pendingSem = 0;
 TCBarray[currentListSize].pendingQueue = 0;
 TCBarray[currentListSize].pendingEventGroup = 0;
 TCBarray[currentListSize].pendingEventFlags = 0;
 TCBarray[currentListSize].eventWaitMode = -1;
 currentListSize++;
 return &(TCBarray[currentListSize-1]);
}

void insertTCBIntoRdyList(TCBptr tcb)
{
 TCBptr tmp;
 if (YKRdyList == 0)
 {
  YKRdyList = tcb;
  tcb->next = 0;
  tcb->prev = 0;
 }
 else
 {
  tmp = YKRdyList;
  while (tmp->priority < tcb->priority)
   tmp = tmp->next;
  if (tmp->prev == 0)
  {
   YKRdyList = tcb;





  }
  else
   tmp->prev->next = tcb;
  tcb->prev = tmp->prev;
  tcb->next = tmp;
  tmp->prev = tcb;
 }
}

void removeFirstTCBFromRdyList()
{
 TCBptr tmp;
 tmp = YKRdyList;
    YKRdyList = tmp->next;
    tmp->next->prev = 0;
    tmp->next = YKSuspList;
    YKSuspList = tmp;
    tmp->prev = 0;
    if (tmp->next != 0)
  tmp->next->prev = tmp;
}




void moveTCBToRdyList(TCBptr tmp)
{
 TCBptr tmp2;

    if (tmp->prev == 0)
   YKSuspList = tmp->next;
    else
   tmp->prev->next = tmp->next;
    if (tmp->next != 0)
   tmp->next->prev = tmp->prev;

    tmp2 = YKRdyList;

  while (tmp2->priority < tmp->priority)
   tmp2 = tmp2->next;
    if (tmp2->prev == 0)
   YKRdyList = tmp;
    else
   tmp2->prev->next = tmp;
    tmp->prev = tmp2->prev;
    tmp->next = tmp2;
    tmp2->prev = tmp;
}



void printContext(struct context_type c)
{
 printString("\n  sp: ");
 printInt(c.sp);
 printString("\n  ip: ");
 printInt(c.ip);
# 120 "linkedList.c"
 printString("\n  ax: ");
 printInt(c.ax);
 printString("\n  bx: ");
 printInt(c.bx);
 printString("\n  cx: ");
 printInt(c.cx);
 printString("\n  dx: ");
 printInt(c.dx);
 printString("\n  si: ");
 printInt(c.si);
 printString("\n  di: ");
 printInt(c.di);
 printString("\n  bp: ");
 printInt(c.bp);
 printString("\n  es: ");
 printInt(c.es);
 printString("\n  ds: ");
 printInt(c.ds);
 printString("\n  flags: ");
 printInt(c.flags);
 printString("\n\n");
}


void printTCB(TCBptr t)
{
 printString("  ID: ");
 printInt(t->ID);
 printString("\n  Priority: ");
 printInt(t->priority);
 printString("\n  Delay: ");
 printInt(t->delay);
 printString("\n Pending Sem: ");
 printWord((int) t->pendingSem);
 printString("\n Pending Sem value: ");
 printInt((t->pendingSem->value));
 printString("\n Pending Queue: ");
 printWord((int) t->pendingQueue);
 printString("\n Pending Event Group: ");
 printWord((int) t->pendingEventGroup);
 printString("\n Pending Event Group value: ");
 printInt((int) *(t->pendingEventGroup));
 printString("\n Pending Event flags: ");
 printInt(t->pendingEventFlags);
 printString("\n Event wait mode: ");
 printInt(t->eventWaitMode);
 printContext(t->context);
}

YKSEM* pendingSem;
YKQ* pendingQueue;
YKEVENT* pendingEventGroup;
unsigned pendingEventFlags;
int eventWaitMode;

void printTCBs()
{
 unsigned i;
 for (i = 0; i < currentListSize; i++)
 {
  printString("TCB ");
  printInt(i);
  printNewLine();
  printTCB(&TCBarray[i]);
 }
}
void printLists()
{

 TCBptr tmp = YKRdyList;
 printString("Ready list: \n");
 while (tmp != 0)
 {
  printTCB(tmp);
  tmp = tmp->next;
 }


 tmp = YKSuspList;
 printString("Suspended list: \n");
 while (tmp != 0)
 {
  printTCB(tmp);
  tmp = tmp->next;
 }
}
