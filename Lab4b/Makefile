#####################################################################
# ECEn 425 Lab 4B Makefile

lab4B.bin:	lab4Bfinal.s
		nasm lab4Bfinal.s -o lab4B.bin -l lab4B.lst

lab4Bfinal.s:	clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s lab4b_app.s
		cat clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s lab4b_app.s > lab4Bfinal.s

interruptHandlers.s:	interruptHandlers.c
		cpp interruptHandlers.c interruptHandlers.i
		c86 -g interruptHandlers.i interruptHandlers.s

lab4b_app.s:	lab4b_app.c
		cpp lab4b_app.c lab4b_app.i
		c86 -g lab4b_app.i lab4b_app.s

linkedList.s:	linkedList.c
		cpp linkedList.c linkedList.i
		c86 -g linkedList.i linkedList.s

yakc.s:		yakc.c
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

clean:
		rm lab4B.bin lab4B.lst lab4Bfinal.s interruptHandlers.s interruptHandlers.i \
		lab4b_app.s lab4b_app.i yakc.s yakc.i linkedList.s linkedList.i
