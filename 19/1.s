global _start

	section .text
	;; inputs: rdi ptr rcx len
	;; outputs: rax,rdi,rcx
readint:
	mov rax, 0
readint_loop:
	cmp rcx, 0
	je readint_end
	movzx r8, byte [rdi]
	cmp r8, 10 		; ascii newline
	je readint_end
	sub r8, 48 		; ascii 0
	imul rax, 10
	add rax, r8
	inc rdi
	dec rcx
	jmp readint_loop
readint_end:	
	ret
	
_start:
	;;
	;; name      offset
	;; --------------------
	;; stat      rbp-144
	;; len	     rbp-152
	;; fd	     rbp-160
	;; fptr      rbp-168


	;;
	
	push rbp
	mov rbp, rsp
	sub rsp, 168
	mov rdi, file
	mov rsi, 0 		; read only
	mov rdx, 0 		; mode
	mov rax, 2 		; sycall stat
	syscall
	mov [rbp-160], rax

	mov rdi, rax
	lea rsi, [rbp-144]
	mov rax, 5 		; fstat
	syscall
	
	mov rax, [rbp-96]
	mov [rbp-152], rax 		; store file size in dedicated memory

	mov rdi, 0
	mov rsi, rax
	mov rdx, 1		; PROT_READ
	mov r10, 1 		; MAP_SHARED
	mov r8, [rbp-160] 	; backed by the file
	mov r9, 0		; no offset
	mov rax, 9		; mmap
	syscall
	mov [rbp-168], rax

	mov rdi, rax
	mov rcx, [rbp-152]
	xor r11, r11
start_readint_loop:	
	call readint
fuel:
	mov rdx, 0 		; zero out upper divisor
	mov rsi, 3
	div rsi
	sub rax, 2
loopback:	
	cmp rcx, 0
	je end
acc:	
	add r11, rax		; add fuel requirement to r11
	add rdi, 1
	jmp start_readint_loop
end:	
	;;  todo: nicer output
	mov rdi, r11
	mov rax, 60 		; exit
	syscall

	section .rodata

file:	db "1.input",0
