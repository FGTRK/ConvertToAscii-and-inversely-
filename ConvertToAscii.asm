SECTION .bss ; Section containing uninitialized data
	BUFFLEN equ 16 ; We read the file 16 bytes at a time
	Buff: resb BUFFLEN ; Text buffer itself

SECTION .data ; Section containing initialized data
	HexStr: db 0, BUFFLEN dup (0, 0, 32)  ; Characters in hex-format. Two bytes are required for each character (FF - (46 46 32)). (The first byte is the number of characters * 3)
	endl: db 0xA, 0xD ; Switching to a new line

SECTION .text ; Section containing code
	global _start ; Linker needs this to find the entry point!
	%include "macros.asm" ; Connecting the library with system calls


_start:

; Read a buffer full of text from stdin:
Read:
	sys_read Buff, BUFFLEN
	
	cmp rax, 0 ; If rax=0, sys_read reached EOF on stdin
	je Exit ; Jump If Equal (to 0, from compare)
	
	mov r8, rax ; Save the number of bytes read for later

	; Write the length of the read text into memory, after multiplying by 3
	mov bl, 3
	mul bl
	mov [HexStr], al

	; Configuring registers for buffers
	mov rsi, Buff ; Place address of file buffer into rsi
	mov rdi, HexStr+1 ; The first byte means the size of the text, so we add 1 to the HexStr address
	mov rcx, 0 ; Clear Buff pointer to 0
	mov r9, 0; Clear HexStr pointer to 0

; Processing characters 16 at a time
Write:
	; Divide by the base of the number system to get two digits of the number in ah and al
	
	mov rax, 0
	mov bl, 16 
	mov al, [rsi+r9]
	div bl
	
	; Determine whether a symbol belongs to a number or a letter
	cmp al, 10 ; Compare the character in the al register
	jb Is_a_digit_al
	
	add al, 55 ; Is a letter
	jmp Comp_two ; Comparing the second operand
	

Is_a_digit_al:
	add al, '0' ; Is a digit
	

Comp_two:
	mov [rdi+rcx], al ; Writing down the translated character from al

	cmp ah, 10 ; Compare the character in the ah register
	jb Is_a_digit_ah
	
	add ah, 55
	jmp Next

Is_a_digit_ah:
	add ah, '0'

Next:	
	mov [rdi+rcx+1], ah ; Writing down the translated character from ah

	inc r9 ; Go to the next character
	add rcx, 3 ; The next place under the symbol starts at offset 3
	cmp r8, r9 ; Checking the number of processed characters
	jnz Write ; Going back to process the remaining characters

;Output processed characters
Write_in_out:
	; Transfer the number of processed characters to the register
	xor r9, r9
	mov r9b, [HexStr]
	sys_write HexStr+1, r9 ; Performing a system write call
	sys_write endl, 1 ; Moving to a new line
	jmp Read

; Exiting the program (0 - successfully)
Exit:
	sys_exit 0