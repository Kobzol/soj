    bits 64
	section .data
_tmp dd 0,0,0,0

	section .text
	; rdi, rsi, rdx, rcx, r8, r9 // rax, r10, r11
	extern sqrt, sqrtf

global asm_vec_length:
asm_vec_length:
	%define par_pole rdi
	%define par_n	 esi
	
	movsd xmm0, [par_pole]		; nacteni prvni slozky
	mulsd xmm0, xmm0			; xmm0 = xmm0^2
	movsx rcx, par_n
	dec rcx
	
.smycka:
	movsd xmm1, [par_pole + rcx * 8]	; xmm1 = pole[i]
	mulsd xmm1, xmm1					; xmm1 = xmm1^2
	addsd xmm0, xmm1
	loop .smycka
	
	call sqrt
	ret

global asm_vec_sumd
asm_vec_sumd:
	%define par_pole rdi
	%define par_pole2 rsi
	%define par_n	  edx
	
	movupd xmm0, [par_pole]		; nacteni prvnich 2 doublu
	addpd xmm0, [par_pole2]
	movsx rcx, par_n
	sar rcx, 1			; delka /= 2
	dec rcx
	
	sub rsp, 16
	
.smycka:
	add par_pole, 16 		; posunuti o 2 prvky
	add par_pole2, 16		; posunuti o 2 prvky
	addpd xmm0, [par_pole]	; pricteni 2 doublu
	addpd xmm0, [par_pole2]	; pricteni 2 doublu
	loop .smycka
	
	movupd [rsp], xmm0
	addsd xmm0, [rsp + 8] ; reduce 2 doublu do jednoho
	
	add rsp, 16
	ret

global asm_pythagoras
asm_pythagoras:
	%define par_a 	xmm0
	%define par_b	xmm1
	
	mulss xmm0, xmm0	; a^2
	mulss xmm1, xmm1	; b^2
	
	addss xmm0, xmm1	; a^2 + b^2
	
	call sqrtf			; return sqrtf(a^2 + b^2)
	ret

global asm_objem_koule
asm_objem_koule:
	%define par_r 	xmm0
	%define par_pi	xmm1
	
	movss xmm2, xmm0	; r^3
	mulss xmm2, xmm0
	mulss xmm2, xmm0
	
	mulss xmm2, xmm1	; r3 * pi

	mov eax, 4
	cvtsi2ss xmm3, eax
	mulss xmm2, xmm3
	
	mov eax, 3
	cvtsi2ss xmm3, eax
	divss xmm2, xmm3
	
	movss xmm0, xmm2
	ret

global asm_vec_sum
asm_vec_sum:
	%define par_pole rdi
	%define par_n	  esi
	
	movups xmm0, [par_pole]		; nacteni prvnich 4 floatu
	movsx rcx, esi
	sar rcx, 2			; delka /= 4
	dec rcx
	
.smycka:
	add rdi, 16 		; posunuti o 4 prvky
	addps xmm0, [rdi]	; pricteni 4 floatu
	loop .smycka
	
	movups [_tmp], xmm0
	addss xmm0, [_tmp + 4]	; reduce 4 floatu do jednoho
	addss xmm0, [_tmp + 8]
	addss xmm0, [_tmp + 12]
	
	ret

global asm_findmax
asm_findmax:
	%define par_pole rdi
	%define par_n	  esi
	movss xmm0, [par_pole]		; uhodneme nejvetsi prvek
	movsx rcx, par_n			; loop counter
	dec rcx
	
.smycka:
	comiss xmm0, [par_pole + rcx * 4]	; xmm0 += pole[i]
	ja .pokracuj
	movss xmm0, [par_pole + rcx * 4]
.pokracuj:
	loop .smycka
	
	ret

global asm_prumer
asm_prumer:
	%define par_pole rdi
	%define par_n	  esi
	mov eax, 0
	cvtsi2ss xmm0, eax			; suma
	movsx rcx, par_n			; loop counter
	
.smycka:
	addss xmm0, [par_pole + rcx * 4 - 4]	; xmm0 += pole[i]
	loop .smycka
	
	cvtsi2ss xmm1, par_n		; xmm1 = N
	divss xmm0, xmm1			; suma /= N
	
	ret

global asm_round
asm_round:
	cvtss2si rax, xmm0
	ret

global asm_obvod
asm_obvod:
	addsd xmm0, xmm0	; 2 * r
	mulsd xmm0, xmm1	; 2r * pi
	ret

global asm_retfl
asm_retfl:
	ret
	
global asm_retdbl
asm_retdbl:
	ret
