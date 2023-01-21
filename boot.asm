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

end:

jmp $

times 510-($-$$) db 0
dw 0xAA55