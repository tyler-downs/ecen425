# 1 "queue.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "queue.c"
# 1 "queue.h" 1


typedef struct
{
 void** qStart;
 void** qEnd;
 void** qArray;
 int qMaxSize;

} YKQ;

int qIsEmpty(YKQ* queue);
int qIsFull(YKQ* queue);
void** qNextInsertSpot(YKQ* queue);
void** qNextRemoveSpot(YKQ* queue);
void qInsert(YKQ* queue, void* elementPtr);
void* qRemove(YKQ* queue);
# 2 "queue.c" 2



int qIsEmpty(YKQ* queue)
{
 return (queue->qStart == queue->qEnd);
}

int qIsFull(YKQ* queue)
{
 return (qNextInsertSpot(queue) == queue->qEnd);
}

void** qNextInsertSpot(YKQ* queue)
{
 void** nextSlot = (queue->qStart) + 1;
 if (nextSlot > (queue->qArray + queue->qMaxSize - 1))
  nextSlot = queue->qArray;
 return nextSlot;
}

void** qNextRemoveSpot(YKQ* queue)
{
 void** nextSlot = (queue->qEnd) + 1;
 if (nextSlot > (queue->qArray + queue->qMaxSize - 1))
  nextSlot = queue->qArray;
 return nextSlot;
}

void qInsert(YKQ* queue, void* elementPtr)
{
 *(queue->qStart) = elementPtr;
 queue->qStart = qNextInsertSpot(queue);
}

void* qRemove(YKQ* queue)
{
 void** temp = queue->qEnd;
 queue->qEnd = qNextRemoveSpot(queue);
 return *temp;
}
