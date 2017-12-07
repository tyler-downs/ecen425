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

extern unsigned binLHighestRow;
extern unsigned binRHighestRow;

void resetInterruptHandler()
{
	exit(0);
}

void tickInterruptHandler()
{

	YKTickHandler();
}

void keyboardInterruptHandler(void)
{

}

void gameOverInterruptHandler()
{
	printString("Game over!!!!\n\n\n\n\n");
	exit(0);
}

void newPieceInterruptHandler()
{
	static int next = 0;
	//printString(" new piece\n");
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
	//printString(" received\n");
	YKSemPost(CmdRcvdSemPtr);
}
/*
void touchdownInterruptHandler()
{
	//update line info
}
*/
void clearInterruptHandler()
{
	//printString(" cleared line\n");
	//update line info
	binLHighestRow--;
	binRHighestRow--;
}
