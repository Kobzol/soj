all: modul_c modul_asm

modul_c:
	cc -std=c99 -g main.c modul.c -o test_c.out
    
modul_asm:
	nasm -g -f elf modul.asm -o modul.o
	cc -std=c99 -g main.c modul.o -o test_asm.out
    
clean:
	rm -f *.out
