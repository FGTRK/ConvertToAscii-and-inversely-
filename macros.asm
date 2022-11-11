SECTION .text


; Syscall write
; input parameters
; 1 - offset of message, 2 - lenght of message
%macro sys_write 2
	push rax
	push rdi
	mov rax,1 ; Number syscall sys_write
	mov rdi,1 ; Output in file with a File Descriptor 1: Standard Output
	mov rsi, %1 ; Pass offset of the message
	mov rdx, %2 ; Pass the length of the message
	syscall ; Make syscall to output the text to stdout
	pop rdi
	pop rax
%endmacro


; Syscall read
; input parameters
; 1 - offset of buffer, 2 - lenght of buffer
; output
; rax - number of characters read
%macro sys_read 2
	push rdi
	mov rax, 0 ; Specify sys_read call
	mov rdi, 0 ; Specify File Descriptor 0: Standard Input
	mov rsi, %1 ; Pass offset of the buffer to read to
	mov rdx, %2 ; Pass number of bytes to read at one pass
	syscall ; Call sys_read to fill the buffer
	pop rdi
%endmacro


; Syscall exit
; input parameters
; 1 - number of error (0 is good)
%macro sys_exit 1
	mov rax, 60 ; Number syscall sys_exit
	mov rdi, %1 ; Return a code of zero (The program was executed without errors)
	syscall ; Make syscall to terminate the program
%endmacro


