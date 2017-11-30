#include "clib.h"
#include "yakk.h"
#include "lab7defs.h"

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


	// static int next = 0;
	// static int data = 0;
	//
	// if (KeyBuffer == 'l')
	// {
	// 	printLists();
	// 	KeyBuffer = 'a';
	// }
	//
	// YKTickHandler();
	//
	// /* create a message with tick (sequence #) and pseudo-random data */
	// MsgArray[next].tick = YKTickNum;
	// data = (data + 89) % 100;
	// MsgArray[next].data = data;
	//
	// if (YKQPost(MsgQPtr, (void *) &(MsgArray[next])) == 0)
	// 		printString("  TickISR: queue overflow! \n");
	// else if (++next >= MSGARRAYSIZE)
	// 		next = 0;

	YKTickHandler();
}

void keyboardInterruptHandler(void)
{
    char c;
    c = KeyBuffer;

    if(c == 'a') YKEventSet(charEvent, EVENT_A_KEY);
    else if(c == 'b') YKEventSet(charEvent, EVENT_B_KEY);
    else if(c == 'c') YKEventSet(charEvent, EVENT_C_KEY);
    else if(c == 'd') YKEventSet(charEvent, EVENT_A_KEY | EVENT_B_KEY | EVENT_C_KEY);
    else if(c == '1') YKEventSet(numEvent, EVENT_1_KEY);
    else if(c == '2') YKEventSet(numEvent, EVENT_2_KEY);
    else if(c == '3') YKEventSet(numEvent, EVENT_3_KEY);
    else {
        print("\nKEYPRESS (", 11);
        printChar(c);
        print(") IGNORED\n", 10);
    }
}
