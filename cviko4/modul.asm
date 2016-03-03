    bits 32
    section .data

    section .text

global asm_replace
asm_replace:
	enter 0, 0
	%define param_str ebp + 8
	%define param_znak ebp + 12
	
	push edi
	push esi
	
	mov edi, [param_str]
	mov esi, edi
	mov ecx, -1
	mov ax, ds
	mov es, ax
	
	mov dl, [param_znak]
	
.smycka:
	lodsb
	cmp al, 0
	je .konec
	
	cmp al, dl
	je .smycka
	stosb
	jmp .smycka
	
.konec:
	mov [edi], byte 0		; zkraceni delky retezce

	pop esi
	pop edi
	
	leave
	ret

global asm_memcpy
asm_memcpy:
	enter 0, 0
	%define param_dest ebp + 8
	%define param_src ebp + 12
	%define param_length ebp + 16
	
	push edi
	push esi
	
	cmp DWORD [param_length], 0
	je .konec
	
	mov edi, [param_dest]
	mov esi, [param_src]
	mov ecx, [param_length]
	mov ax, ds
	mov es, ax
	
	;source = 0
	;dest = 1
	;edx = 5
	
	mov edx, esi
	add edx, [param_length]
	cmp edx, edi
	jb .zleva
	cmp edi, edx
	jb .zprava
	
.zleva:
	rep movsb
	
	jmp .konec
.zprava:
	STD
	
	add esi, [param_length]
	dec esi
	add edi, [param_length]
	dec edi
	
	jmp .zleva
	
.konec:
	pop esi
	pop edi
	
	CLD

	leave
	ret

global asm_str2upper
asm_str2upper:
	enter 0, 0
	%define param_str ebp + 8
	
	push edi
	push esi
	
	mov edi, [param_str]
	mov esi, edi
	mov ecx, -1
	mov ax, ds
	mov es, ax
	
.zpet:
	lodsb
	cmp al, 0				; or al, al
	jz .konec
	
	mov dl, al
	sub dl, ('a' - 'A')
	
	; cmov verze
	cmp al, 'a'
	cmovb edx, eax
	cmp al, 'z'
	cmova edx, eax
	mov al, dl
	
	; jump verze
	;cmp al, 'a'
	;jb .ulozeni
	;cmp al, 'z'
	;ja .ulozeni
	;sub al, ('a' - 'A')		; and ~('a' - 'A')

.ulozeni:
	stosb
	jmp .zpet
	
.konec:
	pop esi
	pop edi
	
	leave
	ret

global asm_strcmp
asm_strcmp:
	enter 0, 0
	%define param_dest ebp + 8
	%define param_src ebp + 12
	
	push edi
	push esi
	
	mov esi, [param_src]		; zdroj
	mov edi, [param_dest]		; cil
	
	push esi
	CALL asm_strlen
	add esp, 4		; uklizeni zasobniku
	
	inc eax			; musime loopovat jednou navic
	mov ecx, eax	; nastaveni poctu loopovani
	mov dx, ds
	mov es, dx
	
	repe cmpsb		; cmp(src - dest)
	
	; konstanty pro cmov
	mov eax, 1
	mov edi, 0
	mov esi, -1
	
	; kontrola flagu po poslednim provedeni cmpsb
	cmove eax, edi	; pokud se rovnaly, dame do vysledku 0
	cmova eax, esi	; pokud bylo src > dest, vratime -1
	
	pop esi
	pop edi
	
	leave
	ret

global asm_strlen
asm_strlen:
	enter 0, 0
	%define param_str ebp + 8
	
	push edi
	
	mov edi, [param_str]	; destination string
	mov al, 0				; pripraveni hodnoty pro porovnavani
	mov dx, ds				; pripraveni extra segmentu (es = ds)
	mov es, dx
	
	mov ecx, -1				; maximalni moznost delky retezce, pro loop
	; DF je defaultne 0, nechame ho tak
	
	repne scasb				; sken retezce, dokud se nenajde hodnota al
	; edi je nyni za nulou
	sub edi, [param_str]	; odecteme od edi adresu retezce
	dec edi
	
	mov eax, edi
	
	pop edi
	
	leave
	ret
