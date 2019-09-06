;org 100h ; 告诉编译器程序加载到100H处
org 07c00h

mov ax,cs ; 通过AX中转, 将CS的值传送给DS和ES
mov ds,ax
mov es,ax
mov ss,ax
; 显示字符串1 "MY-OS 1.0"（开始）
delay equ 10000
ddelay equ 14000

mov bx,000ch
loop1:
	dec word[count]
	  jnz loop1	
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
      jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay
	
	mov bp, str1
	;mov bp,ax	;ES:BP = 串地址
	mov cx,23	;CX=串长度
	mov ax,01301h	;AH = 13, AL = 01h
	
	mov dl,30
	mov dh,10
	int 10h
	add bx,1
	dec word[cnt]
	  jnz loop1
	

mov ah,0 ; 功能号
int 16h ; 调用16H号中断
; 按任一键：退出返回DOS

mov ax,4c00h
int 21h


datadef:	
    count dw delay
	dcount dw ddelay
	cnt dw 25
	
str1: db "MY-OS 1.0! jyf 17341068"
