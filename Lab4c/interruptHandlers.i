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

extern int KeyBuffer;

void resetInterruptHandler()
{
 exit(0);
}

void tickInterruptHandler()
{
 static int tickCount = 0;
 tickCount++;
 printNewLine();
 printString("TICK ");
 printInt(tickCount);
 printNewLine();
}

void keyboardInterruptHandler()
{
 int count;
 printNewLine();
 if (KeyBuffer == 'd')
 {
  printString("DELAY KEY PRESSED");
  count = 0;
  while (count < 5000)
  {
   count++;
  }
  printNewLine();
  printString("DELAY COMPLETE");
  printNewLine();
 }
 else
 {
  printString("KEYPRESS (");
  printChar(KeyBuffer);
  printString(") IGNORED");
  printNewLine();
 }
}
