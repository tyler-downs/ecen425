

typedef struct
{
 void** qStart;
 void** qEnd;
 void** qArray;
 int qMaxSize;
 //int qCurrentSize;
} YKQ;

int qIsEmpty(YKQ* queue); //returns true if the queue is empty
int qIsFull(YKQ* queue); //returns true if the queue is full
void** qNextInsertSpot(YKQ* queue); //returns a pointer to the next space for qStart
void** qNextRemoveSpot(YKQ* queue); //returns a pointer to the next space for qEnd
void qInsert(YKQ* queue, void* elementPtr); //inserts element pointer into the queue, assumes it's not full
void* qRemove(YKQ* queue); //removes and returns oldest element from queue, assumes it's not empty
