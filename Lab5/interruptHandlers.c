#include "clib.h"
#include "yakk.h"

extern int KeyBuffer;
static int tickCount = 0;

void resetInterruptHandler()
{
	exit(0);
}

void tickInterruptHandler()
{
	tickCount++;
	printNewLine();
	printString("TICK ");
	printInt(tickCount);
	printNewLine();
	//call tickHandler
	YKTickHandler();
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
