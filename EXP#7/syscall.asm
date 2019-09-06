;********************************************************
; 21号系统中断                                          *
;********************************************************

extrn _printSysCallMsg:near
extrn _chBuf:near

extrn _Save_Process
extrn _do_fork
extrn _do_wait
extrn _do_exit

system_call:
;中断调用的参数
    sti
    
    push bx  ;将参数ax传进来，并弹出到bx寄存器中
    mov bx,ax
    
    push dx
    push ax
    push cx
    push bp
    push ds
    push es
    
    mov ax,cs
    mov ds,ax
    mov es,ax
    
    mov ax,bx   ; 将传进来的ax参数赋值给ax
    
    cmp al,0
    jz system_msg
    
    cmp al,1
    jz reboot
    
    cmp al,2
    jz sgetChar
    
    cmp al,3
    jz run_system_cls
    
    cmp al,4
    jz sys_print
    
    cmp al,5
    jz sys_back
    
    cmp al, 6
	jz to_forking
    
	cmp al, 7
	jz to_waiting
    
	cmp al, 8
	jz to_exiting

    
to_forking:
    pop es
    pop ds
    pop bp
    pop cx
    pop ax
    pop dx
    pop bx
    jmp forking
    
to_waiting:
    pop es
    pop ds
    pop bp
    pop cx
    pop ax
    pop dx
    pop bx
    jmp waiting
    
to_exiting:
    pop es
    pop ds
    pop bp
    pop cx
    pop ax
    pop dx
    pop bx
    jmp exiting
    
system_msg:
        call printMsg
        jmp system_call_end
    
    reboot:
        call my_reboot
        jmp system_call_end
        
    sgetChar:
        call igetChar
        jmp system_call_end
        
    run_system_cls:
        call system_call_cls
        jmp system_call_end

    sys_print:
        call print
        jmp system_call_end
        
    sys_back:
        call back_space
        jmp system_call_end
    
system_call_end:
    
    in al,60h
    mov al,20h          ; AL = EOI
    out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
    
    
    pop es
    pop ds
    pop bp
    pop cx
    pop ax
    pop dx
    pop bx
    
    iret
    
       
    
;********************************************************
;系统调用测试1                                          *
;********************************************************

printMsg:
    call near ptr _printSysCallMsg
    ret

my_reboot:
    sti
	int 19h
    ret

igetChar:
    sti
    push ax
    mov ah,0
	int 16h ;0号功能调用从键盘读入一个字符放入al中
	mov byte ptr [_chBuf],al
    pop ax
    ret

system_call_cls:
    sti
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
    ret

print:
    sti
    	push bp
		mov bp,sp
		mov al,[bp+26]   ;指向栈顶元素，即字符
		mov bl,2		
		mov ah,0eh		;显示字符光标前移
		int 10h
		mov sp,bp
	pop bp
    ret
    
back_space:
    push bp  
    mov ah,3   ;获取光标位置
    mov bh,0
    int 10h
          
    mov ah,2   ;置光标
    mov bh,0
    dec dl
    int 10h
          
    mov bp,sp
	mov al,[bp+26]   ;指向栈顶元素，即字符
	mov bl,2		
	mov ah,0eh		;显示字符光标前移
	int 10h
	mov sp,bp
    
    mov ah,3   ;获取光标位置
    mov bh,0
    int 10h
          
    mov ah,2   ;置光标
    mov bh,0
    dec dl
    int 10h
    pop bp
    ret
    
forking:
    .386
    push ss
    
    .8086
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
    
    .386
	push ds
	push es
	push fs
	push gs
	.8086
    
	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
    call near ptr _do_fork
    iret
    
waiting:
    .386
    push ss
    
    .8086
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
    
    .386
	push ds
	push es
	push fs
	push gs
	.8086
    
	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
    call near ptr _do_wait
    
exiting:
    .386
    push ss
    
    .8086
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
    
    .386
	push ds
	push es
	push fs
	push gs
	.8086
    
	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
    call near ptr _do_exit