all: asm64

asm:
	nasm -g -f elf modul32.asm -o modul.o
	cc -std=c99 -m32 -O0 -g main32.c modul.o -o test_asm.out

asm64: 
	nasm -g -f elf64 modul.asm -o modul.o
	cc -std=c99 -O0 -g main.c modul.o -o test_asm.out

clean:
	rm -f *.out
