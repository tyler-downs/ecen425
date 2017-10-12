# 1 "test.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "test.c"
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
# 2 "test.c" 2
# 1 "linkedList.h" 1
# 1 "yaku.h" 1
# 2 "linkedList.h" 2






struct context_type
{
 unsigned int sp;
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
 unsigned int IF;
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

static TCBptr YKRdyList;
static TCBptr YKSuspList;

TCBptr createTCB(void *stackptr, int priority, struct context_type context);

void insertTCBIntoRdyList(TCBptr tcb);

void removeFirstTCBFromRdyList();





void moveTCBToRdyList(TCBptr tmp);



void printTCBs();
void printLists();
# 3 "test.c" 2





int AStk[256];
int BStk[256];
int CStk[256];

void ATask(void);
void BTask(void);
void CTask(void);


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
 1
};

void ATask(void)
{

}
void BTask(void)
{

}
void CTask(void)
{

}



void main()
{
 printString("****** TEST BEGIN ******\n");

 TCBptr a = createTCB((void *) &AStk[256], 1, initContext);
 insertTCBIntoRdyList(a);


 removeFirstTCBFromRdyList();
 printLists();
 moveTCBToRdyList(a);
 printLists();
 printString("****** TEST END ******\n");
}
