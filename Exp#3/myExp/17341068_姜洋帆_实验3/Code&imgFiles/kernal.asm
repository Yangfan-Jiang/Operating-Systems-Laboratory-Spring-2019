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
    mov  ax,  cs
	mov  ds,  ax           ; DS = CS
	mov  es,  ax           ; ES = CS
	mov  ss,  ax           ; SS = cs
	mov  sp, 0FFF0h  
    
;@1: 
    call near ptr _cmain 
       
    jmp $
    include kliba.asm
    
_TEXT ends

;************DATA segment*************
_DATA segment word public 'DATA'
_DATA ends

;*************BSS segment*************
_BSS	segment word public 'BSS'
_BSS ends
;**************end of file***********

end start
