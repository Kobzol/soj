    bits 32
    section .data
    extern index, value, retezec, retezec_index
    extern x1, x2, x3
    global delka, pozdrav
    
pozdrav db 'Ahoj programatori', 10, 0
pole dd 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
delka dd 10

    section .text
    global do_pole, vrat_pole
    global retezec_zmen, secti

do_pole:
    mov eax, [index]
    mov edx, [value]
    mov [pole + eax * 4], edx    
    ret

vrat_pole:
    mov eax, pole
    ret

retezec_zmen:
	mov edx, DWORD [retezec_index]
	mov eax, [retezec + edx]
	sub eax, 32
	mov [retezec + edx], eax
	ret

secti:
	mov eax, [x1]
	add eax, [x2]
	add eax, [x3]
	ret
