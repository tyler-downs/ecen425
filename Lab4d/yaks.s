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


  cli     ;disable interrupts

  push bp
  push bx

  mov bx, [lastRunTask]

  mov [bx+4], ax
  mov [bx+8], cx
  mov [bx+10], dx

  mov [bx], sp
  mov [bx+12], si
  mov [bx+14], di


  mov [bx+18], es
  mov [bx+20], ds
  mov [bx+22], cs

  mov bp, bx
  pop bx
  mov [bp+6], bx
  mov bx, bp
  pop bp
  mov [bx+16], bp

  pushf
  pop ax
  mov [bx+24], ax

  pop ax
  mov [bx+2], ax ;this is the ip


  ;assign lastRunTask to the value of YKRdyList
  mov ax, [YKRdyList]
  mov [lastRunTask], ax

  ;restore the context of the new task into the registers
  ;this new task is at the top of YKRdyList

  mov bx, word[YKRdyList]

  mov sp, word [bx] ;sp
  mov ax, word[bx+4]
  mov cx, word[bx+8]
  mov dx, word[bx+10]

  mov di, word[bx+14]
  mov bp, word[bx+16]
  mov es, word[bx+18]
  mov ds, word[bx+20]


  mov si, [bx+24]
  push si                 ;pushes flags to the stack
  mov si, [bx+22]
  push si                 ;pushes cs to the stack
  mov si, [bx+2]
  push si                 ;pushes the ip onto the stack

  mov si, word[bx+12]
  mov bx, word[bx+6]
  sti
  iret  ;return using iret



;YKFirstDispatcher(): dispatches when you dont need to save context
; i.e. when YKRun calls the scheduler

YKFirstDispatcher:
  
  cli ;disable interrupts  

  ;assign lastRunTask to the value of YKRdyList
  mov ax, [YKRdyList]
  mov [lastRunTask], ax

  ;restore the context of the new task into the registers
  ;this new task is at the top of YKRdyList

  mov bx, word[YKRdyList]

  mov sp, word [bx] ;sp
  mov ax, word[bx+4]
  mov cx, word[bx+8]
  mov dx, word[bx+10]

  mov di, word[bx+14]
  mov bp, word[bx+16]
  mov es, word[bx+18]
  mov ds, word[bx+20]


  mov si, [bx+24]
  push si                 ;pushes flags to the stack
  mov si, [bx+22]
  push si                 ;pushes cs to the stack
  mov si, [bx+2]
  push si                 ;pushes the ip onto the stack

  mov si, word[bx+12]
  mov bx, word[bx+6]
  sti
  iret  ;return using iret