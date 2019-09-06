
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                              klib.asm
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

OffSetOfUserPrg1 equ 0A100h
OffSetOfUserPrg2 equ 0A200h
OffSetOfUserPrg3 equ 0A300h
OffSetOfUserPrg4 equ 0A400h

extrn _chBuf:near
;****************************
; void _cls()               *
;****************************

public _cls
_cls proc 
; 清屏
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
_cls endp

;********************************************************
; void _printChar(char ch)                            *
;********************************************************


 ;实现退格功能
public _backspace
_backspace proc     
push bp      
    mov ah,3   ;获取光标位置
    mov bh,0
    int 10h
          
    mov ah,2   ;置光标
    mov bh,0
    dec dl
    int 10h
          
    mov bp,sp
	mov al,[bp+4]   ;指向栈顶元素，即字符
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
_backspace endp

public _printChar
_printChar proc 
	push bp
		mov bp,sp
		mov al,[bp+4]   ;指向栈顶元素，即字符
		mov bl,2		
		mov ah,0eh		;显示字符光标前移
		int 10h
		mov sp,bp
	pop bp
	ret
_printChar endp


public _getChar
_getChar proc
	mov ah,0
	int 16h ;0号功能调用从键盘读入一个字符放入al中
	mov byte ptr [_chBuf],al
tag:
    ret
_getChar endp


public _restart
_restart proc
	push ds	
	push es
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	mov ah,0
	int 16h

    pop  es
	pop  ds    
	ret
_restart endp
    
    
public _RunProm1
_RunProm1 proc
	push ds	
	push es
    call _set_my_int9
      mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx, OffSetOfUserPrg1 ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,10                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域
      mov bx,0A100h
      call bx
    
	pop  es
	pop  ds  
    call set_old_int9
      ret
_RunProm1 endp

public _RunProm2
_RunProm2 proc
	push ds	
	push es
    call _set_my_int9

      mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx, OffSetOfUserPrg2  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,11                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域
      mov bx,0A200h
      call bx
    call set_old_int9
	pop  es
	pop  ds  
      ret
 _RunProm2 endp

public _RunProm3
_RunProm3 proc
	push ds	
	push es
    call _set_my_int9
      mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx, OffSetOfUserPrg3  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,12                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域
      mov bx,0A300h
      call bx
    call set_old_int9
	pop  es
	pop  ds  
     ret
_RunProm3 endp


public _RunProm4
_RunProm4 proc
	push ds	
	push es
    call _set_my_int9
      mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx, OffSetOfUserPrg4  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,13                ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域
      mov bx,0A400h
      call bx
    call set_old_int9
	pop  es
	pop  ds  
     ret
_RunProm4 endp

;********************************************************
;时钟中断                                             *
;********************************************************

;ES 是32位的寄存器，不能用TCC编译，要改成别的寄存器来保存
    icnt equ 4
	tdelay equ 4		; 计时器延迟计数
	icount db icnt		; 表示显示的字符，初值=delay
    tcount db tdelay     ; 计时器计数变量
; 时钟中断处理程序
Timer:
    push dx
    push ax
    push es
      
    mov	ax,0B800h		; 文本窗口显存起始地址
	mov	es,ax		; GS = B800h
    
    ;mov ah,0Fh		; 0000：黑底、1111：亮白字（默认值为07h）
	;mov al,'|'			; AL = 显示字符值（默认值为20h=空格符）
	;mov [es:((80*12+39)*2)],ax	; 屏幕第 24 行, 第 79 列
    
    
	dec byte ptr [tcount]		; 递减计数变量
	jnz endTimer			; >0：跳转
    
    dec byte ptr [icount]  
    
    cmp byte ptr [icount],0
    jz t0
    cmp byte ptr [icount],1
    jz t1
    cmp byte ptr [icount],2
    jz t2
    cmp byte ptr [icount],3
    jz t3
    
    t0:
        mov byte ptr es:[((80*24+78)*2)],'|'
        mov byte ptr [icount],icnt
        jmp t4
    t1:
        mov byte ptr es:[((80*24+78)*2)],92
        jmp t4
    t2:
        mov byte ptr [es:((80*24+78)*2)],'-'	; 屏幕第 24 行, 第 79 列
        jmp t4
    t3:
        mov byte ptr [es:((80*24+78)*2)],'/'	; 屏幕第 24 行, 第 79 列
        jmp t4
    t4:
        mov byte ptr [tcount],tdelay		; 重置计数变量=初值delay
endTimer:
	mov al,20h			; AL = EOI
	out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
    
    pop es
    pop ax
    pop dx
	iret			; 从中断返回
    
    
;*******************************************************
;尝试恢复int9 硬件中断
;*******************************************************

    save_int9:		
        push ax
		push es
		xor ax,ax
		mov es,ax
		cli
		push es:[24h]
		pop es:[200h]
		push es:[26h]
        pop es:[202h]
		sti
		pop es
		pop ax
		ret
        
    set_old_int9:	
        push ax
        push es
        xor ax,ax
        mov es,ax
        cli
        mov ax,[es:200h]
        mov word ptr es:[24h],ax
        
        mov ax,[es:202h]
        mov word ptr es:[26h],ax
        sti
        pop es
        pop ax
        ret
                          
    
;********************************************************
;键盘中断                                             *
;********************************************************
Message: db 'OUCH!OUCH!'
Message2: db 'My name is Van'
Message3: db 'I am an performance artist'
MessageCLS: db '                          '

maxCnt equ 6
keycnt db maxCnt


KeyInt:
    ; 一些上下文的保存以及初始化
    push dx
    push ax
    push es
    push bx
    push cx
    push bp
    push ds
    
    mov ax,cs
    mov ds,ax
    mov es,ax
    
    dec byte ptr[keycnt]
    cmp  byte ptr[keycnt],4
    jz DisplayStr1
    cmp byte ptr[keycnt],2
    jz DisplayStr2
    cmp keycnt,0
    jz DisplayStr3
    
    ; 清屏
    mov bp, offset MessageCLS
	;mov bp,ax	;ES:BP = 串地址
	mov cx,26	;CX=串长度
    mov ax,01301h	;AH = 13, AL = 01h
	mov bx,000ch
	mov dl,15
	mov dh,20
	int 10h
    
    
    jmp show      ;如果不需要改显示的内容，就直接退出中断
    
    DisplayStr1:
	mov bp, offset Message
	;mov bp,ax	;ES:BP = 串地址
	mov cx,10	;CX=串长度
    jmp show
    
    DisplayStr2:
    mov bp, offset Message2
    mov cx,14
    jmp show
    
    DisplayStr3:
    mov bp, offset Message3
    mov cx,26
    mov byte ptr[keycnt],6
    jmp show
    
    show:
	mov ax,01301h	;AH = 13, AL = 01h
	mov bx,000ch
	mov dl,15
	mov dh,20
	int 10h
	;ret
    
endKey:
    in al,60h           ; 从60h端口当中读取出扫描码
    mov al,20h          ; AL = EOI
    out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
	iret			; 从中断返回
    
    
public _set_my_int9 
    _set_my_int9 proc
        push ax
        push es
        xor ax,ax
        mov es,ax
        cli
        
        mov word ptr [es:24h],offset KeyInt	; 设置时钟中断向量的偏移地址
        mov word ptr [es:26h],cs		; 设置时钟中断向量的段地址=CS

        sti
        pop es
        pop ax
        ret
_set_my_int9 endp
    
;********************************************************
;通过中断调用程序                                       *
;********************************************************

myInt33:
    ;保存上下文，初始化寄存器信息

    sti
    push dx
    push ax
    push es
    push bx
    push cx
    push bp
    push ds
    
    call _RunProm1
    
    mov al,20h          ; AL = EOI
    out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
    iret
    
myInt34:
    ;保存上下文，初始化寄存器信息

    sti
    push dx
    push ax
    push es
    push bx
    push cx
    push bp
    push ds
    
    mov ax,cs
    mov ds,ax
    mov es,ax
    
    call _RunProm2
    
    mov al,20h          ; AL = EOI
    out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
    iret
    
    
myInt35:
    ;保存上下文，初始化寄存器信息

    sti
    push dx
    push ax
    push es
    push bx
    push cx
    push bp
    push ds
    
    mov ax,cs
    mov ds,ax
    mov es,ax
    
    call _RunProm3
    
    mov al,20h          ; AL = EOI
    out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
    iret
       

myInt36:
    ;保存上下文，初始化寄存器信息

    sti
    push dx
    push ax
    push es
    push bx
    push cx
    push bp
    push ds
    
    call _RunProm4
    
    mov al,20h          ; AL = EOI
    out 20h,al			; 发送EOI到主8529A
	out 0A0h,al			; 发送EOI到从8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
    iret
    
    
public _runPro1ByInt
_runPro1ByInt proc

    push ds
    push es

    int 33
    
    pop es
    pop ds
    ret
_runPro1ByInt endp

public _runPro2ByInt
_runPro2ByInt proc

    push ds
    push es

    int 34
    
    pop es
    pop ds
    ret
_runPro2ByInt endp

public _runPro3ByInt
_runPro3ByInt proc

    push ds
    push es

    int 35
    
    pop es
    pop ds
    ret
_runPro3ByInt endp

public _runPro4ByInt
_runPro4ByInt proc

    push ds
    push es

    int 36
    
    pop es
    pop ds
    ret
_runPro4ByInt endp




