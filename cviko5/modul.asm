    bits 32
    section .data

    section .text

global asm_atoi
asm_atoi:
	%define param_str ebp + 8
	enter 0, 0
	push ebx
	
	mov eax, 0
	mov ebx, [param_str]
	mov ecx, ebx
	inc ecx
	
	cmp [ebx], BYTE '-'
	cmove ebx, ecx
	
	mov ecx, 0
	
.smycka:
	cmp [ebx + ecx], BYTE 0
	je .konec
	
	cmp [ebx + ecx], BYTE '0'
	jl .konec
	cmp [ebx + ecx], BYTE '9'
	jg .konec
	
	IMUL eax, 10
	add al, [ebx + ecx]
	sub al, '0'
	
	inc ecx
	jmp .smycka
	
.konec:
	mov ebx, [param_str]
	mov ecx, eax
	IMUL eax, -1
	cmp [ebx], BYTE '-'
	cmovne eax, ecx

	pop ebx
	leave
	ret

global asm_find_min_max
asm_find_min_max:
	%define param_pole ebp + 8
	%define param_delka ebp + 12
	%define param_min ebp + 16
	%define param_max ebp + 20
	enter 0, 0
	push ebx
	
	cmp [param_delka], DWORD 0
	jle .konec
	
	mov ecx, [param_delka]	; counter = delka
	dec ecx
	
	mov eax, [param_pole]	; pole
	mov ebx, [eax]			; min
	mov edx, [eax]			; max
	
.smycka:
	cmp ecx, 0
	jle .vrat_hodnoty
	
	cmp [eax + ecx * 4], ebx
	cmovl ebx, [eax + ecx * 4]
	cmp [eax + ecx * 4], edx
	cmovg edx, [eax + ecx * 4]
	
	dec ecx
	jmp .smycka

.vrat_hodnoty:
	mov eax, [param_min]
	mov [eax], ebx
	mov eax, [param_max]
	mov [eax], edx

.konec:
	pop ebx
	leave
	ret

global asm_strstr
asm_strstr:
	%define param_haystack ebp + 8
	%define param_needle ebp + 12
	%define var_haystack_len ebp - 4
	%define var_needle_len ebp - 8
	enter 0, 0
	sub esp, 8	; allocate local variables
	
	push ebx
	push esi
	push edi
	
	push DWORD [param_haystack]
	CALL asm_strlen
	mov [var_haystack_len], eax
	push DWORD [param_needle]
	CALL asm_strlen
	mov [var_needle_len], eax
	add esp, 8
	
	mov edi, [param_haystack]
	mov ecx, 0
	
.smycka:
	mov eax, [var_haystack_len]		; eax = haystack_len
	sub eax, ecx					; eax -= index
	cmp eax, [var_needle_len]		; if eax < needle_len
	jl .not_found
	
	mov edx, edi
	add edx, [var_needle_len]
	add edx, ecx			; edx = haystack + needle_len + index
	mov bl, BYTE [edx]		; eax = saved byte
	mov [edx], BYTE 0		; set null string

	mov esi, edi
	add esi, ecx
	
	push ecx
	push esi
	mov esi, edx
	push DWORD [param_needle]
	CALL asm_strcmp			; call strcmp, if haystack == needle
	add esp, 8
	pop ecx
	
	mov [esi], bl			; restore original character
	
	cmp eax, 0				; check strcmp return value
	je .set_return

	inc ecx
	jmp .smycka

.not_found:
	mov eax, 0
	jmp .konec
	
.set_return:
	; set return value to address of current position of haystack
	mov eax, edi
	add eax, ecx
	
.konec:
	pop edi
	pop esi
	pop ebx

	add esp, 8

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
