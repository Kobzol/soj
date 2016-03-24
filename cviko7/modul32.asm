    bits 32
	section .data
	
	section .text

global asm_delenili
asm_delenili:
	%define par_x_low ebp + 8
	%define par_x_high ebp + 12
	%define par_y ebp + 16
	%define par_zbytek ebp + 20 
	enter 0, 0
	
	mov edx, 0
	mov eax, [par_x_high]		; x->high / y
	div DWORD [par_y]
	
	push eax				; ulozeni spodni casti, zbytek je v edx
	
	mov eax, [par_x_low]
	div DWORD [par_y]
	
	mov ecx, [par_zbytek]	; ecx = zbytek
	jcxz .konec
	mov [ecx], edx
.konec:
	pop edx					; ulozeni predchozi nizsi casti nyni do vyssi casti
	
	leave
	ret

global asm_nasobll
asm_nasobll:
	%define par_x_low ebp + 8
	%define par_x_high ebp + 12
	%define par_y_low ebp + 16
	%define par_y_high ebp + 20
	enter 0, 0
	
	mov eax, [par_x_high]	; x->high * y->low
	mul DWORD [par_y_low]
	mov ecx, eax			; ulozeni mezivysledku (dolni cast)
	
	mov eax, [par_y_high]	; y->high * x->low
	mul DWORD [par_x_low]
	add ecx, eax			; pricteni dolni casti
	
	mov eax, [par_x_low]	; x->low * y->low
	mul DWORD [par_y_low]
	
	add edx, ecx
	
	leave
	ret

global asm_nasobli
asm_nasobli:
	%define par_x_low ebp + 8
	%define par_x_high ebp + 12
	%define par_y ebp + 16
	enter 0, 0
	
	mov eax, [par_x_high]	; x->high * y
	mul DWORD [par_y]
	mov ecx, eax			; ulozeni mezivysledku
	
	mov eax, [par_x_low]	; x->low * y
	mul DWORD [par_y]
	
	add edx, ecx
	
	leave
	ret
	
global asm_nasobii
asm_nasobii:
	enter 0, 0
	
	mov eax, [ebp + 8]
	imul DWORD [ebp + 12]
	
	leave
	ret

global asm_soucetll
asm_soucetll:
	%define par_x_low ebp + 8
	%define par_x_high ebp + 12
	%define par_y_low ebp + 16
	%define par_y_high ebp + 20
	enter 0, 0
	
	mov eax, [par_x_low]
	add eax, [par_y_low]
	mov edx, [par_x_high]
	adc edx, [par_y_high]
	
	leave
	ret
