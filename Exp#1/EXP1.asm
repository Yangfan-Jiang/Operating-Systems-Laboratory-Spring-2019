org 07c00h
mov ax,0xB800
mov es,ax
mov byte[es:0],'@'
mov byte[es:1],7
jmp $