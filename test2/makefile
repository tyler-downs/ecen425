hw.bin:		hwfinal.s
		nasm hwfinal.s -o hw.bin -l hw.lst

hwfinal.s:	clib.s ISRs.s interruptHandlers.s  linkedList.s test.s
		cat clib.s ISRs.s interruptHandlers.s test.s linkedList.s > hwfinal.s

test.s:		test.c
		cpp test.c test.i
		c86 -g test.i test.s

linkedList.s:	linkedList.c
		cpp linkedList.c linkedList.i
		c86 -g linkedList.i linkedList.s

clean:
		rm hw.bin hw.lst hwfinal.s test.s test.i \
			linkedList.s linkedList.i

