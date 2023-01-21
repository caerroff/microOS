org 0x7c00 ;to put the origin at the right place
bits 16 ;starting in 16 bits mode


times 510-($-$$) db 0
dw 0xAA55