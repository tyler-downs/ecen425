#include "queue.h"

//**the queue will leave one empty spot in the array

int qIsEmpty(YKQ* queue) //returns true if the queue is empty
{
	return (queue->qStart == queue->qEnd);
}

int qIsFull(YKQ* queue) //returns true if the queue is full
{
	return (qNextInsertSpot(queue) == queue->qEnd);
}

void** qNextInsertSpot(YKQ* queue) //returns a pointer to the next space for qStart
{
	void** nextSlot = (queue->qStart) + 1;
	if (nextSlot > (queue->qArray + queue->qMaxSize - 1))
		nextSlot = queue->qArray;
	return nextSlot;
}

void** qNextRemoveSpot(YKQ* queue) //returns a pointer to the next space for qEnd
{
	void** nextSlot = (queue->qEnd) + 1;
	if (nextSlot > (queue->qArray + queue->qMaxSize - 1))
		nextSlot = queue->qArray;
	return nextSlot;
}

void qInsert(YKQ* queue, void* elementPtr) //inserts element pointer into the queue, assumes it's not full
{
	*(queue->qStart) = elementPtr;
	queue->qStart = qNextInsertSpot(queue);
}

void* qRemove(YKQ* queue) //removes and returns oldest element from queue, assumes it's not empty
{
	void** temp = queue->qEnd;
	queue->qEnd = qNextRemoveSpot(queue);
	return *temp;
}
