; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   NASM汇编格式
; dx,sp,si,di

    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 50000					; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580					; 计时器延迟计数,用于控制画框的速度

    org 0A200h					; 程序加载到100h，可用于生成COM
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
	mov ah,03h
      mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
      mov byte[char],'A'
	;call DisplayStr				;调用字符串
	  
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
      jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay

      mov al,1
      cmp al,byte[rdul]
	jz  DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp $	

DnRt:
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,13
	sub ax,bx
      jz  dr2ur
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  dr2dl
	jmp show
dr2ur:
	  dec word[cnt]
	  jz 07c00h
      mov word[x],11
      mov byte[rdul],Up_Rt	
      jmp show
dr2dl:
      mov word[y],78
      mov byte[rdul],Dn_Lt	
      jmp show

UpRt:
	;call Erase
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  ur2ul
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ur2dr
	jmp show
ur2ul:
      mov word[y],78
      mov byte[rdul],Up_Lt	
      jmp show
ur2dr:
      mov word[x],1
      mov byte[rdul],Dn_Rt	
      jmp show

	
	
UpLt:
	;call Erase
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,38
	sub ax,bx
      jz  ul2ur
	jmp show

ul2dl:
      mov word[x],1
      mov byte[rdul],Dn_Lt	
      jmp show
ul2ur:
      mov word[y],40
      mov byte[rdul],Up_Rt	
      jmp show

	
	
DnLt:
	;call Erase
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,38
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,13
	sub ax,bx
      jz  dl2ul
	jmp show

dl2dr:
      mov word[y],40
      mov byte[rdul],Dn_Rt	
      jmp show
	
dl2ul:
      mov word[x],11
      mov byte[rdul],Up_Lt	
      jmp show
	
show:	
;    xor ax,ax                 ; 计算显存地址
	call DisplayStr
    mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	;mov ah,0Fh				;00001111:黑底白字 AH(ax高位)为颜色
	;mov ah,03h				;闪烁、背景RGB、高亮、字体RGB 0000 0011
	add ah,1
	mov al,byte[char]			;AL(ax低位)显示字符值
	mov word[gs:bp],ax  		;将字符值和颜色送到要显示字符的显存地址
	jmp loop1
	
	
end:
    jmp $                   ; 停止画框，无限循环 
	
DisplayStr:
	mov bp, BootMessage
	;mov bp,ax	;ES:BP = 串地址
	mov cx,12	;CX=串长度
	mov ax,01301h	;AH = 13, AL = 01h
	mov bx,000ch
	mov dl,50
	mov dh,7
	int 10h
	ret

	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
	cnt dw 5
    x    dw 7
    y    dw 40
	x2	 dw 7
	y2	 dw 40
    char db 'A'
	
	
BootMessage:	db "jyf 17341068"
