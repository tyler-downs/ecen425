#####################################################################
# ECEn 425 Lab 4C Makefile

lab4C.bin:	lab4Cfinal.s
		nasm lab4Cfinal.s -o lab4C.bin -l lab4C.lst

lab4Cfinal.s:	clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s lab4c_app.s
		cat clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s lab4c_app.s > lab4Cfinal.s

interruptHandlers.s:	interruptHandlers.c
		cpp interruptHandlers.c interruptHandlers.i
		c86 -g interruptHandlers.i interruptHandlers.s

lab4c_app.s:	lab4c_app.c
		cpp lab4c_app.c lab4c_app.i
		c86 -g lab4c_app.i lab4c_app.s

linkedList.s:	linkedList.c
		cpp linkedList.c linkedList.i
		c86 -g linkedList.i linkedList.s

yakc.s:		yakc.c
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

clean:
		rm lab4C.bin lab4C.lst lab4Cfinal.s interruptHandlers.s interruptHandlers.i \
		lab4c_app.s lab4c_app.i yakc.s yakc.i linkedList.s linkedList.i
