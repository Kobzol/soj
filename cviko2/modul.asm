    bits 32
    section .data
    extern soucet, delka, pole, bajty
    extern nasob32, nasob8
	extern posun

    section .text
    global prumer, prumer_bajty
    global vynasob32, vynasob8
    global posun_doprava32, posun_doprava8

prumer:
	mov eax, 0
	mov ecx, [delka]
	
.telo:
	add eax, [pole + (ecx - 1) * 4]
	LOOP .telo
	
	CDQ
	IDIV dword [delka]
	
	mov [soucet], eax
	ret
	
prumer_bajty:
	mov eax, 0
	mov ecx, [delka]
	
.telo:
    movsx ebx, byte [bajty + (ecx - 1)]
	add eax, ebx
	LOOP .telo
	
	CDQ
	IDIV dword [delka]
	
	mov [soucet], eax
	ret

vynasob32:
	mov ecx, [delka]
	
.telo:
	mov eax, [pole + (ecx - 1) * 4]
	imul dword [nasob32]
	mov [pole + (ecx - 1) * 4], eax
	
	LOOP .telo
	ret
	
vynasob8:
	mov ecx, [delka]
	
.telo:
    mov al, [bajty + (ecx - 1)]
	imul byte [nasob8]
	
	mov [bajty + (ecx - 1)], al
	
	LOOP .telo
	ret

posun_doprava32:
	mov ecx, [delka]

.telo:
	mov eax, [pole + (ecx - 1) * 4]
	mov edx, ecx
	
	mov cl, [posun]
	sar eax, cl
	mov ecx, edx
	
	mov [pole + (ecx - 1) * 4], eax
	
	LOOP .telo
	ret
	
posun_doprava8:
	mov ecx, [delka]
	
.telo:
    mov al, [bajty + (ecx - 1)]
    mov edx, ecx
    
    mov cl, [posun]
	sar al, cl
	
	mov ecx, edx
	mov [bajty + (ecx - 1)], al
	
	LOOP .telo
	ret
