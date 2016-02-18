all: asm

asm:
	nasm -g -f elf modul.asm -o modul.o
	cc -std=c99 -g main.c modul.o -o test_asm.out
    
clean:
	rm -f *.out
