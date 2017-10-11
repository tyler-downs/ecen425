#include "clib.h"

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
