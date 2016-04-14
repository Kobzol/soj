    bits 32
	section .data
	
	section .text

global shrd_intN
shrd_intN:
	%define par_cislo ebp + 8
	%define par_N ebp + 12
	%define par_posun ebp + 16
	enter 0, 0
	push ebx
	
	dec dword [par_N]
	mov ebx, 0							; i = 0
	mov ecx, [par_posun]
	mov edx, [par_cislo]
	
.smycka:
	mov eax, [edx + ebx * 4 + 4]		; eax = cislo[i + 1]
	shrd [edx + ebx * 4], eax, cl		; cislo[i + 1] >> cislo[i], cl 
	inc ebx								; i++
	cmp ebx, [par_N]					; i < N
	jl .smycka

	shr dword [edx + ebx * 4], cl		; posunuti posledniho bytu, vlevo je 0
	
	pop ebx
	leave
	ret

global shl_intN
shl_intN:
	%define par_cislo ebp + 8
	%define par_N ebp + 12
	enter 0, 0
	
	mov eax, 0
	mov ecx, [par_N]
	mov edx, [par_cislo]
	
	clc
	
.smycka:
	rcl dword [edx + eax * 4], 1		; rotuje se odzadu, protoze vyssi cisla jsou na vyssim indexu
	inc eax
	loop .smycka
	
	mov eax, 0
	adc eax, 0
	
	leave
	ret

global shr_intN
shr_intN:
	%define par_cislo ebp + 8
	%define par_N ebp + 12
	enter 0, 0
	
	mov ecx, [par_N]
	mov edx, [par_cislo]
	
	clc
	
.smycka:
	rcr dword [edx + ecx * 4 - 4], 1		; rotuje se odzadu, protoze vyssi cisla jsou na vyssim indexu
	loop .smycka
	
	mov eax, 0
	adc eax, 0
	
	leave
	ret

global sub_intN_intN
sub_intN_intN:
	%define par_cislo1 ebp + 8
	%define par_cislo2 ebp + 12
	%define par_N ebp + 16
	enter 0, 0
	push edi
	push esi
	
	mov ecx, [par_N]
	mov edi, [par_cislo1]
	mov esi, [par_cislo2]
	
	clc							; vynulovani carry flagu, CF = 0
	mov edx, 0
	
.smycka:
	mov eax, [esi + edx * 4]	; eax = esi[index]
	sbb [edi + edx * 4], eax
	inc edx						; index++
	loop .smycka

	mov eax, 0
	adc eax, 0					; setc al, nastaveni carry flagu

	pop esi
	pop edi
	leave
	ret

global add_intN_intN
add_intN_intN:
	%define par_cislo1 ebp + 8
	%define par_cislo2 ebp + 12
	%define par_N ebp + 16
	enter 0, 0
	push edi
	push esi
	
	mov ecx, [par_N]
	mov edi, [par_cislo1]
	mov esi, [par_cislo2]
	
	clc						; vynulovani carry flagu, CF = 0
	mov edx, 0
	
.smycka:
	mov eax, [esi + edx * 4]	; eax = esi[index]
	adc [edi + edx * 4], eax
	inc edx						; index++
	loop .smycka

	mov eax, 0
	adc eax, 0		; setc al, nastaveni carry flagu

	pop esi
	pop edi
	leave
	ret

global mul_intN_int32
mul_intN_int32:
	%define par_cislo ebp + 8
	%define par_nasobitel ebp + 12
	%define par_N ebp + 16
	enter 0, 0
	push ebx
	push edi
	
	mov ebx, [par_cislo]
	mov ecx, [par_N]
	mov edi, 0					; mezivysledek
	
.smycka:
	mov eax, [ebx]				; eax = *cislo
	mul DWORD [par_nasobitel]	; eax *= nasobitel
	
	add eax, edi				; secteni s predchozim mezivysledkem
	adc edx, 0					; pridani pripadneho preteceni
	mov edi, edx				; ulozeni mezivysledku pro dalsi kolo
	
	mov [ebx], eax				; *cislo = eax
	add ebx, 4					; cislo++

	LOOP .smycka
	
	pop edi
	pop ebx
	leave
	ret

global add_intN_int32
add_intN_int32:
	%define par_cislo ebp + 8
	%define par_scitatel ebp + 12
	%define par_N ebp + 16
	enter 0, 0
	push ebx
	
	mov eax, [par_scitatel]		; eax = scitatel
	mov ebx, [par_cislo]		; ebx = cislo
	mov ecx, [par_N]			; ecx = N
	dec ecx						; prvni cislo nasobime rovnou
	mov edx, 1

	add [ebx], eax				; n[0] += scitanec

.smycka:
	jnc .konec
	adc [ebx + edx * 4], DWORD 0
	inc edx
	
	LOOP .smycka

.konec:
	pop ebx
	leave
	ret
	

global div_intN_int32
div_intN_int32:
	%define par_cislo ebp + 8
	%define par_delitel ebp + 12
	%define par_N ebp + 16
	enter 0, 0
	push ebx
	
	mov ebx, [par_cislo]			; cislo
	mov ecx, [par_N]				; velikost cisla
	mov edx, 0						; zbytek
	
.smycka:
	mov eax, [ebx + ecx * 4 - 4]	; eax = n[ecx - 1]
	div DWORD [par_delitel]			; vydeleni
	mov [ebx + ecx * 4 - 4], eax	; n[ecx - 1] = eax
	
	LOOP .smycka
	
	mov eax, edx
	
	pop ebx
	leave
	ret
