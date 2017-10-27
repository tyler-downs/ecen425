#####################################################################
# ECEn 425 Lab 4D Makefile

lab4D.bin:	lab4Dfinal.s
		nasm lab4Dfinal.s -o lab4D.bin -l lab4D.lst

lab4Dfinal.s:	clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s lab4d_app.s
		cat clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s lab4d_app.s > lab4Dfinal.s

interruptHandlers.s:	interruptHandlers.c
		cpp interruptHandlers.c interruptHandlers.i
		c86 -g interruptHandlers.i interruptHandlers.s

lab4d_app.s:	lab4d_app.c
		cpp lab4d_app.c lab4d_app.i
		c86 -g lab4d_app.i lab4d_app.s

linkedList.s:	linkedList.c
		cpp linkedList.c linkedList.i
		c86 -g linkedList.i linkedList.s

yakc.s:		yakc.c
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

clean:
		rm lab4D.bin lab4D.lst lab4Dfinal.s interruptHandlers.s interruptHandlers.i \
		lab4d_app.s lab4d_app.i yakc.s yakc.i linkedList.s linkedList.i
