#include "yaku.h"

#define DEBUG //comment out to not include debug code

//enum task_state_type {ready, running, suspended};


struct context_type //13 16-bit values = 26 bytes
{
	unsigned sp;		//0
	unsigned int ip;		//2
	//enum task_state_type state;
	unsigned int ax;		//4
	unsigned int bx;		//6
	unsigned int cx;		//8
	unsigned int dx;		//10
	unsigned int si;		//12
	unsigned int di;		//14
	unsigned int bp;		//16
	unsigned int es;		//18
	unsigned int ds;		//20
	unsigned int cs;		//22
	unsigned int flags;		//24
};

typedef struct taskblock *TCBptr;
//typedef struct taskblock *TCBptr;
typedef struct taskblock //38 bytes in total (26<-context + 12<-other stuff)
{
	struct context_type context;
	void *stackptr;
	unsigned priority;
	int delay;
	TCBptr next;
	TCBptr prev;
	unsigned ID;
} TCB;

extern TCBptr 	YKRdyList; //points to first TCB in ready list (sorted)
extern TCBptr 	YKSuspList; //points to first TCB in suspended list (unsorted)

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
