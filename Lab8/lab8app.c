#include "clib.h"
#include "yakk.h"                     /* contains kernel definitions */
#include "lab8defs.h"
#include "simptris.h"

#define TASK_STACK_SIZE   512         /* stack size in words */
#define NEWPIECEQSIZE           5
#define MOVEQSIZE 20

int PlacementTaskStk[TASK_STACK_SIZE];     /* a stack for each task */
int CommunicationTaskStk[TASK_STACK_SIZE];
int StatTaskStk[TASK_STACK_SIZE];

//buffers for queue content
struct newPiece newPieceArray[NEWPIECEARRAYSIZE];
struct move moveArray[MOVEARRAYSIZE];

void* newPieceQ[NEWPIECEQSIZE];           /* space for newPiece queue */
YKQ* newPieceQPtr;                   /* actual name of queue */
void* moveQ[MOVEQSIZE];
YKQ* moveQPtr;

YKSEM *CmdRcvdSemPtr;

void PlacementTask()
{
  
}

void CommunicationTask()
{
  struct move* movePtr;
  YKEnterMutex();
  movePtr = (struct move *) YKQPend(moveQPtr);
  YKExitMutex();
  YKSemPend(CmdRcvdSemPtr);

  //enter mutex?
  YKEnterMutex();
  switch (movePtr->moveType)
  {
    case SLIDE:
      SlidePiece(movePtr->pieceID, movePtr->direction);
      break;
    case ROTATE:
      RotatePiece(movePtr->pieceID, movePtr->direction);
      break;
    default:
      printString("\n****ILLEGAL MOVE TYPE*****\n");
      break;
  }
  YKExitMutex();
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

  SeedSimptris(0); //TODO set seed

  YKRun();
}
