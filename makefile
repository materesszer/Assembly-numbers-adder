all:
	nasm -f elf -g -o final.o final.asm
	ld -m elf_i386 -g -o final final.o