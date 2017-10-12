#include "clib.h"
#include "linkedList.h"

#define ASTACKSIZE 256          /* Size of each stack in words */
#define BSTACKSIZE 256
#define CSTACKSIZE 256
#define IDLESTACKSIZE 256

int AStk[ASTACKSIZE];           /* Space for each task's stack */
int BStk[BSTACKSIZE];
int CStk[CSTACKSIZE];
int IdleStk[IDLESTACKSIZE];

void ATask(void);               /* Function prototypes for task code */
void BTask(void);
void CTask(void);
void IdleTask(void);

//ARE THESE THE VALUES WE WANT?
struct context_type initContext = {
	0, //sp //this should be the bottom of the task's stack
	0, //ip //this should be the function pointer value
//	ready, //ready
	0, //ax  
	0, //bx  
	0, //cx
	0, //dx
	0, //si
	0, //di
	0, //bp //this should also be the stack
	0, //es
	0, //ds
	1 //IF
};

void ATask(void)
{

}               /* Function prototypes for task code */
void BTask(void)
{

}
void CTask(void)
{

}
void IdleTask(void)
{

}

static TCBptr a;
static TCBptr b;

//TCBptr createTCB(void *stackptr, int priority, struct context_type context)
void main()
{
	printString("****** TEST BEGIN ******\n");
	insertTCBIntoRdyList(createTCB((void *) (&(IdleStk[IDLESTACKSIZE])), 100, initContext));
	//put one tcb into the list, check to see if it's there
	a = createTCB((void *) (&(AStk[ASTACKSIZE])), 9, initContext);
	insertTCBIntoRdyList(a);
	b = createTCB((void *) (&(BStk[BSTACKSIZE])), 2, initContext);
	insertTCBIntoRdyList(b);
	printString("After inserting b into the ready list\n");
	removeFirstTCBFromRdyList();
	removeFirstTCBFromRdyList();
	printLists();
	printString("NOW remove a from the susp list back into the ready list:\n");
	moveTCBToRdyList(a);
	moveTCBToRdyList(b);
	printLists();
	printString("****** TEST END ******\n");
}