org 0x7c00 ;to put the origin at the right place
bits 16 ;starting in 16 bits mode

mov al, 0x03
int 0x10

mov ax, 0x0600
mov bh, 0x07
mov cx, 0x0000
mov dx, 0x184f
int 0x10

mov ah, 0x02
mov dh, 0x00 ; row 0
mov dl, 0x00 ; column 0
int 0x10


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

;continue:
; Set up the segment registers
;mov ax, 0x0000 ; Set the data segment to 0
;mov ds, ax
;mov es, ax
;mov ss, ax

; Set up the stack pointer
;mov ax, 0xffff
;mov sp, ax

; Load the kernel into memory
;mov ah, 0x02 ; function 02h of int 13h is read disk
;mov al, 0x01 ; read one sector
;mov ch, 0x00 ; cylinder 0
;mov cl, 0x02 ; sector 2
;mov dh, 0x00 ; head 0
;mov dl, 0x80 ; drive 2 (disk1)
;mov bx, 0x1000 ; destination memory address
;int 0x13 ; call BIOS disk interrupt


; Jump to the kernel
; jmp 0x1000:0x0000

gdtr:
    dw 0xffff   ; limit 0:15
    dw 0x0000   ; limit 0:15
    db 0x00     ; base 16:23
    db 0x9a     ; access
    db 0xcf     ; flags and limit 16:29
    db 0x00     ; base 24:31
idt_descriptor:
    dw 256*8-1  ; limit (size of the IDT - 1)
    dd idt      ; base address of the IDT

    ; Interrupt Descriptor Table
idt:
    ; Interrupt 0 - Division by zero
    dw 0x8e00  ; offset 0:15
    dw 0x0000  ; selector
    db 0x00    ; zero
    db 0x00    ; type_attr
    dw 0x0000  ; offset 16:31

    ; Interrupt 1 - Debug exception
    dw 0x8e00  ; offset 0:15
    dw 0x0000  ; selector
    db 0x00    ; zero
    db 0x00    ; type_attr
    dw 0x0000  ; offset 16:31

    ; Interrupt 2 - Non-maskable interrupt
    dw 0x8e00  ; offset 0:15
    dw 0x0000  ; selector
    db 0x00    ; zero
    db 0x00    ; type_attr
    dw 0x0000  ; offset 16:31

    ; Interrupt 3 - Breakpoint
    dw 0x8e00  ; offset 0:15
    dw 0x0000  ; selector
    db 0x00    ; zero
    db 0x00    ; type_attr
    dw 0x0000  ; offset 16:31
    ; ... more interrupts ...
continue:
    
; IDT descriptor




; Page directory
page_directory:
    dd 0x00000083  ; 4KB page, present, read-write, supervisor level
    dd 0x00000000  ; 4KB page, not present
    ; ... more entries ...

; Page table
page_table:
    dd 0x00000083  ; 4KB page, present, read-write, supervisor level
    dd 0x00000000  ; 4KB page, not present
    ; ... more entries ...

; Load the page directory
mov eax, page_directory
mov cr3, eax

; Enable paging
;mov eax, cr0
;or eax, 0x80000000
;mov cr0, eax

; Load the IDT descriptor
    lidt [idt_descriptor]

    cli
    lgdt [gdtr]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

flush:
    mov eax, cr3
    mov cr3, eax
    
    ; from here, we are in 32bit, protected mode
    hlt
; Boot signature
times 510-($-$$) db 0
dw 0xaa55