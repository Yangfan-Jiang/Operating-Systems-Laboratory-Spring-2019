	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "test.c"
_TEXT	segment	byte public 'CODE'
    DGROUP	group	_DATA,_BSS
        assume	cs:_TEXT,ds:DGROUP,ss:DGROUP
_TEXT	ends
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
	?debug	C E96DBD784E06746573742E63
_BSS	ends
_DATA	segment word public 'DATA'
_a	label	word
	dw	3
_b	label	word
	dw	4
_DATA	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 3
_cmain	proc	near
;	?debug	L 4
	push	word ptr DGROUP:_b
	push	word ptr DGROUP:_a
	call	near ptr _f
	pop	cx
	pop	cx
@1:
;	?debug	L 5
	ret	
_cmain	endp
;	?debug	L 6
_f	proc	near
	push	bp
	mov	bp,sp
;	?debug	L 7
	mov	ax,word ptr [bp+4]
	add	ax,word ptr [bp+6]
	mov	word ptr DGROUP:_c,ax
@2:
;	?debug	L 8
	pop	bp
	ret	
_f	endp
_TEXT	ends
_BSS	segment word public 'BSS'
_c	label	word
	db	2 dup (?)
_BSS	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
_TEXT	segment	byte public 'CODE'
_TEXT	ends
	public	_cmain
	public	_f
	public	_c
	public	_b
	public	_a
	end
