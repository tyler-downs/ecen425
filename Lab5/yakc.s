; Generated by c86 (BYU-NASM) 5.1 (beta) from yakc.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
YKIdleCount:
	DW	0
running_flag:
	DW	0
ISRCallDepth:
	DW	0
lastRunTask:
	DW	0
YKCtxSwCount:
	DW	0
YKTickNum:
	DW	0
firstTime:
	DW	1
currentNumSemaphores:
	DW	0
initContext:
	DW	0,0,0,0,0
	DW	0,0,0,0,0
	DW	0,0,512
L_yakc_2:
	DB	0xA,"************* BEGIN ***************",0xA,0xA,0
	ALIGN	2
YKInitialize:
	; >>>>> Line:	34
	; >>>>> { 
	jmp	L_yakc_3
L_yakc_4:
	; >>>>> Line:	35
	; >>>>> TCB->context.i 
	mov	ax, L_yakc_2
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	37
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	40
	; >>>>> YKNewTask(YKIdleTask, (void *) &IdleStk[256], 100); 
	mov	al, 100
	push	ax
	mov	ax, (L_yakc_1+512)
	push	ax
	mov	ax, YKIdleTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	42
	; >>>>> lastRunTask = YKRdyList; 
	mov	ax, word [YKRdyList]
	mov	word [lastRunTask], ax
	mov	sp, bp
	pop	bp
	ret
L_yakc_3:
	push	bp
	mov	bp, sp
	jmp	L_yakc_4
L_yakc_6:
	DB	"Entering idle task",0xA,0xD,0
	ALIGN	2
YKIdleTask:
	; >>>>> Line:	46
	; >>>>> { 
	jmp	L_yakc_7
L_yakc_8:
	; >>>>> Line:	47
	; >>>>> printString("Entering idle task\n\r"); 
	mov	ax, L_yakc_6
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	48
	; >>>>> while(1) 
	jmp	L_yakc_10
L_yakc_9:
	; >>>>> Line:	51
	; >>>>> tmp = YKIdleCount + 1; 
	mov	ax, word [YKIdleCount]
	inc	ax
	mov	word [bp-2], ax
	; >>>>> Line:	52
	; >>>>> YKIdleCount = tmp; 
	mov	ax, word [bp-2]
	mov	word [YKIdleCount], ax
L_yakc_10:
	jmp	L_yakc_9
L_yakc_11:
	mov	sp, bp
	pop	bp
	ret
L_yakc_7:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_8
	ALIGN	2
YKNewTask:
	; >>>>> Line:	62
	; >>>>> { 
	jmp	L_yakc_13
L_yakc_14:
	; >>>>> Line:	70
	; >>>>> newTCB = createTCB(taskStack, priority, initContext); 
	sub	sp, 26
	mov	di, sp
	mov	si, initContext
	mov	cx, 13
	rep
	movsw
	mov	al, byte [bp+8]
	xor	ah, ah
	push	ax
	push	word [bp+6]
	call	createTCB
	add	sp, 30
	mov	word [bp-2], ax
	; >>>>> Line:	72
	; >>>>> newTCB->context.sp = (int)(taskStack); 
	mov	si, word [bp-2]
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	73
	; >>>>> newTCB->context.i 
	mov	si, word [bp-2]
	add	si, 2
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	74
	; >>>>> newTCB->context.bp = (int)taskStack; 
	mov	si, word [bp-2]
	add	si, 16
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	75
	; >>>>> insertTCBIntoRdyList(newTCB); 
	push	word [bp-2]
	call	insertTCBIntoRdyList
	add	sp, 2
	; >>>>> Line:	79
	; >>>>> if (running_flag) 
	mov	ax, word [running_flag]
	test	ax, ax
	je	L_yakc_15
	; >>>>> Line:	81
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_15:
	mov	sp, bp
	pop	bp
	ret
L_yakc_13:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_14
	ALIGN	2
YKRun:
	; >>>>> Line:	86
	; >>>>> { 
	jmp	L_yakc_17
L_yakc_18:
	; >>>>> Line:	89
	; >>>>> running_flag = 1; 
	mov	word [running_flag], 1
	; >>>>> Line:	92
	; >>>>> YKScheduler(); 
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakc_17:
	push	bp
	mov	bp, sp
	jmp	L_yakc_18
	ALIGN	2
YKDelayTask:
	; >>>>> Line:	96
	; >>>>> { 
	jmp	L_yakc_20
L_yakc_21:
	; >>>>> Line:	101
	; >>>>> if (count == 0) 
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_yakc_22
	; >>>>> Line:	102
	; >>>>> return; 
	jmp	L_yakc_23
L_yakc_22:
	; >>>>> Line:	107
	; >>>>> YKRdyList->delay = count; 
	mov	si, word [YKRdyList]
	add	si, 30
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	108
	; >>>>> removeFirstTCBFromRdyList(); 
	call	removeFirstTCBFromRdyList
	; >>>>> Line:	112
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_23:
	mov	sp, bp
	pop	bp
	ret
L_yakc_20:
	push	bp
	mov	bp, sp
	jmp	L_yakc_21
	ALIGN	2
YKEnterISR:
	; >>>>> Line:	116
	; >>>>> { 
	jmp	L_yakc_25
L_yakc_26:
	; >>>>> Line:	120
	; >>>>> ISRCallDepth++; 
	inc	word [ISRCallDepth]
	mov	sp, bp
	pop	bp
	ret
L_yakc_25:
	push	bp
	mov	bp, sp
	jmp	L_yakc_26
	ALIGN	2
YKExitISR:
	; >>>>> Line:	124
	; >>>>> { 
	jmp	L_yakc_28
L_yakc_29:
	; >>>>> Line:	128
	; >>>>> ISRCallDepth--; 
	dec	word [ISRCallDepth]
	; >>>>> Line:	129
	; >>>>> if (ISRCallDepth == 0) 
	mov	ax, word [ISRCallDepth]
	test	ax, ax
	jne	L_yakc_30
	; >>>>> Line:	130
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_30:
	mov	sp, bp
	pop	bp
	ret
L_yakc_28:
	push	bp
	mov	bp, sp
	jmp	L_yakc_29
	ALIGN	2
YKScheduler:
	; >>>>> Line:	134
	; >>>>> { 
	jmp	L_yakc_32
L_yakc_33:
	; >>>>> Line:	139
	; >>>>> tmp = tm 
	call	YKEnterMutex
	; >>>>> Line:	140
	; >>>>> if (firstTime) 
	mov	ax, word [firstTime]
	test	ax, ax
	je	L_yakc_34
	; >>>>> Line:	142
	; >>>>> firstTime = 0; 
	mov	word [firstTime], 0
	; >>>>> Line:	144
	; >>>>> YKCtxSwCount++; 
	inc	word [YKCtxSwCount]
	; >>>>> Line:	146
	; >>>>> YKFirstDispatcher(); 
	call	YKFirstDispatcher
	jmp	L_yakc_35
L_yakc_34:
	; >>>>> Line:	148
	; >>>>> else if (lastRunTask != YKRdyList) 
	mov	ax, word [YKRdyList]
	cmp	ax, word [lastRunTask]
	je	L_yakc_36
	; >>>>> Line:	151
	; >>>>> YKCtxSwCount++; 
	inc	word [YKCtxSwCount]
	; >>>>> Line:	153
	; >>>>> YKDispatcher(); 
	call	YKDispatcher
L_yakc_36:
L_yakc_35:
	mov	sp, bp
	pop	bp
	ret
L_yakc_32:
	push	bp
	mov	bp, sp
	jmp	L_yakc_33
	ALIGN	2
YKTickHandler:
	; >>>>> Line:	159
	; >>>>> { 
	jmp	L_yakc_38
L_yakc_39:
	; >>>>> Line:	168
	; >>>>> tmp = YKSuspList; 
	mov	ax, word [YKSuspList]
	mov	word [bp-2], ax
	; >>>>> Line:	173
	; >>>>> printString("\n"); 
	mov	ax, (L_yakc_2+37)
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	175
	; >>>>> while(tmp != 0) 
	jmp	L_yakc_41
L_yakc_40:
	; >>>>> Line:	177
	; >>>>> if (tmp->delay > 0) 
	mov	si, word [bp-2]
	add	si, 30
	cmp	word [si], 0
	jle	L_yakc_43
	; >>>>> Line:	179
	; >>>>> (tmp->delay)--; 
	mov	si, word [bp-2]
	add	si, 30
	dec	word [si]
	; >>>>> Line:	180
	; >>>>> if (tmp->delay == 0) 
	mov	si, word [bp-2]
	add	si, 30
	mov	ax, word [si]
	test	ax, ax
	jne	L_yakc_44
	; >>>>> Line:	182
	; >>>>> tmp2 = tmp; 
	mov	ax, word [bp-2]
	mov	word [bp-4], ax
	; >>>>> Line:	183
	; >>>>> tmp = tmp->next; 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	185
	; >>>>> moveTCBToRdyList(tmp2); 
	push	word [bp-4]
	call	moveTCBToRdyList
	add	sp, 2
	jmp	L_yakc_45
L_yakc_44:
	; >>>>> Line:	188
	; >>>>> tmp = tmp->next; 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	mov	word [bp-2], ax
L_yakc_45:
	jmp	L_yakc_46
L_yakc_43:
	; >>>>> Line:	191
	; >>>>> tmp = tm 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	mov	word [bp-2], ax
L_yakc_46:
L_yakc_41:
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_40
L_yakc_42:
	; >>>>> Line:	193
	; >>>>> YKTickNum++; 
	inc	word [YKTickNum]
	mov	sp, bp
	pop	bp
	ret
L_yakc_38:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_39
	ALIGN	2
YKSemCreate:
	; >>>>> Line:	198
	; >>>>> { 
	jmp	L_yakc_48
L_yakc_49:
	; >>>>> Line:	201
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	202
	; >>>>> sem = &(SemArray[currentNumSemaphores]); 
	mov	ax, word [currentNumSemaphores]
	shl	ax, 1
	add	ax, SemArray
	mov	word [bp-2], ax
	; >>>>> Line:	203
	; >>>>> sem->value = initialValue; 
	mov	si, word [bp-2]
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	205
	; >>>>> currentNumSemaphores++; 
	inc	word [currentNumSemaphores]
	; >>>>> Line:	206
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	207
	; >>>>> return sem; 
	mov	ax, word [bp-2]
L_yakc_50:
	mov	sp, bp
	pop	bp
	ret
L_yakc_48:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakc_49
	ALIGN	2
YKSemPend:
	; >>>>> Line:	213
	; >>>>> { 
	jmp	L_yakc_52
L_yakc_53:
	; >>>>> Line:	214
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	220
	; >>>>> if (semaphore->value > 0) 
	mov	si, word [bp+4]
	cmp	word [si], 0
	jle	L_yakc_54
	; >>>>> Line:	223
	; >>>>> (semaphore->value)--; 
	dec	word [si]
	jmp	L_yakc_55
L_yakc_54:
	; >>>>> Line:	229
	; >>>>> (semaphore->value)--; 
	mov	si, word [bp+4]
	dec	word [si]
	; >>>>> Line:	230
	; >>>>> YKRdyList->pendingSem = semaphore; 
	mov	si, word [YKRdyList]
	add	si, 38
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	232
	; >>>>> removeFirstTCBFromRdyList(); 
	call	removeFirstTCBFromRdyList
	; >>>>> Line:	234
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_55:
	; >>>>> Line:	236
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	mov	sp, bp
	pop	bp
	ret
L_yakc_52:
	push	bp
	mov	bp, sp
	jmp	L_yakc_53
	ALIGN	2
YKSemPost:
	; >>>>> Line:	241
	; >>>>> { 
	jmp	L_yakc_57
L_yakc_58:
	; >>>>> Line:	244
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	250
	; >>>>> (semaphore->value)++; 
	mov	si, word [bp+4]
	inc	word [si]
	; >>>>> Line:	262
	; >>>>> tmp = YKSuspList; 
	mov	ax, word [YKSuspList]
	mov	word [bp-2], ax
	; >>>>> Line:	263
	; >>>>> while(tmp != 0) 
	jmp	L_yakc_60
L_yakc_59:
	; >>>>> Line:	266
	; >>>>> if (tmp->pendingSem == semaphore){ 
	mov	si, word [bp-2]
	add	si, 38
	mov	ax, word [bp+4]
	cmp	ax, word [si]
	jne	L_yakc_62
	; >>>>> Line:	267
	; >>>>> tmp->pendingSem = 0; 
	mov	si, word [bp-2]
	add	si, 38
	mov	word [si], 0
	; >>>>> Line:	271
	; >>>>> tmp2 = tmp; 
	mov	ax, word [bp-2]
	mov	word [bp-4], ax
	; >>>>> Line:	272
	; >>>>> tmp = tmp->next; 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	273
	; >>>>> moveTCBToRdyList(tmp2); 
	push	word [bp-4]
	call	moveTCBToRdyList
	add	sp, 2
	jmp	L_yakc_63
L_yakc_62:
	; >>>>> Line:	277
	; >>>>> tmp = tmp->next; 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	mov	word [bp-2], ax
L_yakc_63:
L_yakc_60:
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_yakc_59
L_yakc_61:
	; >>>>> Line:	283
	; >>>>> if (ISRCallDepth <= 0) 
	mov	ax, word [ISRCallDepth]
	test	ax, ax
	jne	L_yakc_64
	; >>>>> Line:	287
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakc_64:
L_yakc_65:
	; >>>>> Line:	294
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	mov	sp, bp
	pop	bp
	ret
L_yakc_57:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakc_58
	ALIGN	2
L_yakc_1:
	TIMES	512 db 0
SemArray:
	TIMES	12 db 0
