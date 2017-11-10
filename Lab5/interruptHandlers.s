; Generated by c86 (BYU-NASM) 5.1 (beta) from interruptHandlers.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
L_interruptHandlers_2:
	DW	0
	ALIGN	2
resetInterruptHandler:
	; >>>>> Line:	9
	; >>>>> { 
	jmp	L_interruptHandlers_3
L_interruptHandlers_4:
	; >>>>> Line:	10
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_interruptHandlers_3:
	push	bp
	mov	bp, sp
	jmp	L_interruptHandlers_4
L_interruptHandlers_6:
	DB	"TICK ",0
	ALIGN	2
tickInterruptHandler:
	; >>>>> Line:	14
	; >>>>> { 
	jmp	L_interruptHandlers_7
L_interruptHandlers_8:
	; >>>>> Line:	15
	; >>>>> tickCount++; 
	inc	word [L_interruptHandlers_2]
	; >>>>> Line:	16
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	17
	; >>>>> printString("TICK "); 
	mov	ax, L_interruptHandlers_6
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	18
	; >>>>> printInt(tickCount); 
	push	word [L_interruptHandlers_2]
	call	printInt
	add	sp, 2
	; >>>>> Line:	19
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	21
	; >>>>> YKTickHandler(); 
	call	YKTickHandler
	mov	sp, bp
	pop	bp
	ret
L_interruptHandlers_7:
	push	bp
	mov	bp, sp
	jmp	L_interruptHandlers_8
L_interruptHandlers_13:
	DB	") IGNORED",0
L_interruptHandlers_12:
	DB	"KEYPRESS (",0
L_interruptHandlers_11:
	DB	"DELAY COMPLETE",0
L_interruptHandlers_10:
	DB	"DELAY KEY PRESSED",0
	ALIGN	2
keyboardInterruptHandler:
	; >>>>> Line:	25
	; >>>>> { 
	jmp	L_interruptHandlers_14
L_interruptHandlers_15:
	; >>>>> Line:	27
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	28
	; >>>>> if (KeyBuffer == 'd' 
	cmp	word [KeyBuffer], 100
	jne	L_interruptHandlers_16
	; >>>>> Line:	30
	; >>>>> printString("DELAY KEY PRESSED"); 
	mov	ax, L_interruptHandlers_10
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	31
	; >>>>> count = 0; 
	mov	word [bp-2], 0
	; >>>>> Line:	32
	; >>>>> while (count < 5000) 
	jmp	L_interruptHandlers_18
L_interruptHandlers_17:
	; >>>>> Line:	34
	; >>>>> count++; 
	inc	word [bp-2]
L_interruptHandlers_18:
	cmp	word [bp-2], 5000
	jl	L_interruptHandlers_17
L_interruptHandlers_19:
	; >>>>> Line:	36
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	37
	; >>>>> printString("DELAY COMPLETE"); 
	mov	ax, L_interruptHandlers_11
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	38
	; >>>>> printNewLine(); 
	call	printNewLine
	jmp	L_interruptHandlers_20
L_interruptHandlers_16:
	; >>>>> Line:	40
	; >>>>> else if (KeyBuffer == 'p') 
	cmp	word [KeyBuffer], 112
	jne	L_interruptHandlers_21
	; >>>>> Line:	42
	; >>>>> YKSemPost(NSemPtr); 
	push	word [NSemPtr]
	call	YKSemPost
	add	sp, 2
	jmp	L_interruptHandlers_22
L_interruptHandlers_21:
	; >>>>> Line:	46
	; >>>>> printString("KEYPRESS ("); 
	mov	ax, L_interruptHandlers_12
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	47
	; >>>>> printChar(KeyBuffer); 
	push	word [KeyBuffer]
	call	printChar
	add	sp, 2
	; >>>>> Line:	48
	; >>>>> printString(") IGNORED"); 
	mov	ax, L_interruptHandlers_13
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	49
	; >>>>> printNewLine(); 
	call	printNewLine
L_interruptHandlers_22:
L_interruptHandlers_20:
	mov	sp, bp
	pop	bp
	ret
L_interruptHandlers_14:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_interruptHandlers_15
	ALIGN	2
L_interruptHandlers_1:
	TIMES	512 db 0
