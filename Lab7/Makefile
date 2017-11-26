#####################################################################
# ECEn 425 Lab 7 Makefile

lab7.bin:	lab7final.s
		nasm lab7final.s -o lab7.bin -l lab7.lst

lab7final.s:	clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s queue.s lab7app.s
		cat clib.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s queue.s lab7app.s > lab7final.s

interruptHandlers.s:	interruptHandlers.c
		cpp interruptHandlers.c interruptHandlers.i
		c86 -g interruptHandlers.i interruptHandlers.s

lab7app.s:	lab7app.c
		cpp lab7app.c lab7app.i
		c86 -g lab7app.i lab7app.s

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
		rm lab7.bin lab7.lst lab7final.s interruptHandlers.s interruptHandlers.i \
		lab7app.s lab7app.i yakc.s yakc.i linkedList.s linkedList.i queue.s queue.i
