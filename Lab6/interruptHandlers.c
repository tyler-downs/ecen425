#include "clib.h"
#include "yakk.h"
#include "lab6defs.h"


extern int KeyBuffer;
//extern YKSEM* NSemPtr;
static int tickCount = 0;

extern YKQ *MsgQPtr;
extern struct msg MsgArray[];
extern int GlobalFlag;

void resetInterruptHandler()
{
	exit(0);
}

void tickInterruptHandler()
{
	/*
	tickCount++;
	printNewLine();
	printString("TICK ");
	printInt(tickCount);
	printNewLine();
	//call tickHandler
	YKTickHandler();
	*/


	static int next = 0;
	static int data = 0;

	if (KeyBuffer == 'l')
	{
		printLists();
		KeyBuffer = 'a';
	}

	YKTickHandler();

	/* create a message with tick (sequence #) and pseudo-random data */
	MsgArray[next].tick = YKTickNum;
	data = (data + 89) % 100;
	MsgArray[next].data = data;

	if (YKQPost(MsgQPtr, (void *) &(MsgArray[next])) == 0)
			printString("  TickISR: queue overflow! \n");
	else if (++next >= MSGARRAYSIZE)
			next = 0;

	//YKTickHandler();
}

void keyboardInterruptHandler()
{
		GlobalFlag = 1;
}
