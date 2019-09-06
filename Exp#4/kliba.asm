
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
    call _set_my_int9
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
    call set_old_int9
      ret
_RunProm1 endp

public _RunProm2
_RunProm2 proc
	push ds	
	push es
    call _set_my_int9

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
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetOfUserPrg4  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,13                ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����
      mov bx,0A400h
      call bx
    call set_old_int9
	pop  es
	pop  ds  
     ret
_RunProm4 endp

;********************************************************
;ʱ���ж�                                             *
;********************************************************

;ES ��32λ�ļĴ�����������TCC���룬Ҫ�ĳɱ�ļĴ���������
    icnt equ 4
	tdelay equ 4		; ��ʱ���ӳټ���
	icount db icnt		; ��ʾ��ʾ���ַ�����ֵ=delay
    tcount db tdelay     ; ��ʱ����������
; ʱ���жϴ������
Timer:
    push dx
    push ax
    push es
      
    mov	ax,0B800h		; �ı������Դ���ʼ��ַ
	mov	es,ax		; GS = B800h
    
    ;mov ah,0Fh		; 0000���ڵס�1111�������֣�Ĭ��ֵΪ07h��
	;mov al,'|'			; AL = ��ʾ�ַ�ֵ��Ĭ��ֵΪ20h=�ո����
	;mov [es:((80*12+39)*2)],ax	; ��Ļ�� 24 ��, �� 79 ��
    
    
	dec byte ptr [tcount]		; �ݼ���������
	jnz endTimer			; >0����ת
    
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
        mov byte ptr [es:((80*24+78)*2)],'-'	; ��Ļ�� 24 ��, �� 79 ��
        jmp t4
    t3:
        mov byte ptr [es:((80*24+78)*2)],'/'	; ��Ļ�� 24 ��, �� 79 ��
        jmp t4
    t4:
        mov byte ptr [tcount],tdelay		; ���ü�������=��ֵdelay
endTimer:
	mov al,20h			; AL = EOI
	out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
    
    pop es
    pop ax
    pop dx
	iret			; ���жϷ���
    
    
;*******************************************************
;���Իָ�int9 Ӳ���ж�
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
;�����ж�                                             *
;********************************************************
Message: db 'OUCH!OUCH!'
Message2: db 'My name is Van'
Message3: db 'I am an performance artist'
MessageCLS: db '                          '

maxCnt equ 6
keycnt db maxCnt


KeyInt:
    ; һЩ�����ĵı����Լ���ʼ��
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
    
    ; ����
    mov bp, offset MessageCLS
	;mov bp,ax	;ES:BP = ����ַ
	mov cx,26	;CX=������
    mov ax,01301h	;AH = 13, AL = 01h
	mov bx,000ch
	mov dl,15
	mov dh,20
	int 10h
    
    
    jmp show      ;�������Ҫ����ʾ�����ݣ���ֱ���˳��ж�
    
    DisplayStr1:
	mov bp, offset Message
	;mov bp,ax	;ES:BP = ����ַ
	mov cx,10	;CX=������
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
    in al,60h           ; ��60h�˿ڵ��ж�ȡ��ɨ����
    mov al,20h          ; AL = EOI
    out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
	iret			; ���жϷ���
    
    
public _set_my_int9 
    _set_my_int9 proc
        push ax
        push es
        xor ax,ax
        mov es,ax
        cli
        
        mov word ptr [es:24h],offset KeyInt	; ����ʱ���ж�������ƫ�Ƶ�ַ
        mov word ptr [es:26h],cs		; ����ʱ���ж������Ķε�ַ=CS

        sti
        pop es
        pop ax
        ret
_set_my_int9 endp
    
;********************************************************
;ͨ���жϵ��ó���                                       *
;********************************************************

myInt33:
    ;���������ģ���ʼ���Ĵ�����Ϣ

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
    out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
    iret
    
myInt34:
    ;���������ģ���ʼ���Ĵ�����Ϣ

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
    out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
    iret
    
    
myInt35:
    ;���������ģ���ʼ���Ĵ�����Ϣ

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
    out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
    
    pop ds
    pop bp
    pop cx
    pop bx
    pop es
    pop ax
    pop dx
    
    iret
       

myInt36:
    ;���������ģ���ʼ���Ĵ�����Ϣ

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
    out 20h,al			; ����EOI����8529A
	out 0A0h,al			; ����EOI����8529A
    
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




