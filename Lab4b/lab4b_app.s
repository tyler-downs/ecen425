; Generated by c86 (BYU-NASM) 5.1 (beta) from lab4b_app.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
L_lab4b_app_2:
	DB	"Starting kernel...",0xA,0
L_lab4b_app_1:
	DB	"Creating task A...",0xA,0
	ALIGN	2
main:
	; >>>>> Line:	23
	; >>>>> { 
	jmp	L_lab4b_app_3
L_lab4b_app_4:
	; >>>>> Line:	24
	; >>>>> YKInitialize(); 
	call	YKInitialize
	; >>>>> Line:	26
	; >>>>> printString("Creating task A...\n"); 
	mov	ax, L_lab4b_app_1
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	27
	; >>>>> YKNewTask(ATask, (void *)&AStk[256], 5); 
	mov	ax, 5
	push	ax
	mov	ax, (AStk+512)
	push	ax
	mov	ax, ATask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	29
	; >>>>> printString("Starting kernel...\n"); 
	mov	ax, L_lab4b_app_2
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	30
	; >>>>> YKRun(); 
	call	YKRun
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_3:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_4
L_lab4b_app_9:
	DB	"Task A is still running! Oh no! Task A was supposed to stop.",0xA,0
L_lab4b_app_8:
	DB	"Creating task C...",0xA,0
L_lab4b_app_7:
	DB	"Creating low priority task B...",0xA,0
L_lab4b_app_6:
	DB	"Task A started!",0xA,0
	ALIGN	2
ATask:
	; >>>>> Line:	34
	; >>>>> { 
	jmp	L_lab4b_app_10
L_lab4b_app_11:
	; >>>>> Line:	35
	; >>>>> printString("Task A started!\n"); 
	mov	ax, L_lab4b_app_6
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	37
	; >>>>> printString("Creating low priority task B...\n"); 
	mov	ax, L_lab4b_app_7
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	38
	; >>>>> YKNewTask(BTask, (void *)&BStk 
	mov	ax, 7
	push	ax
	mov	ax, (BStk+512)
	push	ax
	mov	ax, BTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	40
	; >>>>> printString("Creating task C...\n"); 
	mov	ax, L_lab4b_app_8
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	41
	; >>>>> YKNewTask(CTask, (void *)&CStk[256], 2); 
	mov	ax, 2
	push	ax
	mov	ax, (CStk+512)
	push	ax
	mov	ax, CTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	43
	; >>>>> printString("Task A is still running! Oh no! Task A was supposed to stop.\n"); 
	mov	ax, L_lab4b_app_9
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	44
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_10:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_11
L_lab4b_app_13:
	DB	"Task B started! Oh no! Task B wasn't supposed to run.",0xA,0
	ALIGN	2
BTask:
	; >>>>> Line:	48
	; >>>>> { 
	jmp	L_lab4b_app_14
L_lab4b_app_15:
	; >>>>> Line:	49
	; >>>>> printString("Task B started! Oh no! Task B wasn't supposed to run.\n"); 
	mov	ax, L_lab4b_app_13
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	50
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_14:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_15
	ALIGN	2
AStk:
	TIMES	512 db 0
BStk:
	TIMES	512 db 0
CStk:
	TIMES	512 db 0
