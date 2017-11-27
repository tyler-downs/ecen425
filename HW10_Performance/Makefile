#####################################################################
# ECEn 425 Lab 6 Makefile

lab6.bin:	lab6final.s
		nasm lab6final.s -o lab6.bin -l lab6.lst

lab6final.s:	clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s queue.s lab6app.s
		cat clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s queue.s lab6app.s > lab6final.s

interruptHandlers.s:	interruptHandlers.c
		cpp interruptHandlers.c interruptHandlers.i
		c86 -g interruptHandlers.i interruptHandlers.s

lab6app.s:	lab6app.c
		cpp lab6app.c lab6app.i
		c86 -g lab6app.i lab6app.s

linkedList.s:	linkedList.c
		cpp linkedList.c linkedList.i
		c86 -g linkedList.i linkedList.s

yakc.s:		yakc.c
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

queue.s:  queue.c
		cpp queue.c queue.i
		c86 -g queue.i queue.s

clean:
		rm lab6.bin lab6.lst lab6final.s interruptHandlers.s interruptHandlers.i \
		lab6app.s lab6app.i yakc.s yakc.i linkedList.s linkedList.i queue.s queue.i
