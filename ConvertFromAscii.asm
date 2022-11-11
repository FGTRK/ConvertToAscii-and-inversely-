SECTION .bss ; Section containing uninitialized data
	BUFFLEN equ 3 ; We read the file 16 bytes at a time
	Buff: resb BUFFLEN ; Text buffer itself

SECTION .data ; Section containing initialized data
	HexStr: db 0, BUFFLEN dup (0)  ; Characters in hex-format. 

SECTION .text ; Section containing code
	global _start ; Linker needs this to find the entry point!
	%include "macros.asm" ; Connecting the library with system calls


_start:
	mov r12, 100
	mov r14, 0
	mov r15, 0
; Read a buffer full of text from stdin:
Read:

	cmp r14, 15
	jne next1
	sys_read Buff, 4
	jmp next3

next1:	
	sys_read Buff, 3
next3:

	cmp rax, 0 ; If rax=0, sys_read reached EOF on stdin
	je Exit ; Jump If Equal (to 0, from compare)

	mov r8, rax ; Save the number of bytes read for later



	; Configuring registers for buffers
	mov rsi, Buff ; Place address of file buffer into rsi
	
	mov rcx, 0 ; Clear Buff pointer to 0
	mov r9, 0; Clear HexStr pointer to 0

; Processing characters 16 at a time
Write:
	mov rax, 0
	mov rbx, 0
	mov rdx, 0
	mov al, [Buff]
	mov bl, [Buff+1]
	
	
	; Determine whether a symbol belongs to a number or a letter
	cmp al, 0x40 ; Compare the character in the al register
	jb Is_a_digit_al
	
	sub al, 55 ; Is a letter
	jmp Comp_two ; Comparing the second operand
	

Is_a_digit_al:
	sub al, '0' ; Is a digit
	

Comp_two:
	
	cmp bl, 0x40 ; Compare the character in the al register
	jb Is_a_digit_ah
	
	sub bl, 55
	jmp Next

Is_a_digit_ah:
	sub bl, '0'
	

Next:
	mov dx, 16
	mul dx
	add al, bl

	mov [Buff], al ; Writing down the translated character from ah

	
	;jnz Write ; Going back to process the remaining characters

;Output processed characters
Write_in_out:
	; Transfer the number of processed characters to the register
	xor r9, r9
	mov r9b, [HexStr]



	sys_write Buff, 1 ; Performing a system write call
	
	
	dec r12
	cmp r12, 0
	je Exit
	inc r14

	cmp r14, 15
	jne next2
	dec r15
	mov r14, 0

next2:



	jmp Read

; Exiting the program (0 - successfully)
Exit:
	sys_exit 0