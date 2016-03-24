    bits 64
	section .data
	
	section .text
	; rdi, rsi, rdx, rcx, r8, r9 // rax, r10, r11
	
global deleni
deleni:
	%define par_delenec_low rdi
	%define par_delenec_high rsi
	%define par_delitel rdx
	%define par_zbytek rcx
	
	mov r11, rdx		; delitel
	
	mov rdx, 0
	mov rax, par_delenec_high
	div QWORD r11
	
	mov r10, rax			; ulozeni mezivysledku, zbytek je v rdx
	
	mov rax, par_delenec_low
	div QWORD r11
	
	mov [rcx], rdx			; nastaveni zbytku
	mov rdx, r10			; ulozeni navratove hodnoty - vyssi cast
	
	ret
