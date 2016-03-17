    bits 64
	section .data
	
	section .text
	extern strncmp
	; rdi, rsi, rdx, rcx, r8, r9 // rax, r10, r11

global asm_strstr
asm_strstr:
	%define param_haystack rdi
	%define param_needle rsi
	push r12
	push r13
	push r14
	
	mov r12, param_haystack
	mov r13, param_needle
	
	mov rdi, param_needle
	CALL asm_strlen
	mov r14d, eax
	
.smycka:
	cmp [r12], BYTE 0
	je .nenalezeno

	mov rdi, r12
	mov rsi, r13
	mov rdx, r14
	CALL strncmp
	cmp eax, 0
	je .set_return

	inc r12
	jmp .smycka

.nenalezeno:
	mov rax, 0
	jmp .konec
	
.set_return:
	; set return value to address of current position of haystack
	mov rax, r12
	
.konec:
	pop r14
	pop r13
	pop r12
	ret

global asm_find_min_max
asm_find_min_max:
	%define param_pole rdi
	%define param_delka esi
	%define param_min rdx
	%define param_max rcx
	
	cmp param_delka, DWORD 0
	jle .konec
	
	mov r10, param_min
	mov r11, param_max
	
	movsx rcx, param_delka
	dec rcx
	
	mov r8d, DWORD [param_pole]	; min
	mov r9d, DWORD [param_pole]	; max
	
.smycka:
	cmp rcx, 0
	jle .vrat_hodnoty
	
	cmp [param_pole + rcx * 4], r8d
	cmovl r8d, [param_pole + rcx * 4]
	cmp [param_pole + rcx * 4], r9d
	cmovg r9d, [param_pole + rcx * 4]
	
	dec rcx
	jmp .smycka

.vrat_hodnoty:
	mov [r10], r8d
	mov [r11], r9d

.konec:
	ret

global asm_strcmp
asm_strcmp:
	%define param_dest rdi
	%define param_src rsi
	
	mov r8, rdi
	mov r9, rsi
	
	CALL asm_strlen
	
	mov rdi, r8
	mov rsi, r9
	
	inc rax			; musime loopovat jednou navic
	mov rcx, rax	; nastaveni poctu loopovani
	mov dx, ds
	mov es, dx
	
	repe cmpsb		; cmp(src - dest)
	
	; konstanty pro cmov
	mov rax, 1
	mov rdi, 0
	mov rsi, -1
	
	; kontrola flagu po poslednim provedeni cmpsb
	cmove rax, rdi	; pokud se rovnaly, dame do vysledku 0
	cmova rax, rsi	; pokud bylo src > dest, vratime -1
	
	ret

global asm_strlen
asm_strlen:
	%define param_str rdi
	
	mov rsi, param_str
	mov al, 0				; pripraveni hodnoty pro porovnavani
	mov dx, ds				; pripraveni extra segmentu (es = ds)
	mov es, dx
	
	mov rcx, -1				; maximalni moznost delky retezce, pro loop
	
	repne scasb				; sken retezce, dokud se nenajde hodnota al
	; edi je nyni za nulou
	sub rdi, rsi	; odecteme od edi adresu retezce
	dec rdi
	
	mov eax, edi

	ret

global asm_atoi
asm_atoi:
	%define param_str rdi
	
	mov rax, 0
	mov rdx, param_str
	
	mov rcx, param_str
	inc rcx
	
	cmp [rdx], BYTE '-'
	cmove rdx, rcx
	
	mov rcx, 0
	mov r8, 0
	
.smycka:
	cmp [rdx + rcx], BYTE 0
	je .konec
	
	cmp [rdx + rcx], BYTE '0'
	jl .konec
	cmp [rdx + rcx], BYTE '9'
	jg .konec
	
	IMUL rax, 10
	movsx r8, BYTE [rdx + rcx]
	add rax, r8
	sub rax, BYTE '0'

	inc rcx
	jmp .smycka
	
.konec:
	mov rcx, rax
	IMUL rax, -1
	cmp [param_str], BYTE '-'
	cmovne rax, rcx

	ret

global atob
atob:
	%define par_cislo rdi
	%define par_str rsi
	
	mov rax, par_str			; return value = str
	mov rcx, 64

.smycka:
	mov [rsi], byte '0'			; *str = '0'
	shl par_cislo, 1			; cislo << 1
	adc [rsi], byte 0			; *str += carry
	inc rsi						; str++
	
	loop .smycka

	mov [rsi], byte 0			; null termination

	ret

global soucetll
soucetll:
	%define par_pole rdi
	%define par_delka esi
	
	movsx rcx, par_delka		; delka -> 64bit, znamenkove rozsireni
	mov rax, 0					; soucet = 0
	
.smycka:
	add rax, [par_pole + rcx * 8 - 8]
	loop .smycka

	ret

global soucetl
soucetl:
	%define par_pole rdi
	%define par_delka esi
	
	movsx rcx, par_delka		; delka -> 64bit, znamenkove rozsireni
	mov rax, 0					; soucet = 0
	
.smycka:
	movsx rdx, DWORD [par_pole + rcx * 4 - 4]
	add rax, rdx
	loop .smycka

	ret

global soucet
soucet:
	%define par_pole rdi
	%define par_delka esi
	
	movsx rcx, par_delka		; delka -> 64bit, znamenkove rozsireni
	mov rax, 0					; soucet = 0
	
.smycka:
	add eax, [par_pole + rcx * 4 - 4]
	loop .smycka

	ret

global nasob
nasob:
	%define par_a edi
	%define par_b esi
	
	xor rax, rax
	mov eax, par_a
	imul par_b
	
	ret
	
	
global nasobl
nasobl:
	%define par_a rdi
	%define par_b rsi
	
	mov rax, par_a
	imul par_b

	ret
