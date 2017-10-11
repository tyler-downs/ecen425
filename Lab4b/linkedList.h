#include "yaku.h"

#define DEBUG //comment out to not include debug code

typedef enum task_state_type {ready, running, suspended} task_state;

typedef struct context_type
{
	unsigned int sp;
	unsigned int ip;
	task_state_type state;
	unsigned int ax;
	unsigned int bx;
	unsigned int cx;
	unsigned int dx;
	unsigned int si;
	unsigned int di;
	unsigned int bp;
	unsigned int es;
	unsigned int ds;
	unsigned int IF;
} context;

extern typedef struct taskblock *TCBptr;

TCBptr createTCB(void *stackptr, int priority, context_type context);

void insertTCBIntoRdyList(TCBptr tcb); //inserts the TCB into the ready list

void removeFirstTCBFromRdyList(); //removes the top TCB from ready list and puts it at top of suspended list


    /* code to remove an entry from the suspended list and insert it
       in the (sorted) ready list.  tmp points to the TCB that is to
       be moved. */
void moveTCBToRdyList(TCBptr tmp);

//test functions
#ifdef DEBUG
void printTCBs();
void printLists();
#endif
