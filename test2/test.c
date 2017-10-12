#include "clib.h"
#include "linkedList.h"

#define ASTACKSIZE 256          /* Size of each stack in words */
#define BSTACKSIZE 256
#define CSTACKSIZE 256

int AStk[ASTACKSIZE];           /* Space for each task's stack */
int BStk[BSTACKSIZE];
int CStk[CSTACKSIZE];

void ATask(void);               /* Function prototypes for task code */
void BTask(void);
void CTask(void);

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


//TCBptr createTCB(void *stackptr, int priority, struct context_type context)
void main()
{
	printString("****** TEST BEGIN ******\n");
	//put one tcb into the list, check to see if it's there
	TCBptr a = createTCB((void *) &AStk[ASTACKSIZE], 1, initContext);
	insertTCBIntoRdyList(a);
	//TCBptr b = createTCB((void *) &BStk[BSTACKSIZE], 2, initContext);
	//insertTCBIntoRdyList(b);
	removeFirstTCBFromRdyList();
	printLists();
	moveTCBToRdyList(a);
	printLists();
	printString("****** TEST END ******\n");
}