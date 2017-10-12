YKEnterMutex:
  cli
  ret

YKExitMutex:
  sti
  ret

YKDispatcher:
  ;save context of current task into its TCB
  ;restore context of new task into registers
  ;restore ip of new task, which will send us to the new task
  mov [lastRunTask], sp
  mov [YKRdyList+2], ip
  mov [YKRdyList+4], ax
  mov [YKRdyList+6], bx
  mov [YKRdyList+8], cx
  mov [YKRdyList+10], dx
  mov [YKRdyList+12], si
  mov [YKRdyList+14], di
  mov [YKRdyList+16], bp
  mov [YKRdyList+18], es
  mov [YKRdyList+20], ds
  mov [YKRdyList+22], IF
