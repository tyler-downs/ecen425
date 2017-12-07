reset_isr:
	call resetInterruptHandler

tick_isr:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds

	call YKEnterISR

	sti 		; enable interrupts
	call tickInterruptHandler
	cli			; disable interrupts

	; send EOI command to PIC
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

	call YKExitISR

	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	iret

keyboard_isr:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	push es
	push ds

	call YKEnterISR

	sti 		; enable interrupts
	call keyboardInterruptHandler
	cli			; disable interrupts

	; send EOI command to PIC
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)

	call YKExitISR

	pop ds
	pop es
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	iret

simptris_game_over:
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		push bp
		push es
		push ds

		call YKEnterISR

		sti 		; enable interrupts
		call gameOverInterruptHandler
		cli			; disable interrupts

		; send EOI command to PIC
		mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
		out	0x20, al	; Write EOI to PIC (port 0x20)

		call YKExitISR

		pop ds
		pop es
		pop bp
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax

		iret

simptris_new_piece:
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		push bp
		push es
		push ds

		call YKEnterISR

		sti 		; enable interrupts
		call newPieceInterruptHandler
		cli			; disable interrupts

		; send EOI command to PIC
		mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
		out	0x20, al	; Write EOI to PIC (port 0x20)

		call YKExitISR

		pop ds
		pop es
		pop bp
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax

		iret

simptris_received:
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		push bp
		push es
		push ds

		call YKEnterISR

		sti 		; enable interrupts
		call receivedInterruptHandler
		cli			; disable interrupts

		; send EOI command to PIC
		mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
		out	0x20, al	; Write EOI to PIC (port 0x20)

		call YKExitISR

		pop ds
		pop es
		pop bp
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax

		iret

simptris_touchdown:
		push ax

		; send EOI command to PIC
		mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
		out	0x20, al	; Write EOI to PIC (port 0x20)

		pop ax
		iret

simptris_clear:
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		push bp
		push es
		push ds

		call YKEnterISR

		sti 		; enable interrupts
		call clearInterruptHandler
		cli			; disable interrupts

		; send EOI command to PIC
		mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
		out	0x20, al	; Write EOI to PIC (port 0x20)

		call YKExitISR

		pop ds
		pop es
		pop bp
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax

		iret
