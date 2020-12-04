	global main
	section .rodata
name:	db "../1.input",0
;iota:	times 256 db $-iota
	section .bss
fd:	resw 1			; fd: i32
len:	resq 1			; len: u64
arr:	resq 1			; arr: *u16[len]
text:	resq 1			; text: *u8
stat:	resb 144		; struct stat
buf:	resb 256		; buf: [u8;256]
	section .text
main:   push rbp
	mov rbp, rsp
	sub rsp, 8
	mov rdi, name
	xor rsi, rsi
	xor rdx, rdx
	mov rax, 2 		; syscall open(path, mode, flags)
	syscall
	mov [fd], rax		; fd = open(file, 0, 0)
	mov rdi, rax
	mov rsi, stat
	mov rax, 5		; syscall fstat(fd, &stat)
	syscall
	xor rdi, rdi
	mov rsi, [stat+48]	; stat.st_size
	mov rdx, 1		; PROT_READ
	mov r10,1		; MAP_SHARED
	mov r8, [fd]
	xor r9, r9		
	mov rax, 9		; syscall mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0)
	syscall
	mov [text], rax
	mov rdx, rax
	mov rdi, [fd]
	mov rax, 3		; syscall close(fd)
	syscall
	;; Read the number of newlines in the text file and allocate it as an array of u16s
	mov rdi, rax
	mov rcx, [stat+48]
	xor r11, r11
lc0:	cmp rcx, 0		; while (ctr>0)
	jz lc1
	movsx rax, byte [rdi+rdx]
	cmp rax, 10
	jne lc2
	add r11, 1
lc2:    add rdx, 1
	sub rcx, 1
	jmp lc0
lc1:    mov [len], r11
	xor rdi, rdi
	mov rsi, r11
	imul rsi, rsi, 2
	mov rdx, 3		; PROT_READ | PROT_WRITE
	mov r10, 34		; MAP_PRIVATE | MAP_ANONYMOUS
	xor r8,r9
	xor r9,r9
	mov rax, 9		; mmap
	syscall
	mov [arr], rax		; arr = mmap(..)
	;; Read integers into the mmap'd buffer
	mov rcx, [len]		; remaining ints
	mov rsi, [text]		; offset in text
	mov r9, [arr] 		; offset in arr
	xor rdx, rdx		; char
	xor rax, rax		; acc
ri0:	cmp rcx, 0		; read-int start of loop
	jz ri1
	movsx dx, byte [rsi] 
	cmp rdx, 10		; r11 == '\n'
	je ri2			; else 
	imul rax, rax, 10	; rax *= 10
	sub rdx, 48		; rdx -= '0'
	add rax, rdx		; rax += rdx
	jmp ri3
ri2:    mov [r9], ax		; read end of int, add to array
	add r9, 2 		; r9++
	sub rcx, 1		; rcx--
	xor rax, rax
ri3:	add rsi, 1		; str++
	jmp ri0
ri1:
	mov rdi, [arr]
	mov rsi, 0
	mov rdx, [len]
	sub rdx, 1
	call qs0
	pop rbp
	ret

	;; partitions an array
	;; param rdi arr ptr
	;; param rsi lo
	;; param rdx hi
	;; var rax i
	;; var rbx j
	;; var r10 pivot
	;; var r11 tmp
par0:	mov r10, rsi
	add r10, rdx
	shr r10, 1              ; pivot = (hi + lo) ÷ 2
	movsx r10, word [rdi + 2*r10]
	mov rbx, rdx
	add rbx, 1		; j = hi + 1
	mov rax, rsi
	sub rax, 1		; i = lo - 1
par1:	add rax, 1
	movsx r11, word [rdi + 2 * rax] 
	cmp r11, r10
	jl par1
par2:	sub rbx, 1
	movsx r11, word [rdi + 2 * rbx]
	cmp r11, r10
	jg par2
par3:	cmp rax, rbx
	jl par4			; if (i > j)
	mov rax, rbx
	ret			; ret j
par4:	movsx r12, word [rdi + 2*rbx]	; r12 = A[i]
	mov word [rdi + 2*rbx], r11w	; A[i] = r11 (A[j])
	mov word [rdi + 2*rax], r12w	; A[j] = r12 (A[i])
	jmp par1		; loop

	;; sorts an short array
	;; param rdi arr
	;; param rsi lo
	;; param rdx hi
qs0:	push rbp
	mov rbp, rsp
	sub rsp, 24
	mov [rbp-8], rsi
	mov [rbp-16], rdx
	cmp rsi, rdx
	jge qs1
	call par0
	mov [rbp-24], rax
	mov rdx, rax
	call qs0
	mov rsi, [rbp-24]
	add rsi, 1
	mov rdx, [rbp-16]
	call qs0
qs1:    mov rsi, [rbp-8]
	mov rdx, [rbp-16]
	pop rbp
	ret
