; Generated by c86 (BYU-NASM) 5.1 (beta) from linkedList.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
L_linkedList_1:
	DW	0
	ALIGN	2
createTCB:
	; >>>>> Line:	15
	; >>>>> { 
	jmp	L_linkedList_2
L_linkedList_3:
	; >>>>> Line:	16
	; >>>>> TCBarray[currentListSize].stackptr = stackptr; 
	mov	ax, word [L_linkedList_1]
	mov	cx, 38
	imul	cx
	add	ax, TCBarray
	mov	si, ax
	add	si, 26
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	17
	; >>>>> TCBarray[currentListSize].priority = priority; 
	mov	ax, word [L_linkedList_1]
	mov	cx, 38
	imul	cx
	add	ax, TCBarray
	mov	si, ax
	add	si, 28
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	18
	; >>>>> TCBarray[currentListSize].context = context; 
	lea	ax, [bp+8]
	mov	word [bp-2], ax
	mov	ax, word [L_linkedList_1]
	mov	cx, 38
	imul	cx
	add	ax, TCBarray
	mov	word [bp-4], ax
	mov	di, word [bp-4]
	mov	si, word [bp-2]
	mov	cx, 13
	rep
	movsw
	; >>>>> Line:	19
	; >>>>> TCBarray[currentListSize].ID = currentListSize; 
	mov	ax, word [L_linkedList_1]
	mov	cx, 38
	imul	cx
	add	ax, TCBarray
	mov	si, ax
	add	si, 36
	mov	ax, word [L_linkedList_1]
	mov	word [si], ax
	; >>>>> Line:	20
	; >>>>> currentListSize++; 
	inc	word [L_linkedList_1]
	; >>>>> Line:	21
	; >>>>> return &(TCBarray[currentListSize-1]); 
	mov	ax, word [L_linkedList_1]
	dec	ax
	mov	cx, 38
	imul	cx
	add	ax, TCBarray
L_linkedList_4:
	mov	sp, bp
	pop	bp
	ret
L_linkedList_2:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_linkedList_3
	ALIGN	2
insertTCBIntoRdyList:
	; >>>>> Line:	25
	; >>>>> { 
	jmp	L_linkedList_6
L_linkedList_7:
	; >>>>> Line:	28
	; >>>>> if (YKRdyList == 0) 
	mov	ax, word [YKRdyList]
	test	ax, ax
	jne	L_linkedList_8
	; >>>>> Line:	30
	; >>>>> YKRdyList = tcb; 
	mov	ax, word [bp+4]
	mov	word [YKRdyList], ax
	; >>>>> Line:	31
	; >>>>> tcb->next = 0; 
	mov	si, word [bp+4]
	add	si, 32
	mov	word [si], 0
	; >>>>> Line:	32
	; >>>>> tcb->prev = 0; 
	mov	si, word [bp+4]
	add	si, 34
	mov	word [si], 0
	jmp	L_linkedList_9
L_linkedList_8:
	; >>>>> Line:	36
	; >>>>> tmp = YKRdyList; 
	mov	ax, word [YKRdyList]
	mov	word [bp-2], ax
	; >>>>> Line:	37
	; >>>>> while (tmp->priority < tcb->priority) 
	jmp	L_linkedList_11
L_linkedList_10:
	; >>>>> Line:	38
	; >>>>> tmp = tmp->next; 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	mov	word [bp-2], ax
L_linkedList_11:
	mov	si, word [bp-2]
	add	si, 28
	mov	di, word [bp+4]
	add	di, 28
	mov	ax, word [di]
	cmp	ax, word [si]
	ja	L_linkedList_10
L_linkedList_12:
	; >>>>> Line:	39
	; >>>>> if (tmp->prev == 0) 
	mov	si, word [bp-2]
	add	si, 34
	mov	ax, word [si]
	test	ax, ax
	jne	L_linkedList_13
	; >>>>> Line:	41
	; >>>>>  
	mov	ax, word [bp+4]
	mov	word [YKRdyList], ax
	jmp	L_linkedList_14
L_linkedList_13:
	; >>>>> Line:	49
	; >>>>> tmp->prev->next = tcb; 
	mov	si, word [bp-2]
	add	si, 34
	mov	si, word [si]
	add	si, 32
	mov	ax, word [bp+4]
	mov	word [si], ax
L_linkedList_14:
	; >>>>> Line:	50
	; >>>>> tcb->prev = tmp->prev; 
	mov	si, word [bp-2]
	add	si, 34
	mov	di, word [bp+4]
	add	di, 34
	mov	ax, word [si]
	mov	word [di], ax
	; >>>>> Line:	51
	; >>>>> tcb->next = tmp; 
	mov	si, word [bp+4]
	add	si, 32
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	52
	; >>>>> tmp->prev = tcb; 
	mov	si, word [bp-2]
	add	si, 34
	mov	ax, word [bp+4]
	mov	word [si], ax
L_linkedList_9:
	mov	sp, bp
	pop	bp
	ret
L_linkedList_6:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_linkedList_7
	ALIGN	2
removeFirstTCBFromRdyList:
	; >>>>> Line:	57
	; >>>>> { 
	jmp	L_linkedList_16
L_linkedList_17:
	; >>>>> Line:	59
	; >>>>> tmp = YKRdyList; 
	mov	ax, word [YKRdyList]
	mov	word [bp-2], ax
	; >>>>> Line:	60
	; >>>>> YKRdyList = tmp->next; 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	mov	word [YKRdyList], ax
	; >>>>> Line:	61
	; >>>>> tmp->next->prev = 0; 
	mov	si, word [bp-2]
	add	si, 32
	mov	si, word [si]
	add	si, 34
	mov	word [si], 0
	; >>>>> Line:	62
	; >>>>> tmp->next = YKSuspList; 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [YKSuspList]
	mov	word [si], ax
	; >>>>> Line:	63
	; >>>>> YKSuspList = tmp; 
	mov	ax, word [bp-2]
	mov	word [YKSuspList], ax
	; >>>>> Line:	64
	; >>>>> tmp->prev = 0; 
	mov	si, word [bp-2]
	add	si, 34
	mov	word [si], 0
	; >>>>> Line:	65
	; >>>>> if (tmp->next != 0) 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	test	ax, ax
	je	L_linkedList_18
	; >>>>> Line:	66
	; >>>>> tmp->next->prev = tmp; 
	mov	si, word [bp-2]
	add	si, 32
	mov	si, word [si]
	add	si, 34
	mov	ax, word [bp-2]
	mov	word [si], ax
L_linkedList_18:
	mov	sp, bp
	pop	bp
	ret
L_linkedList_16:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_linkedList_17
	ALIGN	2
moveTCBToRdyList:
	; >>>>> Line:	73
	; >>>>> { 
	jmp	L_linkedList_20
L_linkedList_21:
	; >>>>> Line:	76
	; >>>>> if (tmp->prev == 0) 
	mov	si, word [bp+4]
	add	si, 34
	mov	ax, word [si]
	test	ax, ax
	jne	L_linkedList_22
	; >>>>> Line:	77
	; >>>>> YKSuspList = tmp->next; 
	mov	si, word [bp+4]
	add	si, 32
	mov	ax, word [si]
	mov	word [YKSuspList], ax
	jmp	L_linkedList_23
L_linkedList_22:
	; >>>>> Line:	79
	; >>>>> tmp->prev->next = tmp->next; 
	mov	si, word [bp+4]
	add	si, 32
	mov	di, word [bp+4]
	add	di, 34
	mov	di, word [di]
	add	di, 32
	mov	ax, word [si]
	mov	word [di], ax
L_linkedList_23:
	; >>>>> Line:	80
	; >>>>> if (tmp->next != 0) 
	mov	si, word [bp+4]
	add	si, 32
	mov	ax, word [si]
	test	ax, ax
	je	L_linkedList_24
	; >>>>> Line:	81
	; >>>>> tmp->next->prev = tmp->prev; 
	mov	si, word [bp+4]
	add	si, 34
	mov	di, word [bp+4]
	add	di, 32
	mov	di, word [di]
	add	di, 34
	mov	ax, word [si]
	mov	word [di], ax
L_linkedList_24:
	; >>>>> Line:	83
	; >>>>> tmp2 = YKRdyList; 
	mov	ax, word [YKRdyList]
	mov	word [bp-2], ax
	; >>>>> Line:	85
	; >>>>> while (tmp2->priority < tmp->priority) 
	jmp	L_linkedList_26
L_linkedList_25:
	; >>>>> Line:	86
	; >>>>> tmp2 = tmp2->next; 
	mov	si, word [bp-2]
	add	si, 32
	mov	ax, word [si]
	mov	word [bp-2], ax
L_linkedList_26:
	mov	si, word [bp-2]
	add	si, 28
	mov	di, word [bp+4]
	add	di, 28
	mov	ax, word [di]
	cmp	ax, word [si]
	ja	L_linkedList_25
L_linkedList_27:
	; >>>>> Line:	87
	; >>>>> if (tmp2->prev == 0) 
	mov	si, word [bp-2]
	add	si, 34
	mov	ax, word [si]
	test	ax, ax
	jne	L_linkedList_28
	; >>>>> Line:	88
	; >>>>> YKRdyList = tmp; 
	mov	ax, word [bp+4]
	mov	word [YKRdyList], ax
	jmp	L_linkedList_29
L_linkedList_28:
	; >>>>> Line:	90
	; >>>>> tmp2->prev->next = tmp; 
	mov	si, word [bp-2]
	add	si, 34
	mov	si, word [si]
	add	si, 32
	mov	ax, word [bp+4]
	mov	word [si], ax
L_linkedList_29:
	; >>>>> Line:	91
	; >>>>> tmp->prev = tmp2->prev; 
	mov	si, word [bp-2]
	add	si, 34
	mov	di, word [bp+4]
	add	di, 34
	mov	ax, word [si]
	mov	word [di], ax
	; >>>>> Line:	92
	; >>>>> tmp->next = tmp2; 
	mov	si, word [bp+4]
	add	si, 32
	mov	ax, word [bp-2]
	mov	word [si], ax
	; >>>>> Line:	93
	; >>>>> tmp2->prev = tmp; 
	mov	si, word [bp-2]
	add	si, 34
	mov	ax, word [bp+4]
	mov	word [si], ax
	mov	sp, bp
	pop	bp
	ret
L_linkedList_20:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_linkedList_21
	ALIGN	2
YKRdyList:
	TIMES	2 db 0
YKSuspList:
	TIMES	2 db 0
TCBarray:
	TIMES	228 db 0
runningTask:
	TIMES	2 db 0
