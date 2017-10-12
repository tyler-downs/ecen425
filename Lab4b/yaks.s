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
  ;mov [lastRunTask], sp
  ;mov [lastRunTask+2], ip
  ;mov [lastRunTask+4], ax
  ;mov [lastRunTask+6], bx
  ;mov [lastRunTask+8], cx
  ;mov [lastRunTask+10], dx
  ;mov [lastRunTask+12], si
  ;mov [lastRunTask+14], di
  ;mov [lastRunTask+16], bp
  ;mov [lastRunTask+18], es
  ;mov [lastRunTask+20], ds
  ;mov [lastRunTask+22], IF

  ;assign lastRunTask to the value of YKRdyList
  ;mov ax, [YKRdyList]
  ;mov [lastRunTask], ax

  ;restore the context of the new task into the registers NOT DONE!!!!!!
  
