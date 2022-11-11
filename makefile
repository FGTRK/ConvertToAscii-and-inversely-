to: ConvertToAscii.asm macros.asm 

	nasm -f elf64 macros.asm  -o macros.o 
	nasm -f elf64 ConvertToAscii.asm  -o ConvertToAscii.o 
	ld macros.o ConvertToAscii.o  -o Test  #Linking the program x64
	clear 

from: ConvertFromAscii.asm macros.asm 

	nasm -f elf64 macros.asm  -o macros.o 
	nasm -f elf64 ConvertFromAscii.asm  -o ConvertFromAscii.o 
	ld macros.o ConvertFromAscii.o  -o Test  #Linking the program x64
	clear 
