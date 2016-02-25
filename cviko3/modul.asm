    bits 32
    section .data

    section .text
    
global testret	
testret:
	enter 0, 0
	
	mov eax, [ebp + 8]
	
	leave
	ret
	
global soucet
soucet:
	%define a 	[ebp + 12]
	%define b   [ebp + 8]
	enter 0, 0
	
	mov eax, a
	add eax, b
	
	leave
	ret

global sumapole
sumapole:
	%define delka 	ebp + 12
	%define pole    ebp + 8
	enter 0, 0
	
	cmp [delka], DWORD 0
	je .nulova_delka
	
	mov eax, 0
	mov edx, [pole]
	mov ecx, [delka]
	
.soucet:
	add eax, [edx + ecx * 4 - 4]
	
	LOOP .soucet

.konec:
	leave
	ret

.nulova_delka:
	mov eax, 0
	jmp .konec


global pocet_mezer
pocet_mezer:
	enter 0, 0
	
	mov eax, 0			; pocet
	mov edx, [ebp + 8]	; pole
	
.pocet:
	cmp BYTE [edx], 0 	; *pole == 0
	je .konec
	cmp BYTE [edx], ' '	; *pole == ' '
	jne .preskoc
	inc eax				; pocet++
	
.preskoc:
	inc edx				; pole++
	jmp .pocet
	
.konec:
	leave
	ret

global pocet_malych
pocet_malych:
	enter 0, 0
	
	mov eax, 0			; pocet
	mov edx, [ebp + 8]	; pole
	
.pocet:
	test BYTE [edx], 0xff 	; (*pole & 0xFF) == 0
	jz .konec
	cmp BYTE [edx], 'a'	; *pole < 'a'
	jb .preskoc
	cmp BYTE [edx], 'z'	; *pole > 'z'
	ja .preskoc
	inc eax				; pocet++
	
.preskoc:
	inc edx				; pole++
	jmp .pocet
	
.konec:
	leave
	ret

global pocet_kl_zp
pocet_kl_zp:
	%define pocet_zapornych ebp + 20
	%define pocet_kladnych ebp + 16
	%define delka ebp + 12
	%define pole ebp + 8
	enter 0, 0
	push ebx

	mov edx, [pole]
	mov ecx, [delka]
	mov eax, 0		; kladne
	mov ebx, 0		; zaporne
	
.pocet:
	cmp ecx, DWORD 0
	jle .konec
	dec ecx
	cmp DWORD [edx + ecx * 4], 0
	jge .kladne_inc
	inc ebx
	
	jmp .pocet
	
.kladne_inc:
	inc eax
	jmp .pocet
	
.konec:
	mov edx, [pocet_kladnych] 	; ecx = &pocet_kladnych
	mov [edx], eax				; *pocet_kladnych = eax
	mov edx, [pocet_zapornych]
	mov [edx], ebx
	
	pop ebx
	leave
	ret

global to_lower
to_lower:
	enter 0, 0
	
	mov edx, [ebp + 8]	; pole
	
.pocet:
	cmp BYTE [edx], 0 	; *pole == 0
	jz .konec
	cmp BYTE [edx], 'A'	; *pole < 'A'
	jb .preskoc
	cmp BYTE [edx], 'Z'	; *pole > 'Z'
	ja .preskoc
	add BYTE [edx], 'a' - 'A'
	
.preskoc:
	inc edx				; pole++
	jmp .pocet
	
.konec:
	leave
	ret

global prumer_kl_zp
prumer_kl_zp:
	%define prumer_zapornych ebp + 20
	%define prumer_kladnych ebp + 16
	%define delka ebp + 12
	%define pole ebp + 8
	enter 0, 0
	push ebx
	push edi
	push esi

	mov edx, [pole]
	mov ecx, [delka]
	mov eax, 0		; soucet kladnych
	mov ebx, 0		; soucet zapornych
	mov esi, 0		; pocet kladnych
	mov edi, 0		; pocet zapornych
	
.pocet:
	cmp ecx, DWORD 0
	jle .konec
	dec ecx
	cmp DWORD [edx + ecx * 4], 0
	jge .kladne_inc
	inc edi
	add ebx, DWORD [edx + ecx * 4]
	
	jmp .pocet
	
.kladne_inc:
	inc esi
	add eax, DWORD [edx + ecx * 4]
	jmp .pocet
	
.konec:
	; deleni kladneho souctu
	cdq			; rozsireni pred delenim
	IDIV esi
	mov edx, [prumer_kladnych]
	mov [edx], eax
	
	mov eax, ebx
	cdq
	IDIV edi
	mov edx, [prumer_zapornych]
	mov [edx], eax
	
	pop esi
	pop edi
	pop ebx
	leave
	ret

global nahrada
nahrada:
	enter 0, 0
	
	mov cl, BYTE [ebp + 12]	; nahrada
	mov edx, [ebp + 8]			; pole
	
.pocet:
	cmp BYTE [edx], 0 	; *pole == 0
	jz .konec
	cmp BYTE [edx], '0'	; *pole < 'A'
	jb .preskoc
	cmp BYTE [edx], '9'	; *pole > 'Z'
	ja .preskoc
	mov BYTE [edx], cl
	
.preskoc:
	inc edx				; pole++
	jmp .pocet
	
.konec:
	leave
	ret

global pocet_lichych
pocet_lichych:
	%define delka ebp + 12
	%define pole ebp + 8
	enter 0, 0

	mov eax, 0		; pocet lichych cisel
	mov edx, [pole]
	mov ecx, [delka]
	
.pocet:
	cmp ecx, DWORD 0
	jle .konec
	dec ecx
	test DWORD [edx + ecx * 4], 1
	jz .pocet
	inc eax
	
	jmp .pocet
	
.konec:
	leave
	ret
