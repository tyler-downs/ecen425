; Generated by c86 (BYU-NASM) 5.1 (beta) from test.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
initContext:
	DW	0,0,0,0,0
	DW	0,0,0,0,0
	DW	0,1
	ALIGN	2
ATask:
	; >>>>> Line:	34
	; >>>>> { 
	jmp	L_test_3
L_test_4:
	; >>>>> Line:	36
	; >>>>> } 
	mov	sp, bp
	pop	bp
	ret
L_test_3:
	push	bp
	mov	bp, sp
	jmp	L_test_4
	ALIGN	2
BTask:
	; >>>>> Line:	38
	; >>>>> { 
	jmp	L_test_6
L_test_7:
	; >>>>> Line:	40
	; >>>>> } 
	mov	sp, bp
	pop	bp
	ret
L_test_6:
	push	bp
	mov	bp, sp
	jmp	L_test_7
	ALIGN	2
CTask:
	; >>>>> Line:	42
	; >>>>> { 
	jmp	L_test_9
L_test_10:
	; >>>>> Line:	44
	; >>>>> } 
	mov	sp, bp
	pop	bp
	ret
L_test_9:
	push	bp
	mov	bp, sp
	jmp	L_test_10
	ALIGN	2
L_test_1:
	TIMES	2 db 0
L_test_2:
	TIMES	2 db 0
AStk:
	TIMES	512 db 0
BStk:
	TIMES	512 db 0
CStk:
	TIMES	512 db 0
