#include "linkedList.h"
#include "clib.h"

static unsigned currentListSize = 0;
TCBptr 	YKRdyList; //points to first TCB in ready list (sorted)
TCBptr 	YKSuspList; //points to first TCB in suspended list (unsorted)

struct taskblock TCBarray[MAX_NUM_TASKS + 1]; //plus one for idle task

//TCBptr 	YKAvailTCBList;
TCBptr runningTask;

TCBptr createTCB(void *stackptr, int priority, struct context_type context)
{
	TCBarray[currentListSize].stackptr = stackptr;
	TCBarray[currentListSize].priority = priority;
	TCBarray[currentListSize].context = context;
	TCBarray[currentListSize].ID = currentListSize;
	TCBarray[currentListSize].pendingSem = 0;
	currentListSize++;
	return &(TCBarray[currentListSize-1]);
}

void insertTCBIntoRdyList(TCBptr tcb) //inserts the TCB into the ready list
{
	TCBptr tmp;
	if (YKRdyList == NULL) //first insertion
	{
		YKRdyList = tcb;
		tcb->next = NULL;
		tcb->prev = NULL;
	}
	else
	{
		tmp = YKRdyList;
		while (tmp->priority < tcb->priority) //find position in sorted array
			tmp = tmp->next; //ASSUMES IDLE TASK IS AT END
		if (tmp->prev == NULL) //insert before tmp
		{
			YKRdyList = tcb;
			/*printString("TCB id = ");
			printInt(tcb->ID);
			printString("\nYKRdyList = ");
			printInt((int) YKRdyList);
			printNewLine();*/
		}
		else
			tmp->prev->next = tcb;
		tcb->prev = tmp->prev;
		tcb->next = tmp;
		tmp->prev = tcb;
	}
}

void removeFirstTCBFromRdyList() //removes the top TCB from ready list and puts it at top of suspended list
{
	TCBptr tmp;
	tmp = YKRdyList;		/* get ptr to TCB to change */
    YKRdyList = tmp->next;	/* remove from ready list */
    tmp->next->prev = NULL;	/* ready list is never empty */
    tmp->next = YKSuspList;	/* put at head of delayed list */
    YKSuspList = tmp;
    tmp->prev = NULL;
    if (tmp->next != NULL)	/* susp list may be empty */
		tmp->next->prev = tmp;
}

    /* code to remove an entry from the suspended list and insert it
       in the (sorted) ready list.  tmp points to the TCB that is to
       be moved. */
void moveTCBToRdyList(TCBptr tmp)
{
	TCBptr tmp2;

    if (tmp->prev == NULL)	/* fix up suspended list */
			YKSuspList = tmp->next;
    else
			tmp->prev->next = tmp->next;
    if (tmp->next != NULL)
			tmp->next->prev = tmp->prev;

    tmp2 = YKRdyList;		/* put in ready list (idle task always at end) */

		while (tmp2->priority < tmp->priority)
			tmp2 = tmp2->next;
    if (tmp2->prev == NULL)	/* insert before TCB pointed to by tmp2 */
			YKRdyList = tmp;
    else
			tmp2->prev->next = tmp;
    tmp->prev = tmp2->prev;
    tmp->next = tmp2;
    tmp2->prev = tmp;
}

//TEST FUNCTIONS
#ifdef DEBUG
void printContext(struct context_type c)
{
	printString("\n  sp: ");
	printInt(c.sp);
	printString("\n  ip: ");
	printInt(c.ip);
	/*printString("\n  state: ");
	switch(c.state)
	{
		case ready:
			printString("Ready");
			break;
		case running:
			printString("Running");
			break;
		case suspended:
			printString("Suspended");
			break;
	}*/
	printString("\n  ax: ");
	printInt(c.ax);
	printString("\n  bx: ");
	printInt(c.bx);
	printString("\n  cx: ");
	printInt(c.cx);
	printString("\n  dx: ");
	printInt(c.dx);
	printString("\n  si: ");
	printInt(c.si);
	printString("\n  di: ");
	printInt(c.di);
	printString("\n  bp: ");
	printInt(c.bp);
	printString("\n  es: ");
	printInt(c.es);
	printString("\n  ds: ");
	printInt(c.ds);
	printString("\n  flags: ");
	printInt(c.flags);
	printString("\n\n");
}

//unsigned int IF; //TODO: what is this?
void printTCB(TCBptr t)
{
	printString("  ID: ");
	printInt(t->ID);
	printString("\n  Priority: ");
	printInt(t->priority);
	printString("\n  Delay: ");
	printInt(t->delay);
	printContext(t->context);
}

void printTCBs()
{
	unsigned i;
	for (i = 0; i < currentListSize; i++)
	{
		printString("TCB ");
		printInt(i);
		printNewLine();
		printTCB(&TCBarray[i]);
	}
}
void printLists()
{
	//print ready list
	TCBptr tmp = YKRdyList;
	printString("Ready list: \n");
	while (tmp != NULL)
	{
		printTCB(tmp);
		tmp = tmp->next;
	}

	//print suspended list
	tmp = YKSuspList;
	printString("Suspended list: \n");
	while (tmp != NULL)
	{
		printTCB(tmp);
		tmp = tmp->next;
	}
}
#endif
