; Generated by c86 (BYU-NASM) 5.1 (beta) from queue.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
qIsEmpty:
	; >>>>> Line:	6
	; >>>>> { 
	jmp	L_queue_1
L_queue_2:
	; >>>>> Line:	7
	; >>>>> return (queue->qStart == queue->qEnd); 
	mov	si, word [bp+4]
	add	si, 2
	mov	di, word [bp+4]
	mov	ax, word [di]
	cmp	ax, word [si]
	je	L_queue_3
	xor	ax, ax
	jmp	L_queue_4
L_queue_3:
	mov	ax, 1
L_queue_4:
L_queue_5:
	mov	sp, bp
	pop	bp
	ret
L_queue_1:
	push	bp
	mov	bp, sp
	jmp	L_queue_2
	ALIGN	2
qIsFull:
	; >>>>> Line:	11
	; >>>>> { 
	jmp	L_queue_7
L_queue_8:
	; >>>>> Line:	12
	; >>>>> return (qNextInsertSpot(queue) == queue->qEnd); 
	push	word [bp+4]
	call	qNextInsertSpot
	add	sp, 2
	mov	si, word [bp+4]
	add	si, 2
	mov	dx, word [si]
	cmp	dx, ax
	je	L_queue_9
	xor	ax, ax
	jmp	L_queue_10
L_queue_9:
	mov	ax, 1
L_queue_10:
L_queue_11:
	mov	sp, bp
	pop	bp
	ret
L_queue_7:
	push	bp
	mov	bp, sp
	jmp	L_queue_8
	ALIGN	2
qNextInsertSpot:
	; >>>>> Line:	16
	; >>>>> { 
	jmp	L_queue_13
L_queue_14:
	; >>>>> Line:	18
	; >>>>> if (nextSlot > (queue->qArray + queue->qMaxSize - 1)) 
	mov	si, word [bp+4]
	mov	ax, word [si]
	add	ax, 2
	mov	word [bp-2], ax
	; >>>>> Line:	18
	; >>>>> if (nextSlot > (queue->qArray + queue->qMaxSize - 1)) 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	shl	ax, 1
	mov	si, word [bp+4]
	add	si, 4
	add	ax, word [si]
	sub	ax, 2
	mov	dx, word [bp-2]
	cmp	dx, ax
	jbe	L_queue_15
	; >>>>> Line:	19
	; >>>>> nextSlot = queue->qArray; 
	mov	si, word [bp+4]
	add	si, 4
	mov	ax, word [si]
	mov	word [bp-2], ax
L_queue_15:
	; >>>>> Line:	20
	; >>>>> return nextSlot; 
	mov	ax, word [bp-2]
L_queue_16:
	mov	sp, bp
	pop	bp
	ret
L_queue_13:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_queue_14
	ALIGN	2
qNextRemoveSpot:
	; >>>>> Line:	24
	; >>>>> { 
	jmp	L_queue_18
L_queue_19:
	; >>>>> Line:	26
	; >>>>> if (nextSlot > (queue->qArray + queue->qMaxSize - 1)) 
	mov	si, word [bp+4]
	add	si, 2
	mov	ax, word [si]
	add	ax, 2
	mov	word [bp-2], ax
	; >>>>> Line:	26
	; >>>>> if (nextSlot > (queue->qArray + queue->qMaxSize - 1)) 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	shl	ax, 1
	mov	si, word [bp+4]
	add	si, 4
	add	ax, word [si]
	sub	ax, 2
	mov	dx, word [bp-2]
	cmp	dx, ax
	jbe	L_queue_20
	; >>>>> Line:	27
	; >>>>> nextSlot = queue->qArray; 
	mov	si, word [bp+4]
	add	si, 4
	mov	ax, word [si]
	mov	word [bp-2], ax
L_queue_20:
	; >>>>> Line:	28
	; >>>>> return nextSlot; 
	mov	ax, word [bp-2]
L_queue_21:
	mov	sp, bp
	pop	bp
	ret
L_queue_18:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_queue_19
	ALIGN	2
qInsert:
	; >>>>> Line:	32
	; >>>>> { 
	jmp	L_queue_23
L_queue_24:
	; >>>>> Line:	33
	; >>>>> *(queue->qStart) = eleme 
	mov	si, word [bp+4]
	mov	si, word [si]
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	34
	; >>>>> queue->qStart = qNextInsertSpot(queue); 
	push	word [bp+4]
	call	qNextInsertSpot
	add	sp, 2
	mov	si, word [bp+4]
	mov	word [si], ax
	mov	sp, bp
	pop	bp
	ret
L_queue_23:
	push	bp
	mov	bp, sp
	jmp	L_queue_24
	ALIGN	2
qRemove:
	; >>>>> Line:	38
	; >>>>> { 
	jmp	L_queue_26
L_queue_27:
	; >>>>> Line:	40
	; >>>>> queue->qEnd = qNextRemoveSpot(queue); 
	mov	si, word [bp+4]
	add	si, 2
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	40
	; >>>>> queue->qEnd = qNextRemoveSpot(queue); 
	push	word [bp+4]
	call	qNextRemoveSpot
	add	sp, 2
	mov	si, word [bp+4]
	add	si, 2
	mov	word [si], ax
	; >>>>> Line:	41
	; >>>>> return *temp; 
	mov	si, word [bp-2]
	mov	ax, word [si]
L_queue_28:
	mov	sp, bp
	pop	bp
	ret
L_queue_26:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_queue_27
