
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                              klib.asm
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

OffSetOfUserPrg1 equ 0A100h
OffSetOfUserPrg2 equ 0A200h
OffSetOfUserPrg3 equ 0A300h

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
      ret
_RunProm1 endp

public _RunProm2
_RunProm2 proc
	push ds	
	push es
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
        
	pop  es
	pop  ds  
      ret
 _RunProm2 endp

public _RunProm3
_RunProm3 proc
	push ds	
	push es
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
        
	pop  es
	pop  ds  
     ret
_RunProm3 endp

