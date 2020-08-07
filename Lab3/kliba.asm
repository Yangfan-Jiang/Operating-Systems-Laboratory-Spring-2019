
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
; ����
	push ax
	push bx
	push cx
	push dx		
     
	mov	ax, 0600h	; AH = 6,  AL = 0
						
	mov	bx, 0700h	; �ڵװ���(BL = 7)
	mov	cx, 0		; ���Ͻ�: (0, 0)
	mov	dx, 184fh	; ���½�: (24, 79)	
	int	10h		; ��ʾ�ж�
				;AH=06H��ʾ��cx�����Ͻǣ�dx�����½ǣ��ľ������������ƶ�
	
	;��λ���
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


 ;ʵ���˸���
public _backspace
_backspace proc     
push bp      
    mov ah,3   ;��ȡ���λ��
    mov bh,0
    int 10h
          
    mov ah,2   ;�ù��
    mov bh,0
    dec dl
    int 10h
          
    mov bp,sp
	mov al,[bp+4]   ;ָ��ջ��Ԫ�أ����ַ�
	mov bl,2		
	mov ah,0eh		;��ʾ�ַ����ǰ��
	int 10h
	mov sp,bp
    
    mov ah,3   ;��ȡ���λ��
    mov bh,0
    int 10h
          
    mov ah,2   ;�ù��
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
		mov al,[bp+4]   ;ָ��ջ��Ԫ�أ����ַ�
		mov bl,2		
		mov ah,0eh		;��ʾ�ַ����ǰ��
		int 10h
		mov sp,bp
	pop bp
	ret
_printChar endp


public _getChar
_getChar proc
	mov ah,0
	int 16h ;0�Ź��ܵ��ôӼ��̶���һ���ַ�����al��
	mov byte ptr [_chBuf],al
tag:
    ret
_getChar endp


public _restart
_restart proc
	push ds	
	push es
	mov	ax, cs	       ; �������μĴ���ֵ��CS��ͬ
	mov	ds, ax	       ; ���ݶ�
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
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetOfUserPrg1 ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,10                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����
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
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetOfUserPrg2  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,11                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����
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
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetOfUserPrg3  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,12                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����
      mov bx,0A300h
      call bx
        
	pop  es
	pop  ds  
     ret
_RunProm3 endp

