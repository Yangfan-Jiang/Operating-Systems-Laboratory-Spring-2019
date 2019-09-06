;程序源代码（myos1.asm）
org  7c00h		; BIOS将把引导扇区加载到0:7C00h处，并开始执行
OffSetOfUserPrg1 equ 8100h
OffsetOfUserPrg2 equ 8600h
OffsetOfUserPrg3 equ 9100h
Start:
mov ah,06h	;清屏
mov al,0	
mov ch,0
mov cl,0
mov dh,24
mov dl,79
mov bh,0fh
int 10h
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	mov	bp, Message		 ; BP=当前串的偏移地址
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, MessageLength  ; CX = 串长（=9）
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov dh, 0		       ; 行号=0
	mov	dl, 0			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行字符
	mov ah,0
	int 16h 
	;利用软中断10H的0x0e号功能回显字符
	mov ah,0eh 	
	mov bl,0 
	int 10h 		; 调用10H号中断
	;比较输入的ascii码实现跳转
	cmp al,'A' 
	je LoadnEx
	cmp al,'B'
	je LoadnSecond
	cmp al,'C'
	je LoadnThird
	
LoadnEx:
     ;读软盘或硬盘上的若干物理扇区到内存的ES:BX处：
      mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx, OffSetOfUserPrg1  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,2                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域中
      jmp OffSetOfUserPrg1
LoadnSecond:
	mov ax,cs
	mov es,ax
	mov bx,OffsetOfUserPrg2
	mov ah,2
	mov al,1
	mov dl,0
	mov dh,0
	mov ch,0
	mov cl,3
	int 13H
	jmp OffsetOfUserPrg2
LoadnThird:
	mov ax,cs
	mov es,ax
	mov bx,OffsetOfUserPrg3
	mov ah,2
	mov al,1
	mov dl,0
	mov dh,0
	mov ch,0
	mov cl,4
	int 13H
	jmp OffsetOfUserPrg3
AfterRun:
      jmp $                      ;无限循环

Message:
      db 'Hello, MyOs is loading .chose your program'
MessageLength  equ ($-Message)
      times 510-($-$$) db 0
      db 0x55,0xaa

