# 1 "linkedList.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "linkedList.c"
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
