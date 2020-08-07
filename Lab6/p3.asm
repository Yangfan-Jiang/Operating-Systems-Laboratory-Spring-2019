; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   NASM汇编格式
; dx,sp,si,di

    delay equ 100					; 计时器延迟计数,用于控制画框的速度
    ddelay equ 100					; 计时器延迟计数,用于控制画框的速度

    org 0A100h					; 程序加载到100h，可用于生成COM
    
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
	mov ah,03h
      mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
    
mov bx,000ch
loop1:
	dec word[count]				; 递减计数变量
	 jnz loop1					; >0：跳转;
	dec word[dcount]				; 递减计数变量
      jnz loop1
    mov word[count],delay;
	mov word[dcount],ddelay 
	
DisplayStr:
	mov bp, str1
	;mov bp,ax	;ES:BP = 串地址
	mov cx,23	;CX=串长度
	mov ax,01301h	;AH = 13, AL = 01h
	mov dl,10
	mov dh,18
	int 10h
	add bx,1
    dec word[cnt]
      jnz loop1
    mov word[cnt],0
	ret
	
datadef:	
    count dw delay
	dcount dw ddelay
	cnt dw 10
	
str1:	db "MY-OS 1.0! jyf 17341068"
