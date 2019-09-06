; ����Դ���루stone.asm��
; ���������ı���ʽ��ʾ���ϴ�������һ��*��,��45���������˶���ײ���߿����,�������.
;  ��Ӧ�� 2014/3
;   NASM����ʽ
; dx,sp,si,di

    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 50000					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�
    ddelay equ 580					; ��ʱ���ӳټ���,���ڿ��ƻ�����ٶ�

    org 0A200h					; ������ص�100h������������COM
start:
	;xor ax,ax					; AX = 0   ������ص�0000��100h������ȷִ��
	mov ah,03h
      mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; �ı������Դ���ʼ��ַ
	mov	gs,ax					; GS = B800h
      mov byte[char],'A'
	;call DisplayStr				;�����ַ���
	  
loop1:
	dec word[count]				; �ݼ���������
	jnz loop1					; >0����ת;
	mov word[count],delay
	dec word[dcount]				; �ݼ���������
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
	  jz re
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
;    xor ax,ax                 ; �����Դ��ַ
	call DisplayStr
    mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	;mov ah,0Fh				;00001111:�ڵװ��� AH(ax��λ)Ϊ��ɫ
	;mov ah,03h				;��˸������RGB������������RGB 0000 0011
	add ah,1
	mov al,byte[char]			;AL(ax��λ)��ʾ�ַ�ֵ
	mov word[gs:bp],ax  		;���ַ�ֵ����ɫ�͵�Ҫ��ʾ�ַ����Դ��ַ
	jmp loop1
	
	
end:
    jmp $                   ; ֹͣ��������ѭ�� 
	
DisplayStr:
	mov bp, BootMessage
	;mov bp,ax	;ES:BP = ����ַ
	mov cx,12	;CX=������
	mov ax,01301h	;AH = 13, AL = 01h
	mov bx,000ch
	mov dl,50
	mov dh,7
	int 10h
	ret

re:
    ret
	
datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; �������˶�
	cnt dw 5
    x    dw 7
    y    dw 40
	x2	 dw 7
	y2	 dw 40
    char db 'A'
	
	
BootMessage:	db "jyf 17341068"