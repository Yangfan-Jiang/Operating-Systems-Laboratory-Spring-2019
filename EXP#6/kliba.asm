
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                              klib.asm
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


extrn _chBuf:near

extrn _Current_Process
extrn _Save_Process
extrn _Schedule
extrn _special
extrn _Program_Num
extrn _CurrentPCBno
extrn _Segment

;extrn _printSysCallMsg:near
;****************************
; void _cls()               *
;****************************

public _cls
_cls proc
    mov al,3
    int 21h
    ret
_cls endp
    
public _syscallMsg
_syscallMsg proc
    mov al,0
    int 21h
    ret
_syscallMsg endp

;********************************************************
; void _printChar(char ch)                            *
;********************************************************


 ;实现退格功能
public _backspace
_backspace proc     
    mov al,5
    int 21h
    ret
_backspace endp


public _printChar
_printChar proc 
    mov al,4
    int 21h
    ret
_printChar endp


public _getChar
_getChar proc
    mov al,2
    int 21h
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
      mov bx,0A100h ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,13                 ;起始扇区号 ; 起始编号为1
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
      mov bx, 0A100h  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,14                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域
      mov bx,0A100h
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
      mov bx, 0A100h  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,15                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域
      mov bx,0A100h
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
      mov bx, 0A100h  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,16                ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域
      mov bx,0A100h
      call bx
    call set_old_int9
	pop  es
	pop  ds  
    ret
_RunProm4 endp

    
    
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
    
    
    jmp showint      ;如果不需要改显示的内容，就直接退出中断
    
    DisplayStr1:
	mov bp, offset Message
	;mov bp,ax	;ES:BP = 串地址
	mov cx,10	;CX=串长度
    jmp showint
    
    DisplayStr2:
    mov bp, offset Message2
    mov cx,14
    jmp showint
    
    DisplayStr3:
    mov bp, offset Message3
    mov cx,26
    mov byte ptr[keycnt],6
    jmp showint
    
    showint:
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

myInt37:
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

    int 37
    
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
    

public _myreboot
_myreboot proc
    mov al,1
    int 21h
    ret
_myreboot endp



public _LoadAll
_LoadAll proc
	push ds	
	push es
      mov ax,2000h                ;段地址 ; 存放数据的内存基地址
      mov es,ax               ;设置段地址（不能直接mov es,段地址）
      mov bx,0A100h ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,13                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域
	pop  es
	pop  ds  

    ; P2
	push ds	
	push es
      mov ax,3000h                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx,0A100h  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,14                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
	pop  es
	pop  ds  

    ;P3
	push ds	
	push es
      mov ax,4000h                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx,0A100h  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,15                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
	pop  es
	pop  ds  

    ;P4
	push ds	
	push es
      mov ax,5000h                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx,0A100h  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,16                ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
	pop  es
	pop  ds  
    ret
_LoadAll endp




;*********************
;*  Data Initialize  *
;*********************
Finite dw 0	
icnt equ 4
tdelay equ 4		; 计时器延迟计数
icount db icnt		; 表示显示的字符，初值=delay
tcount db tdelay     ; 计时器计数变量


Pro_Timer:
;*****************************************
;*                Save                   *
; ****************************************
    cmp word ptr[_Program_Num],0
	jnz Save    ;不相等，跳转,保存当前程序的状态
	jmp Ori_Time_Int ;如果已经没有运行的程序了，就退出，然后恢复时钟中断
Save:
	inc word ptr[Finite]    
	cmp word ptr[Finite],1000 ; 并行运行一段时间后，就不并行了，改为正常的时钟中断
	jnz Lee                     ; 1600*50ms
    mov word ptr[_CurrentPCBno],0   ; 跳回内核
	mov word ptr[Finite],0
	mov word ptr[_Program_Num],0
	mov word ptr[_Segment],2000h
	jmp Pre
Lee:
    push ss
	push ax
	push bx
	push cx
	push dx
	push sp
	push bp
	push si
	push di
	push ds
	push es
	.386
	push fs
	push gs
	.8086
    
	mov ax,cs
	mov ds, ax
	mov es, ax

	call near ptr _Save_Process
	call near ptr _Schedule 
	
Pre:
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	call near ptr _Current_Process
	mov bp, ax          ; 汇编n调用C代码时，C函数的返回值保存在AX里

	mov ss,word ptr ds:[bp+0]         
	mov sp,word ptr ds:[bp+16] 

	cmp word ptr ds:[bp+32],0 ; bp+32对应PCB结构体里面的status，0表示NEW
	jnz No_First_Time

;*****************************************
;*                Restart                *
; ****************************************
Restart:
    call near ptr _special
	; 改寄存器上下文，运行当前PCB记录的进程
    ;bp  指向结构体，用来获取寄存器的值
	push word ptr ds:[bp+30]    ; FLAGS
	push word ptr ds:[bp+28]    ; CS
	push word ptr ds:[bp+26]    ; IP
                                ; 调用中断时会先将FLAGS，CS，IP入栈
	push word ptr ds:[bp+2]     ; 执行iret后会把SP,SP+2,SP+4分别出栈到
	push word ptr ds:[bp+4]     ; IP,CS,FLAGS寄存器
	push word ptr ds:[bp+6]
	push word ptr ds:[bp+8]
	push word ptr ds:[bp+10]
	push word ptr ds:[bp+12]
	push word ptr ds:[bp+14]
	push word ptr ds:[bp+18]
	push word ptr ds:[bp+20]
	push word ptr ds:[bp+22]
	push word ptr ds:[bp+24]

	pop ax
	pop cx
	pop dx
	pop bx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret

No_First_Time:	
	add sp,16 
	jmp Restart
	
    
Ori_Time_Int:    ;如果已经没有运行的程序了，就变成原来的风火轮
    push ax
    push es
	push ds
	
	mov ax,cs
	mov ds,ax

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
    pop ds
    pop es
	pop ax

	push ax         
	mov al,20h
	out 20h,al
	out 0A0h,al
	pop ax
	iret
	
	

SetTimer: 
    push ax
    mov al,34h   ; 设控制字值 
    out 43h,al   ; 写控制字到控制字寄存器 
    mov ax,29830 ; 每秒 20 次中断（50ms 一次） 
    out 40h,al   ; 写计数器 0 的低字节 
    mov al,ah    ; AL=AH 
    out 40h,al   ; 写计数器 0 的高字节 
	pop ax
	ret

public _setClock
_setClock proc
    push ax
	push bx
	push cx
	push dx
	push ds
	push es
	
    call SetTimer
    xor ax,ax
	mov es,ax
	mov word ptr es:[20h],offset Pro_Timer
	mov ax,cs
	mov word ptr es:[22h],cs
	
	pop ax
	mov es,ax
	pop ax
	mov ds,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_setClock endp


    
    