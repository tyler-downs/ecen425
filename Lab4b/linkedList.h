#include "yaku.h"

#define DEBUG //comment out to not include debug code

//enum task_state_type {ready, running, suspended};


struct context_type //12 16-bit values = 24 bytes
{
	unsigned int sp;
	unsigned int ip;
	//enum task_state_type state;
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
};

typedef struct taskblock *TCBptr;
//typedef struct taskblock *TCBptr;
typedef struct taskblock //36 bytes in total (24<-context + 12<-other stuff)
{
	struct context_type context;
	void *stackptr;
	unsigned priority;
	int delay;
	TCBptr next;
	TCBptr prev;
	unsigned ID;
} TCB;

static TCBptr 	YKRdyList; //points to first TCB in ready list (sorted)
static TCBptr 	YKSuspList; //points to first TCB in suspended list (unsorted)

TCBptr createTCB(void *stackptr, int priority, struct context_type context);

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
