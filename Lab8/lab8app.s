; Generated by c86 (BYU-NASM) 5.1 (beta) from lab8app.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
binLHighestRow:
	DW	0
binRHighestRow:
	DW	0
L_lab8app_7:
	DW	0
L_lab8app_8:
	DB	0xA,"*****new move made queue overflow!!*****",0xA,0
	ALIGN	2
sendMoveCmd:
	; >>>>> Line:	41
	; >>>>> { 
	jmp	L_lab8app_9
L_lab8app_10:
	; >>>>> Line:	42
	; >>>>> if (YKQPost(moveQPtr, (void*) &(moveArray[nextMove])) == 0) 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	push	ax
	push	word [moveQPtr]
	call	YKQPost
	add	sp, 4
	test	ax, ax
	jne	L_lab8app_11
	; >>>>> Line:	43
	; >>>>> printString("\n*****new move made queue overflow!!*****\n"); 
	mov	ax, L_lab8app_8
	push	ax
	call	printString
	add	sp, 2
	jmp	L_lab8app_12
L_lab8app_11:
	; >>>>> Line:	44
	; >>>>> else if (++nextMove >= 25) 
	mov	ax, word [L_lab8app_7]
	inc	ax
	mov	word [L_lab8app_7], ax
	cmp	ax, 25
	jl	L_lab8app_13
	; >>>>> Line:	45
	; >>>>> nextMove = 0; 
	mov	word [L_lab8app_7], 0
L_lab8app_13:
L_lab8app_12:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_9:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_10
	ALIGN	2
rotatePieceClockwise:
	; >>>>> Line:	50
	; >>>>> { 
	jmp	L_lab8app_15
L_lab8app_16:
	; >>>>> Line:	51
	; >>>>> moveArray[nextMove].pieceID = pieceID; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	mov	si, ax
	add	si, moveArray
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	52
	; >>>>> m 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	mov	si, ax
	add	si, 2
	mov	word [si], 1
	; >>>>> Line:	53
	; >>>>> moveArray[nextMove].direction = 1; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	mov	si, ax
	add	si, 4
	mov	word [si], 1
	; >>>>> Line:	54
	; >>>>> sendMoveCmd(); 
	call	sendMoveCmd
	mov	sp, bp
	pop	bp
	ret
L_lab8app_15:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_16
	ALIGN	2
rotatePieceCounterClockwise:
	; >>>>> Line:	59
	; >>>>> { 
	jmp	L_lab8app_18
L_lab8app_19:
	; >>>>> Line:	60
	; >>>>> moveArray[nextMove].pieceID = pieceID; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	mov	si, ax
	add	si, moveArray
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	61
	; >>>>> moveArray[nextMove].moveType = 1; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	mov	si, ax
	add	si, 2
	mov	word [si], 1
	; >>>>> Line:	62
	; >>>>> moveArray[nextMove].direction = 0; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	mov	si, ax
	add	si, 4
	mov	word [si], 0
	; >>>>> Line:	63
	; >>>>> sendMoveCmd(); 
	call	sendMoveCmd
	mov	sp, bp
	pop	bp
	ret
L_lab8app_18:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_19
	ALIGN	2
slidePieceLeft:
	; >>>>> Line:	68
	; >>>>> { 
	jmp	L_lab8app_21
L_lab8app_22:
	; >>>>> Line:	69
	; >>>>> moveArray[nextMove].pieceID = pieceID; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	mov	si, ax
	add	si, moveArray
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	70
	; >>>>> moveArray[nextMove].moveType = 0; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	mov	si, ax
	add	si, 2
	mov	word [si], 0
	; >>>>> Line:	71
	; >>>>> moveArray[nextMove].direction = 0; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	mov	si, ax
	add	si, 4
	mov	word [si], 0
	; >>>>> Line:	72
	; >>>>> sendMoveCmd(); 
	call	sendMoveCmd
	mov	sp, bp
	pop	bp
	ret
L_lab8app_21:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_22
	ALIGN	2
slidePieceRight:
	; >>>>> Line:	77
	; >>>>> { 
	jmp	L_lab8app_24
L_lab8app_25:
	; >>>>> Line:	78
	; >>>>> moveArray[nextMove].pieceID =  
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	mov	si, ax
	add	si, moveArray
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	79
	; >>>>> moveArray[nextMove].moveType = 0; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	mov	si, ax
	add	si, 2
	mov	word [si], 0
	; >>>>> Line:	80
	; >>>>> moveArray[nextMove].direction = 1; 
	mov	ax, word [L_lab8app_7]
	mov	cx, 6
	imul	cx
	add	ax, moveArray
	mov	si, ax
	add	si, 4
	mov	word [si], 1
	; >>>>> Line:	81
	; >>>>> sendMoveCmd(); 
	call	sendMoveCmd
	mov	sp, bp
	pop	bp
	ret
L_lab8app_24:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_25
	ALIGN	2
rotatePieceToTR:
	; >>>>> Line:	85
	; >>>>> { 
	jmp	L_lab8app_27
L_lab8app_28:
	; >>>>> Line:	86
	; >>>>> switch (piecePtr->orientation) 
	mov	si, word [bp+4]
	add	si, 2
	mov	ax, word [si]
	sub	ax, 0
	je	L_lab8app_30
	dec	ax
	je	L_lab8app_31
	dec	ax
	je	L_lab8app_32
	dec	ax
	je	L_lab8app_33
	jmp	L_lab8app_29
L_lab8app_30:
	; >>>>> Line:	89
	; >>>>> numRotations += 2; 
	add	word [L_lab8app_6], 2
	; >>>>> Line:	90
	; >>>>> break; 
	jmp	L_lab8app_29
L_lab8app_31:
	; >>>>> Line:	92
	; >>>>> numRotations--; 
	dec	word [L_lab8app_6]
	; >>>>> Line:	93
	; >>>>> break; 
	jmp	L_lab8app_29
L_lab8app_32:
	; >>>>> Line:	96
	; >>>>> break; 
	jmp	L_lab8app_29
L_lab8app_33:
	; >>>>> Line:	98
	; >>>>> numRotations++; 
	inc	word [L_lab8app_6]
L_lab8app_29:
	; >>>>> Line:	99
	; >>>>> break; 
	mov	sp, bp
	pop	bp
	ret
L_lab8app_27:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_28
	ALIGN	2
rotatePieceToBL:
	; >>>>> Line:	104
	; >>>>> { 
	jmp	L_lab8app_35
L_lab8app_36:
	; >>>>> Line:	105
	; >>>>> switch (piecePtr->orientation) 
	mov	si, word [bp+4]
	add	si, 2
	mov	ax, word [si]
	sub	ax, 0
	je	L_lab8app_39
	dec	ax
	je	L_lab8app_40
	dec	ax
	je	L_lab8app_41
	dec	ax
	je	L_lab8app_42
	jmp	L_lab8app_38
L_lab8app_39:
	; >>>>> Line:	109
	; >>>>> break; 
	jmp	L_lab8app_37
L_lab8app_40:
	; >>>>> Line:	111
	; >>>>> numRotations++; 
	inc	word [L_lab8app_6]
	; >>>>> Line:	112
	; >>>>> break; 
	jmp	L_lab8app_37
L_lab8app_41:
	; >>>>> Line:	114
	; >>>>> numRotations += 2; 
	add	word [L_lab8app_6], 2
	; >>>>> Line:	115
	; >>>>> break; 
	jmp	L_lab8app_37
L_lab8app_42:
	; >>>>> Line:	117
	; >>>>> numRotations--; 
	dec	word [L_lab8app_6]
L_lab8app_38:
	; >>>>> Line:	118
	; >>>>> break; 
L_lab8app_37:
	; >>>>> Line:	121
	; >>>>> break; 
	mov	sp, bp
	pop	bp
	ret
L_lab8app_35:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_36
	ALIGN	2
placeCornerPieceInLeftBin:
	; >>>>> Line:	126
	; >>>>> { 
	jmp	L_lab8app_44
L_lab8app_45:
	; >>>>> Line:	127
	; >>>>> if (binLflat) 
	mov	ax, word [L_lab8app_3]
	test	ax, ax
	je	L_lab8app_46
	; >>>>> Line:	130
	; >>>>> rotatePieceToBL(piecePtr); 
	push	word [bp+4]
	call	rotatePieceToBL
	add	sp, 2
	; >>>>> Line:	131
	; >>>>> numSlides -= (piecePtr->column); 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	sub	word [L_lab8app_5], ax
	; >>>>> Line:	132
	; >>>>> binLflat = 0; 
	mov	word [L_lab8app_3], 0
	jmp	L_lab8app_47
L_lab8app_46:
	; >>>>> Line:	136
	; >>>>> rotatePieceToTR(piecePtr); 
	push	word [bp+4]
	call	rotatePieceToTR
	add	sp, 2
	; >>>>> Line:	137
	; >>>>> numSlides -= (piecePtr->column - 2); 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	sub	ax, 2
	sub	word [L_lab8app_5], ax
	; >>>>> Line:	138
	; >>>>> binLflat = 1; 
	mov	word [L_lab8app_3], 1
L_lab8app_47:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_44:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_45
	ALIGN	2
placeCornerPieceInRightBin:
	; >>>>> Line:	143
	; >>>>> { 
	jmp	L_lab8app_49
L_lab8app_50:
	; >>>>> Line:	144
	; >>>>> if (binRflat) 
	mov	ax, word [L_lab8app_4]
	test	ax, ax
	je	L_lab8app_51
	; >>>>> Line:	148
	; >>>>>  
	push	word [bp+4]
	call	rotatePieceToBL
	add	sp, 2
	; >>>>> Line:	150
	; >>>>> numSlides -= (piecePtr->column - 3); 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	sub	ax, 3
	sub	word [L_lab8app_5], ax
	; >>>>> Line:	152
	; >>>>> binRflat = 0; 
	mov	word [L_lab8app_4], 0
	jmp	L_lab8app_52
L_lab8app_51:
	; >>>>> Line:	157
	; >>>>> rotatePieceToTR(piecePtr); 
	push	word [bp+4]
	call	rotatePieceToTR
	add	sp, 2
	; >>>>> Line:	158
	; >>>>> numSlides -= (piecePtr->column - 5); 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	sub	ax, 5
	sub	word [L_lab8app_5], ax
	; >>>>> Line:	160
	; >>>>> binRflat = 1; 
	mov	word [L_lab8app_4], 1
L_lab8app_52:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_49:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_50
	ALIGN	2
placeCornerPiece:
	; >>>>> Line:	165
	; >>>>> { 
	jmp	L_lab8app_54
L_lab8app_55:
	; >>>>> Line:	167
	; >>>>> if ((binLHighestRow < binRHighestRow)) 
	mov	ax, word [binRHighestRow]
	cmp	ax, word [binLHighestRow]
	jbe	L_lab8app_56
	; >>>>> Line:	169
	; >>>>> placeCornerPieceInLeftBin(piecePtr); 
	push	word [bp+4]
	call	placeCornerPieceInLeftBin
	add	sp, 2
	; >>>>> Line:	171
	; >>>>> binLHighestRow += 2; 
	add	word [binLHighestRow], 2
	jmp	L_lab8app_57
L_lab8app_56:
	; >>>>> Line:	175
	; >>>>> placeCornerPieceInRightBin(piecePtr); 
	push	word [bp+4]
	call	placeCornerPieceInRightBin
	add	sp, 2
	; >>>>> Line:	177
	; >>>>> binRHighestRow += 2; 
	add	word [binRHighestRow], 2
L_lab8app_57:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_54:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_55
	ALIGN	2
sendRotateCommands:
	; >>>>> Line:	182
	; >>>>> { 
	jmp	L_lab8app_59
L_lab8app_60:
	; >>>>> Line:	183
	; >>>>> sl 
	jmp	L_lab8app_62
L_lab8app_61:
	; >>>>> Line:	185
	; >>>>> if (numRotations < 0) 
	cmp	word [L_lab8app_6], 0
	jge	L_lab8app_64
	; >>>>> Line:	187
	; >>>>> rotatePieceCounterClockwise(piecePtr->id); 
	mov	si, word [bp+4]
	push	word [si]
	call	rotatePieceCounterClockwise
	add	sp, 2
	; >>>>> Line:	188
	; >>>>> numRotations++; 
	inc	word [L_lab8app_6]
	jmp	L_lab8app_65
L_lab8app_64:
	; >>>>> Line:	192
	; >>>>> rotatePieceClockwise(piecePtr->id); 
	mov	si, word [bp+4]
	push	word [si]
	call	rotatePieceClockwise
	add	sp, 2
	; >>>>> Line:	193
	; >>>>> numRotations--; 
	dec	word [L_lab8app_6]
L_lab8app_65:
L_lab8app_62:
	mov	ax, word [L_lab8app_6]
	test	ax, ax
	jne	L_lab8app_61
L_lab8app_63:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_59:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_60
	ALIGN	2
sendMoveCommands:
	; >>>>> Line:	199
	; >>>>> { 
	jmp	L_lab8app_67
L_lab8app_68:
	; >>>>> Line:	201
	; >>>>> curCol = piecePtr->column; 
	mov	si, word [bp+4]
	add	si, 6
	mov	ax, word [si]
	mov	word [bp-2], ax
	; >>>>> Line:	202
	; >>>>> while (numSlides != 0) 
	jmp	L_lab8app_70
L_lab8app_69:
	; >>>>> Line:	204
	; >>>>> if ((curCol == 1 && numSlides < 0) || (curCol == 4 && numSlides > 0)) 
	cmp	word [bp-2], 1
	jne	L_lab8app_74
	cmp	word [L_lab8app_5], 0
	jl	L_lab8app_73
L_lab8app_74:
	cmp	word [bp-2], 4
	jne	L_lab8app_72
	cmp	word [L_lab8app_5], 0
	jle	L_lab8app_72
L_lab8app_73:
	; >>>>> Line:	206
	; >>>>> sendRotateCommands(piecePtr); 
	push	word [bp+4]
	call	sendRotateCommands
	add	sp, 2
L_lab8app_72:
	; >>>>> Line:	209
	; >>>>> if (numSlides < 0) 
	cmp	word [L_lab8app_5], 0
	jge	L_lab8app_75
	; >>>>> Line:	211
	; >>>>> iecePtr; 
	mov	si, word [bp+4]
	push	word [si]
	call	slidePieceLeft
	add	sp, 2
	; >>>>> Line:	212
	; >>>>> numSlides++; 
	inc	word [L_lab8app_5]
	jmp	L_lab8app_76
L_lab8app_75:
	; >>>>> Line:	216
	; >>>>> slidePieceRight(piecePtr->id); 
	mov	si, word [bp+4]
	push	word [si]
	call	slidePieceRight
	add	sp, 2
	; >>>>> Line:	217
	; >>>>> numSlides--; 
	dec	word [L_lab8app_5]
L_lab8app_76:
L_lab8app_70:
	mov	ax, word [L_lab8app_5]
	test	ax, ax
	jne	L_lab8app_69
L_lab8app_71:
	; >>>>> Line:	221
	; >>>>> if (numRotations != 0) 
	mov	ax, word [L_lab8app_6]
	test	ax, ax
	je	L_lab8app_77
	; >>>>> Line:	223
	; >>>>> if (curCol == 0) 
	mov	ax, word [bp-2]
	test	ax, ax
	jne	L_lab8app_78
	; >>>>> Line:	225
	; >>>>> slidePieceRight(piecePtr->id); 
	mov	si, word [bp+4]
	push	word [si]
	call	slidePieceRight
	add	sp, 2
	; >>>>> Line:	226
	; >>>>> sendRotateCommands(piecePtr); 
	push	word [bp+4]
	call	sendRotateCommands
	add	sp, 2
	; >>>>> Line:	227
	; >>>>> slidePieceLeft(piecePtr->id); 
	mov	si, word [bp+4]
	push	word [si]
	call	slidePieceLeft
	add	sp, 2
	jmp	L_lab8app_79
L_lab8app_78:
	; >>>>> Line:	229
	; >>>>> else if (curCol == 5) 
	cmp	word [bp-2], 5
	jne	L_lab8app_80
	; >>>>> Line:	231
	; >>>>> slidePieceLeft(piecePtr->id); 
	mov	si, word [bp+4]
	push	word [si]
	call	slidePieceLeft
	add	sp, 2
	; >>>>> Line:	232
	; >>>>> sendRotateCommands(piecePtr); 
	push	word [bp+4]
	call	sendRotateCommands
	add	sp, 2
	; >>>>> Line:	233
	; >>>>> slidePieceRight(piecePtr->id); 
	mov	si, word [bp+4]
	push	word [si]
	call	slidePieceRight
	add	sp, 2
L_lab8app_80:
L_lab8app_79:
L_lab8app_77:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_67:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_lab8app_68
	ALIGN	2
PlacementTask:
	; >>>>> Line:	239
	; >>>>> { 
	jmp	L_lab8app_83
L_lab8app_84:
	; >>>>> Line:	244
	; >>>>> while(1) 
	jmp	L_lab8app_86
L_lab8app_85:
	; >>>>> Line:	246
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	247
	; >>>>> piecePtr = (struct newPiece *) YKQPend(newPieceQPtr); 
	push	word [newPieceQPtr]
	call	YKQPend
	add	sp, 2
	mov	word [bp-2], ax
	; >>>>> Line:	248
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	251
	; >>>>> numSlides = 0; 
	mov	word [L_lab8app_5], 0
	; >>>>> Line:	252
	; >>>>> numRotations = 0; 
	mov	word [L_lab8app_6], 0
	; >>>>> Line:	255
	; >>>>> switch (piecePtr->type){ 
	mov	si, word [bp-2]
	add	si, 4
	mov	ax, word [si]
	sub	ax, 0
	je	L_lab8app_89
	dec	ax
	je	L_lab8app_90
	jmp	L_lab8app_88
L_lab8app_89:
	; >>>>> Line:	257
	; >>>>> placeCornerPiece(piecePtr); 
	push	word [bp-2]
	call	placeCornerPiece
	add	sp, 2
	; >>>>> Line:	258
	; >>>>> break; 
	jmp	L_lab8app_88
L_lab8app_90:
	; >>>>> Line:	261
	; >>>>> if(piecePtr->orientation == 1) 
	mov	si, word [bp-2]
	add	si, 2
	cmp	word [si], 1
	jne	L_lab8app_91
	; >>>>> Line:	263
	; >>>>> numRotations++; 
	inc	word [L_lab8app_6]
L_lab8app_91:
	; >>>>> Line:	266
	; >>>>> if ((binLHighestRow < binRHighestRow)) 
	mov	ax, word [binRHighestRow]
	cmp	ax, word [binLHighestRow]
	jbe	L_lab8app_92
	; >>>>> Line:	268
	; >>>>> numSlides -= (piecePtr->column - 1); 
	mov	si, word [bp-2]
	add	si, 6
	mov	ax, word [si]
	dec	ax
	sub	word [L_lab8app_5], ax
	; >>>>> Line:	270
	; >>>>> binLHighestRow ++; 
	inc	word [binLHighestRow]
	jmp	L_lab8app_93
L_lab8app_92:
	; >>>>> Line:	274
	; >>>>> numSlides -= (piecePtr->column - 4); 
	mov	si, word [bp-2]
	add	si, 6
	mov	ax, word [si]
	sub	ax, 4
	sub	word [L_lab8app_5], ax
	; >>>>> Line:	276
	; >>>>> binRHighestRow ++; 
	inc	word [binRHighestRow]
L_lab8app_93:
L_lab8app_88:
	; >>>>> Line:	281
	; >>>>> sendMoveCommands(piecePtr); 
	push	word [bp-2]
	call	sendMoveCommands
	add	sp, 2
L_lab8app_86:
	jmp	L_lab8app_85
L_lab8app_87:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_83:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_lab8app_84
	ALIGN	2
L_lab8app_82:
	TIMES	2 db 0
L_lab8app_95:
	DB	0xA,"****ILLEGAL MOVE TYPE*****",0xA,0
	ALIGN	2
CommunicationTask:
	; >>>>> Line:	286
	; >>>>> { 
	jmp	L_lab8app_96
L_lab8app_97:
	; >>>>> Line:	288
	; >>>>> while (1) 
	jmp	L_lab8app_99
L_lab8app_98:
	; >>>>> Line:	291
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	293
	; >>>>> movePtr = (struct move *) YKQPend(moveQPtr); 
	push	word [moveQPtr]
	call	YKQPend
	add	sp, 2
	mov	word [bp-2], ax
	; >>>>> Line:	295
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	297
	; >>>>> YKSemPend(CmdRcvdSemPtr); 
	push	word [CmdRcvdSemPtr]
	call	YKSemPend
	add	sp, 2
	; >>>>> Line:	301
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	302
	; >>>>> switch (movePtr->moveType) 
	mov	si, word [bp-2]
	add	si, 2
	mov	ax, word [si]
	sub	ax, 0
	je	L_lab8app_103
	dec	ax
	je	L_lab8app_104
	jmp	L_lab8app_102
L_lab8app_103:
	; >>>>> Line:	306
	; >>>>> SlidePiece(movePtr->pieceID, movePtr->direction); 
	mov	si, word [bp-2]
	add	si, 4
	push	word [si]
	mov	si, word [bp-2]
	push	word [si]
	call	SlidePiece
	add	sp, 4
	; >>>>> Line:	308
	; >>>>> break; 
	jmp	L_lab8app_101
L_lab8app_104:
	; >>>>> Line:	311
	; >>>>> RotatePiece(movePtr->pieceID, movePtr->direction); 
	mov	si, word [bp-2]
	add	si, 4
	push	word [si]
	mov	si, word [bp-2]
	push	word [si]
	call	RotatePiece
	add	sp, 4
	; >>>>> Line:	312
	; >>>>> break; 
	jmp	L_lab8app_101
L_lab8app_102:
	; >>>>> Line:	314
	; >>>>> printString("\n****ILLEGAL MOVE TYPE*****\n"); 
	mov	ax, L_lab8app_95
	push	ax
	call	printString
	add	sp, 2
L_lab8app_101:
	; >>>>> Line:	317
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
L_lab8app_99:
	jmp	L_lab8app_98
L_lab8app_100:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_96:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_lab8app_97
L_lab8app_110:
	DB	"%>",0xD,0xA,0
L_lab8app_109:
	DB	", CPU: ",0
L_lab8app_108:
	DB	"<CS: ",0
L_lab8app_107:
	DB	"Determining CPU capacity",0xD,0xA,0
L_lab8app_106:
	DB	"Welcome to the YAK kernel",0xD,0xA,0
	ALIGN	2
StatTask:
	; >>>>> Line:	322
	; >>>>> { 
	jmp	L_lab8app_111
L_lab8app_112:
	; >>>>> Line:	326
	; >>>>> YKDelayTask(1); 
	mov	ax, 1
	push	ax
	call	YKDelayTask
	add	sp, 2
	; >>>>> Line:	327
	; >>>>> printString("Welcome to the YAK kernel\r\n"); 
	mov	ax, L_lab8app_106
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	328
	; >>>>> printString("Determining CPU capacity\r\n"); 
	mov	ax, L_lab8app_107
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	329
	; >>>>> YKDelayTask(1); 
	mov	ax, 1
	push	ax
	call	YKDelayTask
	add	sp, 2
	; >>>>> Line:	330
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	331
	; >>>>> YKDelayTask(5); 
	mov	ax, 5
	push	ax
	call	YKDelayTask
	add	sp, 2
	; >>>>> Line:	332
	; >>>>> max = YKIdleCount / 25; 
	mov	ax, word [YKIdleCount]
	xor	dx, dx
	mov	cx, 25
	div	cx
	mov	word [bp-2], ax
	; >>>>> Line:	333
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	335
	; >>>>> YKNewTask(PlacementTa 
	mov	al, 4
	push	ax
	mov	ax, (PlacementTaskStk+1024)
	push	ax
	mov	ax, PlacementTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	336
	; >>>>> YKNewTask(CommunicationTask, (void *) &CommunicationTaskStk[512], 2); 
	mov	al, 2
	push	ax
	mov	ax, (CommunicationTaskStk+1024)
	push	ax
	mov	ax, CommunicationTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	338
	; >>>>> StartSimptris(); 
	call	StartSimptris
	; >>>>> Line:	340
	; >>>>> while (1) 
	jmp	L_lab8app_114
L_lab8app_113:
	; >>>>> Line:	342
	; >>>>> YKDelayTask(20); 
	mov	ax, 20
	push	ax
	call	YKDelayTask
	add	sp, 2
	; >>>>> Line:	344
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	345
	; >>>>> switchCount = YKCtxSwCount; 
	mov	ax, word [YKCtxSwCount]
	mov	word [bp-4], ax
	; >>>>> Line:	346
	; >>>>> idleCount = YKIdleCount; 
	mov	ax, word [YKIdleCount]
	mov	word [bp-6], ax
	; >>>>> Line:	347
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	349
	; >>>>> printString("<CS: "); 
	mov	ax, L_lab8app_108
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	350
	; >>>>> printInt((int)switchCount); 
	push	word [bp-4]
	call	printInt
	add	sp, 2
	; >>>>> Line:	351
	; >>>>> printString(", CPU: "); 
	mov	ax, L_lab8app_109
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	352
	; >>>>> tmp = (int) (idleCount/max); 
	mov	ax, word [bp-6]
	xor	dx, dx
	div	word [bp-2]
	mov	word [bp-8], ax
	; >>>>> Line:	353
	; >>>>> printInt(100-tmp); 
	mov	ax, 100
	sub	ax, word [bp-8]
	push	ax
	call	printInt
	add	sp, 2
	; >>>>> Line:	354
	; >>>>> printString("%>\r\n"); 
	mov	ax, L_lab8app_110
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	356
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	357
	; >>>>> YKCtxSwCount = 0; 
	mov	word [YKCtxSwCount], 0
	; >>>>> Line:	358
	; >>>>>  
	mov	word [YKIdleCount], 0
	; >>>>> Line:	359
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
L_lab8app_114:
	jmp	L_lab8app_113
L_lab8app_115:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_111:
	push	bp
	mov	bp, sp
	sub	sp, 8
	jmp	L_lab8app_112
	ALIGN	2
main:
	; >>>>> Line:	364
	; >>>>> { 
	jmp	L_lab8app_117
L_lab8app_118:
	; >>>>> Line:	365
	; >>>>> YKInitialize(); 
	call	YKInitialize
	; >>>>> Line:	367
	; >>>>> YKNewTask(StatTask, (void *) &StatTaskStk[512], 0); 
	xor	al, al
	push	ax
	mov	ax, (StatTaskStk+1024)
	push	ax
	mov	ax, StatTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	369
	; >>>>> newPieceQPtr = YKQCreate(newPieceQ, 5); 
	mov	ax, 5
	push	ax
	mov	ax, newPieceQ
	push	ax
	call	YKQCreate
	add	sp, 4
	mov	word [newPieceQPtr], ax
	; >>>>> Line:	370
	; >>>>> moveQPtr = YKQCreate(moveQ, 25); 
	mov	ax, 25
	push	ax
	mov	ax, moveQ
	push	ax
	call	YKQCreate
	add	sp, 4
	mov	word [moveQPtr], ax
	; >>>>> Line:	372
	; >>>>> CmdRcvdSemPtr = YKSemCreate(1); 
	mov	ax, 1
	push	ax
	call	YKSemCreate
	add	sp, 2
	mov	word [CmdRcvdSemPtr], ax
	; >>>>> Line:	374
	; >>>>> SeedSimptris(0); 
	xor	ax, ax
	xor	dx, dx
	push	dx
	push	ax
	call	SeedSimptris
	add	sp, 4
	; >>>>> Line:	376
	; >>>>> YKRun(); 
	call	YKRun
	mov	sp, bp
	pop	bp
	ret
L_lab8app_117:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_118
	ALIGN	2
L_lab8app_1:
	TIMES	512 db 0
PlacementTaskStk:
	TIMES	1024 db 0
CommunicationTaskStk:
	TIMES	1024 db 0
StatTaskStk:
	TIMES	1024 db 0
L_lab8app_2:
	TIMES	2 db 0
L_lab8app_3:
	TIMES	2 db 0
L_lab8app_4:
	TIMES	2 db 0
L_lab8app_5:
	TIMES	2 db 0
L_lab8app_6:
	TIMES	2 db 0
newPieceArray:
	TIMES	40 db 0
moveArray:
	TIMES	150 db 0
newPieceQ:
	TIMES	10 db 0
newPieceQPtr:
	TIMES	2 db 0
moveQ:
	TIMES	50 db 0
moveQPtr:
	TIMES	2 db 0
CmdRcvdSemPtr:
	TIMES	2 db 0
