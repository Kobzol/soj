all: asm

asm:
	nasm -g -f elf modul.asm -o modul.o
	cc -std=c99 -m32 -O0 -g main.c modul.o -lm -o test_asm.out

asm64: 
	nasm -g -f elf64 modul.asm -o modul.o
	cc -std=c99 -O0 -g main.c modul.o -lm -o test_asm.out

clean:
	rm -f *.out
