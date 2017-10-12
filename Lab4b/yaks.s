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



  mov [lastRunTask+4], ax
  mov [lastRunTask+6], bx
  mov [lastRunTask+8], cx
  mov [lastRunTask+10], dx

  pop ax
  mov [lastRunTask+2], ax ;this is the ip
  mov [lastRunTask], sp
  mov [lastRunTask+12], si
  mov [lastRunTask+14], di
  mov [lastRunTask+16], bp
  mov [lastRunTask+18], es
  mov [lastRunTask+20], ds
  mov [lastRunTask+22], cs

  pushf
  pop ax
  mov [lastRunTask+24], ax


  ;assign lastRunTask to the value of YKRdyList
  mov ax, [YKRdyList]
  mov [lastRunTask], ax

  ;restore the context of the new task into the registers 
  ;this new task is at the top of YKRdyList

  mov bx, [YKRdyList+6]
  mov cx, [YKRdyList+8]
  mov dx, [YKRdyList+10]
  mov si, [YKRdyList+12]
  mov di, [YKRdyList+14]
  mov bp, [YKRdyList+16]
  mov es, [YKRdyList+18]
  mov ds, [YKRdyList+20]
  mov sp, [YKRdyList]



  mov ax, [YKRdyList+24]
  push ax                 ;pushes flags to the stack
  mov ax, [YKRdyList+22] 
  push ax                 ;pushes cs to the stack
  mov ax, [YKRdyList+2]
  push ax                 ;pushes the ip onto the stack


 
  mov ax, [YKRdyList+4]   ; restore the actual ax
  

  iret  ;return using iret


  
