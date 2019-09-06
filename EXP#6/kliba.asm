
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


 ;ʵ���˸���
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
      mov bx,0A100h ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,13                 ;��ʼ������ ; ��ʼ���Ϊ1
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
      mov bx, 0A100h  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,14                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����
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
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, 0A100h  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,15                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����
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
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, 0A100h  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,16                ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����
      mov bx,0A100h
      call bx
    call set_old_int9
	pop  es
	pop  ds  
    ret
_RunProm4 endp

    
    
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
    
    
    jmp showint      ;�������Ҫ����ʾ�����ݣ���ֱ���˳��ж�
    
    DisplayStr1:
	mov bp, offset Message
	;mov bp,ax	;ES:BP = ����ַ
	mov cx,10	;CX=������
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

myInt37:
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
      mov ax,2000h                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax               ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx,0A100h ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,13                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�����
	pop  es
	pop  ds  

    ; P2
	push ds	
	push es
      mov ax,3000h                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx,0A100h  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,14                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
	pop  es
	pop  ds  

    ;P3
	push ds	
	push es
      mov ax,4000h                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx,0A100h  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,15                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
	pop  es
	pop  ds  

    ;P4
	push ds	
	push es
      mov ax,5000h                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx,0A100h  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,16                ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
	pop  es
	pop  ds  
    ret
_LoadAll endp




;*********************
;*  Data Initialize  *
;*********************
Finite dw 0	
icnt equ 4
tdelay equ 4		; ��ʱ���ӳټ���
icount db icnt		; ��ʾ��ʾ���ַ�����ֵ=delay
tcount db tdelay     ; ��ʱ����������


Pro_Timer:
;*****************************************
;*                Save                   *
; ****************************************
    cmp word ptr[_Program_Num],0
	jnz Save    ;����ȣ���ת,���浱ǰ�����״̬
	jmp Ori_Time_Int ;����Ѿ�û�����еĳ����ˣ����˳���Ȼ��ָ�ʱ���ж�
Save:
	inc word ptr[Finite]    
	cmp word ptr[Finite],1000 ; ��������һ��ʱ��󣬾Ͳ������ˣ���Ϊ������ʱ���ж�
	jnz Lee                     ; 1600*50ms
    mov word ptr[_CurrentPCBno],0   ; �����ں�
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
	mov bp, ax          ; ���n����C����ʱ��C�����ķ���ֵ������AX��

	mov ss,word ptr ds:[bp+0]         
	mov sp,word ptr ds:[bp+16] 

	cmp word ptr ds:[bp+32],0 ; bp+32��ӦPCB�ṹ�������status��0��ʾNEW
	jnz No_First_Time

;*****************************************
;*                Restart                *
; ****************************************
Restart:
    call near ptr _special
	; �ļĴ��������ģ����е�ǰPCB��¼�Ľ���
    ;bp  ָ��ṹ�壬������ȡ�Ĵ�����ֵ
	push word ptr ds:[bp+30]    ; FLAGS
	push word ptr ds:[bp+28]    ; CS
	push word ptr ds:[bp+26]    ; IP
                                ; �����ж�ʱ���Ƚ�FLAGS��CS��IP��ջ
	push word ptr ds:[bp+2]     ; ִ��iret����SP,SP+2,SP+4�ֱ��ջ��
	push word ptr ds:[bp+4]     ; IP,CS,FLAGS�Ĵ���
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
	
    
Ori_Time_Int:    ;����Ѿ�û�����еĳ����ˣ��ͱ��ԭ���ķ����
    push ax
    push es
	push ds
	
	mov ax,cs
	mov ds,ax

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
    mov al,34h   ; �������ֵ 
    out 43h,al   ; д�����ֵ������ּĴ��� 
    mov ax,29830 ; ÿ�� 20 ���жϣ�50ms һ�Σ� 
    out 40h,al   ; д������ 0 �ĵ��ֽ� 
    mov al,ah    ; AL=AH 
    out 40h,al   ; д������ 0 �ĸ��ֽ� 
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


    
    