org 0x7c00 ;to put the origin at the right place
bits 16 ;starting in 16 bits mode

mov ah, 0x0e
mov bx, message
print:
    mov al, [bx]
    cmp al, 0
    je end
    int 0x10
    inc bx
    jmp print


message:
    db "--- Welcome to microOS ---", 0

readingMessage:
    db "Reading from Disk...", 0


; Bootloader in x86 assembly
end:
    mov bx, readingMessage
    mov ah, 0x0e
    mov al, 0x0A
    int 0x10
    mov al, 0x0A
    int 0x10
    mov al, 0x0D
    int 0x10
printTwo:
    mov al, [bx]
    cmp al, 0
    je continue
    int 0x10
    inc bx
    jmp printTwo

continue:
; Set up the segment registers
mov ax, 0x0000 ; Set the data segment to 0
mov ds, ax
mov es, ax
mov ss, ax

; Set up the stack pointer
mov ax, 0xffff
mov sp, ax

; Load the kernel into memory
mov ah, 0x02 ; function 02h of int 13h is read disk
mov al, 0x01 ; read one sector
mov ch, 0x00 ; cylinder 0
mov cl, 0x02 ; sector 2
mov dh, 0x00 ; head 0
mov dl, 0x80 ; drive 0 (floppy)
mov bx, 0x1000 ; destination memory address
int 0x13 ; call BIOS disk interrupt

; Jump to the kernel
jmp 0x1000:0x0000

; Boot signature
times 510-($-$$) db 0
dw 0xaa55