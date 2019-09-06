	
	org  9100h	
	 delay equ 50000			; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580				; 计时器延迟计数,用于控制画框的速度
OffsetOfMyos equ 7c00h
updowntimes equ 5
	mov ah,06h	;清屏
	mov al,0
	mov ch,0
	mov cl,0
	mov dh,24
	mov dl,79
	mov bh,0fh
	int 10h
	;第一个菱形
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	mov	bp, Message1		 ; BP=当前串的偏移地址
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, Message1Length  ; CX = 串长（=9）
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0002h		 ; 页号为0(BH = 0) 
   	mov dh, 16		       ; 行号
	mov	dl, 38			 ; 列号
	int	10h			 ; BIOS的10h功能：显示一行字符
	mov	ax, cs	     
	mov	ds, ax	       
	mov	bp, Message2		
	mov	ax, ds		
	mov	es, ax		 
	mov	cx, Message2Length 
	mov	ax, 1301h		
	mov	bx, 0003h		
   	mov dh, 17		      
	mov	dl, 37			
	int	10h			 
	mov	ax, cs	      
	mov	ds, ax	       
	mov	bp, Message3		 
	mov	ax, ds		 
	mov	es, ax		 
	mov	cx, Message3Length  
	mov	ax, 1301h		
	mov	bx, 0004h		 
   	mov dh, 18		      
	mov	dl, 36			
	int	10h			 
	mov	ax, cs	      
	mov	ds, ax	     
	mov	bp, Message4		
	mov	ax, ds		 
	mov	es, ax		
	mov	cx, Message4Length 
	mov	ax, 1301h		
	mov	bx, 0005h		 
   	mov dh, 19		      
	mov	dl, 35			
	int	10h			
	mov	ax, cs	       
	mov	ds, ax	       
	mov	bp, Message5	
	mov	ax, ds		 
	mov	es, ax		 
	mov	cx, Message5Length 
	mov	ax, 1301h		
	mov	bx, 0006h		
   	mov dh, 20		      
	mov	dl, 34			
	int	10h			 
	mov	ax, cs	      
	mov	ds, ax	      
	mov	bp, Message4		
	mov	ax, ds		
	mov	es, ax		
	mov	cx, Message4Length 
	mov	ax, 1301h		
	mov	bx, 0005h		
   	mov dh, 21		     
	mov	dl, 35		
	int	10h			 
	mov	ax, cs	     
	mov	ds, ax	      
	mov	bp, Message3		
	mov	ax, ds		
	mov	es, ax		
	mov	cx, Message3Length 
	mov	ax, 1301h		
	mov	bx, 0004h		
   	mov dh, 22		      
	mov	dl, 36			
	int	10h			 
	mov	ax, cs	      
	mov	ds, ax	      
	mov	bp, Message2		
	mov	ax, ds		 
	mov	es, ax		
	mov	cx, Message2Length  
	mov	ax, 1301h		
	mov	bx, 0003h		 
   	mov dh, 23		    
	mov	dl, 37			
	int	10h			
	mov	ax, cs	      
	mov	ds, ax	      
	mov	bp, Message1		
	mov	ax, ds		
	mov	es, ax	
	mov	cx, Message1Length
	mov	ax, 1301h		
	mov	bx, 0002h		
   	mov dh, 24		     
	mov	dl, 38		
	int	10h			
;开始进行菱形的运动
mov word[updown],updowntimes;设置来回运动的次数
updownprocess:
	
	mov bl,16 ;上滚16行

loop1:	
dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
    jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay
	mov ah,06h	;上滚
	mov al,1
	mov ch,0
	mov cl,0
	mov dh,24
	mov dl,79
	mov bh,0fh
	int 10h
	dec bl
	jnz loop1

	mov bl,16	;下滚16行

loop2:
dec word[count]				; 递减计数变量
	jnz loop2					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
    jnz loop2
	mov word[count],delay
	mov word[dcount],ddelay
	mov ah,07h;下滚
	mov al,1
	mov ch,0
	mov cl,0
	mov dh,24
	mov dl,79
	mov bh,0fh
	int 10h
	dec bl
	jnz loop2
dec word[updown]
jnz updownprocess
	;退出
	int	10h			 ; BIOS的10h功能：显示一行字符	
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	mov	bp, Messageend		 ; BP=当前串的偏移地址
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, MessageendLength  ; CX = 串长（=9）
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
   	mov dh, 0 		       ; 行号=0
	mov	dl, 0			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行字符
	mov ah,0
	int 16h 
	;利用软中断10H的0x0e号功能回显字符
	mov ah,0eh 	
	mov bl,0 
	int 10h 		; 调用10H号中断
	;比较输入的ascii码实现跳转
	cmp al,'m' 
	jz goback
goback:
	 mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx, OffsetOfMyos ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,1                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      ; 用户程序a.com已加载到指定内存区域中
      jmp OffsetOfMyos                   ; 停止画框，无限循环
Message1:
      db 'A'
	Message1Length  equ ($-Message1)
Message2:
      db 'BBB'
	Message2Length  equ ($-Message2)
Message3:
      db 'CCCCC'
	Message3Length  equ ($-Message3)
Message4:
      db 'DDDDDDD'
	Message4Length  equ ($-Message4)
Message5:
		db'EEEEEEEEE'
	Message5Length equ ($-Message5)
Messageend:
      db 'key in m to quit'
	MessageendLength  equ ($-Messageend)
	
	updown dw updowntimes
	count dw delay
    dcount dw ddelay