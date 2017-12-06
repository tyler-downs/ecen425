#####################################################################
# ECEn 425 Lab 8 Makefile

lab8.bin:	lab8final.s
		nasm lab8final.s -o lab8.bin -l lab8.lst

lab8final.s:	clib.s simptris.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s queue.s lab8app.s 
		cat clib.s simptris.s ISRs.s interruptHandlers.s linkedList.s yakc.s yaks.s queue.s lab8app.s > lab8final.s

interruptHandlers.s:	interruptHandlers.c
		cpp interruptHandlers.c interruptHandlers.i
		c86 -g interruptHandlers.i interruptHandlers.s

lab8app.s:	lab8app.c
		cpp lab8app.c lab8app.i
		c86 -g lab8app.i lab8app.s

linkedList.s:	linkedList.c
		cpp linkedList.c linkedList.i
		c86 -g linkedList.i linkedList.s

yakc.s:		yakc.c
		cpp yakc.c yakc.i
		c86 -g yakc.i yakc.s

queue.s:        queue.c
		cpp queue.c queue.i
		c86 -g queue.i queue.s

clean:
		rm lab8.bin lab8.lst lab8final.s interruptHandlers.s interruptHandlers.i \
		lab8app.s lab8app.i yakc.s yakc.i linkedList.s linkedList.i queue.s queue.i
