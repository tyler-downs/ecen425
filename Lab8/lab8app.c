#include "clib.h"
#include "yakk.h"                     /* contains kernel definitions */
#include "lab8defs.h"
#include "simptris.h"

#define TASK_STACK_SIZE   512         /* stack size in words */
#define NEWPIECEQSIZE           5
#define MOVEQSIZE 25

int PlacementTaskStk[TASK_STACK_SIZE];     /* a stack for each task */
int CommunicationTaskStk[TASK_STACK_SIZE];
int StatTaskStk[TASK_STACK_SIZE];

//Flags used in placing a block
//static unsigned binLlower;  //1 if binL is lower than binR, else 0
static unsigned binLflat;
static unsigned binRflat;


#define binLlower (binLHighestRow < binRHighestRow)

static int numSlides; //negative = left, positive = right
static int numRotations; //negative = counterclockwise, positive = clockwise
unsigned binLHighestRow = 0;
unsigned binRHighestRow = 0;

//buffers for queue content
struct newPiece newPieceArray[NEWPIECEARRAYSIZE];
struct move moveArray[MOVEARRAYSIZE];

void* newPieceQ[NEWPIECEQSIZE];           /* space for newPiece queue */
YKQ* newPieceQPtr;                   /* actual name of queue */
void* moveQ[MOVEQSIZE];
YKQ* moveQPtr;

YKSEM *CmdRcvdSemPtr;

static int nextMove = 0;

void sendMoveCmd()
{
  //printString("sending Move command\n\r");
  if (YKQPost(moveQPtr, (void*) &(moveArray[nextMove])) == 0)
    printString("\n*****new move made queue overflow!!*****\n");
  else if (++nextMove >= MOVEARRAYSIZE)
    nextMove = 0;
}

//sends a message to the move queue to move this piece clockwise
void rotatePieceClockwise(int pieceID)
{
  moveArray[nextMove].pieceID = pieceID;
  moveArray[nextMove].moveType = ROTATE;
  moveArray[nextMove].direction = CLKWISE;
  sendMoveCmd();
}

//sends a message to the move queue to move this piece counterclockwise
void rotatePieceCounterClockwise(int pieceID)
{
  moveArray[nextMove].pieceID = pieceID;
  moveArray[nextMove].moveType = ROTATE;
  moveArray[nextMove].direction = CNTRCLKWISE;
  sendMoveCmd();
}

//sends a message to the move queue to move this piece left
void slidePieceLeft(int pieceID)
{
  moveArray[nextMove].pieceID = pieceID;
  moveArray[nextMove].moveType = SLIDE;
  moveArray[nextMove].direction = LEFT;
  sendMoveCmd();
}

//sends a message to the move queue to move this piece right
void slidePieceRight(int pieceID)
{
  moveArray[nextMove].pieceID = pieceID;
  moveArray[nextMove].moveType = SLIDE;
  moveArray[nextMove].direction = RIGHT;
  sendMoveCmd();
}

void rotatePieceToTR(struct newPiece* piecePtr)
{
  switch (piecePtr->orientation)
  {
    case BL:
      numRotations += 2; //turn clockwise twice
      break;
    case BR:
      numRotations--; //turn counterclockwise once
      break;
    case TR:
      //do nothing
      break;
    case TL:
      numRotations++; //rotate clockwise once
      break;
  }
}

void rotatePieceToBL(struct newPiece* piecePtr)
{
  switch (piecePtr->orientation)
  {
    case BL:
      //do nothing
      break;
    case BR:
      numRotations++; //rotate clockwise once
      break;
    case TR:
      numRotations += 2; //rotate it clockwise twice
      break;
    case TL:
      numRotations--; //rotate counter clockwise once
      break;
    default:
      //print a message
      break;
  }
}

void placeCornerPieceInLeftBin(struct newPiece* piecePtr)
{
  if (binLflat) //if BinL is flat
  {
    //put it in orientation 0 (BL) by rotating it
    rotatePieceToBL(piecePtr);
    numSlides -= (piecePtr->column); //move to col 0
    // printString("Changing binLflat to 0 for piece: ");
    // printInt(piecePtr->id);
    // printNewLine();
    binLflat = 0; //binL is now no longer flat
  }
  else //if bin L is not flat, rotate it to TR and place it
  {
    rotatePieceToTR(piecePtr); //get in TR position
    numSlides -= (piecePtr->column - 2); //slide to col 2
    // printString("Changing binLflat to 1 for piece: ");
    // printInt(piecePtr->id);
    // printNewLine();
    binLflat = 1; //bin is now flat
  }
}

void placeCornerPieceInRightBin(struct newPiece* piecePtr)
{
  if (binRflat)
  {
    //get our piece to pos BL and to column 3
    //determine rotations
    rotatePieceToBL(piecePtr);
    //determine slide to get to column 3
    numSlides -= (piecePtr->column - 3);
    //binR is now no longer flat

    // printString("Changing binRflat to 0 for piece: ");
    // printInt(piecePtr->id);
    // printNewLine();
    
    binRflat = 0;
  }
  else //if the right bin is not flat
  {
    //get our piece to pos TR and column 5
    rotatePieceToTR(piecePtr);
    numSlides -= (piecePtr->column - 5);
    //bin is now flat
    /*
    printString("Changing binRflat to 1 for piece: ");
    printInt(piecePtr->id);
    printNewLine();
    */
    binRflat = 1;
  }
}

void placeCornerPiece(struct newPiece* piecePtr)
{
  //determine which bin to put it in
  /*
  printString("binLflat: ");
  printInt(binLflat);
  printString(", binRflat: ");
  printInt(binRflat);
  printNewLine();
  */
  if (binLflat && binRflat)
  {
    if (binLlower)
    {
      placeCornerPieceInLeftBin(piecePtr);
      //update the highest rows data to reflect where this piece will be
      binLHighestRow += 2;
    }
    else //if binR is lower
    {
      placeCornerPieceInRightBin(piecePtr);
      //update the highest rows data to reflect where this piece will be
      binRHighestRow += 2;
    }
  }
  else if (binRflat)
  {
      placeCornerPieceInLeftBin(piecePtr);
      //update the highest rows data to reflect where this piece will be
  }
  else if (binLflat)
  {
      placeCornerPieceInRightBin(piecePtr);
      //update the highest rows data to reflect where this piece will be
  }
  else
  {
    printString("Neither are flat when placing a corner piece!\n");
  }

}

void sendRotateCommands(struct newPiece* piecePtr)
{
  while (numRotations != 0)
  {
    if (numRotations < 0)
    {
      rotatePieceCounterClockwise(piecePtr->id);
      numRotations++; //update number of rotations left
    }
    else
    {
      rotatePieceClockwise(piecePtr->id);
      numRotations--; //update number of rotations left
    }
  }
}

void sendMoveCommands(struct newPiece* piecePtr)
{
  int curCol;
  int dir;
  curCol = piecePtr->column;
  dir = numSlides;
  while (numSlides != 0)
  {
    if ((curCol == 1 && dir < 0) || (curCol == 4 && dir > 0)) //need to rotate before reaching edge
    {
      //printString("Special case\n");
      sendRotateCommands(piecePtr);
    }
    //slide one step
    if (numSlides < 0)
    {
      slidePieceLeft(piecePtr->id);
      curCol--;
      numSlides++; //update the number of slides left to do
    }
    else
    {
      slidePieceRight(piecePtr->id);
      curCol++;
      numSlides--; //update the number of slides left to do
    }
  }

  if (numRotations != 0) //need to rotate but not slide
  {
    if (curCol == 0)
    {
      slidePieceRight(piecePtr->id);
      sendRotateCommands(piecePtr);
      slidePieceLeft(piecePtr->id);
    }
    else if (curCol == 5)
    {
      slidePieceLeft(piecePtr->id);
      sendRotateCommands(piecePtr);
      slidePieceRight(piecePtr->id);
    }
    else
    {
      sendRotateCommands(piecePtr);
    }
  }
}

void PlacementTask()
{
  //get the piece out of the queue of pieces
  struct newPiece* piecePtr;
  static int i; //for for loops

  while(1)
  {
    YKEnterMutex();
    piecePtr = (struct newPiece *) YKQPend(newPieceQPtr);
    YKExitMutex();

    //set the slides and rotations to 0
    numSlides = 0;
    numRotations = 0;

    //decide what to do with the piece
    switch (piecePtr->type){
      case CORNER_PIECE:
        placeCornerPiece(piecePtr);
        break;
      case STRAIGHT_PIECE:
        //if it's not oriented flat, put it flat
        if(piecePtr->orientation == VERT)
        {
          //printString("numRotations++\n");
          numRotations++;
        }
        if (binLflat && binRflat)
        {
          if (binLlower)
          {
            numSlides -= (piecePtr->column - 1);
            //update the highest rows data to reflect where this piece will be
            binLHighestRow ++;
          }
          else
          {
            numSlides -= (piecePtr->column - 4);
            //update the highest rows data to reflect where this piece will be
            binRHighestRow ++;
          }
        }
        else if (binLflat)
        {
            numSlides -= (piecePtr->column - 1);
            //update the highest rows data to reflect where this piece will be
            binLHighestRow ++;
        }
        else if (binRflat)
        {
            numSlides -= (piecePtr->column - 4);
            //update the highest rows data to reflect where this piece will be
            binRHighestRow ++;
        }

        break;
    }
    //determine best order of sequence and send move commands through queue
    sendMoveCommands(piecePtr);
  }
}

void CommunicationTask()
{
  struct move* movePtr;
  while (1)
  {
    //  printString("comm task\n");
    YKEnterMutex();
  //  printString("comm task pending on q\n");
    movePtr = (struct move *) YKQPend(moveQPtr);
  //  printString("comm task got move cmd\n");
    YKExitMutex();
  //  printString("comm task pending on sem\n");
    YKSemPend(CmdRcvdSemPtr);
  //  printString("comm task got sem\n");

    //enter mutex?
    YKEnterMutex();
    switch (movePtr->moveType)
    {
      case SLIDE:
      /*
        printString("comm task sending slide cmd -> pieceID: ");
        printInt(movePtr->pieceID);
        printString(", dir: ");
        printInt(movePtr->direction);
        printNewLine();
      */
        SlidePiece(movePtr->pieceID, movePtr->direction);
        break;
      case ROTATE:
      /*
        printString("comm task sending rotate cmd -> pieceID: ");
        printInt(movePtr->pieceID);
        printString(", dir: ");
        printInt(movePtr->direction);
        printNewLine();
      */
        RotatePiece(movePtr->pieceID, movePtr->direction);
        break;
      default:
        printString("\n****ILLEGAL MOVE TYPE*****\n");
        break;
    }
    YKExitMutex();
  }
}

void StatTask()
{
  unsigned max, switchCount, idleCount;
  int tmp;

  YKDelayTask(1);
  printString("Welcome to the YAK kernel\r\n");
  printString("Determining CPU capacity\r\n");
  YKDelayTask(1);
  YKIdleCount = 0;
  YKDelayTask(5);
  max = YKIdleCount / 25;
  YKIdleCount = 0;

  YKNewTask(PlacementTask, (void *) &PlacementTaskStk[TASK_STACK_SIZE], 4);
  YKNewTask(CommunicationTask, (void *) &CommunicationTaskStk[TASK_STACK_SIZE], 2);

  StartSimptris();

  while (1)
  {
      YKDelayTask(20);

      YKEnterMutex();
      switchCount = YKCtxSwCount;
      idleCount = YKIdleCount;
      YKExitMutex();

      printString("<CS: ");
      printInt((int)switchCount);
      printString(", CPU: ");
      tmp = (int) (idleCount/max);
      printInt(100-tmp);
      printString("%>\r\n");

      YKEnterMutex();
      YKCtxSwCount = 0;
      YKIdleCount = 0;
      YKExitMutex();
  }
}

int main()
{
  YKInitialize();

  YKNewTask(StatTask, (void *) &StatTaskStk[TASK_STACK_SIZE], 0);

  newPieceQPtr = YKQCreate(newPieceQ, NEWPIECEQSIZE);
  moveQPtr = YKQCreate(moveQ, MOVEQSIZE);

  CmdRcvdSemPtr = YKSemCreate(1); //start at 1 so we can send a command right away

  SeedSimptris(75301); //TODO set seed

  binRflat = 1;
  binLflat = 1;

  YKRun();
}
