section .data ;Segment with initialized data
	mess: db "Hello World! On 64-bit architecture", 10 ; String "Hello world", one byte per character
	messlen: equ $-mess ; Lenght string "Hello world"

section .bss
	lenbuffread: equ 1024
	buffread: resb lenbuffread


section .text ;Segment with instructions
	global _start ; Entry point to the program
	%include "macros.asm"



_start: ; Start the program
	sys_read buffread, lenbuffread		
	sys_write buffread, lenbuffread
	sys_write mess, messlen
	sys_exit 0