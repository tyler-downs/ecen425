#include "clib.h"
#include "yakk.h"
#include "lab8defs.h"

extern int KeyBuffer;
extern int NewPieceID;
extern int NewPieceType;
extern int NewPieceOrientation;
extern int NewPieceColumn;
extern int ScreenBitMap0;
extern int ScreenBitMap1;
extern int ScreenBitMap2;
extern int ScreenBitMap3;
extern int ScreenBitMap4;
extern int ScreenBitMap5;


extern YKSEM* CmdRcvdSemPtr;
static int tickCount = 0;

extern YKQ *newPieceQPtr;
extern struct newPiece newPieceArray[];
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
	/*
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
		*/
}

void gameOverInterruptHandler()
{
	printString("Game over!!!!\n\n\n\n\n");
}

void newPieceInterruptHandler()
{
	static int next = 0;
	newPieceArray[next].id = NewPieceID;
	newPieceArray[next].orientation = NewPieceOrientation;
	newPieceArray[next].type = NewPieceType;
	newPieceArray[next].column = NewPieceColumn;

	if (YKQPost(newPieceQPtr, (void*) &(newPieceArray[next])) == 0)
		printString("\n*****new piece made queue overflow!!*****\n");
	else if (++next >= NEWPIECEARRAYSIZE)
		next = 0;
}

void receivedInterruptHandler()
{
	YKSemPost(CmdRcvdSemPtr);
}

void touchdownInterruptHandler()
{
	//update line info
}

void clearInterruptHandler()
{
	//update line info
}
