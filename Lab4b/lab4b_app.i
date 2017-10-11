# 1 "lab4b_app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "lab4b_app.c"






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
# 8 "lab4b_app.c" 2
# 1 "yakk.h" 1
# 9 "lab4b_app.c" 2





int AStk[256];
int BStk[256];
int CStk[256];

void ATask(void);
void BTask(void);
void CTask(void);

void main(void)
{
    YKInitialize();

    printString("Creating task A...\n");
    YKNewTask(ATask, (void *)&AStk[256], 5);

    printString("Starting kernel...\n");
    YKRun();
}

void ATask(void)
{
    printString("Task A started!\n");

    printString("Creating low priority task B...\n");
    YKNewTask(BTask, (void *)&BStk[256], 7);

    printString("Creating task C...\n");
    YKNewTask(CTask, (void *)&CStk[256], 2);

    printString("Task A is still running! Oh no! Task A was supposed to stop.\n");
    exit(0);
}

void BTask(void)
{
    printString("Task B started! Oh no! Task B wasn't supposed to run.\n");
    exit(0);
}

void CTask(void)
{
    int count;
    unsigned numCtxSwitches;

    YKEnterMutex();
    numCtxSwitches = YKCtxSwCount;
    YKExitMutex();

    printString("Task C started after ");
    printUInt(numCtxSwitches);
    printString(" context switches!\n");

    while (1)
    {
 printString("Executing in task C.\n");
        for(count = 0; count < 5000; count++);
    }
}
