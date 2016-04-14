    bits 64
	section .data
	
	section .text
	; rdi, rsi, rdx, rcx, r8, r9 // rax, r10, r11

global shl_intN
shl_intN:
	%define par_cislo rdi
	%define par_N rsi

	mov rax, 0
	mov rcx, par_N
	mov rdx, par_cislo
	
	clc
	
.smycka:
	rcl dword [rdx + rax * 4], 1		; rotuje se odzadu, protoze vyssi cisla jsou na vyssim indexu
	inc rax
	loop .smycka
	
	mov rax, 0
	adc rax, 0
	
	ret


global shr_intN
shr_intN:
	%define par_cislo rdi
	%define par_N rsi
	
	mov rcx, par_N
	mov rdx, par_cislo
	
	clc
	
.smycka:
	rcr dword [rdx + rcx * 4 - 4], 1		; rotuje se odzadu, protoze vyssi cisla jsou na vyssim indexu
	loop .smycka
	
	mov rax, 0
	adc rax, 0
	
	ret

global sub_intN_intN
sub_intN_intN:
	%define par_cislo1 rdi
	%define par_cislo2 rsi
	%define par_N rdx
	
	mov rcx, par_N
	clc						; vynulovani carry flagu, CF = 0
	mov rdx, 0
	
.smycka:
	mov eax, [rsi + rdx * 4]	; eax = rsi[index]
	sbb [rdi + rdx * 4], eax	; rdi[index] -=  eax
	inc rdx						; index++
	loop .smycka

	mov rax, 0
	adc rax, 0		; setc al, nastaveni carry flagu

	ret

global add_intN_intN
add_intN_intN:
	%define par_cislo1 rdi
	%define par_cislo2 rsi
	%define par_N rdx
	
	mov rcx, par_N
	clc						; vynulovani carry flagu, CF = 0
	mov rdx, 0
	
.smycka:
	mov eax, [rsi + rdx * 4]	; eax = rsi[index]
	adc [rdi + rdx * 4], eax	; rdi[index] += eax
	inc rdx						; index++
	loop .smycka

	mov rax, 0
	adc rax, 0		; setc al, nastaveni carry flagu

	ret


global mul_intN_int32
mul_intN_int32:
	%define par_cislo rdi
	%define par_nasobitel esi
	%define par_pocet edx
	
	movsx rcx, par_pocet
	mov r8, 0					; mezivysledek
	
.smycka:
	movsx rax, DWORD [par_cislo]; eax = *cislo
	mul DWORD par_nasobitel		; eax *= nasobitel
	
	add rax, r8					; secteni s predchozim mezivysledkem
	adc rdx, 0					; pridani pripadneho preteceni
	mov r8, rdx					; ulozeni mezivysledku pro dalsi kolo
	
	mov [par_cislo], eax		; *cislo = eax
	add par_cislo, 4			; cislo++

	LOOP .smycka
	
	ret

global add_intN_int32
add_intN_int32:
	%define par_cislo rdi
	%define par_scitatel esi
	%define par_N edx
	
	movsx rcx, par_N			; ecx = N
	dec rcx						; prvni cislo nasobime rovnou
	mov rdx, 1

	add [par_cislo], par_scitatel	; n[0] += scitanec

.smycka:
	jnc .konec
	adc [par_cislo + rdx * 4], DWORD 0
	inc rdx
	
	LOOP .smycka

.konec:
	ret
	

global div_intN_int32
div_intN_int32:
	%define par_cislo rdi
	%define par_delitel esi
	%define par_N edx
	
	movsx rcx, par_N				; velikost cisla
	mov rdx, 0						; zbytek
	
.smycka:
	movsx rax, DWORD [par_cislo + rcx * 4 - 4]	; eax = n[ecx - 1]
	div DWORD par_delitel						; vydeleni
	mov [par_cislo + rcx * 4 - 4], eax			; n[ecx - 1] = eax
	
	LOOP .smycka
	
	mov rax, rdx					; navratova hodnota - zbytek
	
	ret

