CC=nasm
OPTIONS=-f bin

all: boot.asm
	$(CC) $(bin) boot.asm -o boot
	qemu-system-x86_64 -drive format=raw,file=boot