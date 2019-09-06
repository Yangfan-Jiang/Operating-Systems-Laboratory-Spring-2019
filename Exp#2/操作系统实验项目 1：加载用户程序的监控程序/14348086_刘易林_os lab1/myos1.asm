;����Դ���루myos1.asm��
org  7c00h		; BIOS���������������ص�0:7C00h��������ʼִ��
OffSetOfUserPrg1 equ 8100h
OffsetOfUserPrg2 equ 8600h
OffsetOfUserPrg3 equ 9100h
Start:
mov ah,06h	;����
mov al,0	
mov ch,0
mov cl,0
mov dh,24
mov dl,79
mov bh,0fh
int 10h
	mov	ax, cs	       ; �������μĴ���ֵ��CS��ͬ
	mov	ds, ax	       ; ���ݶ�
	mov	bp, Message		 ; BP=��ǰ����ƫ�Ƶ�ַ
	mov	ax, ds		 ; ES:BP = ����ַ
	mov	es, ax		 ; ��ES=DS
	mov	cx, MessageLength  ; CX = ������=9��
	mov	ax, 1301h		 ; AH = 13h�����ܺţ���AL = 01h��������ڴ�β��
	mov	bx, 0007h		 ; ҳ��Ϊ0(BH = 0) �ڵװ���(BL = 07h)
   	mov dh, 0		       ; �к�=0
	mov	dl, 0			 ; �к�=0
	int	10h			 ; BIOS��10h���ܣ���ʾһ���ַ�
	mov ah,0
	int 16h 
	;�������ж�10H��0x0e�Ź��ܻ����ַ�
	mov ah,0eh 	
	mov bl,0 
	int 10h 		; ����10H���ж�
	;�Ƚ������ascii��ʵ����ת
	cmp al,'A' 
	je LoadnEx
	cmp al,'B'
	je LoadnSecond
	cmp al,'C'
	je LoadnThird
	
LoadnEx:
     ;�����̻�Ӳ���ϵ����������������ڴ��ES:BX����
      mov ax,cs                ;�ε�ַ ; ������ݵ��ڴ����ַ
      mov es,ax                ;���öε�ַ������ֱ��mov es,�ε�ַ��
      mov bx, OffSetOfUserPrg1  ;ƫ�Ƶ�ַ; ������ݵ��ڴ�ƫ�Ƶ�ַ
      mov ah,2                 ; ���ܺ�
      mov al,1                 ;������
      mov dl,0                 ;�������� ; ����Ϊ0��Ӳ�̺�U��Ϊ80H
      mov dh,0                 ;��ͷ�� ; ��ʼ���Ϊ0
      mov ch,0                 ;����� ; ��ʼ���Ϊ0
      mov cl,2                 ;��ʼ������ ; ��ʼ���Ϊ1
      int 13H ;                ���ö�����BIOS��13h����
      ; �û�����a.com�Ѽ��ص�ָ���ڴ�������
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
      jmp $                      ;����ѭ��

Message:
      db 'Hello, MyOs is loading .chose your program'
MessageLength  equ ($-Message)
      times 510-($-$$) db 0
      db 0x55,0xaa

