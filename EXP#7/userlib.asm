
;*************** ********************
;*  int _fork()                       *
;**************** *******************
; 
public _fork
_fork proc 
	mov al,6
	int 21h
	ret
_fork endp

;*************** ********************
;*  void _wait()                       *
;**************** *******************
; 
public _wait
_wait proc 
	mov al,7
	int 21h
	ret
_wait endp

;*************** ********************
;*  void _exit()                       *
;**************** *******************
; 
public _exit
_exit proc 
    push bp
	mov bp,sp
	push bx

	mov al,8
	mov bx,[bp+4]
	int 21h

	pop bx
	pop bp

	ret
_exit endp



public _printChar
_printChar proc
    push bp
		mov bp,sp
		mov al,[bp+4]   ;指向栈顶元素，即字符
		mov bl,0		
		mov ah,0eh		;显示字符光标前移
		int 10h
		mov sp,bp
	pop bp
    ret
_printChar endp



public _cls
_cls proc
	push ax
	push bx
	push cx
	push dx		
     
	mov	ax, 0600h	; AH = 6,  AL = 0
						
	mov	bx, 0700h	; 黑底白字(BL = 7)
	mov	cx, 0		; 左上角: (0, 0)
	mov	dx, 184fh	; 右下角: (24, 79)	
	int	10h		; 显示中断
				;AH=06H表示将cx（左上角）dx（右下角）的矩形区域向上移动
	
	;复位光标
	mov ah, 02h
	mov bh, 0
	mov dx, 0000h
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax
_cls endp