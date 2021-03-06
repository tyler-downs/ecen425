; Generated by c86 (BYU-NASM) 5.1 (beta) from lab4b_app.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
main:
	; >>>>> Line:	36
	; >>>>> { 
	jmp	L_lab4b_app_4
L_lab4b_app_5:
	; >>>>> Line:	37
	; >>>>> YKInitialize(); 
	call	YKInitialize
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_4:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_5
L_lab4b_app_10:
	DB	"Task A is still running! Oh no! Task A was supposed to stop.",0xA,0
L_lab4b_app_9:
	DB	"Creating task C...",0xA,0
L_lab4b_app_8:
	DB	"Creating low priority task B...",0xA,0
L_lab4b_app_7:
	DB	"Task A started!",0xA,0
	ALIGN	2
ATask:
	; >>>>> Line:	42
	; >>>>> { 
	jmp	L_lab4b_app_11
L_lab4b_app_12:
	; >>>>> Line:	43
	; >>>>> printString("Task A started!\n"); 
	mov	ax, L_lab4b_app_7
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	45
	; >>>>> printString("Creating low priority task B...\n"); 
	mov	ax, L_lab4b_app_8
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	46
	; >>>>> YKNewTask(BTask, (void *)&BStk[256], 7); 
	mov	al, 7
	push	ax
	mov	ax, (BStk+512)
	push	ax
	mov	ax, BTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	48
	; >>>>> printString("Creating task C...\n"); 
	mov	ax, L_lab4b_app_9
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	49
	; >>>>> YKNewTask(CTask, (void *)&CStk[256], 2); 
	mov	al, 2
	push	ax
	mov	ax, (CStk+512)
	push	ax
	mov	ax, CTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	51
	; >>>>> printString("Task A is still running! Oh no! Task A was supposed to stop.\n"); 
	mov	ax, L_lab4b_app_10
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	52
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_11:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_12
L_lab4b_app_14:
	DB	"Task B started! Oh no! Task B wasn't supposed to run.",0xA,0
	ALIGN	2
BTask:
	; >>>>> Line:	56
	; >>>>> { 
	jmp	L_lab4b_app_15
L_lab4b_app_16:
	; >>>>> Line:	57
	; >>>>> printString("Task B started! Oh no! Task B wasn't supposed to run.\n"); 
	mov	ax, L_lab4b_app_14
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	58
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_15:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_16
L_lab4b_app_20:
	DB	"Executing in task C.",0xA,0
L_lab4b_app_19:
	DB	" context switches!",0xA,0
L_lab4b_app_18:
	DB	"Task C started after ",0
	ALIGN	2
CTask:
	; >>>>> Line:	62
	; >>>>> { 
	jmp	L_lab4b_app_21
L_lab4b_app_22:
	; >>>>> Line:	66
	; >>>>>  
	call	YKEnterMutex
	; >>>>> Line:	67
	; >>>>> numCtxSwitches = YKCtxSwCount; 
	mov	ax, word [YKCtxSwCount]
	mov	word [bp-4], ax
	; >>>>> Line:	68
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	70
	; >>>>> printString("Task C started after "); 
	mov	ax, L_lab4b_app_18
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	71
	; >>>>> printUInt(numCtxSwitches); 
	push	word [bp-4]
	call	printUInt
	add	sp, 2
	; >>>>> Line:	72
	; >>>>> printString(" context switches!\n"); 
	mov	ax, L_lab4b_app_19
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	74
	; >>>>> while (1) 
	jmp	L_lab4b_app_24
L_lab4b_app_23:
	; >>>>> Line:	76
	; >>>>> printString("Executing in task C.\n"); 
	mov	ax, L_lab4b_app_20
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	77
	; >>>>> for(count = 0; count < 5000; count++); 
	mov	word [bp-2], 0
	jmp	L_lab4b_app_27
L_lab4b_app_26:
L_lab4b_app_29:
	inc	word [bp-2]
L_lab4b_app_27:
	cmp	word [bp-2], 5000
	jl	L_lab4b_app_26
L_lab4b_app_28:
L_lab4b_app_24:
	jmp	L_lab4b_app_23
L_lab4b_app_25:
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_21:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_lab4b_app_22
	ALIGN	2
L_lab4b_app_1:
	TIMES	2 db 0
L_lab4b_app_2:
	TIMES	2 db 0
L_lab4b_app_3:
	TIMES	512 db 0
AStk:
	TIMES	512 db 0
BStk:
	TIMES	512 db 0
CStk:
	TIMES	512 db 0
