    bits 32
	section .data
	
	section .text

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
