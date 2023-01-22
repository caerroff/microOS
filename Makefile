ASM=nasm
ASMFLAGS=-f bin
CC=gcc
CFLAGS=-ffreestanding -c -Wall

all: bootloader.asm
	$(ASM) $(ASMFLAGS) bootloader.asm -o bootloader.o
	qemu-system-x86_64 -drive format=raw,file=bootloader.o

test: bootloader.asm kernel.c
	$(ASM) -felf32 -o bootloader.o bootloader.asm
	$(CC) $(CFLAGS) kernel.c -o kernel.o
	ld -T linker.ld -o kernel.bin kernel.o bootloader.o
