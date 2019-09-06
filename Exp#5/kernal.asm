;程序源代码（showstr.asm）
extern  macro %1    ;统一用extern导入外部标识符
  extrn %1
endm

extrn _cmain:near

.8086
_TEXT segment byte public 'CODE'
assume cs:_TEXT
    DGROUP group _TEXT,_DATA,_BSS
    
org 100h
start:
    
	xor ax,ax			; AX = 0
	mov es,ax			; ES = 0        ; 20h = 32 = 8*4 = int 8
	mov word ptr [es:20h],offset Timer	; 设置时钟中断向量的偏移地址
	mov word ptr [es:22h],cs		; 设置时钟中断向量的段地址=CS
    
    call save_int9
    
    mov word ptr [es:94h],offset myInt37 ; 33*4 = 132 = 84h
    mov word ptr [es:96h],cs             ; 33号中断
    mov word ptr [es:88h],offset myInt34 ; 34*4 = 136 = 88h
    mov word ptr [es:8ah],cs
    mov word ptr [es:8ch],offset myInt35
    mov word ptr [es:8eh],cs
    mov word ptr [es:90h],offset myInt36
    mov word ptr [es:92h],cs
    
    ;system call
    mov word ptr [es:84h],offset system_call ;21h*4 = 84h
    mov word ptr [es:86h],cs
    
    mov ax,cs
    
	mov ds,ax			; DS = CS
	mov es,ax			; ES = CS
	mov  ss, ax           ; SS = cs
	mov  sp, 0FFF0h  
    
;@1: 
    ;int 33
    ;call _pro_from_int
    call near ptr _cmain 
       
    jmp $
    
    include kliba.asm
    include syscall.asm
    
_TEXT ends

;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends

;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********

end start
