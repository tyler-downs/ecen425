#####################################################################
# ECEn 425 Lab 5 Makefile

lab5.bin:	lab5final.s
		nasm lab5final.s -o lab5.bin -l lab5.lst

lab5final.s:	clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s lab5app.s
		cat clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s lab5app.s > lab5final.s

interruptHandlers.s:	interruptHandlers.c
		cpp interruptHandlers.c interruptHandlers.i
		c86 -g interruptHandlers.i interruptHandlers.s

lab5app.s:	lab5app.c
		cpp lab5app.c lab5app.i
		c86 -g lab5app.i lab5app.s

linkedList.s:	linkedList.c
		cpp linkedList.c linkedList.i
		c86 -g linkedList.i linkedList.s

yakc.s:		yakc.c
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

clean:
		rm lab5.bin lab5.lst lab5final.s interruptHandlers.s interruptHandlers.i \
		lab5app.s lab5app.i yakc.s yakc.i linkedList.s linkedList.i
